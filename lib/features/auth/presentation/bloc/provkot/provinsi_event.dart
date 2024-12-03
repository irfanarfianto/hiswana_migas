part of 'provinsi_bloc.dart';

sealed class ProvinsiEvent extends Equatable {
  const ProvinsiEvent();

  @override
  List<Object> get props => [];
}

class GetProvinsi extends ProvinsiEvent {}

