import 'package:equatable/equatable.dart';

class DoctorPatientSummaryEntity extends Equatable {
  final String id;
  final String name;
  final double lastRiskScore;
  final String lastAssessmentDate;
  final String profilePictureUrl;

  const DoctorPatientSummaryEntity({
    required this.id,
    required this.name,
    required this.lastRiskScore,
    required this.lastAssessmentDate,
    this.profilePictureUrl = '',
  });

  @override
  List<Object?> get props => [id, name, lastRiskScore, lastAssessmentDate, profilePictureUrl];
}
