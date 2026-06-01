part of 'history_cubit.dart';

enum HistoryStatus { initial, loading, loaded, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<HistoryEntryEntity> entries;
  final String? message;

  const HistoryState({
    required this.status,
    this.entries = const [],
    this.message,
  });

  const HistoryState.initial()
      : status = HistoryStatus.initial,
        entries = const [],
        message = null;

  const HistoryState.loading()
      : status = HistoryStatus.loading,
        entries = const [],
        message = null;

  const HistoryState.loaded(List<HistoryEntryEntity> e)
      : status = HistoryStatus.loaded,
        entries = e,
        message = null;

  const HistoryState.failure(String m)
      : status = HistoryStatus.failure,
        entries = const [],
        message = m;

  @override
  List<Object?> get props => [status, entries, message];
}
