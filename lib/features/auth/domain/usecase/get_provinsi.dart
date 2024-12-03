import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/domain/entities/provinsi_entities.dart';
import 'package:hiswana_migas/features/auth/domain/repositories/auth_repository.dart';

class GetProvinsiUsecase {
  final AuthRepository repository;

  GetProvinsiUsecase(this.repository);

  Future<Either<Failure, List<ProvinsiEntities>>> execute() async {
    return await repository.getProvinsi();
  }
}
