import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';

part 'delete_comment_state.dart';

class DeleteCommentCubit extends Cubit<DeleteCommentState> {
  final CommentRepository commentRepository;

  DeleteCommentCubit(this.commentRepository) : super(DeleteCommentInitial());

  Future<void> deleteComment(int commentId) async {
    emit(DeleteCommentLoading());
    final result = await commentRepository.deleteComment(commentId);
    result.fold((failure) => emit(DeleteCommentsError(failure.message)),
        (_) => emit(DeleteCommentsSuccess(commentId)));
  }
}
