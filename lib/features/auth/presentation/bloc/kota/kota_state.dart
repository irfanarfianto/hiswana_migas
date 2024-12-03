part of 'kota_bloc.dart';

sealed class KotaState extends Equatable {
  const KotaState();

  @override
  List<Object> get props => [];
}

final class KotaInitial extends KotaState {}

final class KotaLoading extends KotaState {}

final class KotaLoaded extends KotaState {
  final List<KotaEntities> kota;

  const KotaLoaded({required this.kota});

  @override
  List<Object> get props => [kota];
}

final class KotaError extends KotaState {
  final String message;

  const KotaError({required this.message});

  @override
  List<Object> get props => [message];
}
