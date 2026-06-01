import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<HistoryEntryEntity>>> getPatientHistory([String? patientId]);
  Future<Either<Failure, Unit>> addHistoryEntry(HistoryEntryEntity entry);
}
