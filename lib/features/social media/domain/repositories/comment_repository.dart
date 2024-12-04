import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<Comment>>> getComments(int postId);
  // Future<Comment> getCommentById(int id);
  // Future<void> addComment(Comment comment);
  // Future<void> addReply(Reply reply);
}
