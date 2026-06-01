import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardiogaurd/app/di/injection_container.dart';
import 'package:cardiogaurd/app/router/app_router.dart';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';

class CardioGuardApp extends StatelessWidget {
  const CardioGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: sl<AuthCubit>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
