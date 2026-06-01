import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';
import 'package:cardiogaurd/features/assessment/presentation/cubit/assessment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CalculateButton extends StatelessWidget {
  final double ageVal;
  final int sexVal;
  final int cpVal;
  final double trestbpsVal;
  final double cholVal;
  final int fbsVal;
  final int restecgVal;
  final double thalachVal;
  final int exangVal;
  final double oldpeakVal;
  final int slopeVal;
  final int caVal;
  final int thalVal;

  const CalculateButton({
    super.key,
    required this.ageVal,
    required this.sexVal,
    required this.cpVal,
    required this.trestbpsVal,
    required this.cholVal,
    required this.fbsVal,
    required this.restecgVal,
    required this.thalachVal,
    required this.exangVal,
    required this.oldpeakVal,
    required this.slopeVal,
    required this.caVal,
    required this.thalVal,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssessmentCubit, AssessmentState>(
      listener: (context, state) {
        if (state.status == AssessmentStatus.success) {
          context.push('/results');
        } else if (state.status == AssessmentStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MyColors.alertRed,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AssessmentStatus.loading;

        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    final inputData = AssessmentInputEntity(
                      age: ageVal,
                      sex: sexVal,
                      cp: cpVal,
                      trestbps: trestbpsVal,
                      chol: cholVal,
                      fbs: fbsVal,
                      restecg: restecgVal,
                      thalach: thalachVal,
                      exang: exangVal,
                      oldpeak: oldpeakVal,
                      slope: slopeVal,
                      ca: caVal,
                      thal: thalVal,
                    );
                    context.read<AssessmentCubit>().calculate(inputData);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.actionBlue,
              disabledBackgroundColor: MyColors.actionBlue.withValues(alpha: 0.6),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            child: isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Analyzing Parameters...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Calculate Risk Score'),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
