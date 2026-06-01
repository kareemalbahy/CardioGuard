import 'package:flutter/material.dart';

class AssessmentHistory {
  final String date;
  final double score;
  String status = "STABLE";
  Color color = Colors.grey;

  AssessmentHistory({
    required this.date,
    required this.score,
  });
}