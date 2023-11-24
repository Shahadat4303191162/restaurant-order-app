

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../auth/auth_services.dart';
import '../../../../../page/launcher_page.dart';
import '../widgets/password_input_field.dart';
import '../widgets/user_id_input_field.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //layout builder
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: SizedBox(
            width: size.width < 600 ? size.width * 1 : 400,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.35),
              children: [
                UserIdInputField(emailController: emailController),
                const SizedBox(
                  height: 10,
                ),
                PasswordInputField(
                  onSuffix: _suffixHandler,
                  isObscureText: isObscureText,
                  passController: passController,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    authenticate();
                  },
                  child: const Text('LOGIN'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Forget Password',
                      style: TextStyle(fontSize: 12),
                    ),
                    TextButton(
                        onPressed: () {}, child: const Text('Click here....'))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  errMsg,
                  style: TextStyle(color: Theme.of(context).errorColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void authenticate() async {
    if (formKey.currentState!.validate()) {
      // try{
      //   AuthService.login(emailController.text, passController.text).then((login) =>
      //       Navigator.pushReplacementNamed(context, LauncherPage.routeName));
      //
      //     //Navigator.pushReplacementNamed(context, LauncherPage.routeName);
      //
      // }
      try {
        final status =
            await AuthService.login(emailController.text, passController.text);
        if (status) {
          print('mounted e jai kaj atke geche');
          if (!mounted) return;
          print('all ok');
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
          print('Launcher page e pathanu holo');
        } else {
          await AuthService.logOut();
          setState(() {
            errMsg = 'This Email does not belong to an admin account';
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }

  void _suffixHandler() {
    setState(() {
      isObscureText = !isObscureText;
    });
  }
}

//TextFormField(
//                   obscureText: isObscureText,
//                   controller: passController,
//                   decoration: InputDecoration(
//                     hintText: 'Password', //68didar524
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           width: 1, color: Theme.of(context).primaryColor),
//                       borderRadius: BorderRadius.circular(50.0),
//                     ),
//                     prefixIcon: Icon(
//                       Icons.lock,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(isObscureText
//                           ? Icons.visibility_off
//                           : Icons.visibility),
//                       onPressed: _suffixHandler,
//                     ),
//                     filled: true,
//                     fillColor: Colors.transparent,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'please enter a valid password';
//                     }
//                     return null;
//                   },
//                 ),
