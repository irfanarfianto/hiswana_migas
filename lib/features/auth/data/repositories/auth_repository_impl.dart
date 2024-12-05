import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hiswana_migas/core/exaption.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hiswana_migas/features/auth/data/datasources/db/user_db_source.dart';
import 'package:hiswana_migas/features/auth/data/models/user_model.dart';
import 'package:hiswana_migas/features/auth/domain/entities/kota_entities.dart';
import 'package:hiswana_migas/features/auth/domain/entities/provinsi_entities.dart';
import 'package:hiswana_migas/features/auth/domain/entities/user_entities.dart';
import 'package:hiswana_migas/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserDatabaseHelper userDatabaseHelper;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.userDatabaseHelper,
  });

  @override
  Future<Either<Failure, User>> getUserProfile(String userId) async {
    try {
      // Cek data lokal terlebih dahulu
      UserModel? localUser = await userDatabaseHelper.getUser();
      if (localUser != null) {
        return Right(localUser); // Kembalikan data lokal jika ada
      }

      // Jika data lokal tidak ada, ambil dari server
      final user = await remoteDataSource.getUserProfile(userId);
      await userDatabaseHelper.insertUser(user); // Simpan ke lokal

      return Right(user);
    } on ServerException {
      return const Left(
          ServerFailure('Gagal mendapatkan data user, silahkan coba lagi.'));
    } catch (e) {
      return const Left(ServerFailure('Terjadi kesalahan yang tidak terduga.'));
    }
  }

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);

      if (response != null) {
        await userDatabaseHelper
            .insertUser(response); // Simpan data user ke database lokal
        return Right(response); // Kembalikan data user
      } else {
        return const Left(ServerFailure(
            'Gagal login, silahkan cek kembali email dan password.'));
      }
    } catch (e) {
      return const Left(ServerFailure(
          'Gagal login, silahkan cek kembali email dan password.'));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String name,
    String email,
    String password,
    String provinceCode,
    String cityCode,
    File? profilePhoto,
  ) async {
    try {
      final result = await remoteDataSource.register(
          name, email, password, provinceCode, cityCode, profilePhoto);
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
      return const Left(
          ServerFailure('Gagal mengambil data provinsi, silahkan coba lagi.'));
    }
  }

  @override
  Future<Either<Failure, List<KotaEntities>>> getKota(
      String provinsiCode) async {
    try {
      final result = await remoteDataSource.getKota(provinsiCode);
      return Right(result);
    } on ServerException {
      return const Left(
          ServerFailure('Gagal mengambil data kota, silahkan coba lagi.'));
    }
  }
}
