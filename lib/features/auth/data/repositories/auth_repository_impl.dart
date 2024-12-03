import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/exaption.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hiswana_migas/features/auth/domain/entities/kota_entities.dart';
import 'package:hiswana_migas/features/auth/domain/entities/provinsi_entities.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';
import 'package:hiswana_migas/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getUserProfile(String userId) async {
    try {
      final user = await remoteDataSource.getUserProfile(userId);
      return Right(user);
    } on ServerException {
      return const Left(
          ServerFailure('Gagal mendapatkan data user, silahkan coba lagi.'));
    }
  }

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on ServerException {
      return const Left(ServerFailure(
          'Gagal login, silahkan cek kembali email dan password anda.'));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String name,
    String email,
    String password,
    String provinceCode,
    String cityCode,
    String? profilePhoto,
  ) async {
    try {
      final result = await remoteDataSource.register(
          name, email, password, provinceCode, cityCode, profilePhoto!);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('Gagal registrasi, silahkan coba lagi.'));
    }
  }

  @override
  Future<Either<Failure, List<ProvinsiEntities>>> getProvinsi() async {
    try {
      final result = await remoteDataSource.getProvinsi();
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('Gagal registrasi, silahkan coba lagi.'));
    }
  }

  @override
  Future<Either<Failure, List<KotaEntities>>> getKota(
      String provinsiCode) async {
    try {
      final result = await remoteDataSource.getKota(provinsiCode);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('Gagal registrasi, silahkan coba lagi.'));
    }
  }
}
