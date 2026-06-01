import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:cardiogaurd/core/theme/app_colors.dart';

class BuildBottomNav extends StatelessWidget {
  const BuildBottomNav({super.key});

  int _getIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/inputs')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/doctor-contact')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex(context);

    final routes = [
      '/dashboard',
      '/inputs',
      '/history',
      '/doctor-contact',
    ];

    return ConvexAppBar(
      style: TabStyle.reactCircle,
      backgroundColor: Colors.white,
      color: MyColors.primaryBlue,
      activeColor: MyColors.primaryBlue,
      elevation: 10,

      items: const [
        TabItem(icon: Icons.explore_outlined, title: 'Dashboard'),
        TabItem(icon: Icons.science, title: 'Simulator'),
        TabItem(icon: Icons.bar_chart, title: 'History'),
        TabItem(icon: Icons.medical_services_outlined, title: 'doctor'),
      ],

      initialActiveIndex: currentIndex,

      onTap: (index) {
        context.go(routes[index]);
      },
    );
  }
  }
