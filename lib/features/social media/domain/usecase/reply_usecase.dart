import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/data/models/comment_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';

class ReplyCommentUsecase {
  final CommentRepository postRepository;

  ReplyCommentUsecase(this.postRepository);

  Future<Either<Failure, Comment>> execute(
      int commentId, CommentModel replyComment) async {
    return await postRepository.replyComment(commentId, replyComment);
  }
}
