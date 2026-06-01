import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/doctor/domain/repositories/doctor_patients_repository.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';

class GetPatientHistoryUseCase implements UseCase<List<HistoryEntryEntity>, String> {
  final DoctorPatientsRepository repository;

  GetPatientHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<HistoryEntryEntity>>> call(String patientId) {
    return repository.getPatientHistory(patientId);
  }
}
