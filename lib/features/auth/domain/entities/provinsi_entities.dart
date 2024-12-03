import 'package:equatable/equatable.dart';

class ProvinsiEntities extends Equatable {
  final String code;
  final String name;

  const ProvinsiEntities({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [code, name];
}
