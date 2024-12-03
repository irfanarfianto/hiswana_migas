import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> getUserProfile(String userId);
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(
      String name, String email, String password);
}