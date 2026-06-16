import 'dart:io';
import 'package:cardiogaurd/features/auth/domain/entities/app_user.dart';
import 'package:cardiogaurd/core/enums/user_role.dart';

abstract class AuthRemoteDataSource {
  Future<AppUser> signIn(String email, String password, UserRole? forceRole);
  Future<AppUser> register({
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
  Future<void> signOut();
  
  Future<AppUser> updateProfile({
    required String uid,
    String? name,
    String? phone,
    String? gender,
    String? dob,
    File? imageFile,
    String? specialty,
    String? hospital,
  });
  Future<void> sendPasswordResetEmail(String email);
  Future<AppUser?> getCurrentUser();
}
