part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String provinceCode;
  final String cityCode;
  final File? profilePhoto;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.provinceCode,
    required this.cityCode,
    required this.profilePhoto,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        confirmPassword,
        provinceCode,
        cityCode,
        profilePhoto
      ];
}

