import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/auth/domain/entities/app_user.dart';
import 'package:cardiogaurd/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<AppUser, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      role: params.role,
      specialty: params.specialty,
      hospital: params.hospital,
      phone: params.phone,
      gender: params.gender,
      dob: params.dob,
      profileImage: params.profileImage,
    );
  }
}
