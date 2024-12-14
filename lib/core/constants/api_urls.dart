import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrls {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String login = '${baseUrl}login';
  static String register = '${baseUrl}register';
  static String profile = '${baseUrl}profile';

  static String posts = '${baseUrl}posts';
  static String comments = '${baseUrl}comments';
  static String likePost(int postId) => '${baseUrl}posts/$postId/like';
  static String deletePost(int postId) => '${baseUrl}posts/$postId';
}
