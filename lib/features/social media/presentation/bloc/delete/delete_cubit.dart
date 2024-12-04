import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/post_repository.dart';

part 'delete_state.dart';

class DeletePostCubit extends Cubit<DeleteState> {
  final PostRepository postRepository;
  // final CommentRepository commentRepository;

  DeletePostCubit(this.postRepository) : super(DeleteInitial());

  Future<void> deletePost(int postId) async {
    emit(DeletePostLoading());
    final result = await postRepository.deletePost(postId);
    result.fold((failure) => emit(DeletePostError(failure.message)),
        (_) => emit(DeletePostSuccess(postId)));
  }

  // Future<void> deleteComment(int commentId) async {
  //   emit(DeletePostLoading());
  //   final result = await commentRepository.deleteComment(commentId);
  //   result.fold((failure) => emit(DeleteCommentsError(failure.message)),
  //       (_) => emit(DeleteCommentsSuccess(commentId)));
  // }
}
