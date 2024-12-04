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
        print("API Result: $result"); // Debugging: print result
        emit(result.fold(
          (failure) {
            print(
                "Error: ${failure.message}"); // Debugging: print error message
            return UserError(failure.message);
          },
          (user) {
            print("User Loaded: ${user.name}"); // Debugging: print user info
            return UserLoaded(user);
          },
        ));
      } catch (e) {
        print("Exception: $e"); // Debugging: print exception
        emit(UserError(e.toString()));
      }
    });
  }
}
