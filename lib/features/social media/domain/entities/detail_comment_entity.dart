import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';

class DetailComment extends Equatable {
  final int id;
  final int postId;
  final int? parentId;
  final String content;
  final DateTime createdAt;
  final User user;
  final List<Reply>? replies;

  const DetailComment({
    required this.id,
    required this.postId,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.user,
    required this.replies,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        parentId,
        content,
        createdAt,
        user,
        replies,
      ];
}
