
class UserProfileEntity {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final int age;
  final String profileImageUrl;
  final double lastRiskScore;
  final String lastAssessmentDate;

  UserProfileEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.age,
    required this.profileImageUrl,
    required this.lastRiskScore,
    required this.lastAssessmentDate,
  });
}