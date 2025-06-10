import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:DC/utilities/dependencies.dart'; // Access AuthController
import 'package:DC/utilities/routes.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              Get.find<AuthController>().signOut(); // Clears session
              Get.offAllNamed(Routes.homePage); // Navigates home
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome! You are signed in.'),
      ),
    );
  }
}
