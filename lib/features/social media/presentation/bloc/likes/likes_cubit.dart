import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/post_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/post_repository.dart';

part 'likes_state.dart';

class LikesCubit extends Cubit<LikesState> {
  final PostRepository postRepository;
  Map<int, bool> likedPosts = {};

  LikesCubit(this.postRepository) : super(LikesInitial());

  Future<void> postLike(int postId) async {
    emit(PostLikeLoading());

    final eitherResult = await postRepository.likePost(postId);

    eitherResult.fold(
      (failure) => emit(PostLikeError(failure.message)),
      (_) {
        // Toggle like status
        bool newLikeStatus = !(likedPosts[postId] ?? false);
        likedPosts[postId] = newLikeStatus;
        emit(
            PostLikeLoaded(postId, newLikeStatus)); // Kirim status like terbaru
      },
    );
  }

  bool isPostLiked(int postId) {
    return likedPosts[postId] ?? false;
  }
}

