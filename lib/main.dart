import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/providers/appetizer.dart';
import 'package:flutter_app/providers/location.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/screens/admin_Screen.dart';
import 'package:flutter_app/screens/cart_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/location_info.dart';
import 'package:flutter_app/screens/location_screen.dart';

import 'package:flutter_app/screens/orders_screen.dart';
import 'package:flutter_app/screens/pesonal_screen.dart';
import 'package:flutter_app/screens/splash_screen.dart';
import 'package:flutter_app/widgets/AnimatedBottomNavigationBar.dart';
import 'package:flutter_fcm/Notification/FCM.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'models/app_bar_model.dart';
import 'providers/auth.dart';
import 'screens/auth_screen.dart';
import 'providers/price.dart';
import 'screens/location_screen.dart';

import 'providers/products.dart';
import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'providers/category.dart';
import 'providers/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/orders.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
 // Navigator.of(context).pushNamed(AdminScreen.routeName);

  print("Handling a background message: ${message.messageId}");
}

void main() async {
 // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
    MyApp(),
    //  DevicePreview(
    //   // enabled: !kReleaseMode,
    //    builder: (context) => MyApp(), // Wrap your app
    //  ),
  );
}
class Messaging {
  static String token;
  static initFCM()async{
    try{
      await FCM.initializeFCM(
          onNotificationPressed: (Map<String, dynamic> data) {
            AdminScreen();
            print(data);
          },
          onTokenChanged: (String token) {
            Messaging.token = token;
            print(token);
          },
          icon: 'icon'
      );
    }catch(e){}
  }
}

class MyApp extends StatelessWidget {
  // final productsData =new Categories();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // productsData.fetchAndSetProducts();
    return ScreenUtilInit(
        designSize: Size(392, 807),
        builder: () => MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(
                    value: Auth(),
                  ),
                  ChangeNotifierProvider.value(
                    value: AppbarModel(),
                  ),
                  ChangeNotifierProvider.value(
                    value: Animated(),
                  ),
                  ChangeNotifierProxyProvider<Auth, Categories>(
                    update: (context, auth, previousCategory) => Categories(
                        previousCategory == null
                            ? "beef"
                            : previousCategory.selected),
                  ),
                  ChangeNotifierProvider.value(
                    value: CategoryP(),
                  ),
                  ChangeNotifierProvider.value(
                    value: PriceProvider(),
                  ),
                  ChangeNotifierProvider.value(
                    value: Appetizer(),
                  ),
                  ChangeNotifierProvider.value(
                    value: Product(),
                  ),
                  ChangeNotifierProxyProvider<Auth, Products>(
                    update: (ctx, auth, previousProducts) => Products(
                      auth.token,
                      auth.userId,
                      previousProducts == null ? [] : previousProducts.items,
                      previousProducts == null ? [] : previousProducts.item,
                      previousProducts == null
                          ? "beef"
                          : previousProducts.category,
                    ),
                  ),
                  ChangeNotifierProxyProvider<Auth, AppetizerProvider>(
                    update: (ctx, auth, previousAppetizer) => AppetizerProvider(
                        previousAppetizer == null
                            ? []
                            : previousAppetizer.items),
                  ),
                  ChangeNotifierProxyProvider<Auth, Cart>(
                    update: (ctx, auth, previousCart) =>
                        Cart(previousCart == null ? [] : previousCart.items),
                  ),
                  // ChangeNotifierProvider.value(
                  //   value: Cart(),
                  // ),
                  ChangeNotifierProxyProvider<Auth, Location>(
                    update: (ctx, auth, previousOrders) => Location(
                      auth.token,
                      auth.userId,
                      previousOrders == null ? [] : previousOrders.location,
                    ),
                  ),
                  ChangeNotifierProxyProvider<Auth, Orders>(
                    update: (ctx, auth, previousOrders) => Orders(
                      auth.token,
                      auth.userId,
                      previousOrders == null ? [] : previousOrders.orders,
                    ),
                  ),
                ],
                child: Consumer<Auth>(
                    builder: (ctx, auth, _) => MaterialApp(
                          // builder: DevicePreview.appBuilder,
                          title: 'MyShop',
                          theme: ThemeData(
                            primaryColor: kPrimaryColor,
                            textSelectionColor: kPrimaryColor,
                            fontFamily: 'Lato',
                          ),

                          home: auth.isAuth
                              ? HomeScreen()
                              : FutureBuilder(
                                  future: auth.tryAutoLogin(),
                                  builder: (ctx, authResultSnapshot) =>
                                      authResultSnapshot.connectionState ==
                                              ConnectionState.waiting
                                          ? SplashScreen()
                                          : AuthScreen(),
                                ),
                          //ProductsOverviewScreen(),
                          // auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
                          routes: {
                            ProductsOverviewScreen.routeName: (ctx) =>
                                ProductsOverviewScreen(),
                            ProductDetailScreen.routeName: (ctx) =>
                                ProductDetailScreen(),

                            //  Products.routeName: (ctx) => Products()
                            CartScreen.routeName: (ctx) => CartScreen(),
                            OrdersScreen.routeName: (ctx) => OrdersScreen(),
                            LocationScreen.routeName: (ctx) => LocationScreen(),
                            // LocationScreen2.routeName: (ctx) =>
                            //     LocationScreen2(),

                            LocationInfo.routeName: (ctx) => LocationInfo(),
                            PersonalScreen.routeName: (ctx) => PersonalScreen(),
                            AdminScreen.routeName: (ctx) => AdminScreen(),
                            HomeScreen.routeName: (ctx) => HomeScreen(),
                            // UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                            //  EditProductScreen.routeName: (ctx) => EditProductScreen(),
                          },
                        ))));
  }
}
