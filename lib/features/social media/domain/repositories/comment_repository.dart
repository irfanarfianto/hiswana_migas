import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_comment_entity.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<DetailComment>>> getComments(int postId);
  Future<Either<Failure, Comment>> postComment(int postId, Comment postComment);
  Future<Either<Failure, Comment>> replyComment(
      int commentId, Comment replyComment);
  Future<Either<Failure, void>> deleteComment(int commentId);
}
