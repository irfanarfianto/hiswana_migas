import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';
import 'package:hiswana_migas/features/social%20media/data/models/post_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/post_entity.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/create_post_use_case.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/get_posts_usecase.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;

  PostBloc({
    required this.getPostsUseCase,
    required this.createPostUseCase,
  }) : super(PostInitial()) {
    on<GetPostsEvent>((event, emit) async {
      try {
        emit(PostLoading());
        final result = await getPostsUseCase.execute();
        emit(result.fold(
          (failure) => PostError(failure.message),
          (posts) => PostLoaded(posts),
        ));
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });

    on<CreatePostEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final result = await createPostUseCase.execute(
          event.postCreate,
        );
        result.fold(
          (failure) => emit(PostError(failure.message)),
          (post) => emit(PostCreated([post])),
        );
      } catch (error) {
        emit(PostError(error.toString()));
      }
    });
  }
}
