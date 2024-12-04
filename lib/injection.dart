import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hiswana_migas/core/token_storage.dart';
import 'package:hiswana_migas/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hiswana_migas/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hiswana_migas/features/auth/domain/repositories/auth_repository.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/get_kota.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/get_provinsi.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/get_user_profile_usecase.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/login_usecase.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/register_usecase.dart';
import 'package:hiswana_migas/features/social%20media/data/datasources/post_remote_data_source.dart';
import 'package:hiswana_migas/features/social%20media/data/repositories/comments_repository_impl.dart';
import 'package:hiswana_migas/features/social%20media/data/repositories/post_repository_impl.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/comment_repository.dart';
import 'package:hiswana_migas/features/social%20media/domain/repositories/post_repository.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/comment_usecase.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/create_comment_usecsae.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/create_post_use_case.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/delete_comment.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/delete_post_usecase.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/get_posts_usecase.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/like_post_usecase.dart';
import 'package:hiswana_migas/features/social%20media/domain/usecase/reply_usecase.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final sl = GetIt.instance;

Future<void> init() async {
  const secureStorage = FlutterSecureStorage();
  await dotenv.load(fileName: ".env");
  final baseUrl = dotenv.env['BASE_URL']!;

  // TokenLocalDataSource
  sl.registerLazySingleton(() => TokenLocalDataSource(secureStorage));

  // Registering UseCases
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetProvinsiUsecase(sl()));
  sl.registerLazySingleton(() => GetKotaUsecase(sl()));
  // Post Usecases
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => LikePostUsecase(sl()));
  sl.registerLazySingleton(() => DeletePostUsecase(sl()));
  sl.registerLazySingleton(() => CommentUseCase(sl()));
  sl.registerLazySingleton(() => CreateCommentUsecase(sl()));
  sl.registerLazySingleton(() => ReplyCommentUsecase(sl()));
  sl.registerLazySingleton(() => DeleteComment(sl()));

  // Registering Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()));
  // Post Repositories
  sl.registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(remoteDataSource: sl()));
// comment repository
  sl.registerLazySingleton<CommentRepository>(
      () => CommentsRepositoryImpl(remoteDataSource: sl()));
  // Registering Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
      client: sl(), baseUrl: baseUrl, tokenLocalDataSource: sl()));
  // Post Data Sources
  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(
      client: sl(), baseUrl: baseUrl, tokenLocalDataSource: sl()));

  // Registering External Dependencies (http client)
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => secureStorage);
}
