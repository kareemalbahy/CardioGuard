import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'login_text_field.dart';

class SignInFormContainer extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignInPressed;
  final VoidCallback onCreateAccountPressed;
  final VoidCallback onForgotPressed;

  const SignInFormContainer({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSignInPressed,
    required this.onCreateAccountPressed,
    required this.onForgotPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: MyColors.cardBackground,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Sign In",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: MyColors.textPrimary,
            ),
          ),
          const Text(
            "Access your cardiac health dashboard",
            style: TextStyle(color: MyColors.textSecondary),
          ),
          const SizedBox(height: 32),
          
          LoginTextField(
            label: "EMAIL ADDRESS",
            hint: "name@medical-center.com",
            controller: emailController,
          ),
          
          const SizedBox(height: 24),
          
          LoginTextField(
            label: "PASSWORD",
            hint: "••••••••",
            controller: passwordController,
            isPassword: true,
            forgot: true,
            onForgotPressed: onForgotPressed,
          ),
          
          const SizedBox(height: 32),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.actionBlue,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onSignInPressed,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Secure Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.lock, color: Colors.white, size: 20),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          const Divider(color: MyColors.borderGray),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "New to CardioGuard?",
                style: TextStyle(color: MyColors.textSecondary),
              ),
              TextButton(
                onPressed: onCreateAccountPressed,
                child: const Text(
                  "Create account",
                  style: TextStyle(
                    color: MyColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fingerprint, size: 14, color: MyColors.textSecondary),
              SizedBox(width: 4),
              Text(
                "BIOMETRIC READY",
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: MyColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}