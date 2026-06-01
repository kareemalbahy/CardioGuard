import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cardiogaurd/app/app.dart';
import 'package:cardiogaurd/app/di/injection_container.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await configureDependencies();
  runApp(const CardioGuardApp());
}
