class DoctorProfileEntity {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String imagePath;
  final bool isOnline;

  DoctorProfileEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.imagePath,
    this.isOnline = false,
  });
}