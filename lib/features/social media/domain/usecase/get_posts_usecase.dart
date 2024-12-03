import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/post_repository.dart';


class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<DetailPostEntity>>> execute() async {
    return await repository.getAllPosts();
  }
}
