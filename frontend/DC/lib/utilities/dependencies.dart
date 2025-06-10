import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';
import 'package:DC/dialogs/user_model.dart';

class AuthController extends GetxController {
  // final createAccountUrl = Uri.parse('$baseUrl/api/users/create-account');
  // final signInUrl = Uri.parse('$baseUrl/api/users/sign-in');
  final createAccountUrl = Uri.parse('$baseUrl/api/users/create-account');
  final logInUrl = Uri.parse('$baseUrl/api/users/sign-in');

  RxBool isSignedIn =
      false.obs; // .obs makes it observable and updates the UI when changed
  RxString token = ''.obs;
  RxString signedInEmail = ''.obs;

  Future<String> createUser(AppUser user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/create-account'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Account created successfully';
      } else {
        return 'Signup failed: ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> createAccount(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      var createAccountData = await http.post(
        createAccountUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        }),
      );
      if (createAccountData.statusCode == 200) {
        return 'Account created successfully';
      } else {
        return createAccountData.body.toString();
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> signIn(String email, String password) async {
    try {
      var signInData = await http.post(
        logInUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }), // payload converted fromd Dart map to JSON
      );
      if (signInData.statusCode == 200) {
        final jsonSignInData = jsonDecode(signInData.body);
        isSignedIn.value = true;
        token.value = jsonSignInData['token'];
        signedInEmail.value = jsonSignInData['email'];
        return 'Sign in successful';
      } else {
        return signInData.body.toString();
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  void signOut() {
    Get.offAllNamed('/home_page');
    token.value = '';
    isSignedIn.value = false;
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}
