import 'package:cardiogaurd/core/enums/user_role.dart';
import 'package:cardiogaurd/app/router/app_router.dart';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cardiogaurd/features/auth/presentation/widgets/sign_in_form_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/login_header.dart';
import '../widgets/login_footer.dart';

class LoginScreen extends StatefulWidget {
  final String? role;
  const LoginScreen({super.key, this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && state.user != null) {
          context.go(AppRouter.homeForRole(state.user!.role));
        } else if (state.status == AuthStatus.failure &&
            state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      builder: (context, state) {
        final busy = state.status == AuthStatus.loading;
        return Scaffold(
          backgroundColor: MyColors.scaffoldBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const LoginHeader(),
                  const SizedBox(height: 32),
                  const SizedBox(height: 32),
                  SignInFormContainer(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onSignInPressed: busy
                        ? () {}
                        : () {
                            UserRole? forceRole;
                            if (widget.role == 'doctor') {
                              forceRole = UserRole.doctor;
                            } else if (widget.role == 'patient') {
                              forceRole = UserRole.patient;
                            }

                            context.read<AuthCubit>().signIn(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                  forceRole: forceRole,
                                );
                          },
                    onCreateAccountPressed: () {
                      final path = widget.role != null
                          ? '/register?role=${widget.role}'
                          : '/register';
                      context.push(path);
                    },
                    onForgotPressed: () => _showForgotPasswordDialog(context),
                  ),
                  const SizedBox(height: 40),
                  const LoginFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter your email address and we will send you a link to reset your password."),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                context.read<AuthCubit>().sendPasswordResetEmail(email);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("If an account exists for this email, a reset link will be sent.")),
                );
              }
            },
            child: const Text("SEND LINK"),
          ),
        ],
      ),
    );
  }
}
