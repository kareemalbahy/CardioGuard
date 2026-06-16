import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/enums/user_role.dart';
import 'package:cardiogaurd/core/error/exceptions.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cardiogaurd/features/auth/domain/entities/app_user.dart';
import 'package:cardiogaurd/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
    UserRole? forceRole,
  }) async {
    try {
      final user = await remoteDataSource.signIn(email, password, forceRole);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final user = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        role: role,
        specialty: specialty,
        hospital: hospital,
        phone: phone,
        gender: gender,
        dob: dob,
        profileImage: profileImage,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> updateProfile({
    required String uid,
    String? name,
    String? phone,
    String? gender,
    String? dob,
    File? imageFile,
    String? specialty,
    String? hospital,
  }) async {
    try {
      final user = await remoteDataSource.updateProfile(
        uid: uid,
        name: name,
        phone: phone,
        gender: gender,
        dob: dob,
        imageFile: imageFile,
        specialty: specialty,
        hospital: hospital,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
