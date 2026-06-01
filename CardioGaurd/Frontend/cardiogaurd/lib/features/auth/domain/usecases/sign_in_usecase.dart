import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/auth/domain/entities/app_user.dart';
import 'package:cardiogaurd/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase implements UseCase<AppUser, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(SignInParams params) {
    return repository.signIn(
      email: params.email,
      password: params.password,
      forceRole: params.forceRole,
    );
  }
}
