import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/get_user_profile_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileUseCase getUserInfo;

  UserBloc({
    required this.getUserInfo,
  }) : super(UserInitial()) {
    on<GetUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final result = await getUserInfo.execute(event.token);

        emit(result.fold(
          (failure) {
            // Debugging: print error message
            return UserError(failure.message);
          },
          (user) {
            // Debugging: print user info
            return UserLoaded(user);
          },
        ));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
