import 'package:flutter/material.dart';

class AssessmentStatusInfo {
  final String text;
  final Color color;

  AssessmentStatusInfo(this.text, this.color);
}

AssessmentStatusInfo getAssessmentStatusInfo(double current, double? previous) {
  if (previous == null) {
    return AssessmentStatusInfo('STABLE', Colors.grey);
  }
  
  if (current > previous) {
    return AssessmentStatusInfo('WORSENING', Colors.red);
  } else if (current < previous) {
    return AssessmentStatusInfo('IMPROVING', Colors.green);
  } else{
    return AssessmentStatusInfo('STABLE', Colors.grey);
  }
}
