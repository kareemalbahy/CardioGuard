import 'package:cardiogaurd/features/assessment/domain/entities/assessment_result_entity.dart';

class AssessmentResultModel extends AssessmentResultEntity {
  const AssessmentResultModel({
    required super.riskScore,
    required super.recommendations,
    required super.generatedAt,
  });

  factory AssessmentResultModel.fromJson(Map<String, dynamic> json) {
    return AssessmentResultModel(
      riskScore: (json['riskScore'] as num).toDouble(),
      recommendations: json['recommendations'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'riskScore': riskScore,
      'recommendations': recommendations,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}
