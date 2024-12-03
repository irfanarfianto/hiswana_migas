import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';
import 'package:hiswana_migas/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> execute(
      String name, String email, String password) {
    return repository.register(name, email, password);
  }
}
