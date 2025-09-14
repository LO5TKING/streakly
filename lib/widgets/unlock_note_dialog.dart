import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../model/note.dart';

class UnlockNoteDialog extends StatefulWidget {
  final Note note;
  const UnlockNoteDialog({super.key, required this.note});

  @override
  State<UnlockNoteDialog> createState() => _UnlockNoteDialogState();
}

class _UnlockNoteDialogState extends State<UnlockNoteDialog> {
  final LocalAuthentication auth = LocalAuthentication();
  final _pinController = TextEditingController();

  bool _biometricSupported = false;
  bool _checkingBiometric = true;
  final String _correctPin = "1234"; // Replace with your secure PIN management

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    _biometricSupported = await auth.isDeviceSupported() && await auth.canCheckBiometrics;
    if (_biometricSupported) {
      _authenticateBiometric();
    } else {
      setState(() => _checkingBiometric = false);
    }
  }

  Future<void> _authenticateBiometric() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to unlock this note',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        Get.back(result: true);
      } else {
        setState(() => _checkingBiometric = false);
      }
    } catch (e) {
      setState(() => _checkingBiometric = false);
    }
  }

  void _submitPin() {
    if (_pinController.text == _correctPin) {
      Get.back(result: true);
    } else {
      Get.snackbar('Error', 'Incorrect PIN');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingBiometric) {
      return const Center(child: CircularProgressIndicator());
    }
    return AlertDialog(
      title: const Text('Unlock Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Enter PIN to unlock"),
          TextField(
            controller: _pinController,
            obscureText: true,
            maxLength: 4,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "PIN",
            ),
            onSubmitted: (_) => _submitPin(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitPin,
          child: const Text('Unlock'),
        ),
      ],
    );
  }
}