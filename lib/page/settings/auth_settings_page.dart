import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easywrt/provider/app_settings_provider.dart';
import 'package:easywrt/services/auth/bio_auth_service.dart';

class AuthSettingsPage extends StatefulWidget {
  const AuthSettingsPage({super.key});

  @override
  State<AuthSettingsPage> createState() => _AuthSettingsPageState();
}

class _AuthSettingsPageState extends State<AuthSettingsPage> {
  final BioAuthService _bioAuthService = BioAuthService();
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricsSupport();
  }

  Future<void> _checkBiometricsSupport() async {
    bool canCheck = await _bioAuthService.canCheckBiometrics();
    setState(() {
      _canCheckBiometrics = canCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Settings'),
      ),
      body: Consumer<AppSettingsProvider>(
        builder: (context, appSettingsProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
                title: const Text('Enable Biometric Authentication'),
                trailing: Switch(
                  value: appSettingsProvider.settings.bioAuthEnabled,
                  onChanged: _canCheckBiometrics
                      ? (bool value) async {
                          if (value) {
                            // If enabling, prompt for authentication immediately
                            bool isAuthenticated = await _bioAuthService.authenticate(
                                localizedReason: 'Authenticate to enable biometrics');
                            if (isAuthenticated) {
                              appSettingsProvider.setBioAuthEnabled(value);
                            } else {
                              // If authentication fails, don't change the switch state
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Biometric authentication failed')),
                              );
                            }
                          } else {
                            // If disabling, no authentication needed
                            appSettingsProvider.setBioAuthEnabled(value);
                          }
                        }
                      : null, // Disable switch if biometrics not supported
                ),
              ),
              if (!_canCheckBiometrics)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Biometric authentication is not available on this device.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
