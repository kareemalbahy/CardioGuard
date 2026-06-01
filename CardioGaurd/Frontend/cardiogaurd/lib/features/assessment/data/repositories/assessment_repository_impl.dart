import 'package:fpdart/fpdart.dart';
import 'package:cardiogaurd/core/error/exceptions.dart';
import 'package:cardiogaurd/core/error/failures.dart';
import 'package:cardiogaurd/features/assessment/data/datasources/medical_recommendation_remote_datasource.dart';
import 'package:cardiogaurd/features/assessment/data/datasources/risk_ml_remote_datasource.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_input_entity.dart';
import 'package:cardiogaurd/features/assessment/domain/entities/assessment_result_entity.dart';
import 'package:cardiogaurd/features/assessment/data/models/assessment_model.dart';
import 'package:cardiogaurd/features/assessment/domain/repositories/assessment_repository.dart';

class AssessmentRepositoryImpl implements AssessmentRepository {
  final RiskMlRemoteDataSource mlDataSource;
  final MedicalRecommendationRemoteDataSource recommendationDataSource;

  AssessmentRepositoryImpl({
    required this.mlDataSource,
    required this.recommendationDataSource,
  });

  @override
  Future<Either<Failure, AssessmentResultEntity>> assess(
    AssessmentInputEntity input,
  ) async {
    try {
      final score = await mlDataSource.predictRiskScore(input);
      final recs = await recommendationDataSource.getRecommendations(
        input: input,
        riskScore: score,
      );
      return Right(
        AssessmentResultModel(
          riskScore: score,
          recommendations: recs,
          generatedAt: DateTime.now(),
        ),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
