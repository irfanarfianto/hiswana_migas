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
    required List<CommentModelPost> super.comments,
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
          .map((e) => CommentModelPost.fromJson(e))
          .toList(),
    );
  }
  @override
  String toString() {
    return 'DetailsPostModel{id: $id, caption: $caption, createdAt: $createdAt, updatedAt: $updatedAt, user: ${user.name}, likes: ${likes.length}, comments: ${comments.length}}';
  }

  // Menambahkan toJson() untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caption': caption,
      'photo': jsonEncode(photos),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
      'likes': likes.map((like) => like.toJson()).toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
    };
  }
}

class CommentModelPost extends CommentPost {
  CommentModelPost({
    required super.id,
    required super.postId,
    required super.userId,
    required super.content,
    required super.createdAt,
  });

  factory CommentModelPost.fromJson(Map<String, dynamic> json) {
    return CommentModelPost(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Menambahkan toJson() untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
