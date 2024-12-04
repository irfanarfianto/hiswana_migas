import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/data/datasources/post_remote_data_source.dart';
import 'package:hiswana_migas/features/social%20media/data/models/comment_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';

class CommentsRepositoryImpl implements CommentRepository {
  final PostRemoteDataSource remoteDataSource;

  CommentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DetailComment>>> getComments(int postId) async {
    try {
      final response = await remoteDataSource.getComments(postId);
      return Right(response);
    } catch (error) {
      return Left(
          ServerFailure('Failed to get detail comments: ${error.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Comment>> postComment(
      int postId, Comment comment) async {
    try {
      final postComment =
          CommentModel(content: comment.content, postId: postId);
      final response = await remoteDataSource.postComment(postId, postComment);
      return Right(response);
    } catch (error) {
      return Left(
          ServerFailure('Failed to create comments: ${error.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Comment>> replyComment(
      int commentId, Comment comment) async {
    try {
      final replyComment =
          CommentModel(content: comment.content, commentId: commentId);
      final response =
          await remoteDataSource.replyComment(commentId, replyComment);
      return Right(response);
    } catch (error) {
      return Left(ServerFailure('Failed to create reply: ${error.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(int commentId) async {
    try {
      final response = await remoteDataSource.deleteComment(commentId);
      return response;
    } catch (error) {
      return Left(ServerFailure('Failed to delete comment: ${error.toString()}'));
    }
  }
}
