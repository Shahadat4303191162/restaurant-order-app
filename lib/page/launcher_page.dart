

import 'package:flutter/material.dart';
import 'package:order_app_for_resturent/page/product_page.dart';

import '../auth/auth_services.dart';
import '../src/features/login/presentation/page/login_page.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/launcher';
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      if(AuthService.user != null){
        Navigator.pushReplacementNamed(context, ProductPage.routeName);
      }else{
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
