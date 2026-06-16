import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/doctor/domain/entities/doctor_patient_summary_entity.dart';
import 'package:cardiogaurd/features/doctor/domain/repositories/doctor_patients_repository.dart';
import 'package:cardiogaurd/features/patient/domain/entities/patient_info_entity.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';
import 'package:cardiogaurd/features/assessment/data/models/input_model.dart';

class DoctorPatientsRepositoryImpl implements DoctorPatientsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, List<DoctorPatientSummaryEntity>>>
  getAssignedPatients() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return const Left(AuthFailure('Not logged in'));

      final careTeamSnapshot = await _firestore
          .collection('care_teams')
          .where('doctorId', isEqualTo: user.uid)
          .get();

      final patientIds = careTeamSnapshot.docs
          .map((doc) => doc.data()['patientId'] as String)
          .toList();
      if (patientIds.isEmpty) return const Right([]);

      final List<DoctorPatientSummaryEntity> summaries = [];
      for (final pid in patientIds) {
        final userDoc = await _firestore.collection('users').doc(pid).get();
        if (!userDoc.exists) continue;

        final assessmentSnapshot = await _firestore
            .collection('assessments')
            .where('patientId', isEqualTo: pid)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        final userData = userDoc.data()!;
        final latestAssessment = assessmentSnapshot.docs.isNotEmpty
            ? assessmentSnapshot.docs.first.data()
            : null;

        summaries.add(
          DoctorPatientSummaryEntity(
            id: pid,
            name: userData['name'] ?? 'Unknown Patient',
            lastRiskScore: latestAssessment != null
                ? (latestAssessment['riskScore'] as num).toDouble()
                : 0.0,
            lastAssessmentDate: latestAssessment != null
                ? (latestAssessment['timestamp'] as Timestamp)
                      .toDate()
                      .toString()
                      .substring(0, 10)
                : 'No scans',
            profilePictureUrl: userData['profileImageUrl'] ?? '',
          ),
        );
      }

      return Right(summaries);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatientInfoEntity>> getPatientInfo(
    String patientId,
  ) async {
    try {
      final doc = await _firestore.collection('users').doc(patientId).get();
      if (!doc.exists) return const Left(ServerFailure('Patient not found'));

      final data = doc.data()!;
      return Right(
        PatientInfoEntity(
          id: patientId,
          fullName: data['name'] ?? 'Unknown',
          firstName: (data['name'] as String? ?? '').split(' ').first,
          lastName: (data['name'] as String? ?? '').split(' ').last,
          email: data['email'] ?? '',
          phoneNumber: data['phone'] ?? 'Not provided',
          sex: data['sex'] ?? 'Unknown',
          dateOfBirthString: data['dob'] ?? 'Not provided',
          profilePictureUrl: data['profileImageUrl'] ?? '',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HistoryEntryEntity>>> getPatientHistory(
    String patientId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('assessments')
          .where('patientId', isEqualTo: patientId)
          .orderBy('timestamp', descending: true)
          .get();

      final entries = snapshot.docs.map((doc) {
        final data = doc.data();
        final double scoreValue =
            (data['riskScore'] as num?)?.toDouble() ?? 0.0;

        return HistoryEntryEntity(
          date: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          score: scoreValue,
          status: scoreValue > 50 ? 'High Risk' : 'Healthy',
          recommendations: List<String>.from(data['recommendations'] ?? []),
          inputs: data['inputs'] != null
              ? AssessmentInputModel.fromMap(
                  data['inputs'] as Map<String, dynamic>,
                )
              : null,
        );
      }).toList();

      return Right(entries);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getPendingAssignments() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return const Left(AuthFailure('Not logged in'));

      final snapshot = await _firestore
          .collection('assignments')
          .where('doctorId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'pending')
          .get();

      final requests = <Map<String, dynamic>>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final patientId = data['patientId'] as String?;
        String patientProfileImageUrl = 'images/patient_placeholder.png';

        if (patientId != null && patientId.isNotEmpty) {
          final patientDoc = await _firestore
              .collection('users')
              .doc(patientId)
              .get();
          if (patientDoc.exists) {
            patientProfileImageUrl =
                patientDoc.data()?['profileImageUrl'] ?? patientProfileImageUrl;
          }
        }

        requests.add({
          'id': doc.id,
          'patientId': patientId,
          'patientName': data['patientName'] ?? 'Anonymous',
          'date':
              (data['requestedAt'] as Timestamp?)
                  ?.toDate()
                  .toString()
                  .substring(0, 16) ??
              'Just now',
          'patientProfileImageUrl': patientProfileImageUrl,
        });
      }

      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> acceptAssignment(
    String assignmentId,
    String patientId,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return const Left(AuthFailure('Not logged in'));

      final batch = _firestore.batch();

      batch.update(_firestore.collection('assignments').doc(assignmentId), {
        'status': 'accepted',
      });

      final careTeamId = "${patientId}_${user.uid}";
      batch.set(_firestore.collection('care_teams').doc(careTeamId), {
        'patientId': patientId,
        'doctorId': user.uid,
        'assignedAt': FieldValue.serverTimestamp(),
        'active': true,
      });

      await batch.commit();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> rejectAssignment(String assignmentId) async {
    try {
      await _firestore.collection('assignments').doc(assignmentId).update({
        'status': 'rejected',
      });
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
