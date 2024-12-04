import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/data/datasources/post_remote_data_source.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';

class CommentsRepositoryImpl implements CommentRepository {
  final PostRemoteDataSource remoteDataSource;

  CommentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Comment>>> getComments(int postId) async {
    try {
      final response = await remoteDataSource.getComments(postId);
      return Right(response);
    } catch (error) {
      return Left(ServerFailure('Failed to get comments: ${error.toString()}'));
    }
  }
}
