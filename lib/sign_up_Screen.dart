// ignore_for_file: deprecated_member_use

// ignore: file_names
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'auth.dart';
import 'httpException.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/SignUpScreen";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  final signUpform = GlobalKey<FormState>();

  final passController = TextEditingController();

  void showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              title: const Text('An error occured'),
              content: Text(errorMessage),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay!'),
                )
              ]);
        });
  }

  Map<String, dynamic> signUpData = {
    'Name': '',
    'Gender': '',
    'EnrollmentNo': null,
    "Branch&Section": '',
    'Semester': '',
    'Password': '',
    'Email': ''
  };

  Future<void> onSubmit() async {
    if (!signUpform.currentState!.validate()) {
      return;
    }
    signUpform.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // Sign user up
      await Provider.of<Auth>(context, listen: false)
          .signUp(signUpData['Email']!, signUpData['Password']!);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/');
    } on HttpException catch (error) {
      var errorMessage = 'Authantication Failed';
      if (error.errorMessage.contains('EMAIL_EXISTS')) {
        errorMessage = 'Email already exist,Try Login';
      } else if (error.errorMessage.contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid Email';
      } else if (error.errorMessage.contains('WEAK_PASSWORD')) {
        errorMessage = 'Password too weak';
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
            image: AssetImage('assets/register bg.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.06, left: 25),
              child: Row(
                children: const [
                  Text('Create\nAccount',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.26,
                  left: MediaQuery.of(context).size.width * 0.08,
                  right: MediaQuery.of(context).size.width * 0.08,
                ),
                child: Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Form(
                      key: signUpform,
                      child: ListView(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                fillColor: Colors.blueGrey[50],
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'Name'),
                            validator: (value) {
                              if (value == null) {
                                return 'Enter the name';
                              }
                              return null;
                            },
                            onSaved: (value) => signUpData['Name'] = value,
                          ),
                          const SizedBox(height: 6),
                          DropDownFormFieldButton(
                              const ['Male', 'Female'], 'Gender', (value) {
                            signUpData['Gender'] = value;
                          }),
                          const SizedBox(height: 6),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                fillColor: Colors.blueGrey[50],
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'Enrollment Number'),
                            validator: (value) {
                              if (value == null) {
                                return 'Enter the Enrollment No';
                              }
                              if (!value.endsWith('11502821')) {
                                return 'Invalid Number';
                              }
                              if (value.length < 11) {
                                return 'Invalid Number';
                              }
                              if (value.length > 11) {
                                return 'Invalid Number';
                              }
                              return null;
                            },
                            onSaved: (value) =>
                                signUpData['EnrollmentNo'] = value,
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                fillColor: Colors.blueGrey[50],
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'Email'),
                            validator: (value) {
                              if (value == null) {
                                return 'Enter the Email';
                              }
                              if (!value.contains('@')) {
                                return 'Invalid Email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              signUpData['Email'] = value;
                            },
                          ),
                          const SizedBox(height: 6),
                          DropDownFormFieldButton(const [
                            'ECE-1',
                            'ECE-2',
                            'ECE-3',
                            'IT-1',
                            'IT-2',
                            'IT-3'
                          ], 'Branch&Section', (value) {
                            signUpData['Branch&Section'] = value;
                          }),
                          const SizedBox(height: 6),
                          DropDownFormFieldButton(const [
                            '1st',
                            '2nd',
                            '3rd',
                            '4th',
                            '5th',
                            '6th',
                            '7th',
                            '8th'
                          ], 'Semester', (value) {
                            signUpData['Semester'] = value;
                          }),
                          const SizedBox(height: 6),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.blueGrey[50],
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'Password'),
                            controller: passController,
                            validator: (value) {
                              if (value == null) {
                                return 'Enter the Password';
                              }
                              if (value.length < 10) {
                                return 'Enter Password More than 10 digit';
                              }
                              return null;
                            },
                            onSaved: (value) => signUpData['Password'] = value,
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.blueGrey[50],
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'Confirm Password'),
                            validator: (value) {
                              if (value == null) {
                                return 'Enter the Password';
                              }
                              if (value != passController.text) {
                                return 'Password don\'t match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.w600)),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xff4c505b),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : IconButton(
                                    onPressed: () {
                                      onSubmit();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    )),
                          )
                        ],
                      )),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DropDownFormFieldButton extends StatefulWidget {
  final String hintText;
  final List givenItems;
  final Function saved;

  const DropDownFormFieldButton(this.givenItems, this.hintText, this.saved,
      {Key? key})
      : super(key: key);

  @override
  State<DropDownFormFieldButton> createState() =>
      _DropDownFormFieldButtonState();
}

class _DropDownFormFieldButtonState extends State<DropDownFormFieldButton> {
  String? valuechoose;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16)),
      child: DropdownButtonFormField(
        onSaved: (value) => widget.saved(value),
        hint: Text(widget.hintText),
        isExpanded: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        value: valuechoose,
        icon: const Icon(Icons.arrow_drop_down),
        onChanged: (newValue) {
          setState(() {
            valuechoose = newValue.toString();
          });
        },
        items: widget.givenItems
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return 'select the ${widget.hintText}';
          }
          return null;
        },
      ),
    );
  }
}
