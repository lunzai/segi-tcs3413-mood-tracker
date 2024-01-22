import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  static final auth = LocalAuthentication();
  
  static Future<bool> canAuthenticate() async {
    return await auth.canCheckBiometrics || await auth.isDeviceSupported();
  }

  static Future<bool> authenticate() async {
    try {
      if (!await canAuthenticate()) {
        return false;
      }
      return await auth.authenticate(
        localizedReason: 'Protect Mood Tracker with Biometric passcode.',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}