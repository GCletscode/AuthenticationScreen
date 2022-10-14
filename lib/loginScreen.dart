
// ignore_for_file: deprecated_member_use

// ignore: file_names
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'sign_up_Screen.dart';
import'auth.dart';
import'httpException.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  Map<String, dynamic> signInData = {"Email": null, 'Password': ''};
  final formkey = GlobalKey<FormState>();
 
  void showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              title: const Text('An error occured'),
              content: Text(errorMessage),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay!'),
                )
              ]);
        });
  }
 
 
  void onSubmit() async {
    if (!formkey.currentState!.validate()) {
      return;
    }
    formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .logIn(signInData['Email']!, signInData['Password']!);
      
    } on HttpException catch (error) {
      var errorMessage = 'Authantication Failed';
        if (error.errorMessage.contains('INVALID_PASSWORD')) {
        errorMessage = 'Inavlid Password';
      } else if (error.errorMessage.contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid Email';
      } else if (error.errorMessage.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email not found.Try Signup';
      } 
      showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Authantication failed.Try later';
      showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/loginPage.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25, left: 30),
              child: Row(
                children: const [
                  Text('Welcome',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w600)),
                  SizedBox(width: 6),
                  Icon(
                    Icons.waving_hand_outlined,
                    color: Colors.white,
                    size: 34,
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(children: [
                  Form(
                    key: formkey,
                    child: Column(children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: 'Email'),
                        validator: (value) {
                          if (value == null) {
                            return 'Enter the email';
                          }
                          if (!value.contains('@')) {
                            return 'invalid Email';
                          }
                          return null;
                        },
                        onSaved: (value) => signInData['Email'] = value,
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: 'Password'),
                        validator: (value) {
                          if (value == null) {
                            return 'Enter the Password';
                          }
                          if (value.length < 10) {
                            return 'Password too short';
                          }
                          return null;
                        },
                        onSaved: (value) => signInData['Password'] = value,
                      )
                    ]),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sign In',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w600)),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff4c505b),
                        child:_isLoading?const CircularProgressIndicator(): IconButton(
                            onPressed: () {
                              onSubmit();
                            },
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignUpScreen.routeName);
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(184, 71, 71, 71),
                          decoration: TextDecoration.underline),
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
