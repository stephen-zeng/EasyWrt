import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:local_auth_android/local_auth_android.dart';
// import 'package:local_auth_ios/local_auth_ios.dart';

class BioAuthService {
  final LocalAuthentication auth;

  BioAuthService({LocalAuthentication? localAuthentication})
      : auth = localAuthentication ?? LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print("Error checking biometrics: $e");
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print("Error getting available biometrics: $e");
      return [];
    }
  }

  Future<bool> authenticate({required String localizedReason}) async {
    try {
      return await auth.authenticate(
        localizedReason: localizedReason,
        // options: const AuthenticationOptions(
        //   stickyAuth: true,
        //   sensitiveTransaction: true,
        // ),
        // Try passing directly if options is not found
        // stickyAuth: true,
        // sensitiveTransaction: true,
        /* authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Authenticate to EasyWRT',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ], */
      );
    } on PlatformException catch (e) {
      print("Error during authentication: $e");
      return false;
    }
  }
}
