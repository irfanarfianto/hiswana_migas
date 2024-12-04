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

class UpdatePostEvent extends PostEvent {
  final int postId;
  final PostModel updatePost;

  const UpdatePostEvent({required this.updatePost, required this.postId});

  @override
  List<Object> get props => [updatePost];
}
