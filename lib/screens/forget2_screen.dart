import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:my_app/widget/lottie_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/widget/passwordform.dart';

class ForgetScreen2 extends StatefulWidget {
  const ForgetScreen2({
    super.key,
  });
  @override
  ForgetScreen2State createState() => ForgetScreen2State();
}

class ForgetScreen2State extends State<ForgetScreen2> {
  final passwordFormKey1 = GlobalKey<FormState>();
  final passwordFormKey2 = GlobalKey<FormState>();

  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  bool isLoading = false;
  String errorMessage = "";
  String email = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('email')) {
      setState(() {
        email = args['email'] ?? '';
      });
    }
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
    if (_passwordController1.text != _passwordController2.text) {
      return "Password not match";
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
            'Reset Password',
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
                const LottieController(ratio: 0.22, name: 'password'),
                PasswordForm(
                    controller: _passwordController1,
                    label: "New Password",
                    formKey: passwordFormKey1),
                PasswordForm(
                  controller: _passwordController2,
                  label: "Confirm New Password",
                  formKey: passwordFormKey2,
                  validate: _validatePassword,
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
                      : () async {
                          if (passwordFormKey1.currentState!.validate() &&
                              passwordFormKey2.currentState!.validate()) {
                            await resetPassword(
                                email, _passwordController2.text, context);
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Reset',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword(
      String email, String password, BuildContext context) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    try {
      var response = await http
          .post(
            Uri.parse('http://192.168.0.5:3000/resetPass'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/loginScreen',
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          isLoading = false;
          errorMessage = data['message'];
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error occurs during reset";
      });
    }
  }
}
