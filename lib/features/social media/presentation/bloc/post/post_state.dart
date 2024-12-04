part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<DetailPostEntity> posts;

  const PostLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object> get props => [message];
}

// state untuk created
class PostCreated extends PostState {
  final List<Post> posts;

  const PostCreated(this.posts);

  @override
  List<Object> get props => [posts];
}
