import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/doctor/domain/entities/doctor_patient_summary_entity.dart';
import 'package:cardiogaurd/features/patient/domain/entities/patient_info_entity.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';

abstract class DoctorPatientsRepository {
  Future<Either<Failure, List<DoctorPatientSummaryEntity>>> getAssignedPatients();
  Future<Either<Failure, PatientInfoEntity>> getPatientInfo(String patientId);
  Future<Either<Failure, List<HistoryEntryEntity>>> getPatientHistory(String patientId);
  
  Future<Either<Failure, List<Map<String, dynamic>>>> getPendingAssignments();
  Future<Either<Failure, Unit>> acceptAssignment(String assignmentId, String patientId);
  Future<Either<Failure, Unit>> rejectAssignment(String assignmentId);
}
