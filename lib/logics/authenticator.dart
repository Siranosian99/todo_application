
import 'package:local_auth/local_auth.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();
  static AuthService authService = AuthService();

  static Future<bool> authenticate(bool auth) async {
    try {
      if (!auth) {
        return true;
      }

      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isDeviceSecure = await _auth.isDeviceSupported() || canCheckBiometrics;
      bool hasBiometricEnrolled = await _auth.getAvailableBiometrics().then(
            (biometrics) => biometrics.isNotEmpty,
      );

      bool isAuthenticated = false;

      if (canCheckBiometrics && hasBiometricEnrolled) {
        // Use biometric authentication
        isAuthenticated = await _auth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );
      } else {
        // Fallback to device credentials (PIN, pattern, etc.)
        isAuthenticated = await _auth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          options: const AuthenticationOptions(
            biometricOnly: false,
          ),
        );
      }

      if (!isAuthenticated) {
        auth = false;
      }

      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }
  static Future<bool> isDeviceSecure() async {
    final LocalAuthentication auth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();
      bool isDeviceSecure = await auth.isDeviceSupported() || canCheckBiometrics;

      return isDeviceSecure;
    } catch (e) {
      print("Error checking device security: $e");
      return false;
    }
  }

}
