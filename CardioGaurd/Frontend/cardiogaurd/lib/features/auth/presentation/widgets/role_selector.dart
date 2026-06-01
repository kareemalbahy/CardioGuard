import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "I AM A",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: MyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRoleOption("patient", Icons.person_outline, "Patient"),
            const SizedBox(width: 12),
            _buildRoleOption("doctor", Icons.medical_services_outlined, "Doctor"),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleOption(String role, IconData icon, String label) {
    bool isSelected = selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => onRoleChanged(role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? MyColors.primaryBlue : MyColors.inputField,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? MyColors.primaryBlue : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : MyColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : MyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}