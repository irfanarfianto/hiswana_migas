import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hiswana_migas/core/constants/api_urls.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/core/network/dio_client.dart';
import 'package:hiswana_migas/core/token_storage.dart';
import 'package:hiswana_migas/features/social%20media/data/models/comment_model.dart';
import 'package:hiswana_migas/features/social%20media/data/models/detail_comment_model.dart';
import 'package:hiswana_migas/features/social%20media/data/models/details_post_model.dart';
import 'package:hiswana_migas/features/social%20media/data/models/post_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_comment_entity.dart';

abstract class PostRemoteDataSource {
  Future<List<DetailsPostModel>> getPosts();
  Future<List<DetailComment>> getComments(int postId);
  Future<PostModel> postCreate(PostModel postCreate);
  Future<PostModel> updatePost(PostModel updatePost, int postId);
  Future<CommentModel> postComment(int postId, CommentModel postComment);
  Future<CommentModel> replyComment(int commentId, CommentModel postComment);
  Future<Either<Failure, void>> postLike(int postId);
  Future<Either<Failure, void>> deletePost(int postId);
  Future<Either<Failure, void>> deleteComment(int commentId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final DioClient dioClient;
  final TokenLocalDataSource tokenLocalDataSource;

  PostRemoteDataSourceImpl({
    required this.dioClient,
    required this.tokenLocalDataSource,
  });

  @override
  Future<List<DetailsPostModel>> getPosts() async {
    final token = await tokenLocalDataSource.getToken();
    try {
      final response = await dioClient.get(
        ApiUrls.posts,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((json) => DetailsPostModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<PostModel> postCreate(PostModel postCreate) async {
    final token = await tokenLocalDataSource.getToken();

    final formData = FormData.fromMap({
      'caption': postCreate.caption,
      if (postCreate.photo != null)
        'photo[]': await Future.wait(
          postCreate.photo!.map(
            (path) => MultipartFile.fromFile(path),
          ),
        ),
    });

    try {
      final response = await dioClient.post(
        ApiUrls.posts,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        return PostModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<PostModel> updatePost(PostModel updatePost, int postId) async {
    final token = await tokenLocalDataSource.getToken();

    final formData = FormData.fromMap({
      'caption': updatePost.caption,
      if (updatePost.photo != null)
        'photo[]': await Future.wait(
          updatePost.photo!.map(
            (path) => MultipartFile.fromFile(path),
          ),
        ),
    });

    try {
      final response = await dioClient.post(
        '${ApiUrls.posts}/$postId',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating post: $e');
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int postId) async {
    final token = await tokenLocalDataSource.getToken();

    try {
      final response = await dioClient.delete(
        '${ApiUrls.posts}/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(
            ServerFailure('Failed to delete post: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure('Error deleting post: $e'));
    }
  }

  @override
  Future<CommentModel> postComment(int postId, CommentModel postComment) async {
    final token = await tokenLocalDataSource.getToken();

    try {
      final response = await dioClient.post(
        '${ApiUrls.posts}/$postId/comment',
        data: postComment.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        return CommentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  @override
  Future<CommentModel> replyComment(
      int commentId, CommentModel postComment) async {
    final token = await tokenLocalDataSource.getToken();

    try {
      final response = await dioClient.post(
        '${ApiUrls.comments}/$commentId/reply',
        data: postComment.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        return CommentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to reply to comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error replying to comment: $e');
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(int commentId) async {
    final token = await tokenLocalDataSource.getToken();

    try {
      final response = await dioClient.delete(
        '${ApiUrls.comments}/$commentId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        throw Exception(
            'Failed to delete comment: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Error deleting comment: Connection timed out');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception(
            'Failed to delete comment: ${e.response?.statusCode} - ${e.response?.statusMessage}, Response: ${e.response?.data}');
      } else {
        throw Exception('Error deleting comment: ${e.message}');
      }
    } on Exception catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }

  @override
  Future<List<DetailComment>> getComments(int postId) async {
    try {
      final token = await tokenLocalDataSource.getToken();

      return await retry(() async {
        final response = await dioClient.get(
          '${ApiUrls.posts}/$postId/comments',
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode == 200) {
          final List<dynamic> comments = response.data['data'];
          return comments
              .map((comment) => CommentDetailModel.fromJson(comment))
              .toList();
        } else {
          throw Exception(
              'Failed to load comments: ${response.statusCode} - ${response.statusMessage}');
        }
      });
    } on DioException catch (e) {
      throw Exception(
          'Error loading comments: ${e.response?.statusCode} - ${e.response?.statusMessage}, Response: ${e.response?.data}');
    } on Exception catch (e) {
      throw Exception('Error loading comments: $e');
    }
  }

  // likes
  @override
  Future<Either<Failure, void>> postLike(int postId) async {
    final token = await tokenLocalDataSource.getToken();
    try {
      final response = await dioClient.post(
        '${ApiUrls.posts}/$postId/like',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        throw Exception(
            'Failed to like post: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Error liking post: ${e.response?.data ?? e.message}');
    } on Exception catch (e) {
      throw Exception('Error liking post: $e');
    }
  }

  Future<T> retry<T>(
    Future<T> Function() action, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await action();
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          rethrow;
        }
        await Future.delayed(delay * attempt);
      }
    }
  }
}
