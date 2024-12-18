import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/get_user_profile_usecase.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/login_usecase.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getUserProfileUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await loginUseCase.execute(event.email, event.password);
        emit(result.fold(
          (failure) => AuthError(message: _mapFailureToMessage(failure)),
          (user) => AuthAuthenticated(user: user),
        ));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await registerUseCase.execute(
          event.name,
          event.email,
          event.password,
          event.provinceCode,
          event.cityCode,
          event.profilePhoto,
        );
        emit(result.fold(
          (failure) => AuthError(message: _mapFailureToMessage(failure)),
          (user) => RegisterSuccess(user: user),
        ));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
  }
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return 'Network Error: ${failure.message}';
    } else {
      return 'Unexpected Error: ${failure.message}';
    }
  }
}
