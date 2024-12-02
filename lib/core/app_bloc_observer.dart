import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/core/exaption.dart';
import 'package:hiswana_migas/main.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (error is UnauthorizedException) {
      final context = MyApp.navigatorKey.currentContext;

      if (context != null) {
        GoRouter.of(context).goNamed('login');
      }
    } else {
      super.onError(bloc, error, stackTrace);
    }
  }
}
