
// ignore: file_names
import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  static const routeName = '/DummyScreen';
  const Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Dummy Page')),
    );
  }
}
