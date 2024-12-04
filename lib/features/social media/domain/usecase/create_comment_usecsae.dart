import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/data/models/comment_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';

class CreateCommentUsecase {
  final CommentRepository postRepository;

  CreateCommentUsecase(this.postRepository);

  Future<Either<Failure, Comment>> execute(
      int postId, CommentModel postComment) async {
    return await postRepository.postComment(postId, postComment);
  }
}
