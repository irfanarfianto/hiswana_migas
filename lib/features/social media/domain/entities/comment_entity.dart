// Entity untuk User
class User {
  final String name;
  final String profilePhoto;

  User({
    required this.name,
    required this.profilePhoto,
  });
}

// Entity untuk Reply
class Reply {
  final int id;
  final int postId;
  final int? parentId; // Bisa null
  final String content;
  final DateTime createdAt;
  final User user;

  Reply({
    required this.id,
    required this.postId,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.user,
  });
}

// Entity untuk Comment
class Comment {
  final int id;
  final int postId;
  final int? parentId; // Bisa null
  final String content;
  final DateTime createdAt;
  final User user;
  final List<Reply> replies;

  Comment({
    required this.id,
    required this.postId,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.user,
    required this.replies,
  });
}
