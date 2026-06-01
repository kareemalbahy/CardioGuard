import 'package:equatable/equatable.dart';

class AssessmentResultEntity extends Equatable {
  final double riskScore;
  // final List<String> recommendations;
  final String recommendations;
  final DateTime generatedAt;

  const AssessmentResultEntity({
    required this.riskScore,
    required this.recommendations,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [riskScore, recommendations, generatedAt];
}
