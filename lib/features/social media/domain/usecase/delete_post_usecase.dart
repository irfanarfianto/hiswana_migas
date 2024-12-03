import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/post_repository.dart';

class DeletePostUsecase {
  final PostRepository _postRepository;

  DeletePostUsecase(this._postRepository);

  Future<Either<Failure, void>> execute(int postId) async {
    return await _postRepository.deletePost(postId);
  }
}
