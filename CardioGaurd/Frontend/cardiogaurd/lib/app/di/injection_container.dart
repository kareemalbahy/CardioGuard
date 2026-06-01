import 'package:cardiogaurd/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:cardiogaurd/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:cardiogaurd/features/chat/domain/repositories/chat_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:cardiogaurd/features/assessment/data/datasources/gemini_medical_recommendation_remote_datasource.dart';
import 'package:cardiogaurd/features/assessment/data/datasources/medical_recommendation_remote_datasource.dart';
import 'package:cardiogaurd/features/assessment/data/datasources/risk_ml_remote_datasource.dart';
import 'package:cardiogaurd/features/assessment/data/datasources/risk_ml_remote_datasource_impl.dart';
import 'package:cardiogaurd/features/assessment/data/repositories/assessment_repository_impl.dart';
import 'package:cardiogaurd/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:cardiogaurd/features/assessment/domain/usecases/calculate_heart_risk_usecase.dart';
import 'package:cardiogaurd/features/assessment/presentation/cubit/assessment_cubit.dart';
import 'package:cardiogaurd/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cardiogaurd/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:cardiogaurd/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cardiogaurd/features/auth/domain/repositories/auth_repository.dart';
import 'package:cardiogaurd/features/auth/domain/usecases/register_usecase.dart';
import 'package:cardiogaurd/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:cardiogaurd/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:cardiogaurd/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cardiogaurd/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:cardiogaurd/features/doctor/data/repositories/doctor_patients_repository_impl.dart';
import 'package:cardiogaurd/features/doctor/domain/repositories/doctor_patients_repository.dart';
import 'package:cardiogaurd/features/doctor/domain/usecases/get_assigned_patients_usecase.dart';
import 'package:cardiogaurd/features/doctor/domain/usecases/get_patient_details_usecase.dart';
import 'package:cardiogaurd/features/doctor/domain/usecases/get_patient_history_usecase.dart' as doctor_history;
import 'package:cardiogaurd/features/doctor/presentation/cubit/doctor_patients_cubit.dart';
import 'package:cardiogaurd/features/history/data/repositories/history_repository_impl.dart';
import 'package:cardiogaurd/features/history/domain/repositories/history_repository.dart';
import 'package:cardiogaurd/features/history/domain/usecases/add_history_entry_usecase.dart';
import 'package:cardiogaurd/features/history/domain/usecases/get_patient_history_usecase.dart';
import 'package:cardiogaurd/features/doctor/domain/repositories/patient_doctor_repository.dart';
import 'package:cardiogaurd/features/doctor/data/repositories/patient_doctor_repository_impl.dart';
import 'package:cardiogaurd/features/doctor/presentation/cubit/patient_doctor_cubit.dart';
import 'package:cardiogaurd/features/history/presentation/cubit/history_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<RiskMlRemoteDataSource>(
    RiskMlRemoteDataSourceImpl.new,
  );
  sl.registerLazySingleton<MedicalRecommendationRemoteDataSource>(
    () => GeminiMedicalRecommendationRemoteDataSource(
      "AIzaSyBj-JxtjhAy2l9zruLWGKCLOFi7DlwxNQw",
    ),
  );
  sl.registerLazySingleton<AssessmentRepository>(
    () => AssessmentRepositoryImpl(
      mlDataSource: sl(),
      recommendationDataSource: sl(),
    ),
  );
  sl.registerLazySingleton(() => CalculateHeartRiskUseCase(sl()));
  sl.registerLazySingleton(() => AssessmentCubit(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl.new);
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(
    () => AuthCubit(
      signInUseCase: sl(),
      registerUseCase: sl(),
      forgotPasswordUseCase: sl(),
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton<HistoryRepository>(HistoryRepositoryImpl.new);
  sl.registerLazySingleton(() => GetPatientHistoryUseCase(sl()));
  sl.registerLazySingleton(() => AddHistoryEntryUseCase(sl()));
  sl.registerLazySingleton(() => HistoryCubit(sl(), sl()));

  sl.registerLazySingleton<DoctorPatientsRepository>(
    DoctorPatientsRepositoryImpl.new,
  );
  sl.registerLazySingleton(() => GetAssignedPatientsUseCase(sl()));
  sl.registerLazySingleton(() => GetPatientDetailsUseCase(sl()));
  sl.registerLazySingleton(() => doctor_history.GetPatientHistoryUseCase(sl()));
  sl.registerLazySingleton<PatientDoctorRepository>(
    PatientDoctorRepositoryImpl.new,
  );
  sl.registerLazySingleton(
    () => DoctorPatientsCubit(repository: sl()),
  );

  sl.registerFactory(() => PatientDoctorCubit(sl()));
  
  // Chat Registration
  sl.registerLazySingleton<ChatRemoteDataSource>(ChatRemoteDataSourceImpl.new);
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerFactory(() => ChatCubit(sl()));
}
