import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:my_app/widget/lottie_controller.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:convert';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
  });
  @override
  State<OtpScreen> createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  String _pinCode = "";
  String errorMessage = "";
  bool isLoading = false;
  bool freeze = false;
  Color resendC = Colors.green;
  Timer? _timer;
  static const int _start = 120;
  int _current = _start;
  String email = '';
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  void startTimer() {
    _timer?.cancel();
    _current = _start;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_current > 0) {
        setState(() {
          _current--;
        });
      } else {
        timer.cancel();
        setState(() {
          freeze = false;
          resendC = Colors.green;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic>? arguments =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // final String email = arguments?['email'] ?? '';

    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Verifying',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LottieController(
                ratio: 0.22,
                name: 'email',
                type: true,
              ),
              const Text("An Email Has Been Sent To "),
              Text(
                email,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color.fromARGB(255, 224, 79, 224)),
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  validator: (v) {
                    if (v!.length < 6) {
                      return "Please Enter 6 Digit Number";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(14),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    selectedColor: Colors.red,
                    inactiveColor: Colors.blue,
                  ),
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {
                    _pinCode = value; // Capture the completed PIN code
                  },
                ),
              ),
              const SizedBox(height: 8.0),
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
                        if (formKey.currentState!.validate()) {
                          verify(email, _pinCode, context);
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Verify',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Did not received email? '),
                  GestureDetector(
                    onTap: freeze
                        ? null
                        : () {
                            resend(email);
                          },
                    child: Text(
                      'Resend',
                      style: TextStyle(
                          color: resendC, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (freeze)
                Text(
                  'Resend OTP in ${_current ~/ 60}:${(_current % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> validate(String email, String otp) async {
    try {
      var response = await http
          .post(
            Uri.parse('http://192.168.0.5:3000/validate'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': email,
              'otp': otp,
            }),
          )
          .timeout(const Duration(seconds: 30));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          "status": "success",
          "message": data['message'],
        };
      } else if (response.statusCode == 400) {
        return {"status": "error", "message": data['message']};
      } else {
        return {
          "status": "error",
          "message": "Something Error, Please Try Again Later"
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Something Error, Please Try Again Later"
      };
    }
  }

  void verify(String email, String otp, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> result = await validate(email, otp);
    if (result["status"] == "success") {
      setState(() {
        isLoading = false;
      });
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, '/homeScreen', (Route<dynamic> route) => false,
          arguments: {'scIndex': "2"});
    } else {
      setState(() {
        isLoading = false;
        errorMessage = result["message"];
      });
    }
  }

  void resend(String email) {
    setState(() {
      freeze = true;
      resendC = Colors.grey;
    });
    startTimer();
  }
}
