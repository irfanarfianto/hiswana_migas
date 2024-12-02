import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final locator = GetIt.instance;

Future<void> init() async {
  await dotenv.load(fileName: ".env");
  locator.registerLazySingleton(() => http.Client());
}