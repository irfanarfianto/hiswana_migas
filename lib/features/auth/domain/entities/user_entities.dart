import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String email;
  final String provinceCode;
  final String cityCode;
  final String registerNumber;
  final String uniqueNumber;
  final String? profilePhoto;

  const User({
    required this.name,
    required this.email,
    required this.provinceCode,
    required this.cityCode,
    required this.registerNumber,
    required this.uniqueNumber,
    this.profilePhoto,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        provinceCode,
        cityCode,
        registerNumber,
        uniqueNumber,
        profilePhoto,
      ];
}
