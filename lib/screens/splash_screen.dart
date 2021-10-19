import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/orders_screen.dart';

import 'admin_Screen.dart';

class SplashScreen extends StatefulWidget  {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> setupInteractedMessage() async {

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    NotificationSettings setting = await messaging.requestPermission(
      provisional: true,
    );

   }
  Future<void> _handleMessage(RemoteMessage message) {
    if(message  != null)
    if (message.data['type'] == 'admin') {
    Navigator.of(context).pushNamed(AdminScreen.routeName);}
    else if(message.data['type'] == 'user') {
      Navigator.of(context).pushNamed(OrdersScreen.routeName);}
  }
  @override
  void initState() {
   // FirebaseMessaging.onBackgroundMessage(_handleMessage);

    setupInteractedMessage();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  Image(image: AssetImage('assets/images/Logo.png'))),

    );
  }
}
