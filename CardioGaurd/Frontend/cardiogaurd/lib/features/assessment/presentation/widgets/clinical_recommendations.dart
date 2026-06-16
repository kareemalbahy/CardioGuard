import 'package:flutter/material.dart';

class BuildClinicalRecommendation extends StatelessWidget {
  final String items;

  const BuildClinicalRecommendation({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final recommendationLines = items
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.replaceAll(RegExp(r'^[\*\-\d\.]+\s*'), '').trim())
        .toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF00458D),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Clinical\nRecommendations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (recommendationLines.isEmpty)
            _buildRecommendationItem(Icons.info_outline, items)
          else
            ...recommendationLines.map((line) =>
                _buildRecommendationItem(Icons.check_circle_outline, line)),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
