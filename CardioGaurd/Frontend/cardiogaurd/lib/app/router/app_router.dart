import 'package:cardiogaurd/features/doctor/presentation/screens/assessment_details_screen.dart';
import 'package:cardiogaurd/features/doctor/presentation/screens/doctor_edit_profile_screen.dart';
import 'package:cardiogaurd/features/doctor/presentation/screens/doctor_profile_screen.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cardiogaurd/app/di/injection_container.dart';
import 'package:cardiogaurd/core/enums/user_role.dart';
import 'package:cardiogaurd/features/assessment/presentation/cubit/assessment_cubit.dart';
import 'package:cardiogaurd/features/assessment/presentation/screens/assessment_input_screen.dart';
import 'package:cardiogaurd/features/assessment/presentation/screens/assessment_result_screen.dart';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cardiogaurd/features/auth/presentation/screens/login_screen.dart';
import 'package:cardiogaurd/features/auth/presentation/screens/register_screen.dart';
import 'package:cardiogaurd/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:cardiogaurd/features/chat/presentation/screens/chat_screen.dart';
import 'package:cardiogaurd/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:cardiogaurd/features/doctor/presentation/cubit/doctor_patients_cubit.dart';
import 'package:cardiogaurd/features/doctor/presentation/screens/doctor_home.dart';
import 'package:cardiogaurd/features/doctor/presentation/screens/patient_details_screen.dart';
import 'package:cardiogaurd/features/doctor/presentation/screens/patient_doctor_view.dart';
import 'package:cardiogaurd/features/history/presentation/cubit/history_cubit.dart';
import 'package:cardiogaurd/features/history/presentation/screens/history_screen.dart';
import 'package:cardiogaurd/features/patient/presentation/screens/edit_profile_screen.dart';
import 'package:cardiogaurd/features/patient/presentation/screens/patient_home.dart';
import 'package:cardiogaurd/features/patient/presentation/screens/profile_screen.dart';
import 'package:cardiogaurd/features/auth/presentation/screens/role_selection_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/role-selection',
    routes: [
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'];
          return LoginScreen(role: role);
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'];
          return RegisterScreen(selectedRole: role);
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AssessmentCubit>.value(value: sl<AssessmentCubit>()),
              BlocProvider<HistoryCubit>.value(value: sl<HistoryCubit>()),
            ],
            child: PatientHome(child: child),
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/inputs',
            builder: (context, state) => const AssessmentInputScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/doctor-contact',
            builder: (context, state) => const PatientDoctorView(),
          ),
        ],
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) {
          final user = context.read<AuthCubit>().state.user;
          if (user?.role == UserRole.doctor) {
            return const DoctorEditProfileScreen();
          }
          return const EditProfileScreen();
        },
      ),
      GoRoute(
        path: '/doctor-edit-profile',
        builder: (context, state) => const DoctorEditProfileScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          final user = context.read<AuthCubit>().state.user;
          if (user?.role == UserRole.doctor) {
            return BlocProvider.value(
              value: sl<DoctorPatientsCubit>(),
              child: const DoctorProfileScreen(),
            );
          }
          return BlocProvider.value(
            value: sl<HistoryCubit>(),
            child: const ProfileViewScreen(),
          );
        },
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final extras = state.extra as Map?;
          final receiverId = extras?['receiverId'] as String? ?? '';
          final receiverName = extras?['receiverName'] as String? ?? 'Support';
          final receiverImageUrl = extras?['receiverImageUrl'] as String? ?? '';
          final currentUserId = context.read<AuthCubit>().state.user?.id ?? '';
          
          return BlocProvider(
            create: (_) => sl<ChatCubit>(),
            child: ChatScreen(
              receiverId: receiverId,
              receiverName: receiverName,
              receiverImageUrl: receiverImageUrl,
              currentUserId: currentUserId,
            ),
          );
        },
      ),
      GoRoute(
        path: '/doctor-home',
        builder: (context, state) => BlocProvider.value(
          value: sl<DoctorPatientsCubit>(),
          child: const DoctorHome(),
        ),
      ),
      GoRoute(
        path: '/patient-details/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BlocProvider.value(
            value: sl<DoctorPatientsCubit>(),
            child: PatientDetailsScreen(patientId: id),
          );
        },
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<AssessmentCubit>.value(value: sl<AssessmentCubit>()),
            BlocProvider<HistoryCubit>.value(value: sl<HistoryCubit>()),
          ],
          child: const AssessmentResultScreen(),
        ),
      ),
      GoRoute(
        path: '/assessment-details',
        builder: (context, state) {
          final assessment = state.extra as HistoryEntryEntity;
          return AssessmentDetailsScreen(assessment: assessment);
        },
      ),
    ],
  );

  static String homeForRole(UserRole role) =>
      role == UserRole.doctor ? '/doctor-home' : '/dashboard';
}
