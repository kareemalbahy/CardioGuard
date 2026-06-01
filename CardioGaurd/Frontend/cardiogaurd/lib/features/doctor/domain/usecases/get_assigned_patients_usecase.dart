import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/doctor/domain/entities/doctor_patient_summary_entity.dart';
import 'package:cardiogaurd/features/doctor/domain/repositories/doctor_patients_repository.dart';

class GetAssignedPatientsUseCase
    implements UseCase<List<DoctorPatientSummaryEntity>, NoParams> {
  final DoctorPatientsRepository repository;

  GetAssignedPatientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<DoctorPatientSummaryEntity>>> call(
    NoParams params,
  ) {
    return repository.getAssignedPatients();
  }
}
