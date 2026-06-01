import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../history/domain/entities/history_entry_entity.dart';
import '../../../assessment/domain/entities/assessment_input_entity.dart';

class AssessmentDetailsScreen extends StatelessWidget {
  final HistoryEntryEntity assessment;

  const AssessmentDetailsScreen({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    final inputs = assessment.inputs;
    
    final Color color;
    final String statusText;
    
    if (assessment.score < 50) {
      color = MyColors.riskLow;
      statusText = 'Low Risk';
    } else if (assessment.score < 80) {
      color = MyColors.riskMedium;
      statusText = 'Medium Risk';
    } else {
      color = MyColors.riskHigh;
      statusText = 'High Risk';
    }

    return Scaffold(
      backgroundColor: MyColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Assessment Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(color, statusText),
            const SizedBox(height: 32),
            const Text(
              'Input Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (inputs == null)
              const Center(child: Text('No input data available'))
            else
              _buildFeaturesGrid(inputs),
            const SizedBox(height: 32),
            const Text(
              'Clinical Recommendations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (assessment.recommendations.isEmpty)
              const Center(child: Text('No recommendations available'))
            else
              _buildRecommendationsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00458D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: assessment.recommendations.map((rec) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  rec,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildSummaryCard(Color color, String statusText) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM dd, yyyy').format(assessment.date),
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text('Risk Assessment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${assessment.score}%',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
              ),
              Text(
                statusText,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(AssessmentInputEntity inputs) {
    final features = [
      {'label': 'Age', 'value': '${inputs.age}'},
      {'label': 'Sex', 'value': inputs.sex == 1 ? 'Male' : 'Female'},
      {'label': 'Chest Pain Type', 'value': _getCpType(inputs.cp)},
      {'label': 'Resting BP', 'value': '${inputs.trestbps} mmHg'},
      {'label': 'Cholesterol', 'value': '${inputs.chol} mg/dl'},
      {'label': 'Fasting Blood Sugar', 'value': inputs.fbs == 1 ? '> 120 mg/dl' : '< 120 mg/dl'},
      {'label': 'Resting ECG', 'value': _getRestEcg(inputs.restecg)},
      {'label': 'Max Heart Rate', 'value': '${inputs.thalach}'},
      {'label': 'Exercise Angina', 'value': inputs.exang == 1 ? 'Yes' : 'No'},
      {'label': 'Oldpeak', 'value': '${inputs.oldpeak}'},
      {'label': 'Slope', 'value': _getSlope(inputs.slope)},
      {'label': 'Major Vessels', 'value': '${inputs.ca}'},
      {'label': 'Thalassemia', 'value': _getThal(inputs.thal)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _buildFeatureItem(features[index]['label']!, features[index]['value']!);
      },
    );
  }

  Widget _buildFeatureItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  String _getCpType(int type) {
    switch (type) {
      case 0: return 'Typical Angina';
      case 1: return 'Atypical Angina';
      case 2: return 'Non-anginal Pain';
      case 3: return 'Asymptomatic';
      default: return 'Unknown';
    }
  }

  String _getRestEcg(int res) {
    switch (res) {
      case 0: return 'Normal';
      case 1: return 'ST-T Wave Abnormality';
      case 2: return 'Left Ventricular Hypertrophy';
      default: return 'Unknown';
    }
  }

  String _getSlope(int s) {
    switch (s) {
      case 0: return 'Upsloping';
      case 1: return 'Flat';
      case 2: return 'Downsloping';
      default: return 'Unknown';
    }
  }

  String _getThal(int t) {
    switch (t) {
      case 1: return 'Normal';
      case 2: return 'Fixed Defect';
      case 3: return 'Reversable Defect';
      default: return 'Unknown';
    }
  }
}
