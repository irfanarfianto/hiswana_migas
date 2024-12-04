import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';

class DetailPostEntity {
  final int id;
  final String? caption;
  final List<String> photos;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final List<Like> likes;
  final List<CommentPost> comments;

  DetailPostEntity({
    required this.id,
    this.caption,
    required this.photos,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.likes,
    required this.comments,
  });
}

class Like {
  final int id;
  final int userId;
  final int postId;

  Like({required this.id, required this.userId, required this.postId});
}

class CommentPost {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final DateTime createdAt;

  CommentPost({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });
}
