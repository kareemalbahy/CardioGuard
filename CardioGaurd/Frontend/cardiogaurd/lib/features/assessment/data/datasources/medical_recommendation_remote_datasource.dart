import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';

abstract class MedicalRecommendationRemoteDataSource {
  Future<String> getRecommendations({
    required AssessmentInputEntity input,
    required double riskScore,
  });
}
