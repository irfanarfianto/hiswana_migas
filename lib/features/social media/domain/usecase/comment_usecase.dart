import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';

class CommentUseCase {
  final CommentRepository commentRepository;

  CommentUseCase(this.commentRepository);

  Future<Either<Failure, List<Comment>>> execute(int postId) async {
    return await commentRepository.getComments(postId);
  }

  // Future<void> addComment(int postId, String content) async {
  //   return await commentRepository.addComment(postId, content);
  // }
}
