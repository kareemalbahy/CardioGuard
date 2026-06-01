import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';

class AssessmentInputModel extends AssessmentInputEntity {
  const AssessmentInputModel({
    required super.age,
    required super.sex,
    required super.cp,
    required super.trestbps,
    required super.chol,
    required super.fbs,
    required super.restecg,
    required super.thalach,
    required super.exang,
    required super.oldpeak,
    required super.slope,
    required super.ca,
    required super.thal,
  });

  factory AssessmentInputModel.fromMap(Map<String, dynamic> map) {
    return AssessmentInputModel(
      age: (map['age'] as num?)?.toDouble() ?? 0.0,
      sex: map['sex'] as int? ?? 0,
      cp: map['cp'] as int? ?? 0,
      trestbps: (map['trestbps'] as num?)?.toDouble() ?? 0.0,
      chol: (map['chol'] as num?)?.toDouble() ?? 0.0,
      fbs: map['fbs'] as int? ?? 0,
      restecg: map['restecg'] as int? ?? 0,
      thalach: (map['thalachh'] as num?)?.toDouble() ?? 0.0,
      exang: map['exang'] as int? ?? 0,
      oldpeak: (map['oldpeak'] as num?)?.toDouble() ?? 0.0,
      slope: map['slope'] as int? ?? 0,
      ca: map['ca'] as int? ?? 0,
      thal: map['thal'] as int? ?? 0,
    );
  }

  factory AssessmentInputModel.fromEntity(AssessmentInputEntity entity) {
    return AssessmentInputModel(
      age: entity.age,
      sex: entity.sex,
      cp: entity.cp,
      trestbps: entity.trestbps,
      chol: entity.chol,
      fbs: entity.fbs,
      restecg: entity.restecg,
      thalach: entity.thalach,
      exang: entity.exang,
      oldpeak: entity.oldpeak,
      slope: entity.slope,
      ca: entity.ca,
      thal: entity.thal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'sex': sex,
      'cp': cp,
      'trestbps': trestbps,
      'chol': chol,
      'fbs': fbs,
      'restecg': restecg,
      'thalachh': thalach,
      'exang': exang,
      'oldpeak': oldpeak,
      'slope': slope,
      'ca': ca,
      'thal': thal,
    };
  }
}
