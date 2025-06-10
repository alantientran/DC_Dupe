import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:DC/utilities/dependencies.dart' as dependencies;

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Sign Out?', textAlign: TextAlign.center),
      actions: [
        ElevatedButton(
          child: const Text('Yes'),
          onPressed: () {
            Get.find<dependencies.AuthController>().signOut();
            // Close the dialog and navigate to home page
          },
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
