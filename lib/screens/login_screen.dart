import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:my_app/widget/lottie_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/widget/emailform.dart';
import 'package:my_app/widget/passwordform.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LottieController(ratio: 0.24, name: 'hi'),
                EmailForm(
                  controller: _emailController,
                  label: "Email",
                  formKey: emailFormKey,
                ),
                PasswordForm(
                  controller: _passwordController,
                  validate: _validatePassword,
                  label: "Password",
                  formKey: passwordFormKey,
                  hide: true,
                ),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                    backgroundColor: Colors.green, //
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          if (emailFormKey.currentState!.validate() &&
                              passwordFormKey.currentState!.validate()) {
                            _login();
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not yet register with us? '),
                    GestureDetector(
                      onTap: _register,
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    final email = _emailController.text.toLowerCase();
    final password = _passwordController.text;

    Map<String, dynamic> result = await validation(email, password);
    if (result["status"] == "success") {
      String token = result["token"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamedAndRemoveUntil(
          context, '/homeScreen', (Route<dynamic> route) => false);
    } else {
      setState(() {
        isLoading = false;
        errorMessage = result["message"];
      });
    }
  }

  void _register() {
    Navigator.pushNamed(context, '/registerScreen');
  }

  Future<Map<String, dynamic>> validation(String email, String password) async {
    try {
      var response = await http
          .post(
            Uri.parse('http://192.168.0.5:3000/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          "status": "success",
          "message": data['message'],
          "token": data['token']
        };
      } else if (response.statusCode == 401) {
        return {"status": "error", "message": data['message']};
      } else {
        return {"status": "error", "message": data['message']};
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Something Error, Please Try Again Later"
      };
    }
  }
}
