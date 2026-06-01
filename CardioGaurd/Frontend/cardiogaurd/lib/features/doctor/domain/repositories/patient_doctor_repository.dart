import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/doctor/domain/entities/doctor_profile_entity.dart';

abstract class PatientDoctorRepository {
  Future<Either<Failure, List<DoctorProfileEntity>>> searchDoctors(String query);
  Future<Either<Failure, List<DoctorProfileEntity>>> getAssignedDoctors();
  Future<Either<Failure, List<DoctorProfileEntity>>> getPendingDoctors();
  Future<Either<Failure, Unit>> requestAssignment(String doctorId);
  Future<Either<Failure, Unit>> cancelAssignment(String doctorId, {required bool isPending});
}
