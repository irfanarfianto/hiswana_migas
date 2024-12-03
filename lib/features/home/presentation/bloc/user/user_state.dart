part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);
}

class UserLoading extends UserState {}

class UserError extends UserState {
  final String message;

  const UserError(this.message);
}
