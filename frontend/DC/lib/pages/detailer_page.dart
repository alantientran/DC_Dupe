import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dc_clone/resuseable widgets/blue_long.dart';
import 'package:DC/utilities/dependencies.dart';
import 'package:get/get.dart'; //needed for get authcontroller

//this page has the defined class Login which required role from swipe.
//and it has the _loginState class that holds the login and build methods. i have logic for login first.

class DetailerPage extends StatefulWidget {
  final String role;
  const DetailerPage(
      {super.key, required this.role}); // ✅ constructer needed role parameter

  @override
  _DetailerPage createState() => _DetailerPage();
}

class _DetailerPage extends State<DetailerPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        //this is a prebuilt
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login & Signup'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Signup'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LoginCard(),
              SignupCard(role: widget.role), // put this in parameter
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

//this one works!!
  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar('Please enter both email and password');
      return;
    }

    try {
      final response = await http.post(
        AuthController().logInUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token'];
        String role = responseData['role'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);

        if (role == 'detail_customer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CHomeScreen()),
          );
        } else if (role == 'detailer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DHomeScreen()),
          );
        }
      } else {
        _showSnackBar('Invalid credentials');
      }
    } catch (e) {
      _showSnackBar('Something went wrong. Please try again.');
      print('Login error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //log in build
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: loginUser,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//sign up stufffffff

class SignupCard extends StatelessWidget {
  final String role;
  const SignupCard(
      {super.key,
      required this.role}); //without this, line above has compile error

  @override
  Widget build(BuildContext context) {
    if (role == 'detail_customer') {
      //SignupCard(role: 'client'); // does nothing lmao
      return CSignupCard();
    }
    if (role == 'detailer') {
      return DSignupCard();
    }
    return const SizedBox();
  }
}

class CSignupCard extends StatefulWidget {
  @override
  _CSignupCardState createState() => _CSignupCardState();
}

class _CSignupCardState extends State<CSignupCard> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();

  Future<void> signupUser() async {
    print("SIGN UP BUTTON PRESSED");

    // final AuthController authController = Get.find<AuthController>();

    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String email = emailController.text.trim();
    String location = locationController.text.trim();
    String referralCode = referralController.text.trim();
    String password = passwordController.text;
    String cpassword = cpasswordController.text;

    if (password != cpassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    Map<String, dynamic> body = {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'location': location,
      'password': password,
    };

    if (referralCode.isNotEmpty) {
      body['referralCode'] = referralCode;
    }

    try {
      final response = await http.post(
        AuthController().createAccountUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Signup successful!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CHomeScreen()),
        );
      } else {
        print('Signup failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                          controller: phoneNumberController,
                          decoration:
                              InputDecoration(labelText: 'Contact Number')),
                      SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: locationController,
                        decoration: InputDecoration(labelText: 'location'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: referralController,
                        decoration: InputDecoration(
                            labelText: 'Referral Code (Optional)'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration:
                            InputDecoration(labelText: 'Create Password'),
                        obscureText: true,
                      ),
                      TextField(
                        controller: cpasswordController,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      // BluePillButton(
                      //   //this is a custom widget i made, and i do text: "Next" rather than Text('Next') bc of custom parameters already built
                      //   text: "Sign Up",
                      //   onPressed: () {
                      //     print("SIGN UP BUTTON PRESSED");
                      //     signupUser();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
//TODO these are testing pages, will delete and redirect stuff above later :)

//TODO this is temporarily here
class DSignupCard extends StatelessWidget {
  const DSignupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detailer SIGN UP')),
      body: Center(child: Text('Detailer Sign Up!')),
    );
  }
}

class CHomeScreen extends StatelessWidget {
  const CHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client Home')),
      body: Center(child: Text('Welcome to Client Home!')),
    );
  }
}

class DHomeScreen extends StatelessWidget {
  const DHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detailer Home')),
      body: Center(child: Text('Welcome to Detailer Home!')),
    );
  }
}
