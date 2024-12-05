import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiswana_migas/features/auth/data/models/user_model.dart';

class LocalDataSource {
  Future<UserModel?> getUserProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user_profile_$userId');
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> saveUserProfile(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'user_profile_${user.registerNumber}', json.encode(user.toJson()));
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }
}
