import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/providers/appetizer.dart';
import 'package:flutter_app/providers/auth.dart';

import 'package:flutter_app/screens/admin_Screen.dart';
import 'package:flutter_app/widgets/AnimatedBottomNavigationBar.dart';

import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../providers/products.dart';
import '../widgets/category_list.dart';
import '../providers/category.dart';
import '../widgets/slider.dart';
import 'package:flutter_app/constants.dart';
import '../widgets/discount_card.dart';
import 'cart_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/confirmation_dialog.dart';
import 'orders_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  //static const routeName = '/productoverview-detail';
  static const routeName = '/product-view';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  // FirebaseMessaging _firebaseMessaging =FirebaseMessaging.instance;
  // Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   print("Handling a background message: ${message.messageId}");
  // }
  // void firebaseTrigger() async {
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   NotificationSettings settings = await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     provisional: false,
  //     sound: true,
  //   );
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //     // TODO: handle the received notifications
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  //   await _firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true ,sound: true);
  //   _firebaseMessaging.requestPermission(alert: true,carPlay: true,sound: true);
  //   _firebaseMessaging.getNotificationSettings();
  //   FirebaseMessaging.onMessage;
  //   FirebaseMessaging.onBackgroundMessage((message) => null);
  //   FirebaseMessaging.onMessageOpenedApp;
  // }

  // Future<void> setupInteractedMessage() async {
  // await  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true, // Required to display a heads up notification
  //     badge: true,
  //     sound: true,
  //   );
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage initialMessage =
  //   await FirebaseMessaging.instance.getInitialMessage();
  //
  //   // If the message also contains a data property with a "type" of "chat",
  //   // navigate to a chat screen
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }
  //
  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }

  // void _handleMessage(RemoteMessage message) {
  //  {
  //     Navigator.pushNamed(context, '/AdminScreen',
  //
  //       //arguments: ChatArguments(message),
  //     );
  //    // Navigator.of(context).pushNamed(AdminScreen.routeName);
  //   }
  // }


  @override
  void initState() {
    FirebaseMessaging.onMessage;
    //     .listen((RemoteMessage message){
    //   if (message.data['type'] == 'admin') {
    //     Navigator.of(context).pushNamed(AdminScreen.routeName);}
    //   else if(message.data['type'] == 'user') {
    //     Navigator.of(context).pushNamed(OrdersScreen.routeName);}
    // });
   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)
   { if (message.data['type'] == 'admin') {
     Navigator.of(context).pushNamed(AdminScreen.routeName);}
   else if(message.data['type'] == 'user') {
     Navigator.of(context).pushNamed(OrdersScreen.routeName);}});
   // firebaseTrigger();

    //firebaseMessaging.getToken().then((token) => print("the token is :"+  ""+ token));

   // await Provider.of<Auth>(context, listen: false).setAdminTokens();
    // getToken();
    //



    //
    // firebaseMessaging.confige(
    //
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     //_showItemDialog(message);
    //   },
    //   //onBackgroundMessage: myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     //_navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     //_navigateToItemDetail(message);
    //   },
    // );
    super.initState();
  }

  // String token = '';

  //
  // void getToken() async {
  //   token = await firebaseMessaging.getToken();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // Provider.of<Categories>(context).fetchAndSetProducts().then((_){});

      Provider.of<Categories>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Provider.of<AppetizerProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Papa's",
                style: TextStyle(color: kPrimaryColor),
              ),
              //SizedBox(width: 3,),
              TextSpan(
                text: "Burger",
                style: TextStyle(color: kThirdColor),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          auth.isAdmin
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AdminScreen.routeName);
                  },
                  color: Colors.black,
                  icon: Icon(
                    Icons.shopping_basket,
                  ),
                )
              : Container(),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            color: Colors.black,
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ],

        brightness: Brightness.dark, //IconButton
      ),
      // drawer: AppDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          Container(
            height: screenHeight * 0.19,
              width:screenWidth ,
              child: DiscountCard()),
          SizedBox(
            height: 20.h,
          ),
          Container(
            height: 50.h,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CategoryList(),
          ),
          Expanded(
            //flex: 8,
            child: Consumer<Products>(
                builder: (context, product, child) => Container(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ProductsGrid(_showOnlyFavorites))),
          ),
        ],
      ),
      // floatingActionButton:AnimatedBottom(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: AnimatedBar(),

      //other params
    );
  }
}
