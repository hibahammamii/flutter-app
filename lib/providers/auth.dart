import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart';

import '../models/http_excption.dart ';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  var _email;
  bool _isAdmin =false;

  bool get isAuth {
    // checkAdmin();

    return token != null;
  }
  bool get isAdmin 
  {
    //if(_isAdmin != null)
    return _isAdmin != null ? _isAdmin : false;
  }
  void tokenSet(String newValue)
  {
    _token=newValue;
    notifyListeners();
  }
  void userIdSet(String newValue)
  {
    _userId=newValue;
    notifyListeners();
  }
  void expiryDateSet(DateTime newValue)
  {
    _expiryDate=newValue;
    notifyListeners();
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }
  DateTime get expiryDate
  {
    return _expiryDate;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {

    final url =
        Uri.parse( 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyCpHRnc8lW5d9WVuZKI9GAoAFFbow-owI0');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      await FirebaseFirestore.instance.collection("users").where(
          FieldPath.documentId,
          isEqualTo: userId
      ).get().then((event) async {
        if (event.docs.isNotEmpty)  {
          _isAdmin = true;
          setAdminTokens();
        }});

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
          'admin' : _isAdmin,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }
  Future<void> _reset(
      String email) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return _firebaseAuth.sendPasswordResetEmail(email: email);

  }

  Future<void> reset(String email) async {
    return _reset(email);
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<void> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();


    if (!pref.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(pref.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _isAdmin =extractedUserData['admin'];
    notifyListeners();
    _autoLogout();
    return true;


  }
  Future<void> setAdminTokens() async
  {
    final FirebaseMessaging firebaseMessaging =FirebaseMessaging.instance;
    final adminToken = await firebaseMessaging.getToken();
    if(_isAdmin)
      await FirebaseFirestore.instance.collection("adminTokens")
        .doc(userId).set({"token" : adminToken});
  }

  Future<void>  logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _isAdmin =null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
  // Future<void> checkAdmin() async
  // {
  //
  //
  //   await FirebaseFirestore.instance.collection("users").where(
  //       FieldPath.documentId,
  //       isEqualTo: userId
  //   ).get().then((event) {
  //     if (event.docs.isNotEmpty) {
  //       _isAdmin = true;
  //       notifyListeners();
  //
  //     }
  //   });

  //}
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }


}
