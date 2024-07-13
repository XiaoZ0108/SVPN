import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:my_app/widget/lottie_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/widget/emailform.dart';

class ForgetScreen1 extends StatefulWidget {
  const ForgetScreen1({
    super.key,
  });
  @override
  ForgetScreenState createState() => ForgetScreenState();
}

class ForgetScreenState extends State<ForgetScreen1> {
  final emailFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Recover Password',
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
                const LottieController(ratio: 0.26, name: 'forget'),
                EmailForm(
                    controller: _emailController,
                    label: "Your Registered Email",
                    formKey: emailFormKey),
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
                          if (emailFormKey.currentState!.validate()) {
                            await validateMail(
                                _emailController.text.toLowerCase(), context);
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Proceed',
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

  Future<void> validateMail(String email, BuildContext context) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    try {
      var response = await http
          .get(Uri.parse('http://192.168.0.5:3000/validateM?email=$email'))
          .timeout(const Duration(seconds: 15));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        if (!context.mounted) return;
        Navigator.pushNamed(
          context,
          '/otpScreen',
          arguments: {"email": email, "reset": true},
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
        errorMessage = "Error occurs during validation";
      });
    }
  }
}
