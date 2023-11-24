import 'package:flutter/material.dart';

const String currencysymbol = '৳';
bool showUpdateOrder= false;
bool showbill = false;

const primaryColor = Color.fromRGBO(17, 159, 250, 1);
const secondaryColor = Colors.white;
const bgColor = Color.fromRGBO(247, 251, 254, 1);
const textColor = Colors.black;
const lightTextColor = Colors.black26;
const transparent = Colors.transparent;

const grey = Color.fromRGBO(148, 170, 220, 1);
const purple = Color.fromRGBO(165, 80, 179, 1);
const orange = Color.fromRGBO(251, 137, 13, 1);
const green = Color.fromRGBO(51, 173, 127, 1);
const skyBlue = Color.fromRGBO(227, 242, 253, 1);
const dark = Color(0xFF212332);
const red = Colors.red;

// Default App Padding
const appPadding = 16.0;

abstract class PaymentMethod{
  static const String online = 'Online Payment';
  static const String cash = 'Pay to Cash';
}

