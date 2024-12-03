import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/post_repository.dart';

part 'delete_state.dart';

class DeleteCubit extends Cubit<DeleteState> {
  final PostRepository postRepository;

  DeleteCubit(this.postRepository) : super(DeleteInitial());

  Future<void> deletePost(int postId) async {
    emit(DeletePostLoading());
    final result = await postRepository.deletePost(postId);
    result.fold((failure) => emit(DeletePostError(failure.message)),
        (_) => emit(DeletePostSuccess(postId)));
  }
}
