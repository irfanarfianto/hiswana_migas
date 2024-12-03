part of 'kota_bloc.dart';

sealed class KotaEvent extends Equatable {
  const KotaEvent();

  @override
  List<Object> get props => [];
}

class GetKota extends KotaEvent {
  final String provinsiCode;

  const GetKota({required this.provinsiCode});
}
