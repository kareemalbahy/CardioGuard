import 'package:equatable/equatable.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';

class HistoryEntryEntity extends Equatable {
  final DateTime date;
  final double score;
  final String status;
  final List<String> recommendations;
  final AssessmentInputEntity? inputs;

  const HistoryEntryEntity({
    required this.date,
    required this.score,
    required this.status,
    this.recommendations = const [],
    this.inputs,
  });

  @override
  List<Object?> get props => [date, score, status, recommendations, inputs];
}
