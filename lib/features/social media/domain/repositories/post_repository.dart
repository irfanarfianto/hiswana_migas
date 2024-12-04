import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, List<DetailPostEntity>>> getAllPosts();
  Future<Either<Failure, Post>> postCreate(Post postCreateModel);
  Future<Either<Failure, Post>> updatePost(Post updatePostModel, int postId);

  Future<Either<Failure, void>> likePost(int postId);
  Future<Either<Failure, void>> deletePost(int postId);
}
