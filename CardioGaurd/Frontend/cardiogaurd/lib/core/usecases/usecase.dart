import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';

abstract class UseCase<Result, Params> {
  Future<Either<Failure, Result>> call(Params params);
}

class NoParams {
  const NoParams();
}
