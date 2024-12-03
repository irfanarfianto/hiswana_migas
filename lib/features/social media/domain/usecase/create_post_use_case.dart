
import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/data/models/post_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/post_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository postRepository;

  CreatePostUseCase(this.postRepository);

  Future<Either<Failure, Post>> execute(PostModel postCreate) async {
    return await postRepository.postCreate(postCreate);
  }
}
