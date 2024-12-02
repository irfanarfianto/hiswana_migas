import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/core/app_bloc_observer.dart';
import 'package:hiswana_migas/features/theme/cubit/switch_theme_cubit.dart';
import 'package:hiswana_migas/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hiswana_migas/injection.dart' as di;
import 'package:hiswana_migas/core/theme/app_pallete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
