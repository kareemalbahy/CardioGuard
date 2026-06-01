import 'dart:io';
import 'package:cardiogaurd/app/router/app_router.dart';
import 'package:cardiogaurd/core/enums/user_role.dart';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/login_header.dart';
import '../widgets/register_form_container.dart';
import '../widgets/login_footer.dart';

class RegisterScreen extends StatefulWidget {
  final String? selectedRole;
  const RegisterScreen({super.key, this.selectedRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  
  late String _selectedRole;
  File? _profileImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.selectedRole ?? 'patient';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _specialtyController.dispose();
    _hospitalController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  UserRole _roleFromSelection() =>
      _selectedRole == 'doctor' ? UserRole.doctor : UserRole.patient;

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
                  RegisterFormContainer(
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    specialtyController: _specialtyController,
                    hospitalController: _hospitalController,
                    phoneController: _phoneController,
                    dobController: _dobController,
                    genderController: _genderController,
                    profileImage: _profileImage,
                    onPickImage: _pickImage,
                    selectedRole: _selectedRole,
                    onRoleChanged: (role) {
                      setState(() => _selectedRole = role);
                    },
                    onRegisterPressed: busy
                        ? () {}
                        : () {
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match'),
                                ),
                              );
                              return;
                            }
                            context.read<AuthCubit>().register(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                  role: _roleFromSelection(),
                                  specialty: _selectedRole == 'doctor' ? _specialtyController.text.trim() : null,
                                  hospital: _selectedRole == 'doctor' ? _hospitalController.text.trim() : null,
                                  phone: _phoneController.text.trim(),
                                  gender: _genderController.text.trim(),
                                  dob: _dobController.text.trim(),
                                  profileImage: _profileImage,
                                );
                          },
                    onLoginPressed: () => context.pop(),
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
}
