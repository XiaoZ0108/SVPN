import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
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
            'Login',
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
                'assets/animation/hi.json',
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
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: passwordFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) => _validatePassword(value!),
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                  backgroundColor: Colors.green, //
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (passwordFormKey.currentState!.validate() &&
                      emailFormKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Perform login action (e.g., API call) here

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logging in with email: $email')),
    );
  }
}
