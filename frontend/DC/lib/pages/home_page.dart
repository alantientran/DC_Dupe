import 'package:flutter/material.dart';
import 'package:DC/dialogs/sign_in_dialog.dart';
import 'package:DC/dialogs/create_d_account_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1,
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 57, 95, 249),
                  Color.fromARGB(255, 130, 150, 240),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Detail Connect Dupe',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Image.asset('../images/detailconnect_logo.jpeg', height: 120),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const SignInDialog(),
                    );
                  },
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const CreateAccountDialog(role: 'detail_customer'),
                    );
                  },
                  child: const Text('Create Client Account'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const CreateAccountDialog(role: 'detailer'),
                    );
                  },
                  child: const Text('Create Detailer Account'),
                ),
                // const SizedBox(height: 25),
                // ElevatedButton(
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) => const CreateAccountDialog(),
                //     );
                //   },
                //   child: const Text('Create Account'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
