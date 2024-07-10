import 'package:flutter/material.dart';

class EmailForm extends StatelessWidget {
  const EmailForm(
      {super.key,
      required this.controller,
      required this.label,
      required this.formKey});

  final String label;
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

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

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              labelText: label,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
            validator: (value) => _validateEmail(value!),
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}
