import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_result_entity.dart';

abstract class AssessmentRepository {
  Future<Either<Failure, AssessmentResultEntity>> assess(
    AssessmentInputEntity input,
  );
}
