import 'package:cardiogaurd/core/widgets/app_bar.dart';
import 'package:cardiogaurd/core/widgets/global_drawer.dart';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/patient_bottom_nav.dart';

class PatientHome extends StatelessWidget {
  final Widget child;

  const PatientHome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final name = user?.displayName ?? "Guest User";
        final email = user?.email ?? "";
        final profilePic = user?.profileImageUrl ?? 'images/patient_placeholder.png';

        return Scaffold(
          appBar: BuildAppBar(profilePictureUrl: profilePic),
          endDrawer: BuildDrawer(
            profilePictureUrl: profilePic,
            name: name,
            email: email,
          ),
          body: child,
          bottomNavigationBar: const BuildBottomNav(),
        );
      },
    );
  }
}
