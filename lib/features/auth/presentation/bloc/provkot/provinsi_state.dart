part of 'provinsi_bloc.dart';

sealed class ProvinsiState extends Equatable {
  const ProvinsiState();

  @override
  List<Object> get props => [];
}

final class ProvinsiInitial extends ProvinsiState {}

final class ProvinsiLoading extends ProvinsiState {}

final class ProvinsiLoaded extends ProvinsiState {
  final List<ProvinsiEntities> provinsi;

  const ProvinsiLoaded({required this.provinsi});

  @override
  List<Object> get props => [provinsi];
}

final class ProvinsiError extends ProvinsiState {
  final String message;

  const ProvinsiError({required this.message});

  @override
  List<Object> get props => [message];
}

