part of 'delete_cubit.dart';

sealed class DeleteState extends Equatable {
  const DeleteState();

  @override
  List<Object> get props => [];
}

final class DeleteInitial extends DeleteState {}

class DeletePostLoading extends DeleteState {}

class DeletePostSuccess extends DeleteState {
  final int postId;

  const DeletePostSuccess(this.postId);
}

class DeletePostError extends DeleteState {
  final String error;

  const DeletePostError(this.error);
}
