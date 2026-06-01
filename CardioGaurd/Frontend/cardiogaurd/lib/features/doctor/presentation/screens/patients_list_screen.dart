import 'package:flutter/material.dart';
import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:cardiogaurd/features/patient/presentation/widgets/patient_bottom_nav.dart';
import 'package:go_router/go_router.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: Image.asset('images/heart.png'),
        ),
        title: Text(
          'CardioGuard',
          style: TextStyle(
            color: MyColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
            icon: Icon(Icons.notifications, color: MyColors.primaryBlue),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              child: IconButton(
                onPressed: () => context.push('/profile'),
                icon: Icon(Icons.person, color: MyColors.primaryBlue),
              ),
            ),
          ),
        ],
      ),

      body: Container(),
      bottomNavigationBar: BuildBottomNav(),
    );
  }
}
