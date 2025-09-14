import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AuthController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  var isAuthenticated = false.obs;

  Future<void> authenticate() async {
    bool authenticated = false;
    final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      print("available ${availableBiometrics}");
    }

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access your notes',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print("exception is $e");
    }

    isAuthenticated.value = authenticated;
  }

  Future<bool> canCheckBiometrics() async {
    try {
      // Check if biometric hardware is available
      bool canCheck = await auth.canCheckBiometrics;
      // Also check if device supports any local authentication
      bool deviceSupported = await auth.isDeviceSupported();

      // Optionally, check if any biometrics are enrolled
      final availableBiometrics = await auth.getAvailableBiometrics();

      return canCheck && deviceSupported && availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isDeviceSupported() async {
    try {
      return await auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }




}
