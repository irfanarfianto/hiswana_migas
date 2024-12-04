part of 'reply_bloc.dart';

sealed class ReplyState extends Equatable {
  const ReplyState();

  @override
  List<Object> get props => [];
}

final class ReplyInitial extends ReplyState {}

class ReplyCommentLoading extends ReplyState {}

class ReplyCommentCreated extends ReplyState {
  final Comment comment;
  const ReplyCommentCreated(this.comment);

  @override
  List<Object> get props => [comment];
}

class ReplyCommentError extends ReplyState {
  final String message;
  const ReplyCommentError(this.message);

  @override
  List<Object> get props => [message];
}
