// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:mood_tracker/core/services/local_auth.dart';
import 'package:mood_tracker/core/utils/assets.dart';
import 'package:mood_tracker/core/utils/colors.dart';
import 'package:mood_tracker/ui/widgets/app_gradient_container.dart';
import 'package:mood_tracker/ui/widgets/app_text.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {

  Future<void> handleAuthenticate() async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (await LocalAuthService.authenticate()) {
      AppLock.of(context)!.didUnlock();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleAuthenticate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: AppGradientContainer(
        child: Container(
          padding: const EdgeInsets.only(
            top: 50,
            bottom: 50,
            left: 30,
            right: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  handleAuthenticate();
                },
                child: Image.asset(
                  AppAssets.iconFingerprint,
                  height: 150,
                ),
              ),
              const SizedBox(height: 30),
              const AppText(
                text: 'Please authenticate \n to access Mood Tracker',
                size: 22,
                color: AppColors.indigo400,
                align: TextAlign.center,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}