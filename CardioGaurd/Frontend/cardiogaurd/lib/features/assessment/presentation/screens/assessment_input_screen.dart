import 'package:cardiogaurd/core/constants/app_strings.dart';
import 'package:cardiogaurd/features/assessment/presentation/widgets/calculate_button.dart';
import 'package:cardiogaurd/features/patient/domain/entities/user_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:cardiogaurd/features/assessment/presentation/widgets/slider_card.dart';
import 'package:cardiogaurd/features/assessment/presentation/widgets/toggle_card.dart';

class AssessmentInputScreen extends StatefulWidget {
  const AssessmentInputScreen({super.key});

  @override
  State<AssessmentInputScreen> createState() => _AssessmentInputScreenState();
}

class _AssessmentInputScreenState extends State<AssessmentInputScreen> {
  final userProfile = UserProfileEntity(
    name: fullName,
    email: email,
    phone: phoneNumber,
    gender: sex,
    age: 24,
    profileImageUrl: patientImageURL,
    lastRiskScore: 68.0,
    lastAssessmentDate: "Oct 12, 2023",
  );

  // 13 Feature Variables initialized to standard clinical baselines (Age & Sex from Profile)
  late double _age = userProfile.age.toDouble();
  late int _sex = userProfile.gender.toLowerCase() == 'male'
      ? 1
      : 0; // 0: Female, 1: Male
  int _cp =
      0; // 0: Typical Angina, 1: Atypical Angina, 2: Non-anginal, 3: Asymptomatic
  double _trestbps = 120; // Resting Blood Pressure
  double _chol = 200; // Serum Cholesterol
  double _fbsValue = 100; // Fasting Blood Sugar numeric value
  int _fbs = 0; // Fasting blood sugar > 120 mg/dl: 0 = False, 1 = True
  int _restecg = 0; // 0: Normal, 1: ST-T wave abnormality, 2: LV hypertrophy
  double _thalach = 150; // Maximum heart rate achieved
  int _exang = 0; // Exercise-induced angina: 0 = No, 1 = Yes
  double _oldpeak = 1.0; // ST depression induced by exercise
  int _slope = 1; // 0: Upsloping, 1: Flat, 2: Downsloping
  int _ca = 0; // Number of major vessels (0-3)
  int _thal = 1; // 1: Normal, 2: Fixed defect, 3: Reversible defect

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),

            BuildSliderCard(
              title: 'Age',
              initialValue: _age,
              min: 0,
              max: 100,
              unit: 'years old',
              badge: false,
              imgpath: 'images/time.png',
              onChangedTFF: (val) => setState(() => _age = val),
              onChangedsld: (val) => setState(() => _age = val),
            ),

            BuildToggleCard(
              imgpath: 'images/gender.png',
              title: 'Gender',
              options: const ['Female', 'Male'],
              selectedIndex: _sex,
              onChanged: (val) => setState(() => _sex = val),
            ),

            BuildToggleCard(
              imgpath: 'images/chest-pain.png',
              title: 'Chest Pain Type',
              options: const [
                'Typical Angina',
                'Atypical Angina',
                'Non-anginal',
                'Asymptomatic',
              ],
              selectedIndex: _cp,
              onChanged: (val) => setState(() => _cp = val),
            ),

            BuildSliderCard(
              title: 'Resting BP',
              initialValue: _trestbps,
              min: 80,
              max: 220,
              unit: 'mmHg',
              badge: true,
              imgpath: 'images/machine.png',
              minst: 90,
              maxst: 130,
              onChangedTFF: (val) => setState(() => _trestbps = val),
              onChangedsld: (val) => setState(() => _trestbps = val),
            ),

            BuildSliderCard(
              title: 'Cholestrol',
              initialValue: _chol,
              min: 100,
              max: 600,
              unit: 'mg/dL',
              badge: true,
              imgpath: 'images/blood-test.png',
              minst: 0,
              maxst: 200,
              stableLabel: 'Normal',
              unstableLabel: 'High',
              onChangedTFF: (val) => setState(() => _chol = val),
              onChangedsld: (val) => setState(() => _chol = val),
            ),

            BuildSliderCard(
              title: 'Blood Sugar',
              initialValue: _fbsValue,
              min: 0,
              max: 500,
              unit: 'mg/dL',
              badge: true,
              imgpath: 'images/diabetes.png',
              minst: 0,
              maxst: 120,
              stableLabel: '<120',
              unstableLabel: '>120',
              onChangedTFF: (val) {
                setState(() {
                  _fbsValue = val;
                  _fbs = val > 120 ? 1 : 0;
                });
              },
              onChangedsld: (val) {
                setState(() {
                  _fbsValue = val;
                  _fbs = val > 120 ? 1 : 0;
                });
              },
            ),

            BuildToggleCard(
              imgpath: 'images/ecg.png',
              title: 'ECG',
              options: const ['Normal', 'ST-T Abnormality', 'LV Hypertrophy'],
              selectedIndex: _restecg,
              onChanged: (val) => setState(() => _restecg = val),
            ),

            BuildSliderCard(
              title: 'Max Heart Rate',
              initialValue: _thalach,
              min: 60,
              max: 220,
              unit: 'bpm',
              badge: true,
              imgpath: 'images/heartrate.png',
              minst: 100,
              maxst: 170,
              onChangedTFF: (val) => setState(() => _thalach = val),
              onChangedsld: (val) => setState(() => _thalach = val),
            ),

            BuildToggleCard(
              imgpath: 'images/chest-pain.png',
              title: 'Exercise Angina',
              options: const ['No', 'Yes'],
              selectedIndex: _exang,
              onChanged: (val) => setState(() => _exang = val),
            ),

            BuildSliderCard(
              title: 'ST Depression',
              initialValue: _oldpeak,
              min: 0,
              max: 6,
              unit: 'mm',
              badge: true,
              imgpath: 'images/heartrate.png',
              minst: 0,
              maxst: 1.5,
              onChangedTFF: (val) => setState(() => _oldpeak = val),
              onChangedsld: (val) => setState(() => _oldpeak = val),
            ),

            BuildToggleCard(
              imgpath: 'images/heartrate.png',
              title: 'Peak ST Slope',
              options: const ['Upsloping', 'Flat', 'Downsloping'],
              selectedIndex: _slope,
              onChanged: (val) => setState(() => _slope = val),
            ),

            BuildToggleCard(
              imgpath: 'images/vessels.png',
              title: 'Colored Vessels',
              options: const ['0', '1', '2', '3'],
              selectedIndex: _ca,
              onChanged: (val) => setState(() => _ca = val),
            ),

            BuildToggleCard(
              imgpath: 'images/thalassemia.png',
              title: 'Thalassemia',
              options: const ['Normal', 'Fixed Defect', 'Reversible Defect'],
              selectedIndex: _thal - 1,
              onChanged: (val) => setState(() => _thal = val + 1),
            ),

            CalculateButton(
              ageVal: _age,
              sexVal: _sex,
              cpVal: _cp,
              trestbpsVal: _trestbps,
              cholVal: _chol,
              fbsVal: _fbs,
              restecgVal: _restecg,
              thalachVal: _thalach,
              exangVal: _exang,
              oldpeakVal: _oldpeak,
              slopeVal: _slope,
              caVal: _ca,
              thalVal: _thal,
            ),

            const SizedBox(height: 16),
            _buildClinicalInsightCard(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Smart Risk\nAssessment',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Provide your 13 Cleveland dataset clinical parameters below. Our advanced model uses these accurate values to predict precision cardiovascular health scores.',
          style: TextStyle(color: Colors.grey[700], fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildClinicalInsightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF1E3A8A),
            radius: 18,
            child: Icon(Icons.lightbulb_outline, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Standardized Feature Input',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The Cleveland format classifies key hemodynamic stress measurements like ST segment changes during exercise (oldpeak/slope) alongside major colored vessels (ca) to accurately assess arterial blockages.',
                  style: TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
