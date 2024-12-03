import 'package:equatable/equatable.dart';

class KotaEntities extends Equatable {
  final String code;
  final String name;

  const KotaEntities({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [code, name];
}
