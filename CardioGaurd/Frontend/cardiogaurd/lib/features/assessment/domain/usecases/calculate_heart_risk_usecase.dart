import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_result_entity.dart';
import 'package:cardiogaurd/features/assessment/domain/repositories/assessment_repository.dart';

class CalculateHeartRiskUseCase
    implements UseCase<AssessmentResultEntity, AssessmentInputEntity> {
  final AssessmentRepository repository;

  CalculateHeartRiskUseCase(this.repository);

  @override
  Future<Either<Failure, AssessmentResultEntity>> call(
    AssessmentInputEntity params,
  ) {
    return repository.assess(params);
  }
}
