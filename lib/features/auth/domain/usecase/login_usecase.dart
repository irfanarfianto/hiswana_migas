import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';
import 'package:hiswana_migas/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> execute(String email, String password) {
    return repository.login(email, password);
  }
}
