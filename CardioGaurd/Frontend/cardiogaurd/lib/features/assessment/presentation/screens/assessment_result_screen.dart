import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:cardiogaurd/features/assessment/presentation/cubit/assessment_cubit.dart';
import 'package:cardiogaurd/features/assessment/presentation/widgets/clinical_recommendations.dart';
import 'package:cardiogaurd/features/assessment/presentation/widgets/risk_score_card.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';
import 'package:cardiogaurd/features/history/presentation/cubit/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AssessmentResultScreen extends StatelessWidget {
  const AssessmentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssessmentCubit, AssessmentState>(
      builder: (context, state) {
        if (state.status != AssessmentStatus.success ||
            state.lastInput == null ||
            state.lastResult == null) {
          return Scaffold(
            backgroundColor: MyColors.scaffoldBackground,
            appBar: AppBar(
              title: const Text('Results'),
              backgroundColor: Colors.transparent,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Run an assessment first to see results here.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.go('/inputs'),
                      child: const Text('Go to assessment'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final input = state.lastInput!;
        final result = state.lastResult!;

        const sexLabels = ['Female', 'Male'];
        const cpLabels = [
          'Typical Angina',
          'Atypical Angina',
          'Non-anginal',
          'Asymptomatic',
        ];
        const ecgLabels = ['Normal', 'ST-T Abnormality', 'LV Hypertrophy'];
        const exangLabels = ['No', 'Yes'];
        const slopeLabels = ['Upsloping', 'Flat', 'Downsloping'];
        const thalLabels = [
          'Unknown',
          'Normal',
          'Fixed Defect',
          'Reversible Defect',
        ];

        return Scaffold(
          backgroundColor: MyColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Results',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                    _buildBadge(
                      'Last Scan: Today, ${DateFormat('HH:mm').format(DateTime.now())}',
                      Colors.grey[200]!,
                      Colors.black87,
                    ),
                
                const SizedBox(height: 24),
                BuildRiskScoreCard(riskScore: result.riskScore),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MyColors.borderGray),
                  ),
                  child: Column(
                    children: [
                      _rowItem('Age', '${input.age.toInt()} yrs'),
                      _rowItem('Biological Sex', sexLabels[input.sex.clamp(0, 1)]),
                      _rowItem('Chest Pain (CP)', cpLabels[input.cp.clamp(0, 3)]),
                      _rowItem('Resting BP', '${input.trestbps.toInt()} mmHg'),
                      _rowItem('Cholesterol', '${input.chol.toInt()} mg/dL'),
                      _rowItem('Fasting BS > 120', input.fbs == 1 ? 'True' : 'False'),
                      _rowItem('Resting ECG', ecgLabels[input.restecg.clamp(0, 2)]),
                      _rowItem('Max Heart Rate', '${input.thalach.toInt()} bpm'),
                      _rowItem('Exercise Angina', exangLabels[input.exang.clamp(0, 1)]),
                      _rowItem('ST Depression', '${input.oldpeak.toStringAsFixed(1)} mm'),
                      _rowItem('Peak ST Slope', slopeLabels[input.slope.clamp(0, 2)]),
                      _rowItem('Colored Vessels', '${input.ca.clamp(0, 3)}'),
                      _rowItem(
                        'Thalassemia',
                        thalLabels[input.thal.clamp(0, 3)],
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BuildClinicalRecommendation(items: result.recommendations),
                const SizedBox(height: 32),
                _buildSaveButton(context, result.riskScore, input, result.recommendations),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context, double score, dynamic input, String recommendations) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          final recommendationList = recommendations
              .split('\n')
              .where((line) => line.trim().isNotEmpty)
              .map((line) => line.replaceAll(RegExp(r'^[\*\-\d\.]+\s*'), '').trim())
              .toList();

          final entry = HistoryEntryEntity(
            date: DateTime.now(),
            score: score,
            status: score > 50 ? 'High Risk' : 'Healthy',
            inputs: input,
            recommendations: recommendationList.isNotEmpty ? recommendationList : [recommendations],
          );
          context.read<HistoryCubit>().addEntry(entry);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Assessment saved to history and dashboard'),
              backgroundColor: MyColors.primaryBlue,
            ),
          );
          

          context.pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        child: const Text(
          'Save & Sync Assessment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SIMULATED DIAGNOSTIC REPORT',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Actionable Risk\nIntelligence.',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Your results combine modeled hemodynamic inputs with AI-assisted guidance. Always confirm with your clinician.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textCol,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _rowItem(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
