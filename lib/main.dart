import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:order_app_for_resturent/page/cash_order_successful_page.dart';
import 'package:order_app_for_resturent/page/checkout_page.dart';
import 'package:order_app_for_resturent/page/online_order_successful_page.dart';
import 'package:order_app_for_resturent/provider/cart_provider.dart';
import 'package:order_app_for_resturent/utils/dialog_show_flag.dart';
import 'package:provider/provider.dart';
import 'page/coustomizable_product.dart';
import 'page/launcher_page.dart';
import 'page/order_list_page.dart';
import 'page/product_details_page.dart';
import 'page/product_page.dart';
import 'provider/order_provider.dart';
import 'provider/product_provider.dart';
import 'src/features/login/presentation/page/login_page.dart';
import 'utils/controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyCUpH2LtCHSDyr03oZoBkafEScllcfd_Xw',
        appId: '1:468236031580:android:2279d7619cf91b05adf899',
        messagingSenderId: '468236031580',
        projectId: 'restsurant-management')
  ) :
      await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProductProvider()),
      ChangeNotifierProvider(create: (context) => OrderProvider()),
      ChangeNotifierProvider(create: (context) => CartProvider()),
      ChangeNotifierProvider(create: (create) => Controller()),
      ChangeNotifierProvider(create: (create) => DialogShownFlag()),
    ],
    child: const MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (_) => LauncherPage(),
        LoginPage.routeName: (_) => LoginPage(),
        ProductPage.routeName: (_) => ProductPage(),
        CheckoutPage.routeName: (_) => CheckoutPage(),
        ProductDetailsPage.routeName: (_) => const ProductDetailsPage(),
        OrderPage.routeName: (_) => OrderPage(),
        CustomizeProduct.routeName: (_) => CustomizeProduct(),
        OnlineOrderSuccessfulPage.routeName: (_) => OnlineOrderSuccessfulPage(),
        CashOrderSuccessfulPage.routeName: (_) => CashOrderSuccessfulPage(),
      },
    );
  }
}

