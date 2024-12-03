part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends PostEvent {}

class CreatePostEvent extends PostEvent {
  final PostModel postCreate;

  const CreatePostEvent({required this.postCreate});

  @override
  List<Object> get props => [postCreate];
}

class AddCommentEvent extends PostEvent {
  final int postId;
  final String content;
  final User user;

  const AddCommentEvent(
      {required this.postId, required this.content, required this.user});

  @override
  List<Object> get props => [postId, content, user];
}

class AddReplyEvent extends PostEvent {
  final int commentId;
  final String reply;

  const AddReplyEvent({required this.commentId, required this.reply});

  @override
  List<Object> get props => [commentId, reply];
}
