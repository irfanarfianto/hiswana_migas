import 'package:hiswana_migas/features/auth/data/models/user_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    super.parentId,
    required super.content,
    required super.createdAt,
    required super.user,
    required super.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['post_id'],
      parentId: json['parent_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      user: UserModel.fromJson(json['user']),
      replies:
          (json['replies'] as List).map((e) => ReplyModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'parent_id': parentId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'user': user,
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}

class ReplyModel extends Reply {
  const ReplyModel({
    required super.id,
    required super.postId,
    super.parentId,
    required super.content,
    required super.createdAt,
    required super.user,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'],
      postId: json['post_id'],
      parentId: json['parent_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      user: UserModel.fromJson(json['user']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'parent_id': parentId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'user': user,
    };
  }
}
