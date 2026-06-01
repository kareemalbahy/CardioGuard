import 'package:equatable/equatable.dart';

class AssessmentInputEntity extends Equatable {
  final double age;
  final int sex;
  final int cp;
  final double trestbps;
  final double chol;
  final int fbs;
  final int restecg;
  final double thalach;
  final int exang;
  final double oldpeak;
  final int slope;
  final int ca;
  final int thal;

  const AssessmentInputEntity({
    required this.age,
    required this.sex,
    required this.cp,
    required this.trestbps,
    required this.chol,
    required this.fbs,
    required this.restecg,
    required this.thalach,
    required this.exang,
    required this.oldpeak,
    required this.slope,
    required this.ca,
    required this.thal,
  });

  @override
  List<Object?> get props => [
        age,
        sex,
        cp,
        trestbps,
        chol,
        fbs,
        restecg,
        thalach,
        exang,
        oldpeak,
        slope,
        ca,
        thal,
      ];
}
