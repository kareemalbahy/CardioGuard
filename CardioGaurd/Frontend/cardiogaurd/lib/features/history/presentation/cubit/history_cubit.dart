import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardiogaurd/core/usecases/usecase.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';
import 'package:cardiogaurd/features/history/domain/usecases/get_patient_history_usecase.dart';
import 'package:cardiogaurd/features/history/domain/usecases/add_history_entry_usecase.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetPatientHistoryUseCase getPatientHistoryUseCase;
  final AddHistoryEntryUseCase addHistoryEntryUseCase;

  HistoryCubit(this.getPatientHistoryUseCase, this.addHistoryEntryUseCase)
      : super(const HistoryState.initial());

  Future<void> load() async {
    emit(const HistoryState.loading());
    final result = await getPatientHistoryUseCase(const NoParams());
    result.fold(
      (f) => emit(HistoryState.failure(f.message)),
      (items) => emit(HistoryState.loaded(items)),
    );
  }

  Future<void> addEntry(HistoryEntryEntity entry) async {
    final result = await addHistoryEntryUseCase(entry);
    result.fold(
      (f) => emit(HistoryState.failure(f.message)),
      (_) => load(),
    );
  }
}
