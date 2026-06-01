import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/doctor/domain/repositories/doctor_patients_repository.dart';
import 'package:cardiogaurd/features/patient/domain/entities/patient_info_entity.dart';

class GetPatientDetailsUseCase implements UseCase<PatientInfoEntity, String> {
  final DoctorPatientsRepository repository;

  GetPatientDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, PatientInfoEntity>> call(String patientId) {
    return repository.getPatientInfo(patientId);
  }
}
