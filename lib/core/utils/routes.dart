import 'package:flutter/material.dart';
import 'package:mood_tracker/ui/screens/main.dart';
import 'package:mood_tracker/ui/screens/authenticate.dart';
import 'package:mood_tracker/ui/screens/introduction.dart';
import 'package:mood_tracker/ui/screens/splash.dart';

enum Routes {
  splash,
  introduction,
  main,
  authenticate,
}

class Paths {
  static const String splash = '/';
  static const String introduction = '/introduction';
  static const String main = '/main';
  static const String authenticate = '/authenticate';

  static const Map<Routes, String> pathMap = {
    Routes.splash: Paths.splash,
    Routes.main: Paths.main,
    Routes.introduction: Paths.introduction,
    Routes.authenticate: Paths.authenticate,
  };

  static String of(Routes route) => pathMap[route] ?? splash;
}

class AppNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Paths.splash: 
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case Paths.introduction: 
        return MaterialPageRoute(builder: (context) => const IntroductionScreen());
      case Paths.main: 
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case Paths.authenticate: 
        return MaterialPageRoute(builder: (context) => const AuthenticateScreen());
      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }

  static Future? push<T>(Routes route, [T? arguments]) =>
    state?.pushNamed(Paths.of(route), arguments: arguments);

  static Future? replaceWith<T>(Routes route, [T? arguments]) =>
      state?.pushReplacementNamed(Paths.of(route), arguments: arguments);

  static void pop() => state?.pop();

  static NavigatorState? get state => navigatorKey.currentState;
}