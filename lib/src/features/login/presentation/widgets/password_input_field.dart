import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({
    super.key,
    required this.onSuffix,
    required this.isObscureText,
    required this.passController,
  });

  final void Function() onSuffix;
  final bool isObscureText;
  final TextEditingController passController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscureText,
      controller: passController,
      decoration: InputDecoration(
        hintText: 'Password', //68didar524
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(50.0),
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: Theme.of(context).primaryColor,
        ),
        suffixIcon: IconButton(
          icon: Icon(isObscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: onSuffix,
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please enter a valid password';
        }
        return null;
      },
    );
  }
}
