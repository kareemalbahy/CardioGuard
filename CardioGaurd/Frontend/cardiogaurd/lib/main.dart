import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cardiogaurd/app/app.dart';
import 'package:cardiogaurd/app/di/injection_container.dart';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await configureDependencies();

  await sl<AuthCubit>().checkAuthStatus();

  runApp(const CardioGuardApp());
}
