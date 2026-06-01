import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';
import 'package:cardiogaurd/features/history/domain/repositories/history_repository.dart';

class AddHistoryEntryUseCase implements UseCase<void, HistoryEntryEntity> {
  final HistoryRepository repository;

  AddHistoryEntryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(HistoryEntryEntity params) {
    return repository.addHistoryEntry(params);
  }
}
