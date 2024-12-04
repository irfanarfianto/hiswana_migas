import 'dart:convert';
import 'dart:io';
import 'package:hiswana_migas/core/exaption.dart';
import 'package:hiswana_migas/core/token_storage.dart';
import 'package:hiswana_migas/features/auth/data/models/kota_model.dart';
import 'package:hiswana_migas/features/auth/data/models/prov_model.dart';
import 'package:hiswana_migas/features/auth/data/models/user_model.dart';
import 'package:hiswana_migas/features/auth/domain/entities/kota_entities.dart';
import 'package:hiswana_migas/features/auth/domain/entities/provinsi_entities.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<UserModel> getUserProfile(String userId);
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password,
      String provinceCode, String cityCode, File? profilePhoto);
  Future<List<ProvinsiEntities>> getProvinsi();
  Future<List<KotaEntities>> getKota(String provinsiCode);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final TokenLocalDataSource tokenLocalDataSource;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.tokenLocalDataSource,
  });

  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final token = await tokenLocalDataSource.getToken();

      final response = await client.get(
        Uri.parse('${baseUrl}profile'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
            'Gagal mendapatkan data user, silahkan coba lagi');
      }
    } catch (e) {
      // Log any exceptions
      throw ServerException('Gagal mendapatkan data user, $e');
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        // Menyimpan token
        final token = decodedResponse['access_token'];
        if (token != null) {
          tokenLocalDataSource.saveToken(token);
        }

        // Mengecek data user
        final user = decodedResponse['user'];
        if (user != null) {
          // Membuat dan mengembalikan model User dengan data yang sesuai
          return UserModel.fromJson({
            'name': user['name'],
            'email': user['email'],
            'province_code': user['province_code'],
            'city_code': user['city_code'],
            'register_number': user['register_number'],
            'unique_number': user['unique_number'],
            'profile_photo': user['profile_photo'],
          });
        } else {
          throw ServerException('User data tidak tersedia dalam respons.');
        }
      } else {
        throw ServerException(
            'Gagal login, silahkan cek kembali email dan password.');
      }
    } catch (e) {
      throw ServerException(
          'Gagal login, silahkan cek kembali email dan password.');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password,
      String provinceCode, String cityCode, File? profilePhoto) async {
    try {
      // Buat request multipart
      final uri = Uri.parse('${baseUrl}register');
      final request = http.MultipartRequest('POST', uri);

      // Tambahkan field
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['password_confirmation'] = password;
      request.fields['province_code'] = provinceCode;
      request.fields['city_code'] = cityCode;

      // Tambahkan file jika ada
      if (profilePhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_photo',
          profilePhoto.path,
        ));
      }

      // Set header
      request.headers['Accept'] = 'application/json';

      // Kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Gagal registrasi, silahkan coba lagi');
      }
    } catch (e) {
      throw ServerException('Gagal registrasi, silahkan coba lagi');
    }
  }

  @override
  Future<List<ProvinsiEntities>> getProvinsi() async {
    try {
      final response = await client.get(
        Uri.parse('https://wilayah.id/api/provinces.json'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> prov = json.decode(response.body)['data'];
        return prov.map((provinsi) => ProvModel.fromJson(provinsi)).toList();
      } else {
        throw ServerException(
            'Gagal mendapatkan data user, silahkan coba lagi');
      }
    } catch (e) {
      throw ServerException('Gagal mendapatkan data user, silahkan coba lagi');
    }
  }

  @override
  Future<List<KotaEntities>> getKota(String provinsiCode) async {
    try {
      final response = await client.get(
        Uri.parse('https://wilayah.id/api/regencies/$provinsiCode.json'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> kota = json.decode(response.body)['data'];
        return kota.map((kot) => KotaModel.fromJson(kot)).toList();
      } else {
        throw ServerException(
            'Gagal mendapatkan data user, silahkan coba lagi');
      }
    } catch (e) {
      throw ServerException('Gagal mendapatkan data user, silahkan coba lagi');
    }
  }
}
