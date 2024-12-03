class Post {
  final String? caption;
  final List<String>? photo;
  bool isLiked;

  Post({
    this.caption,
    this.photo,
    this.isLiked = false,
  });
}
