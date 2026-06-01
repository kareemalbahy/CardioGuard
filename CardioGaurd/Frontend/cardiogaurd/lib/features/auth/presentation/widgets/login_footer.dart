import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "© 2026 CARDIOGUARD\nMEDICAL SYSTEMS",
            style: TextStyle(
              fontSize: 10,
              color: MyColors.textSecondary,
              height: 1.4,
            ),
          ),
          Text(
            "PRIVACY\nPOLICY",
            style: TextStyle(
              fontSize: 10,
              color: MyColors.textSecondary,
              height: 1.4,
            ),
          ),
          Text(
            "SYSTEM\nSTATUS",
            style: TextStyle(
              fontSize: 10,
              color: MyColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}