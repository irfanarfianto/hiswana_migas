part of 'delete_comment_cubit.dart';

sealed class DeleteCommentState extends Equatable {
  const DeleteCommentState();

  @override
  List<Object> get props => [];
}

final class DeleteCommentInitial extends DeleteCommentState {}

class DeleteCommentLoading extends DeleteCommentState {}

class DeleteCommentsSuccess extends DeleteCommentState {
  final int postId;

  const DeleteCommentsSuccess(this.postId);
}

class DeleteCommentsError extends DeleteCommentState {
  final String error;

  const DeleteCommentsError(this.error);
}
