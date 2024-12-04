import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/core/token_storage.dart';
import 'package:hiswana_migas/features/social%20media/data/models/comment_model.dart';
import 'package:hiswana_migas/features/social%20media/data/models/detail_comment_model.dart';
import 'package:hiswana_migas/features/social%20media/data/models/details_post_model.dart';
import 'package:hiswana_migas/features/social%20media/data/models/post_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_comment_entity.dart';
import 'package:http/http.dart' as http;

abstract class PostRemoteDataSource {
  Future<List<DetailsPostModel>> getPosts();
  Future<List<DetailComment>> getComments(int postId);
  Future<PostModel> postCreate(PostModel postCreate);
  Future<CommentModel> postComment(int postId, CommentModel postComment);
  Future<CommentModel> replyComment(int commentId, CommentModel postComment);
  Future<Either<Failure, void>> postLike(int postId);
  Future<Either<Failure, void>> deletePost(int postId);
  Future<Either<Failure, void>> deleteComment(int commentId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final TokenLocalDataSource tokenLocalDataSource;

  PostRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.tokenLocalDataSource,
  });

  @override
  Future<List<DetailsPostModel>> getPosts() async {
    try {
      final token = await tokenLocalDataSource.getToken();
      final response = await client.get(
        Uri.parse('${baseUrl}posts'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> posts = json.decode(response.body)['data'];
        return posts.map((post) => DetailsPostModel.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.body}');
      }
    } on Exception catch (e) {
      throw Exception('Error loading posts: $e');
    }
  }

  @override
  Future<List<DetailComment>> getComments(int postId) async {
    try {
      final token = await tokenLocalDataSource.getToken();
      final response = await client.get(
        Uri.parse('${baseUrl}posts/$postId/comments'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> comments = json.decode(response.body)['data'];
        return comments
            .map((comment) => CommentDetailModel.fromJson(comment))
            .toList();
      } else {
        throw Exception('Failed to load comments: ${response.body}');
      }
    } on Exception catch (e) {
      throw Exception('Error loading comments: $e');
    }
  }

  @override
  Future<PostModel> postCreate(PostModel postCreate) async {
    final token = await tokenLocalDataSource.getToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}posts'),
    );

    // Add headers
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    // Tambahkan caption jika tidak null
    if (postCreate.caption != null && postCreate.caption!.isNotEmpty) {
      request.fields['caption'] = postCreate.caption!;
    }

    // Tambahkan foto jika tidak kosong
    if (postCreate.photo != null && postCreate.photo!.isNotEmpty) {
      for (var photoPath in postCreate.photo!) {
        request.files.add(
          await http.MultipartFile.fromPath('photo[]', photoPath),
        );
      }
    }

    // Validasi jika keduanya kosong
    if ((postCreate.caption == null || postCreate.caption!.isEmpty) &&
        (postCreate.photo == null || postCreate.photo!.isEmpty)) {
      throw Exception('At least one of "caption" or "photo" must be provided.');
    }

    try {
      var response = await request.send();

      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        final dynamic postJson = json.decode(responseData);
        return PostModel.fromJson(postJson);
      } else {
        var errorResponse = await response.stream.bytesToString();
        throw Exception(
            'Failed to create post: ${response.statusCode} - ${response.reasonPhrase}, Response: $errorResponse');
      }
    } on Exception catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  // likes
  @override
  Future<Either<Failure, void>> postLike(int postId) async {
    final token = await tokenLocalDataSource.getToken();
    final url = Uri.parse('${baseUrl}posts/$postId/like');
    final request = http.Request('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final errorResponse = await response.stream.bytesToString();
        throw Exception(
            'Failed to like post: ${response.statusCode} - ${response.reasonPhrase}, Response: $errorResponse');
      }
    } on Exception catch (e) {
      throw Exception('Error liking post: $e');
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int postId) async {
    final token = await tokenLocalDataSource.getToken();
    final url = Uri.parse('${baseUrl}posts/$postId');
    final request = http.Request('DELETE', url);
    request.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final errorResponse = await response.stream.bytesToString();
        throw Exception(
            'Failed to delete post: ${response.statusCode} - ${response.reasonPhrase}, Response: $errorResponse');
      }
    } on Exception catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }

  // buatkan untuk create komen pada post
  @override
  Future<CommentModel> postComment(int postId, CommentModel postComment) async {
    final token = await tokenLocalDataSource.getToken();
    final url = Uri.parse('${baseUrl}posts/$postId/comment');
    final request = http.Request('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'application/json';
    request.body = json.encode({'content': postComment.content});

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final commentJson = json.decode(responseData);

        return CommentModel.fromJson(commentJson);
      } else {
        final errorResponse = await response.stream.bytesToString();
        throw Exception(
            'Failed to post comment: ${response.statusCode} - ${response.reasonPhrase}, Response: $errorResponse');
      }
    } on Exception catch (e) {
      throw Exception('Error posting comment: $e');
    }
  }

  @override
  Future<CommentModel> replyComment(
      int commentId, CommentModel postreplyComment) async {
    final token = await tokenLocalDataSource.getToken();
    final url = Uri.parse('${baseUrl}comments/$commentId/reply');
    final request = http.Request('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'application/json';
    request.body = json.encode({'content': postreplyComment.content});
    try {
      final response = await request.send();


      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final replyJson = json.decode(responseData);
        return CommentModel.fromJson(replyJson);
      } else {
        final errorResponse = await response.stream.bytesToString();
        throw Exception(
            'Failed to reply comment: ${response.statusCode} - ${response.reasonPhrase}, Response: $errorResponse');
      }
    } on Exception catch (e) {
      throw Exception('Error replying comment: $e');
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(int commentId) async {
    final token = await tokenLocalDataSource.getToken();
    final url = Uri.parse('${baseUrl}comments/$commentId');
    final request = http.Request('DELETE', url);
    request.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final errorResponse = await response.stream.bytesToString();
        throw Exception(
            'Failed to delete comment: ${response.statusCode} - ${response.reasonPhrase}, Response: $errorResponse');
      }
    } on Exception catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }
}
