import 'package:hiswana_migas/features/auth/domain/entities/provinsi_entities.dart';

class ProvModel extends ProvinsiEntities {
  const ProvModel({
    required super.code,
    required super.name,
  });

  factory ProvModel.fromJson(Map<String, dynamic> json) {
    return ProvModel(
      code: json['code'] ?? " ",
      name: json['name'] ?? " ",
    );
  }
}
