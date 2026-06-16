import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardiogaurd/core/enums/user_role.dart';
import 'package:cardiogaurd/features/auth/domain/entities/app_user.dart';
import 'package:cardiogaurd/features/auth/domain/repositories/auth_repository.dart';
import 'package:cardiogaurd/features/auth/domain/usecases/register_usecase.dart';
import 'package:cardiogaurd/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:cardiogaurd/features/auth/domain/usecases/forgot_password_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final AuthRepository authRepository;

  AuthCubit({
    required this.signInUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
    required this.authRepository,
  }) : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    final result = await authRepository.getCurrentUser();
    result.fold(
      (_) => emit(const AuthState.initial()),
      (user) {
        if (user != null) {
          emit(AuthState.authenticated(user));
        } else {
          emit(const AuthState.initial());
        }
      },
    );
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    emit(const AuthState.initial());
  }

  Future<void> signIn({
    required String email,
    required String password,
    UserRole? forceRole,
  }) async {
    emit(const AuthState.loading());
    final result = await signInUseCase(
      SignInParams(email: email, password: password, forceRole: forceRole),
    );
    result.fold(
      (f) => emit(AuthState.failure(f.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> register({
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
    emit(const AuthState.loading());
    final result = await registerUseCase(
      RegisterParams(
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
      ),
    );
    result.fold(
      (f) => emit(AuthState.failure(f.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? gender,
    String? dob,
    File? imageFile,
    String? specialty,
    String? hospital,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    emit(AuthState.loading(currentUser: currentUser));
    final result = await authRepository.updateProfile(
      uid: currentUser.id,
      name: name,
      phone: phone,
      gender: gender,
      dob: dob,
      imageFile: imageFile,
      specialty: specialty,
      hospital: hospital,
    );

    result.fold(
      (f) => emit(AuthState.failure(f.message, currentUser: currentUser)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(const AuthState.loading());
    final result = await forgotPasswordUseCase(email);
    result.fold(
      (f) => emit(AuthState.failure(f.message)),
      (_) => emit(const AuthState.initial()),
    );
  }

  void clearError() {
    if (state.status == AuthStatus.failure) {
      emit(const AuthState.initial());
    }
  }
}
