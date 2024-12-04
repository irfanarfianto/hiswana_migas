import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/social%20media/data/models/comment_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/comment_usecase.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/create_comment_usecsae.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentUseCase getComments;
  CreateCommentUsecase postComments;

  CommentsBloc({
    required this.getComments,
    required this.postComments,
  }) : super(CommentsInitial()) {
    on<GetComments>((event, emit) async {
      try {
        emit(CommentLoading());
        final result = await getComments.execute(event.postId);

        result.fold(
          (failure) => emit(CommentError(failure.message)),
          (getComments) => emit(CommentLoaded(getComments)),
        );
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });

    on<AddComment>((event, emit) async {
      try {
        emit(CommentLoading());
        final result = await postComments.execute(event.postId, event.comment);

        result.fold(
          (failure) => emit(CommentCreatedError(failure.message)),
          (comment) {
            emit(CommentCreated(comment));
            add(GetComments(event.postId));
          },
        );
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });
  }
}
