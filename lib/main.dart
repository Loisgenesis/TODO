import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task/dashboard.dart';
import 'package:task/constants.dart';
import 'package:task/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_colors.dart';


void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  String apiKey = sharedPref.getString(Constants.email);
  bool hasUserLogged = apiKey != null && apiKey.isNotEmpty ? true : false;
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: new ThemeData(
          primaryColor: MyColors.colorPrimary,
          accentColor: MyColors.accentColor,),
      home:DashBoard()));
}
