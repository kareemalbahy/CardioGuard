import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/history/domain/entities/history_entry_entity.dart';
import 'package:cardiogaurd/features/history/domain/repositories/history_repository.dart';
import 'package:cardiogaurd/features/assessment/data/models/input_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, List<HistoryEntryEntity>>> getPatientHistory([String? patientId]) async {
    try {
      final targetId = patientId ?? _auth.currentUser?.uid;
      if (targetId == null) return const Left(AuthFailure('No user ID found'));

      final snapshot = await _firestore
          .collection('assessments')
          .where('patientId', isEqualTo: targetId)
          .orderBy('timestamp', descending: true)
          .get();

      final entries = snapshot.docs.map((doc) {
        final data = doc.data();
        final double scoreValue = (data['riskScore'] as num?)?.toDouble() ?? 0.0;
        
        return HistoryEntryEntity(
          date: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          score: scoreValue,
          status: scoreValue > 50 ? 'High Risk' : 'Healthy',
          recommendations: List<String>.from(data['recommendations'] ?? []),
          inputs: data['inputs'] != null ? AssessmentInputModel.fromMap(data['inputs'] as Map<String, dynamic>) : null,
        );
      }).toList();

      return Right(entries);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addHistoryEntry(HistoryEntryEntity entry) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return const Left(AuthFailure('User not logged in'));

      await _firestore.collection('assessments').add({
        'patientId': user.uid,
        'riskScore': entry.score,
        'recommendations': entry.recommendations,
        'timestamp': FieldValue.serverTimestamp(),
        'inputs': entry.inputs != null ? AssessmentInputModel.fromEntity(entry.inputs!).toJson() : null,
      });

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
