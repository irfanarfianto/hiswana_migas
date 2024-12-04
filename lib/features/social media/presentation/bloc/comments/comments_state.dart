part of 'comments_bloc.dart';

sealed class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object> get props => [];
}

final class CommentsInitial extends CommentsState {}

class CommentLoading extends CommentsState {}

class CommentLoaded extends CommentsState {
  final List<DetailComment> getComments;
  const CommentLoaded(this.getComments);

  @override
  List<Object> get props => [getComments];
}

class CommentError extends CommentsState {
  final String message;
  const CommentError(this.message);

  @override
  List<Object> get props => [message];
}

class CommentCreated extends CommentsState {
  final Comment comment;
  const CommentCreated(this.comment);

  @override
  List<Object> get props => [comment];
}

class CommentCreatedError extends CommentsState {
  final String message;
  const CommentCreatedError(this.message);

  @override
  List<Object> get props => [message];
}
