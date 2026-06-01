import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cardiogaurd/features/doctor/presentation/cubit/doctor_patients_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_utils.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final profilePic = user?.profileImageUrl ?? 'images/doctor_placeholder.png';
        
        return Scaffold(
          backgroundColor: MyColors.scaffoldBackground,
          appBar: AppBar(
            title: const Text("Professional Profile", style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeader(user?.displayName ?? "Doctor", user?.email ?? "", profilePic),
                const SizedBox(height: 24),
                _buildCredentialsCard(user?.specialty ?? "Specialist", user?.hospital ?? "Clinic"),
                const SizedBox(height: 24),
                _buildStatsSection(context),
                const SizedBox(height: 32),
                _buildActionButtons(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(String name, String email, String profilePic) {
    final image = CardioImageUtils.getImageProvider(profilePic, fallback: 'images/doctor_placeholder.png');

    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: MyColors.primaryBlue, width: 3),
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.verified, color: MyColors.primaryBlue, size: 20),
          ],
        ),
        Text(email, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildCredentialsCard(String specialty, String hospital) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("CLINICAL CREDENTIALS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          const SizedBox(height: 16),
          _infoRow(Icons.medical_services_outlined, "Specialty", specialty),
          const Divider(height: 24),
          _infoRow(Icons.local_hospital_outlined, "Hospital", hospital),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: MyColors.primaryBlue, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return BlocBuilder<DoctorPatientsCubit, DoctorPatientsState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(child: _statCard("Total Patients", "${state.patients.length}", Icons.people_outline)),
            const SizedBox(width: 16),
            Expanded(child: _statCard("Pending", "${state.pendingAssignments.length}", Icons.assignment_outlined)),
          ],
        );
      },
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.primaryBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () => context.push('/doctor-edit-profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: MyColors.primaryBlue,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: MyColors.primaryBlue)),
            ),
            child: const Text("Edit Professional Profile", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            context.read<AuthCubit>().signOut();
            context.go('/role-selection');
          },
          child: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
