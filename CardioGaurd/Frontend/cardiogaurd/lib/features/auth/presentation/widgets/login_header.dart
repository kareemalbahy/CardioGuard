import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 42,
                height: 1.1,
                fontWeight: FontWeight.w900,
                color: MyColors.textPrimary,
              ),
              children: [
                TextSpan(text: "Clinical\nintegrity.\n"),
                TextSpan(
                  text: "Human-\ncentered.",
                  style: TextStyle(color: MyColors.primaryBlue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Advanced cardiac monitoring for those who prioritize clinical precision and personal health ownership.",
            style: TextStyle(
              fontSize: 16,
              color: MyColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}