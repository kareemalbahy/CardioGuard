import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardiogaurd/features/doctor/domain/entities/doctor_profile_entity.dart';
import 'package:cardiogaurd/features/doctor/domain/repositories/patient_doctor_repository.dart';

abstract class PatientDoctorState extends Equatable {
  const PatientDoctorState();
  @override
  List<Object?> get props => [];
}

class PatientDoctorInitial extends PatientDoctorState {}
class PatientDoctorLoading extends PatientDoctorState {}
class PatientDoctorLoaded extends PatientDoctorState {
  final List<DoctorProfileEntity> assignedDoctors;
  final List<DoctorProfileEntity> pendingDoctors;
  final List<DoctorProfileEntity> searchResults;
  const PatientDoctorLoaded({
    this.assignedDoctors = const [],
    this.pendingDoctors = const [],
    this.searchResults = const [],
  });
  @override
  List<Object?> get props => [assignedDoctors, pendingDoctors, searchResults];
}
class PatientDoctorFailure extends PatientDoctorState {
  final String message;
  const PatientDoctorFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class PatientDoctorCubit extends Cubit<PatientDoctorState> {
  final PatientDoctorRepository repository;
  PatientDoctorCubit(this.repository) : super(PatientDoctorInitial());

  Future<void> load() async {
    emit(PatientDoctorLoading());
    final assignedRes = await repository.getAssignedDoctors();
    final pendingRes = await repository.getPendingDoctors();

    assignedRes.fold(
      (f) => emit(PatientDoctorFailure(f.message)),
      (assigned) => pendingRes.fold(
        (f) => emit(PatientDoctorFailure(f.message)),
        (pending) => emit(PatientDoctorLoaded(
          assignedDoctors: assigned,
          pendingDoctors: pending,
        )),
      ),
    );
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      if (state is PatientDoctorLoaded) {
        final curr = state as PatientDoctorLoaded;
        emit(PatientDoctorLoaded(
          assignedDoctors: curr.assignedDoctors,
          pendingDoctors: curr.pendingDoctors,
          searchResults: const [],
        ));
      }
      return;
    }

    final res = await repository.searchDoctors(query);
    res.fold(
      (f) => emit(PatientDoctorFailure(f.message)),
      (results) {
        if (state is PatientDoctorLoaded) {
          final curr = state as PatientDoctorLoaded;
          emit(PatientDoctorLoaded(
            assignedDoctors: curr.assignedDoctors,
            pendingDoctors: curr.pendingDoctors,
            searchResults: results,
          ));
        }
      },
    );
  }

  Future<void> requestAssignment(String doctorId) async {
    final res = await repository.requestAssignment(doctorId);
    res.fold(
      (f) => emit(PatientDoctorFailure(f.message)),
      (_) => load(),
    );
  }

  Future<void> cancelAssignment(String doctorId, bool isPending) async {
    final res = await repository.cancelAssignment(doctorId, isPending: isPending);
    res.fold(
      (f) => emit(PatientDoctorFailure(f.message)),
      (_) => load(),
    );
  }
}
