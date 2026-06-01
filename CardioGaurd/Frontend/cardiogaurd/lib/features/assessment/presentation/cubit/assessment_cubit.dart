import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_result_entity.dart';
import 'package:cardiogaurd/features/assessment/domain/usecases/calculate_heart_risk_usecase.dart';

part 'assessment_state.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  final CalculateHeartRiskUseCase calculateHeartRiskUseCase;

  AssessmentCubit(this.calculateHeartRiskUseCase)
      : super(const AssessmentState.initial());

  Future<void> calculate(AssessmentInputEntity input) async {
    emit(AssessmentState.loading(input));
    final result = await calculateHeartRiskUseCase(input);
    result.fold(
      (f) => emit(AssessmentState.failure(f.message, input)),
      (r) => emit(AssessmentState.success(input: input, result: r)),
    );
  }

  void reset() {
    emit(const AssessmentState.initial());
  }
}
