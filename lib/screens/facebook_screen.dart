import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/providers/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FacebookLogIn extends StatefulWidget {
  @override
  _FacebookLoginState createState() => new _FacebookLoginState();


}

class _FacebookLoginState extends State<FacebookLogIn> {


 // final fb = FacebookLogIn();



  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final auth = Provider.of<Auth>(context, listen: false);
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    //final resultt = await facebookLogin.logInWithReadPermissions(['email']);
    // final FacebookLogIn result =
    // await .logInWithReadPermissions(['email', 'public_profile']);
    // final facebookLogin = FacebookLogIn();
    // final result = await facebookLogin.logIn(['email']);
    try {

      final result = await FacebookAuth.instance.login(permissions: ['email']);

      //final result = await FacebookAuth.instance.accessToken;


      final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider
          .credential(result.accessToken.token);


      // final UserCredential authResult = await firebaseAuth.signInWithCredential(facebookAuthCredential);
      // final User user = authResult.user;


      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      auth.userIdSet(firebaseAuth.currentUser.uid);
      print("user id" + firebaseAuth.currentUser.uid);
      auth.tokenSet(await firebaseAuth.currentUser.getIdToken());
      auth.expiryDateSet(result.accessToken.expires);
      print(firebaseAuth.currentUser.refreshToken);
      print("token");
      print(firebaseAuth.currentUser.uid);
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': auth.token,
          'userId': auth.userId,
          'expiryDate': auth.expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    }
    on FirebaseAuthException catch  (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }


  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;


    return Container(

      height: 44.h,
      child:_isLoading ? CircularProgressIndicator(): new   SignInButton(
        Buttons.Facebook,

       //mini: true,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(30.r),
        ),
        elevation: 8.0,

        onPressed:() async{
          setState(() {
            _isLoading =true;
          });
         await signInWithFacebook();
         setState(() {
           _isLoading =false;
         });
        }


      ),
    );
  }
}