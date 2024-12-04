import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';

class CommentUseCase {
  final CommentRepository commentRepository;

  CommentUseCase(this.commentRepository);

  Future<Either<Failure, List<DetailComment>>> execute(int postId) async {
    return await commentRepository.getComments(postId);
  }
}
