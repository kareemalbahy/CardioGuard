import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';

abstract class RiskMlRemoteDataSource {
  Future<double> predictRiskScore(AssessmentInputEntity input);
}
