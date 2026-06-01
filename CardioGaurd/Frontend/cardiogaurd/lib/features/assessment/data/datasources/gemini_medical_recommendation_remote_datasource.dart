import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cardiogaurd/features/assessment/data/datasources/medical_recommendation_remote_datasource.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';

class GeminiMedicalRecommendationRemoteDataSource
    implements MedicalRecommendationRemoteDataSource {
  final GenerativeModel _model;

  GeminiMedicalRecommendationRemoteDataSource(String apiKey)
    : _model = GenerativeModel(
        model: 'models/gemini-2.5-flash',
        apiKey: apiKey,
      );

  @override
  Future<String> getRecommendations({
    required AssessmentInputEntity input,
    required double riskScore,
  }) async {
    final patientData = {
      'age': input.age,
      'sex': input.sex == 1 ? 'Male' : 'Female',
      'chest_pain_type': input.cp,
      'resting_bp': input.trestbps,
      'cholesterol': input.chol,
      'fasting_blood_sugar': input.fbs,
      'resting_ecg': input.restecg,
      'max_heart_rate': input.thalach,
      'exercise_angina': input.exang,
      'st_depression': input.oldpeak,
      'st_slope': input.slope,
      'vessels_colored': input.ca,
      'thalassemia': input.thal,
    };

    final prediction = riskScore >= 50 ? 'High Risk' : 'Low Risk';

    final prompt =
        """
Act as a cardiologist. Based on this patient data: $patientData 
and calculated cardiovascular risk prediction: $prediction (Score: ${riskScore.toStringAsFixed(1)}%).

Provide 5 short, professional, and actionable clinical recommendations. 
Format them as a bulleted list. 
Focus on lifestyle, monitoring, and clinical follow-up.
""";

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ??
          "No clinical advice available at this time. Please consult your physician.";
    } catch (e) {
      if (e.toString().contains('503')) {
        return "The AI service is currently overloaded. Please try again in a few moments.";
      }
      return "Unable to generate recommendations at this time. Please follow standard clinical guidelines.";
    }
  }
}
