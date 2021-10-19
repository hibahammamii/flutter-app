import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/screens/facebook_screen.dart';
import 'package:flutter_app/widgets/auth_card.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_excption.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AuthMode { Signup, Login, resetpassword }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    print(screenHeight);
    print(screenWidth);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            //height: screenHeight,
            child: Column(
              children: [
                Container(
                    height: 200.h,
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Image(image: AssetImage('assets/images/Logo.png')),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 0.9.sw,
                    child: AuthCard(),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

