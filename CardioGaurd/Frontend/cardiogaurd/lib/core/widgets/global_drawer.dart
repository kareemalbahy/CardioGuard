import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:cardiogaurd/core/utils/image_utils.dart';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/enums/user_role.dart';

class BuildDrawer extends StatelessWidget {
  final String profilePictureUrl;
  final String name;
  final String email;
  
  const BuildDrawer({
    super.key,
    required this.profilePictureUrl,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final isDoctor = user?.role == UserRole.doctor;
    
    final imageProvider = CardioImageUtils.getImageProvider(
      profilePictureUrl,
      fallback: isDoctor ? 'images/doctor_placeholder.png' : 'images/patient_placeholder.png',
    );

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: MyColors.primaryBlue,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: imageProvider,
              onBackgroundImageError: (error, stackTrace) {
              },
            ),
            accountName: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(email),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("View Profile"),
            onTap: () {
              context.push('/profile');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<AuthCubit>().signOut();
              context.go('/role-selection');
            },
          ),
        ],
      ),
    );
  }
}
