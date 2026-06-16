import 'package:cardiogaurd/features/assessment/data/datasources/risk_ml_remote_datasource.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';
import 'package:cardiogaurd/features/assessment/data/models/input_model.dart';
import 'package:cardiogaurd/core/error/exceptions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RiskMlRemoteDataSourceImpl implements RiskMlRemoteDataSource {
  //final String endpoint = 'http://192.168.1.7:5000/predict';
  final String endpoint = 'http://10.0.2.2:5000/predict';

  @override
  Future<double> predictRiskScore(AssessmentInputEntity input) async {
    try {
      final inputModel = AssessmentInputModel.fromEntity(input);
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inputModel.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        double riskScore = 0.0;
        if (data is Map) {
          if (data.containsKey('predictions') &&
              data['predictions'] is List &&
              (data['predictions'] as List).isNotEmpty) {
            final pred = (data['predictions'] as List).first;
            if (pred is Map && pred.containsKey('probability_disease')) {
              riskScore = (pred['probability_disease'] as num).toDouble() * 100;
            }
          }
          if (riskScore == 0.0) {
            if (data.containsKey('risk_score')) {
              riskScore = (data['risk_score'] as num).toDouble();
            } else if (data.containsKey('prediction')) {
              riskScore = (data['prediction'] as num).toDouble();
            } else if (data.containsKey('score')) {
              riskScore = (data['score'] as num).toDouble();
            } else if (data.containsKey('risk')) {
              riskScore = (data['risk'] as num).toDouble();
            } else if (data.isNotEmpty && data.values.first is num) {
              riskScore = (data.values.first as num).toDouble();
            }
          }
        } else if (data is num) {
          riskScore = data.toDouble();
        } else if (data is List && data.isNotEmpty && data.first is num) {
          riskScore = (data.first as num).toDouble();
        }
        return riskScore;
      } else {
        throw ServerException(
          'Failed to predict risk score. Status code: ${response.statusCode}',
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw NetworkException('Connection timed out or failed: $e');
    }
  }
}
