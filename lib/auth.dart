import 'dart:convert';
import 'dart:async';
 
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'httpException.dart';


class Auth with ChangeNotifier {
  String? token;
  DateTime? exptime;
  String? userId;

  bool get isAuth {
    return tok != null;
  }

  String? get tok {
    if (exptime != null && exptime!.isAfter(DateTime.now()) && token != null) {
      return token!;
    }
    return null;
  }

  String get userid {
    return userId!;
  }

  Future<void> authanticate(
      String email, String password, String urlSegment) async {
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCwJCRSMQtN26P9OFt61j4fHdtB-bmRQHg');
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      token = responseData['idToken'];
      exptime = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      userId = responseData['localId'];
      autoLogout();
      notifyListeners();
    } catch (error) {
      
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authanticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return authanticate(email, password, 'signInWithPassword');
  }

 

  void logout() {
    exptime = null;
    notifyListeners();
  }

  void autoLogout() {
    if (exptime != null) {
      final time = exptime!.difference(DateTime.now()).inSeconds;
      Timer(Duration(seconds: time), logout);
    }
  }
}
