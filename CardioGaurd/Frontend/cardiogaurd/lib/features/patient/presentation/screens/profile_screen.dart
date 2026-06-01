import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cardiogaurd/features/auth/domain/entities/app_user.dart';
import 'package:cardiogaurd/features/history/presentation/cubit/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_utils.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) return const Scaffold(body: Center(child: Text("User not found")));

        return Scaffold(
          backgroundColor: MyColors.scaffoldBackground,
          appBar: AppBar(
            title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => context.push('/edit-profile'), 
                icon: const Icon(Icons.edit_note, color: MyColors.primaryBlue, size: 28)
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildProfileHeader(user.profileImageUrl, user.displayName, user.email),
                const SizedBox(height: 30),
                _buildLastAssessmentSection(),
                const SizedBox(height: 30),
                _buildInfoSection(user),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(String profilePic, String name, String email) {
    final image = CardioImageUtils.getImageProvider(profilePic, fallback: 'images/patient_placeholder.png');

    return Column(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
            ],
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(email, style: const TextStyle(color: Colors.grey, fontSize: 16)),
      ],
    );
  }

  Widget _buildLastAssessmentSection() {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final lastEntry = state.entries.isNotEmpty ? state.entries.first : null;
        final score = lastEntry?.score ?? 0;
        final date = lastEntry?.date != null ? lastEntry!.date.toString().split(' ')[0] : "No Data";

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [MyColors.primaryBlue, MyColors.primaryBlue.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white24,
                radius: 25,
                child: Icon(Icons.favorite, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Health Status", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text("Last Scan: $date", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${score.toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  const Text("Risk Level", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(AppUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("PERSONAL DETAILS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
        const SizedBox(height: 15),
        _buildInfoTile(Icons.email_outlined, "Email", user.email),
        _buildInfoTile(Icons.phone_android_outlined, "Phone", user.phone ?? "Not provided"),
        _buildInfoTile(Icons.wc_outlined, "Gender", user.gender ?? "Not provided"),
        _buildInfoTile(Icons.cake_outlined, "Date of Birth", user.dob ?? "Not provided"),
        _buildInfoTile(Icons.badge_outlined, "Role", user.role.name.toUpperCase()),
        _buildInfoTile(Icons.fingerprint, "User ID", user.id.substring(0, 8)),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: MyColors.primaryBlue, size: 22),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}