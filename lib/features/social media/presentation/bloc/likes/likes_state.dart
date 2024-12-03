part of 'likes_cubit.dart';

sealed class LikesState extends Equatable {
  const LikesState();

  @override
  List<Object> get props => [];
}

final class LikesInitial extends LikesState {}

class PostLikeLoading extends LikesState {}

class PostLikeLoaded extends LikesState {
  final int postId;
  final bool isLiked;

  const PostLikeLoaded(this.postId, this.isLiked);
}

class PostLikeError extends LikesState {
  final String error;

  const PostLikeError(this.error);
}
