import 'package:hiswana_migas/features/auth/data/models/user_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';

class CommentModel extends Comment {
  const CommentModel({
    super.commentId,
    required super.content,
    super.postId,
    super.parentId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['id'],
      content: json['content'] ?? '',
      postId: json['postId'],
      parentId: json['parent_id'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'post_id': postId,
      'parent_id': commentId,
    };
  }
}

class ReplyModel extends Reply {
  const ReplyModel({
    required super.id,
    required super.postId,
    super.commentId,
    required super.content,
    required super.createdAt,
    required super.user,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'],
      postId: json['post_id'],
      commentId: json['parent_id'],
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
      'parent_id': commentId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'user': user,
    };
  }
}
