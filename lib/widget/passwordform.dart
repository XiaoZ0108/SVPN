import 'package:flutter/material.dart';

class PasswordForm extends StatelessWidget {
  const PasswordForm(
      {super.key,
      required this.controller,
      required this.label,
      required this.formKey,
      this.validate,
      this.hide = false});
  final String? Function(String)? validate;
  final bool hide;
  final String label;
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

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
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
              obscureText: hide,
              controller: controller,
              decoration: InputDecoration(
                fillColor: Colors.grey,
                labelText: label,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
              validator: (value) {
                if (validate == null) {
                  return _validatePassword(value!);
                } else {
                  return validate!(value!);
                }
              }),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}
