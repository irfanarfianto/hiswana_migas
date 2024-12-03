part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUser extends UserEvent {
  final String token;

  const GetUser({required this.token});

  @override
  List<Object> get props => [token];
}

class LoadUserData extends UserEvent {}
