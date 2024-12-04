part of 'comments_bloc.dart';

sealed class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object> get props => [];
}

final class CommentsInitial extends CommentsState {}

class CommentLoading extends CommentsState {}

class CommentLoaded extends CommentsState {
  final List<Comment> comments;
  const CommentLoaded(this.comments);

  @override
  List<Object> get props => [comments];
}

class CommentError extends CommentsState {
  final String message;
  const CommentError(this.message);

  @override
  List<Object> get props => [message];
}
