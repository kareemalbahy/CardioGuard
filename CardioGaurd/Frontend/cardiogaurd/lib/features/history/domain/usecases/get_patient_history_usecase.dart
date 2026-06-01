import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';
import 'package:cardiogaurd/features/history/domain/repositories/history_repository.dart';

class GetPatientHistoryUseCase
    implements UseCase<List<HistoryEntryEntity>, NoParams> {
  final HistoryRepository repository;

  GetPatientHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<HistoryEntryEntity>>> call(NoParams params) {
    return repository.getPatientHistory();
  }
}
