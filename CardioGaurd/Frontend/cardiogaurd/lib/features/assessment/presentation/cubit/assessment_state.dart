part of 'assessment_cubit.dart';

enum AssessmentStatus { initial, loading, success, failure }

class AssessmentState extends Equatable {
  final AssessmentStatus status;
  final AssessmentInputEntity? lastInput;
  final AssessmentResultEntity? lastResult;
  final String? errorMessage;

  const AssessmentState({
    required this.status,
    this.lastInput,
    this.lastResult,
    this.errorMessage,
  });

  const AssessmentState.initial()
      : status = AssessmentStatus.initial,
        lastInput = null,
        lastResult = null,
        errorMessage = null;

  const AssessmentState.loading(AssessmentInputEntity input)
      : status = AssessmentStatus.loading,
        lastInput = input,
        lastResult = null,
        errorMessage = null;

  const AssessmentState.success({
    required AssessmentInputEntity input,
    required AssessmentResultEntity result,
  })  : status = AssessmentStatus.success,
        lastInput = input,
        lastResult = result,
        errorMessage = null;

  const AssessmentState.failure(String message, AssessmentInputEntity input)
      : status = AssessmentStatus.failure,
        lastInput = input,
        lastResult = null,
        errorMessage = message;

  @override
  List<Object?> get props => [status, lastInput, lastResult, errorMessage];
}
