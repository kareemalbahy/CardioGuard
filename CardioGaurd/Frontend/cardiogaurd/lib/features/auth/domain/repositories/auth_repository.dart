import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/enums/user_role.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
    UserRole? forceRole,
  });
  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? specialty,
    String? hospital,
    String? phone,
    String? gender,
    String? dob,
    File? profileImage,
  });
  Future<Either<Failure, Unit>> signOut();
  
  Future<Either<Failure, AppUser>> updateProfile({
    required String uid,
    String? name,
    String? phone,
    String? gender,
    String? dob,
    File? imageFile,
    String? specialty,
    String? hospital,
  });
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);
}
