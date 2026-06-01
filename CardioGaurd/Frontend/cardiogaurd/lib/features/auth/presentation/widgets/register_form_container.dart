import 'dart:io';
import 'package:cardiogaurd/features/auth/presentation/widgets/role_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import 'login_text_field.dart';

class RegisterFormContainer extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController specialtyController;
  final TextEditingController hospitalController;
  final TextEditingController phoneController;
  final TextEditingController dobController;
  final TextEditingController genderController;
  final String selectedRole;
  final File? profileImage;
  final VoidCallback onPickImage;
  final Function(String) onRoleChanged;
  final VoidCallback onRegisterPressed;
  final VoidCallback onLoginPressed;

  const RegisterFormContainer({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.specialtyController,
    required this.hospitalController,
    required this.phoneController,
    required this.dobController,
    required this.genderController,
    required this.selectedRole,
    this.profileImage,
    required this.onPickImage,
    required this.onRoleChanged,
    required this.onRegisterPressed,
    required this.onLoginPressed,
  });

  @override
  State<RegisterFormContainer> createState() => _RegisterFormContainerState();
}

class _RegisterFormContainerState extends State<RegisterFormContainer> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColors.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        widget.dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

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
          _buildAvatarPicker(),
          const SizedBox(height: 24),
          const Text(
            "Create Account",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: MyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          
          LoginTextField(
            label: "FULL NAME",
            hint: "John Doe",
            controller: widget.nameController,
          ),
          const SizedBox(height: 20),
          
          LoginTextField(
            label: "EMAIL ADDRESS",
            hint: "name@medical-center.com",
            controller: widget.emailController,
          ),
          const SizedBox(height: 20),

          LoginTextField(
            label: "PHONE NUMBER",
            hint: "+20 123 456 789",
            controller: widget.phoneController,
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: LoginTextField(
                      label: "DOB",
                      hint: "Select Date",
                      controller: widget.dobController,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: ["Male", "Female"].contains(widget.genderController.text) 
                      ? widget.genderController.text 
                      : null,
                  decoration: InputDecoration(
                    labelText: "GENDER",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ["Male", "Female"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      widget.genderController.text = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
    
          RoleSelector(
            selectedRole: widget.selectedRole,
            onRoleChanged: widget.onRoleChanged,
          ),
          const SizedBox(height: 20),

          if (widget.selectedRole == 'doctor') ...[
            LoginTextField(
              label: "SPECIALTY",
              hint: "Senior Cardiologist",
              controller: widget.specialtyController,
            ),
            const SizedBox(height: 20),
            LoginTextField(
              label: "HOSPITAL / CLINIC",
              hint: "City Medical Center",
              controller: widget.hospitalController,
            ),
            const SizedBox(height: 20),
          ],
          
          LoginTextField(
            label: "PASSWORD",
            hint: "••••••••",
            controller: widget.passwordController,
            isPassword: true,
          ),
          const SizedBox(height: 20),
          
          LoginTextField(
            label: "CONFIRM PASSWORD",
            hint: "••••••••",
            controller: widget.confirmPasswordController,
            isPassword: true,
          ),
          const SizedBox(height: 32),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryBlue,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: widget.onRegisterPressed,
            child: const Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          const Divider(color: MyColors.borderGray),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: MyColors.textSecondary),
              ),
              TextButton(
                onPressed: widget.onLoginPressed,
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    color: MyColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return GestureDetector(
      onTap: widget.onPickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
              border: Border.all(color: MyColors.primaryBlue, width: 2),
              image: widget.profileImage != null 
                ? DecorationImage(image: FileImage(widget.profileImage!), fit: BoxFit.cover)
                : null,
            ),
            child: widget.profileImage == null 
              ? const Icon(Icons.person, size: 50, color: Colors.grey)
              : null,
          ),
          const CircleAvatar(
            backgroundColor: MyColors.primaryBlue,
            radius: 14,
            child: Icon(Icons.add, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}