import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';

class UserModel extends User {
  const UserModel({
    required super.name,
    required super.email,
    required super.provinceCode,
    required super.cityCode,
    required super.registerNumber,
    required super.uniqueNumber,
    super.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      provinceCode: json['province_code'] ?? '',
      cityCode: json['city_code'] ?? '',
      registerNumber: (json['register_number'] ?? 0).toString(),
      uniqueNumber: json['unique_number'] ?? '',
      profilePhoto: json['profile_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'province_code': provinceCode,
      'city_code': cityCode,
      'register_number': registerNumber,
      'unique_number': uniqueNumber,
      'profile_photo': profilePhoto,
    };
  }
}
