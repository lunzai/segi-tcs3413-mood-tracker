// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mood_tracker/core/services/db.dart';
import 'package:mood_tracker/core/services/hive.dart';
import 'package:mood_tracker/core/services/local_auth.dart';
import 'package:mood_tracker/core/helpers/utils.dart';
import 'package:mood_tracker/core/models/settings.dart';
import 'package:mood_tracker/core/services/notification.dart';
import 'package:mood_tracker/core/utils/colors.dart';
import 'package:mood_tracker/core/utils/constants.dart';
import 'package:mood_tracker/ui/widgets/app_card.dart';
import 'package:mood_tracker/ui/widgets/app_text.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  late Settings settings;
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    settings = HiveService.getSettings();
  }

  Future<void> saveSettings() async {
    await HiveService.saveSettings(settings);
  }

  Future<bool> enrollBiometrics() async {
    if (!await LocalAuthService.canAuthenticate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric passcode not supported on this device.')),
      );
      return false;
    }
    if (await LocalAuthService.authenticate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometrics passcode successfully activated')),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occured while trying to enable biometric passcode. Please try again.')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: settings.useBiometricAuthentication ? 'Enabled' : 'Disabled',
                    size: 22,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  const AppText(
                    text: 'BIOMETRIC PASSCODE',
                    color: AppColors.gray400,
                    weight: FontWeight.bold,
                    size: 14,
                  ),
                ],
              ),
              Switch(
                activeColor: AppColors.white,
                activeTrackColor: AppColors.indigo500,
                value: settings.useBiometricAuthentication,
                onChanged: (bool value) async {
                  if (!value || settings.didBiometricAuthentication) {
                    setState(() {
                      AppLock.of(context)!.setEnabled(value);
                      settings.useBiometricAuthentication = value;
                    });
                  } else {
                    bool success = await enrollBiometrics();
                    if (success) {
                      AppLock.of(context)!.setEnabled(value);
                      setState(() {
                        settings.useBiometricAuthentication = value;
                        settings.didBiometricAuthentication = value;
                      });
                    }
                  }
                  saveSettings();
                },
              ),
            ],
          )
        ),
        const SizedBox(height: 20),
        AppCard(
          child: Column(
            children: [
              // row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: settings.enableReminder ? 'Enabled' : 'Disabled',
                        size: 22,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      const AppText(
                        text: 'CHECK-IN REMINDERS',
                        color: AppColors.gray400,
                        weight: FontWeight.bold,
                        size: 14,
                      ),
                    ],
                  ),
                  Switch(
                    activeColor: AppColors.white,
                    activeTrackColor: AppColors.indigo500,
                    value: settings.enableReminder,
                    onChanged: (value) {
                      if (value) {
                        NotificationService().requestIOSPermissions();
                        NotificationService().scheduleReminder(settings.reminderTime);
                      } else {
                        NotificationService().cancelReminder();
                      }
                      setState(() {
                        settings.enableReminder = value;
                      });
                      saveSettings();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: Utils.formatTime(settings.reminderTime),
                        size: 22,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      const AppText(
                        text: 'EVENING',
                        color: AppColors.gray400,
                        weight: FontWeight.bold,
                        size: 14,
                      ),
                    ],
                  ),
                  Slider(
                    activeColor: AppColors.indigo500,
                    value: Utils.timeToMin(settings.reminderTime), 
                    min: AppConstants.reminderMinMinute.toDouble(),
                    max: AppConstants.reminderMaxMinute.toDouble(),
                    divisions: 96,                      
                    onChanged: (double value) {
                      setState(() {
                        settings.reminderTime = Utils.minuteToTime(value);
                      });
                      if (settings.enableReminder) {
                        NotificationService().cancelReminder();
                        NotificationService().scheduleReminder(settings.reminderTime);
                      }
                      saveSettings();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: settings.skipIntroduction ? 'Enabled' : 'Disabled',
                    size: 22,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  const AppText(
                    text: 'SKIP INTRODUCTIONS',
                    color: AppColors.gray400,
                    weight: FontWeight.bold,
                    size: 14,
                  ),
                ],
              ),
              Switch(
                activeColor: AppColors.white,
                activeTrackColor: AppColors.indigo500,
                value: settings.skipIntroduction,
                onChanged: (value) {
                  setState(() {
                    settings.skipIntroduction = value;
                  });
                  saveSettings();
                },
              ),
            ],
          )
        ),
        const SizedBox(height: 20), 
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          ),
          onPressed: () => showDialog<String>(
            context: context, 
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Are You Sure?'),
              content: const Text('Are you sure you want to permanently delete all data and settings?\n\nThis cannot be undone.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: const AppText(
                    text: 'CANCEL',
                    color: AppColors.gray500,
                    weight: FontWeight.bold,
                    size: 16,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await HiveService.resetSettings();
                    await DbService.truncateAll();
                    setState(() {
                      settings = HiveService.getSettings();
                    });
                    Navigator.pop(context, 'Ok');
                  },
                  child: const AppText(
                    text: 'OK',
                    color: AppColors.red500,
                    weight: FontWeight.bold,
                    size: 16,
                  ),
                ),
              ]
            )
          ), 
          child: const AppText(
            text: 'Delete All My Data',
            weight: FontWeight.bold,
            color: AppColors.gray400,
            size: 15,
          ),
        )
      ],
    );
  }
}