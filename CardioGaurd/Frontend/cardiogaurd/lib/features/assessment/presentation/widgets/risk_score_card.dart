import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BuildRiskScoreCard extends StatelessWidget {
  final double riskScore;

  const BuildRiskScoreCard({super.key, required this.riskScore});

  String get riskLevel {
    if (riskScore < 50) return 'low';
    if (riskScore < 80) return 'medium';
    return 'high';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border(
          top: BorderSide(
            color: switch (riskLevel) {
              'low' => MyColors.riskLow,
              'medium' => MyColors.riskMedium,
              'high' => MyColors.riskHigh,
              _ => Colors.grey,
            },
            width: 4,
          ),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'CARDIAC RISK SCORE',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: CircularProgressIndicator(
                  value: (riskScore / 100).clamp(0.0, 1.0),
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(switch (riskLevel) {
                    'low' => MyColors.riskLow,
                    'medium' => MyColors.riskMedium,
                    'high' => MyColors.riskHigh,
                    _ => Colors.grey,
                  }),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${riskScore.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 48,
                      color: switch (riskLevel) {
                        'low' => MyColors.riskLow,
                        'medium' => MyColors.riskMedium,
                        'high' => MyColors.riskHigh,
                        _ => Colors.grey,
                      },
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    switch (riskLevel) {
                      'low' => 'Low Risk',
                      'medium' => 'Medium Risk',
                      'high' => 'High Risk',
                      _ => 'Unknown Risk',
                    },
                    style: TextStyle(
                      color: switch (riskLevel) {
                        'low' => MyColors.riskLow,
                        'medium' => MyColors.riskMedium,
                        'high' => MyColors.riskHigh,
                        _ => Colors.grey,
                      },
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(switch (riskLevel) {
              'low' =>
                'Patient is at low risk for cardiac events. Continue regular monitoring and maintain healthy lifestyle.',
              'medium' =>
                'Patient is at medium risk for cardiac events. Consider lifestyle modifications and closer monitoring.',
              'high' =>
                'Patient is at high risk for cardiac events. Immediate medical evaluation and intervention recommended.',
              _ =>
                'Risk level unknown. Please consult a healthcare professional.',
            }, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
