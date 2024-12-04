import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';

class DeleteComment {
  final CommentRepository _postRepository;

  DeleteComment(this._postRepository);

  Future<Either<Failure, void>> execute(int commentId) async {
    return await _postRepository.deleteComment(commentId);
  }
}
