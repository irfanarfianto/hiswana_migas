part of 'reply_bloc.dart';

sealed class ReplyEvent extends Equatable {
  const ReplyEvent();

  @override
  List<Object> get props => [];
}

final class ReplyComment extends ReplyEvent {
  final int postId;
  final int commentId;
  final CommentModel comment;
  const ReplyComment(
      {required this.postId, required this.commentId, required this.comment});

  @override
  List<Object> get props => [comment, commentId];
}
