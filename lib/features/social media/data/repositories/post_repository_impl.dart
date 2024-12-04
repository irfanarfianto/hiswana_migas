import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/social%20media/data/datasources/post_remote_data_source.dart';
import 'package:hiswana_migas/features/social%20media/data/models/post_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/post_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DetailPostEntity>>> getAllPosts() async {
    try {
      final response = await remoteDataSource.getPosts();
      return Right(response);
    } catch (error) {
      return Left(ServerFailure('Failed to get posts: ${error.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Post>> postCreate(Post postCreate) async {
    try {
      final postCreateModel =
          PostModel(caption: postCreate.caption!, photo: postCreate.photo!);
      final response = await remoteDataSource.postCreate(postCreateModel);
      return Right(response);
    } catch (error) {
      return Left(ServerFailure('Failed to create post: ${error.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> likePost(int postId) async {
    try {
      final response = await remoteDataSource.postLike(postId);
      return response;
    } catch (error) {
      return Left(ServerFailure('Failed to like post: ${error.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int postId) async {
    try {
      final response = await remoteDataSource.deletePost(postId);
      return response;
    } catch (error) {
      return Left(ServerFailure('Failed to delete post: ${error.toString()}'));
    }
  }
}
