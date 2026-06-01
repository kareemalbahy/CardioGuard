import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<Unit, String> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String email) async {
    return await repository.sendPasswordResetEmail(email);
  }
}
