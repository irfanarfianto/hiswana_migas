import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/domain/entities/kota_entities.dart';
import 'package:hiswana_migas/features/auth/domain/repositories/auth_repository.dart';

class GetKotaUsecase {
  final AuthRepository repository;

  GetKotaUsecase(this.repository);

  Future<Either<Failure, List<KotaEntities>>> execute(
      String provinsiCode) async {
    return await repository.getKota(provinsiCode);
  }
}
