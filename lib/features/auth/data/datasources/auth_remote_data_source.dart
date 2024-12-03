import 'dart:convert';
import 'package:hiswana_migas/core/exaption.dart';
import 'package:hiswana_migas/core/token_storage.dart';
import 'package:hiswana_migas/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<UserModel> getUserProfile(String userId);
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
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
      final token = await tokenLocalDataSource
          .getToken(); // Ensure this gets the token correctly
      print('Token: $token'); // Debugging the token value

      final response = await client.get(
        Uri.parse('${baseUrl}profile'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'response.statusCode: ${response.statusCode}, response.body: ${response.body}');

      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
            'Gagal mendapatkan data user, silahkan coba lagi');
      }
    } catch (e) {
      print('Error: $e'); // Log any exceptions
      throw ServerException('Gagal mendapatkan data user, silahkan coba lagi');
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

      print(
          'response.statusCode: ${response.statusCode}, response.body: ${response.body}');

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
      print('Error: $e');
      throw ServerException(
          'Gagal login, silahkan cek kembali email dan password.');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Gagal registrasi, silahkan coba lagi');
      }
    } catch (e) {
      throw ServerException('Gagal registrasi, silahkan coba lagi');
    }
  }
}
