import 'dart:convert';
import 'package:hiswana_migas/features/auth/data/models/user_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';

class DetailsPostModel extends DetailPostEntity {
  DetailsPostModel({
    required super.id,
    required super.caption,
    required super.photos,
    required super.createdAt,
    required super.updatedAt,
    required UserModel super.user,
    required List<LikeModel> super.likes,
    required List<CommentModel> super.comments,
  });

  factory DetailsPostModel.fromJson(Map<String, dynamic> json) {
    return DetailsPostModel(
      id: json['id'],
      caption: json['caption'] ?? " ",
      photos: List<String>.from(jsonDecode(json['photo'])),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(json['user']),
      likes: (json['likes'] as List).map((e) => LikeModel.fromJson(e)).toList(),
      comments: (json['comments'] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList(),
    );
  }
}

class LikeModel extends Like {
  LikeModel({required super.id, required super.userId, required super.postId});

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
    );
  }
}

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.content,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
