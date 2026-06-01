import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardiogaurd/features/doctor/domain/entities/doctor_patient_summary_entity.dart';
import 'package:cardiogaurd/features/doctor/domain/repositories/doctor_patients_repository.dart';
import 'package:cardiogaurd/features/patient/domain/entities/patient_info_entity.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';

part 'doctor_patients_state.dart';

class DoctorPatientsCubit extends Cubit<DoctorPatientsState> {
  final DoctorPatientsRepository repository;

  DoctorPatientsCubit({
    required this.repository,
  }) : super(const DoctorPatientsState.initial());

  Future<void> load() async {
    emit(const DoctorPatientsState.loading());
    
    final assignedResult = await repository.getAssignedPatients();
    final pendingResult = await repository.getPendingAssignments();

    assignedResult.fold(
      (f) => emit(DoctorPatientsState(status: DoctorPatientsStatus.failure, message: f.message)),
      (patients) {
        pendingResult.fold(
          (f) => emit(DoctorPatientsState(
            status: DoctorPatientsStatus.loaded,
            patients: patients,
            message: f.message,
          )),
          (pending) => emit(DoctorPatientsState(
            status: DoctorPatientsStatus.loaded,
            patients: patients,
            pendingAssignments: pending,
          )),
        );
      },
    );
  }

  Future<void> acceptAssignment(String assignmentId, String patientId) async {
    final res = await repository.acceptAssignment(assignmentId, patientId);
    res.fold(
      (f) => emit(state.copyWith(message: f.message)),
      (_) => load(),
    );
  }

  Future<void> rejectAssignment(String assignmentId) async {
    final res = await repository.rejectAssignment(assignmentId);
    res.fold(
      (f) => emit(state.copyWith(message: f.message)),
      (_) => load(),
    );
  }

  Future<void> loadPatientDetails(String patientId) async {
    emit(state.copyWith(status: DoctorPatientsStatus.loading));
    
    final infoResult = await repository.getPatientInfo(patientId);
    final historyResult = await repository.getPatientHistory(patientId);

    infoResult.fold(
      (f) => emit(state.copyWith(status: DoctorPatientsStatus.failure, message: f.message)),
      (info) {
        historyResult.fold(
          (f) => emit(state.copyWith(
            status: DoctorPatientsStatus.loaded,
            selectedPatientInfo: info,
            message: f.message,
          )),
          (history) => emit(state.copyWith(
            status: DoctorPatientsStatus.loaded,
            selectedPatientInfo: info,
            selectedPatientHistory: history,
          )),
        );
      },
    );
  }
}
