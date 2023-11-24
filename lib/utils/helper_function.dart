import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger
        .of(context)
        .showSnackBar(SnackBar(content: Text(msg)));

String getFormattedTime (DateTime dateTime,String format) =>
    DateFormat(format).format(dateTime);

Future<bool> isConnectedToInternet() async{
  final result = await Connectivity().checkConnectivity();
  return result == ConnectivityResult.wifi ||
  result == ConnectivityResult.mobile;
}

extension MyExtension on String{
  String capitalize(){
    return '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
  }
}
