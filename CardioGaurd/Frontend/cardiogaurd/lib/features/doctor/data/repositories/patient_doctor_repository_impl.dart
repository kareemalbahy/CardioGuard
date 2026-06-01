import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/doctor/domain/entities/doctor_profile_entity.dart';
import 'package:cardiogaurd/features/doctor/domain/repositories/patient_doctor_repository.dart';

class PatientDoctorRepositoryImpl implements PatientDoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, List<DoctorProfileEntity>>> searchDoctors(String query) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();

      final doctors = snapshot.docs
          .map((doc) {
            final data = doc.data();
            return DoctorProfileEntity(
              id: doc.id,
              name: data['name'] ?? 'Unknown Doctor',
              specialty: data['specialty'] ?? 'Specialist',
              hospital: data['hospital'] ?? 'General Clinic',
              imagePath: data['profileImageUrl'] ?? 'images/doctor_placeholder.png',
              isOnline: true,
            );
          })
          .where((doc) =>
              doc.name.toLowerCase().contains(query.toLowerCase()) ||
              doc.specialty.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return Right(doctors);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoctorProfileEntity>>> getAssignedDoctors() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return const Left(AuthFailure('Not logged in'));

      final snapshot = await _firestore
          .collection('care_teams')
          .where('patientId', isEqualTo: user.uid)
          .get();

      final List<DoctorProfileEntity> doctors = [];
      for (final doc in snapshot.docs) {
        final doctorId = doc.data()['doctorId'] as String;
        final doctorDoc = await _firestore.collection('users').doc(doctorId).get();
        if (!doctorDoc.exists) continue;

        final data = doctorDoc.data()!;
        doctors.add(DoctorProfileEntity(
          id: doctorId,
          name: data['name'] ?? 'Unknown',
          specialty: data['specialty'] ?? 'Specialist',
          hospital: data['hospital'] ?? 'Clinic',
          imagePath: data['profileImageUrl'] ?? 'images/doctor_placeholder.png',
        ));
      }
      return Right(doctors);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoctorProfileEntity>>> getPendingDoctors() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return const Left(AuthFailure('Not logged in'));

      final snapshot = await _firestore
          .collection('assignments')
          .where('patientId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'pending')
          .get();

      final List<DoctorProfileEntity> doctors = [];
      for (final doc in snapshot.docs) {
        final doctorId = doc.data()['doctorId'] as String;
        final doctorDoc = await _firestore.collection('users').doc(doctorId).get();
        if (!doctorDoc.exists) continue;

        final data = doctorDoc.data()!;
        doctors.add(DoctorProfileEntity(
          id: doctorId,
          name: data['name'] ?? 'Unknown',
          specialty: data['specialty'] ?? 'Specialist',
          hospital: data['hospital'] ?? 'Clinic',
          imagePath: data['profileImageUrl'] ?? 'images/doctor_placeholder.png',
        ));
      }
      return Right(doctors);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestAssignment(String doctorId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return const Left(AuthFailure('Not logged in'));

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final patientName = userDoc.data()?['name'] ?? 'A Patient';

      await _firestore.collection('assignments').add({
        'patientId': user.uid,
        'doctorId': doctorId,
        'patientName': patientName,
        'status': 'pending',
        'requestedAt': FieldValue.serverTimestamp(),
      });
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelAssignment(String doctorId, {required bool isPending}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return const Left(AuthFailure('Not logged in'));

      if (isPending) {
        final snapshot = await _firestore
            .collection('assignments')
            .where('patientId', isEqualTo: user.uid)
            .where('doctorId', isEqualTo: doctorId)
            .where('status', isEqualTo: 'pending')
            .get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      } else {
        final docId = "${user.uid}_$doctorId";
        await _firestore.collection('care_teams').doc(docId).delete();
      }
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
