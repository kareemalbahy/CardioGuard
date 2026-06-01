import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:cardiogaurd/core/enums/user_role.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final String profileImageUrl;
  final String? specialty;
  final String? hospital;
  final String? phone;
  final String? gender;
  final String? dob;

  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    this.profileImageUrl = '',
    this.specialty,
    this.hospital,
    this.phone,
    this.gender,
    this.dob,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        role,
        profileImageUrl,
        specialty,
        hospital,
        phone,
        gender,
        dob,
      ];
}

class SignInParams extends Equatable {
  final String email;
  final String password;
  final UserRole? forceRole;

  const SignInParams({
    required this.email,
    required this.password,
    this.forceRole,
  });

  @override
  List<Object?> get props => [email, password, forceRole];
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String? specialty;
  final String? hospital;
  final String? phone;
  final String? gender;
  final String? dob;
  final File? profileImage;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.specialty,
    this.hospital,
    this.phone,
    this.gender,
    this.dob,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        role,
        specialty,
        hospital,
        phone,
        gender,
        dob,
        profileImage,
      ];
}
