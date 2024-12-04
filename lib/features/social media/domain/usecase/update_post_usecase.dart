import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/data/models/post_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/post_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/post_repository.dart';

class UpdatePostUsecase {
  final PostRepository postRepository;

  UpdatePostUsecase(this.postRepository);

  Future<Either<Failure, Post>> execute(
      PostModel updatePost, int postId) async {
    return await postRepository.updatePost(updatePost, postId);
  }
}
