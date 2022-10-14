import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'auth.dart';
import 'loginScreen.dart';
import 'sign_up_Screen.dart';
import 'dummy_Screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home:  Provider.of<Auth>(context).isAuth
              ? const Screen()
              : const LoginScreen(),
          routes: {SignUpScreen.routeName: (context) => SignUpScreen()},
        );
      },
    );
  }
}
