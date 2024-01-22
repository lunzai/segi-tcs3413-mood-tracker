import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mood_tracker/core/services/hive.dart';
import 'package:mood_tracker/core/services/notification.dart';
import 'package:mood_tracker/core/utils/constants.dart';
import 'package:mood_tracker/core/utils/routes.dart';
import 'package:mood_tracker/ui/screens/authenticate.dart';
import 'package:mood_tracker/ui/screens/splash.dart';

void main() async {
  await HiveService.init();
  await NotificationService().init();
  runApp(AppLock(
    builder: (arg) => const MainApp(), 
    lockScreen: const AuthenticateScreen(),
    enabled: HiveService.getSettings().useBiometricAuthentication,
    backgroundLockLatency: Duration(
      seconds: AppConstants.backgroundLockLatency
    ),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.navigatorKey,
      onGenerateRoute: AppNavigator.onGenerateRoute,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
