import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/social%20media/data/models/comment_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/reply_usecase.dart';

part 'reply_event.dart';
part 'reply_state.dart';

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  ReplyCommentUsecase replyCommentUsecase;
  ReplyBloc({
    required this.replyCommentUsecase,
  }) : super(ReplyInitial()) {
    on<ReplyComment>((event, emit) async {
      try {
        emit(ReplyCommentLoading());
        final result =
            await replyCommentUsecase.execute(event.commentId, event.comment);

        result.fold(
          (failure) {
            emit(ReplyCommentError(failure.message));
          },
          (comment) {
            emit(ReplyCommentCreated(comment));
          },
        );
      } catch (e) {
        emit(ReplyCommentError(e.toString()));
      }
    });
  }
}
