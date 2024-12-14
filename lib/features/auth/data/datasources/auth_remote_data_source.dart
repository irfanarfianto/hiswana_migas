import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hiswana_migas/core/constants/api_urls.dart';
import 'package:hiswana_migas/core/exaption.dart';
import 'package:hiswana_migas/core/network/dio_client.dart';
import 'package:hiswana_migas/core/token_storage.dart';
import 'package:hiswana_migas/features/auth/data/datasources/db/user_db_source.dart';
import 'package:hiswana_migas/features/auth/data/models/kota_model.dart';
import 'package:hiswana_migas/features/auth/data/models/prov_model.dart';
import 'package:hiswana_migas/features/auth/data/models/user_model.dart';
import 'package:hiswana_migas/features/auth/domain/entities/kota_entities.dart';
import 'package:hiswana_migas/features/auth/domain/entities/provinsi_entities.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> getUserProfile(String userId);
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password,
      String provinceCode, String cityCode, File? profilePhoto);
  Future<List<ProvinsiEntities>> getProvinsi();
  Future<List<KotaEntities>> getKota(String provinsiCode);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  final TokenLocalDataSource tokenLocalDataSource;
  final UserDatabaseHelper userDatabaseHelper;

  AuthRemoteDataSourceImpl({
    required this.dioClient,
    required this.tokenLocalDataSource,
    required this.userDatabaseHelper,
  });

  @override
  Future<UserModel> getUserProfile(String userId) async {
    UserModel? localUser = await userDatabaseHelper.getUser();
    if (localUser != null) {
      return localUser;
    }

    try {
      final token = await tokenLocalDataSource.getToken();

      final response = await dioClient.get(
        ApiUrls.profile,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final user = UserModel.fromJson(response.data);
      await userDatabaseHelper.insertUser(user);
      return user;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        ApiUrls.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['access_token'];
      if (token != null) {
        tokenLocalDataSource.saveToken(token);
      }

      final user = UserModel.fromJson(response.data['user']);
      await userDatabaseHelper.insertUser(user);
      return user;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password,
      String provinceCode, String cityCode, File? profilePhoto) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'province_code': provinceCode,
        'city_code': cityCode,
        if (profilePhoto != null)
          'profile_photo': await MultipartFile.fromFile(profilePhoto.path),
      });

      final response = await dioClient.post(
        ApiUrls.register,
        data: formData,
        options: Options(headers: {
          'Accept': 'application/json',
        }),
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<ProvinsiEntities>> getProvinsi() async {
    try {
      final response = await dioClient.get(
        'https://wilayah.id/api/provinces.json',
      );

      // Validasi respons
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> prov = response.data['data'];
        return prov.map((provinsi) => ProvModel.fromJson(provinsi)).toList();
      } else {
        throw ServerException(
            'Failed to fetch provinces: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<KotaEntities>> getKota(String provinsiCode) async {
    try {
      final response = await dioClient.get(
        'https://wilayah.id/api/regencies/$provinsiCode.json',
      );

      final List<dynamic> kota = response.data['data'];
      return kota.map((kot) => KotaModel.fromJson(kot)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  ServerException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException('Koneksi timeout. Silakan coba lagi.');
      case DioExceptionType.badResponse:
        return ServerException(
            'Gagal mendapatkan data. Status code: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return ServerException('Request dibatalkan.');
      case DioExceptionType.unknown:
        if (e.message!.contains('Connection closed')) {
          return ServerException('Koneksi terputus sebelum selesai.');
        }
        return ServerException('Kesalahan jaringan: ${e.message}');
      default:
        return ServerException('Kesalahan tak terduga: ${e.message}');
    }
  }
}
