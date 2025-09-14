import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../controllers/auth_controller.dart';
import 'notes_dashboard.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();

    return Obx(() {
      if (authCtrl.isAuthenticated.value) {
        return const NotesDashboard();
      } else {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () async {
                bool canCheckBiometrics = await authCtrl.canCheckBiometrics();
                bool isDeviceSupported = await authCtrl.isDeviceSupported();
                if(canCheckBiometrics && isDeviceSupported){
                  authCtrl.authenticate();
                }
              },
              child: const Text('Authenticate'),
            ),
          ),
        );
      }
    });
  }
}
