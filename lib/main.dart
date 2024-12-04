import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/core/app_bloc_observer.dart';
import 'package:hiswana_migas/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:hiswana_migas/features/auth/presentation/bloc/kota/kota_bloc.dart';
import 'package:hiswana_migas/features/auth/presentation/bloc/provkot/provinsi_bloc.dart';
import 'package:hiswana_migas/features/home/presentation/bloc/user/user_bloc.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/del_comment/delete_comment_cubit.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/reply/reply_bloc.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/comments/comments_bloc.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/delete/delete_cubit.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/likes/likes_cubit.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/post/post_bloc.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/reply/reply_bloc.dart';
import 'package:hiswana_migas/features/theme/cubit/switch_theme_cubit.dart';
import 'package:hiswana_migas/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hiswana_migas/injection.dart' as di;
import 'package:hiswana_migas/core/theme/app_pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  timeago.setLocaleMessages('id', timeago.IdMessages());
  await dotenv.load(fileName: ".env");
  await di.init();

  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = createRouter();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SwitchThemeCubit(),
        ),
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: di.sl(),
            registerUseCase: di.sl(),
            getUserProfileUseCase: di.sl(),
          ),
        ),
        BlocProvider(
          create: (_) => UserBloc(
            getUserInfo: di.sl(),
          ),
        ),
        BlocProvider(
          create: (_) => PostBloc(
            getPostsUseCase: di.sl(),
            createPostUseCase: di.sl(),
          ),
        ),
        BlocProvider(
          create: (_) => CommentsBloc(
            getComments: di.sl(),
            postComments: di.sl(),
          ),
        ),
        BlocProvider(
          create: (_) => ReplyBloc(
            replyCommentUsecase: di.sl(),
          ),
        ),
        BlocProvider(
          create: (_) => ProvinsiBloc(
            getProvinsi: di.sl(),
          ),
        ),
        BlocProvider(
          create: (_) => KotaBloc(
            getKota: di.sl(),
          ),
        ),
        BlocProvider(create: (_) => LikesCubit(di.sl())),
        BlocProvider(create: (_) => DeletePostCubit(di.sl())),
        BlocProvider(create: (_) => DeleteCommentCubit(di.sl())),
      ],
      child: BlocBuilder<SwitchThemeCubit, SwitchThemeState>(
          builder: (context, themeState) {
        return MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: themeState.isDarkMode ? darkTheme : lightTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('id'),
          ],
        );
      }),
    );
  }
}
