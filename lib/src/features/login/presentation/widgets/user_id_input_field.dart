import 'package:flutter/material.dart';

class UserIdInputField extends StatelessWidget {
  const UserIdInputField({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Email Address',
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(width: 1, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(50.0),
        ),
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).primaryColor,
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please enter a valid email address';
        }
        return null;
      },
    );
  }
}