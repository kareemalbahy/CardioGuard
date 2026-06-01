import 'package:intl/intl.dart';

class PatientInfoEntity {
  final String id;
  final String fullName;
  final String firstName;
  final String lastName;
  String get name => '$firstName $lastName';
  final String email;
  final String phoneNumber;
  final String sex;
  final String dateOfBirthString;
  final String profilePictureUrl;

  PatientInfoEntity({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.sex,
    required this.dateOfBirthString,
    required this.profilePictureUrl,
  });

  DateTime get dateOfBirthDateTime {
    try {
      DateFormat format = DateFormat("dd/MM/yyyy");

      DateTime dateTime = format.parse(dateOfBirthString);
      return dateTime;
    } catch (e) {
      return DateTime(1970, 1, 1); // Default fallback date
    }
  }

  int get age {
    DateTime today = DateTime.now();
    DateTime dob = dateOfBirthDateTime;

    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }
}
