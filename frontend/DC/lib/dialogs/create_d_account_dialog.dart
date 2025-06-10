import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:DC/utilities/dependencies.dart';
import 'package:DC/dialogs/user_model.dart';
import 'package:DC/dialogs/sign_in_dialog.dart';

class CreateAccountDialog extends StatefulWidget {
  final String role;

  const CreateAccountDialog({super.key, required this.role});

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  final _formKey = GlobalKey<FormState>();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final location = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  RxString status = 'enter-details'.obs;

  void submit() async {
    if (password.text != confirmPassword.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Passwords do not match'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      return;
    }

    AppUser user = AppUser(
      firstName: firstName.text,
      lastName: lastName.text,
      phoneNumber: phoneNumber.text,
      email: email.text,
      location: location.text,
      password: password.text,
      role: widget.role,
    );

    status.value = 'creating-account';

    final response = await Get.find<AuthController>().createUser(user);

    if (response == 'Account created successfully') {
      // Delay briefly, then show sign-in dialog
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context); // Close this dialog
        showDialog(
          context: context,
          builder: (context) => const SignInDialog(), // Open sign-in dialog
        );
      });
    } else {
      status.value = 'enter-details';
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Account Creation Failed'),
          content: Text(response),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget formFields() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Create Account', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 20),
          TextFormField(
              controller: firstName,
              decoration: const InputDecoration(labelText: 'First Name')),
          TextFormField(
              controller: lastName,
              decoration: const InputDecoration(labelText: 'Last Name')),
          TextFormField(
              controller: phoneNumber,
              decoration: const InputDecoration(labelText: 'Phone Number')),
          TextFormField(
              controller: email,
              decoration: const InputDecoration(labelText: 'Email')),
          TextFormField(
              controller: location,
              decoration: const InputDecoration(labelText: 'Location')),
          TextFormField(
              controller: password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true),
          TextFormField(
              controller: confirmPassword,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: submit,
                child: const Text('Sign Up'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget loadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Creating Account...'),
          SizedBox(height: 20),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Obx(() {
        if (status.value == 'creating-account') {
          return loadingWidget();
        } else {
          return formFields();
        }
      }),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:DC/dialogs/user_model.dart';
// import 'package:get/get.dart';
// import 'package:DC/utilities/dependencies.dart';

// class CreateAccountDialog extends StatefulWidget {
//   final String role;

//   const CreateAccountDialog({super.key, required this.role});

//   @override
//   State<CreateAccountDialog> createState() => _CreateAccountDialog();
// }

// class _CreateAccountDialog extends State<CreateAccountDialog> {
//   final _formKey = GlobalKey<FormState>();

//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final phoneNumber = TextEditingController();
//   final email = TextEditingController();
//   final location = TextEditingController();
//   final password = TextEditingController();
//   final confirmPassword = TextEditingController();

//   void submit() async {
//     if (password.text != confirmPassword.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match')),
//       );
//       return;
//     }

//     AppUser user = AppUser(
//       firstName: firstName.text,
//       lastName: lastName.text,
//       phoneNumber: phoneNumber.text,
//       email: email.text,
//       location: location.text,
//       password: password.text,
//       role: widget.role,
//     );

//     final response = await Get.find<AuthController>().createUser(user);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(response)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(children: [
//           TextFormField(
//               controller: firstName,
//               decoration: const InputDecoration(labelText: 'First Name')),
//           TextFormField(
//               controller: lastName,
//               decoration: const InputDecoration(labelText: 'Last Name')),
//           TextFormField(
//               controller: phoneNumber,
//               decoration: const InputDecoration(labelText: 'Phone Number')),
//           TextFormField(
//               controller: email,
//               decoration: const InputDecoration(labelText: 'Email')),
//           TextFormField(
//               controller: location,
//               decoration: const InputDecoration(labelText: 'Location')),
//           TextFormField(
//               controller: password,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true),
//           TextFormField(
//               controller: confirmPassword,
//               decoration: const InputDecoration(labelText: 'Confirm Password'),
//               obscureText: true),
//           const SizedBox(height: 20),
//           ElevatedButton(onPressed: submit, child: const Text('Sign Up'))
//         ]),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:DC/utilities/dependencies.dart' as dependencies;

// class CreateAccountDialog extends StatefulWidget {
//   const CreateAccountDialog({super.key});

//   @override
//   State<CreateAccountDialog> createState() => _CreateAccountDialogState();
// }

// class _CreateAccountDialogState extends State<CreateAccountDialog> {
//   RxString status = 'enter-details'.obs;

//   var firstNameController = TextEditingController();
//   var lastNameController = TextEditingController();
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();

//   Widget detailsWidget() {
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.topLeft,
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         const SizedBox(height: 50),
//         const Text('Create Memo Account'),
//         const SizedBox(height: 30),
//         SizedBox(
//           width: 300,
//           child: TextFormField(
//             decoration: const InputDecoration(hintText: 'First Name'),
//             controller: firstNameController,
//           ),
//         ),
//         const SizedBox(height: 20),
//         SizedBox(
//           width: 300,
//           child: TextFormField(
//             decoration: const InputDecoration(hintText: 'Last Name'),
//             controller: lastNameController,
//           ),
//         ),
//         const SizedBox(height: 20),
//         SizedBox(
//           width: 300,
//           child: TextFormField(
//             decoration: const InputDecoration(hintText: 'Email'),
//             controller: emailController,
//           ),
//         ),
//         const SizedBox(height: 20),
//         SizedBox(
//           width: 300,
//           child: TextFormField(
//             decoration: const InputDecoration(hintText: 'Password'),
//             controller: passwordController,
//           ),
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: const Text('Create'),
//               onPressed: () {
//                 if (firstNameController.text.isNotEmpty &&
//                     lastNameController.text.isNotEmpty &&
//                     emailController.text.isNotEmpty &&
//                     passwordController.text.isNotEmpty) {
//                   status.value = 'creating-account';
//                 } else {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         content: const Text(
//                           'Fill in all the details',
//                           textAlign: TextAlign.center,
//                         ),
//                         actions: [
//                           ElevatedButton(
//                             child: const Text('Close'),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//             const SizedBox(width: 20),
//             ElevatedButton(
//               child: const Text('Close'),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget creatingUserAccountWidget() {
//     return FutureBuilder(
//       future: Get.find<dependencies.AuthController>().createAccount(
//         firstNameController.text,
//         lastNameController.text,
//         emailController.text,
//         passwordController.text,
//       ),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState != ConnectionState.done) {
//           return const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Creating Account'),
//                 SizedBox(height: 30),
//                 CircularProgressIndicator(),
//               ],
//             ),
//           );
//         } else {
//           if (snapshot.data == 'Account created successfully') {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Account created successfully'),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     child: const Text('Close'),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(snapshot.data!),
//                   ElevatedButton(
//                     child: const Text('Try again'),
//                     onPressed: () {
//                       status.value = 'enter-details';
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     child: const Text('Close'),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (status.value == 'creating-account') {
//           return creatingUserAccountWidget();
//         } else if (status.value == 'enter-details') {
//           return detailsWidget();
//         } else {
//           return const SizedBox();
//         }
//       }),
//     );
//   }
// }
