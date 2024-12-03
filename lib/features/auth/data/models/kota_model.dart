import 'package:hiswana_migas/features/auth/domain/entities/kota_entities.dart';

class KotaModel extends KotaEntities {
  const KotaModel({
    required super.code,
    required super.name,
  });

  factory KotaModel.fromJson(Map<String, dynamic> json) {
    return KotaModel(
      code: json['code'] ?? " ",
      name: json['name'] ?? " ",
    );
  }
}
