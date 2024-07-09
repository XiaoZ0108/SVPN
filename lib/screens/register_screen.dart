import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey1 = GlobalKey<FormState>();
  final passwordFormKey2 = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  late final AnimationController _controller;
  bool isLoading = false;
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController1.dispose();
    _passwordController2.dispose();
    _controller.dispose();
    super.dispose();
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter your email';
      //return null;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword1(String password) {
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

  String? _validatePassword2(String password) {
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
    double screenHeight = MediaQuery.of(context).size.height;
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Register',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animation/regis.json',
                height: screenHeight * 0.22,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: emailFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        fillColor: Colors.grey,
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      validator: (value) => _validateEmail(value!),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: passwordFormKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _passwordController1,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) => _validatePassword1(value!),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: passwordFormKey2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _passwordController2,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) => _validatePassword2(value!),
                    ),
                  ],
                ),
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
                            passwordFormKey1.currentState!.validate() &&
                            passwordFormKey2.currentState!.validate()) {
                          _register();
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Register',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have your own account? '),
                  GestureDetector(
                    onTap: _login,
                    child: const Text(
                      'Login Now',
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
    );
  }

  void _register() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    final email = _emailController.text.toLowerCase();
    final password = _passwordController2.text;

    Map<String, dynamic> result = await validation(email, password);
    if (result["status"] == "success") {
      isLoading = false;
      Provider.of<VpnService>(context, listen: false)
          .navigateTo('/homeScreen', arguments: {"email": email});
    } else {
      setState(() {
        isLoading = false;
        errorMessage = result["message"];
      });
    }
  }

  void _login() {
    Provider.of<VpnService>(context, listen: false).navigateTo('/homeScreen');
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
          .timeout(const Duration(minutes: 1));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {
          "status": "success",
          "message": data['message'],
        };
      } else {
        return {"status": "error", "message": "Error during registration"};
      }
    } catch (e) {
      return {"status": "error", "message": "Error during registration"};
    }
  }
}