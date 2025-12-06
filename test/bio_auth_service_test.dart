import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:easywrt/services/auth/bio_auth_service.dart';
import 'package:flutter/services.dart';

import 'bio_auth_service_test.mocks.dart';

@GenerateMocks([LocalAuthentication])
void main() {
  group('BioAuthService', () {
    late BioAuthService bioAuthService;
    late MockLocalAuthentication mockLocalAuthentication;

    setUp(() {
      mockLocalAuthentication = MockLocalAuthentication();
      // bioAuthService = BioAuthService(); // Not needed, instantiated in tests
    });

    test('canCheckBiometrics returns true if biometrics are available', () async {
      when(mockLocalAuthentication.canCheckBiometrics).thenAnswer((_) async => true);
      final testService = BioAuthService(localAuthentication: mockLocalAuthentication); // Inject mock
      final result = await testService.canCheckBiometrics();
      expect(result, true);
    });

    test('canCheckBiometrics returns false if biometrics are not available', () async {
      when(mockLocalAuthentication.canCheckBiometrics).thenAnswer((_) async => false);
      final testService = BioAuthService(localAuthentication: mockLocalAuthentication);
      final result = await testService.canCheckBiometrics();
      expect(result, false);
    });

    test('canCheckBiometrics handles PlatformException', () async {
      when(mockLocalAuthentication.canCheckBiometrics).thenThrow(PlatformException(code: 'test'));
      final testService = BioAuthService(localAuthentication: mockLocalAuthentication);
      final result = await testService.canCheckBiometrics();
      expect(result, false);
    });

    test('getAvailableBiometrics returns a list of biometric types', () async {
      when(mockLocalAuthentication.getAvailableBiometrics())
          .thenAnswer((_) async => [BiometricType.face, BiometricType.fingerprint]);
      final testService = BioAuthService(localAuthentication: mockLocalAuthentication);
      final result = await testService.getAvailableBiometrics();
      expect(result, contains(BiometricType.face));
      expect(result, contains(BiometricType.fingerprint));
    });

    test('authenticate returns true on successful authentication', () async {
      when(mockLocalAuthentication.authenticate(
        localizedReason: anyNamed('localizedReason'),
        // Options and authMessages commented out in implementation
      )).thenAnswer((_) async => true);
      final testService = BioAuthService(localAuthentication: mockLocalAuthentication);
      final result = await testService.authenticate(localizedReason: 'Test reason');
      expect(result, true);
    });

    test('authenticate returns false on failed authentication', () async {
      when(mockLocalAuthentication.authenticate(
        localizedReason: anyNamed('localizedReason'),
      )).thenAnswer((_) async => false);
      final testService = BioAuthService(localAuthentication: mockLocalAuthentication);
      final result = await testService.authenticate(localizedReason: 'Test reason');
      expect(result, false);
    });

    test('authenticate handles PlatformException during authentication', () async {
      when(mockLocalAuthentication.authenticate(
        localizedReason: anyNamed('localizedReason'),
      )).thenThrow(PlatformException(code: 'test_auth_fail'));
      final testService = BioAuthService(localAuthentication: mockLocalAuthentication);
      final result = await testService.authenticate(localizedReason: 'Test reason');
      expect(result, false);
    });
  });
}
