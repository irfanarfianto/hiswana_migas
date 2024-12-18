import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';

class Reply extends Equatable {
  final int id;
  final int postId;
  final int? parentId;
  final String content;
  final DateTime createdAt;
  final User user;

  const Reply({
    required this.id,
    required this.postId,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        parentId,
        content,
        createdAt,
        user,
      ];

  toJson() {}
}

class Comment {
  final int? commentId;
  final int? postId;
  final int? parentId;
  final String content;

  const Comment({
    this.commentId,
    this.postId,
    this.parentId,
    required this.content,
  });
}
