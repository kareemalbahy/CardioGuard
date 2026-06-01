part of 'doctor_patients_cubit.dart';

enum DoctorPatientsStatus { initial, loading, loaded, failure }

class DoctorPatientsState extends Equatable {
  final DoctorPatientsStatus status;
  final List<DoctorPatientSummaryEntity> patients;
  final List<Map<String, dynamic>> pendingAssignments;
  final PatientInfoEntity? selectedPatientInfo;
  final List<HistoryEntryEntity> selectedPatientHistory;
  final String? message;

  const DoctorPatientsState({
    required this.status,
    this.patients = const [],
    this.pendingAssignments = const [],
    this.selectedPatientInfo,
    this.selectedPatientHistory = const [],
    this.message,
  });

  const DoctorPatientsState.initial()
      : status = DoctorPatientsStatus.initial,
        patients = const [],
        pendingAssignments = const [],
        selectedPatientInfo = null,
        selectedPatientHistory = const [],
        message = null;

  const DoctorPatientsState.loading()
      : status = DoctorPatientsStatus.loading,
        patients = const [],
        pendingAssignments = const [],
        selectedPatientInfo = null,
        selectedPatientHistory = const [],
        message = null;

  DoctorPatientsState copyWith({
    DoctorPatientsStatus? status,
    List<DoctorPatientSummaryEntity>? patients,
    List<Map<String, dynamic>>? pendingAssignments,
    PatientInfoEntity? selectedPatientInfo,
    List<HistoryEntryEntity>? selectedPatientHistory,
    String? message,
  }) {
    return DoctorPatientsState(
      status: status ?? this.status,
      patients: patients ?? this.patients,
      pendingAssignments: pendingAssignments ?? this.pendingAssignments,
      selectedPatientInfo: selectedPatientInfo ?? this.selectedPatientInfo,
      selectedPatientHistory: selectedPatientHistory ?? this.selectedPatientHistory,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        patients,
        pendingAssignments,
        selectedPatientInfo,
        selectedPatientHistory,
        message,
      ];
}
