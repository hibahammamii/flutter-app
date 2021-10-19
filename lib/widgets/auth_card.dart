import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/screens/auth_screen.dart';
import 'package:flutter_app/screens/facebook_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passwordController.dispose();
    //textController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );

      } else if (_authMode == AuthMode.resetpassword) {
        await Provider.of<Auth>(context, listen: false).reset(
          _authData['email'],
        );
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Password has been reset'),
            content: Text('Check your E-mail for change Password'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
        setState(() {
          _authMode = AuthMode.Login;
        });
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );

      }

    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
      _passwordController.clear();
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else if (_authMode == AuthMode.resetpassword) {
      setState(() {
        _authMode = AuthMode.resetpassword;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            style: TextStyle(fontSize: 17.sp),
            decoration: InputDecoration(
              labelText: 'E-Mail',
              fillColor: kPrimaryColor,
              prefixIcon: Padding(
                padding: EdgeInsets.all(0.0),
                child: Icon(
                  Icons.email_outlined,
                  color: kPrimaryColor,
                ),
              ), // icon is 48px widget.
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,

                  ///  color: Colors.red,//this has no effect
                ),
                borderRadius: BorderRadius.circular(10.0.r),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Invalid email!';
              }
            },
            onSaved: (value) {
              _authData['email'] = value;
            },
          ),
          SizedBox(
            height: 20,
          ),
          if (_authMode == AuthMode.Login || _authMode == AuthMode.Signup)
            TextFormField(
              style: TextStyle(fontSize: 17.sp),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Icon(
                    Icons.vpn_key_outlined,
                    color: kPrimaryColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    // color: Colors.red,//this has no effect
                  ),
                  borderRadius: BorderRadius.circular(10.0.r),
                ),
              ),
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value.isEmpty || value.length < 5) {
                  return 'Password is too short!';
                }
              },
              onSaved: (value) {
                _authData['password'] = value;
              },
            ),
          if (_authMode == AuthMode.Signup)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextFormField(
                enabled: _authMode == AuthMode.Signup,
                style: TextStyle(fontSize: 17.sp),
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        //color: Colors.red,//this has no effect
                      ),
                      borderRadius: BorderRadius.circular(10.0.r),
                    )),
                obscureText: true,
                validator: _authMode == AuthMode.Signup
                    ? (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match!';
                  }
                }
                    : null,
              ),
            ),
          SizedBox(
            height: 3,
          ),
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.grey, textStyle: TextStyle(fontSize: 14.sp)),
            child: Text(_authMode != AuthMode.resetpassword
                ? 'Forget Password?'
                : 'Back'),
            onPressed: () => {
              if (_authMode == AuthMode.resetpassword)
                {_authMode = AuthMode.Login, _switchAuthMode()}
              else
                {_authMode = AuthMode.resetpassword, _switchAuthMode()}
            },
          ),
          SizedBox(
            height: 50.h,
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            Container(
              width: 260.w,
              height: 45.h,
              child: TextButton(
                child: Text(_authMode == AuthMode.Login
                    ? 'LOGIN'
                    : _authMode == AuthMode.Signup
                    ? 'SIGN UP'
                    : 'ResetPassword'),
                onPressed: _submit,
                style: TextButton.styleFrom(


                    padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                    primary: Colors.black,
                    textStyle: TextStyle(fontSize: 14.sp),
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      // side: BorderSide(color: Colors.red)
                    )),
                // style: ButtonStyle(
                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //         RoundedRectangleBorder(
                //             borderRadius: BorderRadius.zero,
                //             side: BorderSide(color: Colors.red)
                //         )
                //     )
                // )
              ),
            ),
          if (_authMode == AuthMode.Login || _authMode == AuthMode.Signup)
            FlatButton(
              child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      if (_authMode == AuthMode.Login)
                        TextSpan(
                            text: ' No registered yet ? please, ',
                            style: TextStyle(color: Colors.grey,fontSize: 13.sp)),
                      TextSpan(
                          text: _authMode == AuthMode.Login ? 'SINGUP' : 'Back',
                          style: TextStyle(
                              color: Colors.black87, fontWeight: FontWeight.bold,fontSize: 14.sp)),
                    ],
                  )
                //   '${_authMode == AuthMode.Login ? ' No registered yet ? please,Sign Up' : 'LOGIN'} '),
              ),
              onPressed: _switchAuthMode,
              padding: EdgeInsets.symmetric(horizontal: 30.0.h, vertical: 4.w),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textColor:
              _authMode == AuthMode.Login ? Colors.grey : Colors.black87,
            ),
          SizedBox(
            height: 50.h,
          ),
          Row(children: <Widget>[
            Expanded(
                child: Divider(
                  color: Colors.black38,
                )),
            Text("OR"),
            Expanded(
                child: Divider(
                  color: Colors.black38,
                )),
          ]),
          SizedBox(
            height: 50.h,
          ),
          FacebookLogIn(),
        ],
      ),
    );
  }
}
