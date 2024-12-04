import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/comment_usecase.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentUseCase getComments;
  CommentsBloc({
    required this.getComments,
  }) : super(CommentsInitial()) {
    on<GetComments>((event, emit) async {
      try {
        emit(CommentLoading());
        final result = await getComments.execute(event.postId);

        result.fold(
          (failure) => emit(CommentError(failure.message)),
          (comments) => emit(CommentLoaded(comments)),
        );
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });
  }
}
