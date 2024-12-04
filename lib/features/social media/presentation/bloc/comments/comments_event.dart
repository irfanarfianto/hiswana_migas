part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

final class GetComments extends CommentsEvent {
  final int postId;
  const GetComments(this.postId);

  @override
  List<Object> get props => [postId];
}

final class AddComment extends CommentsEvent {
  final int postId;
  final CommentModel comment;
  const AddComment({required this.postId, required this.comment});

  @override
  List<Object> get props => [comment, postId];
}
