import 'dart:async';
//import 'dart:html';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/screens/cart_screen.dart';
import 'package:flutter_app/screens/orders_screen.dart';
import 'package:flutter_app/screens/pesonal_screen.dart';
import 'package:flutter_app/screens/products_overview_screen.dart';
import 'package:flutter_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class AnimatedBottom extends StatefulWidget {
  AnimatedBottom({Key key}) : super(key: key);

  @override
  _AnimatedBottomNavigationBarState createState() =>
      _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState extends State<AnimatedBottom>
    with SingleTickerProviderStateMixin {
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: HexColor('#373A36'),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0.00001,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: FloatingActionButton(
        elevation: 8,
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.home_outlined,
          color: HexColor('#373A36'),
        ),
        onPressed: () {
          _animationController.reset();
          _animationController.forward();
        },
      ),
    );
  }
}

class AnimatedBar extends StatefulWidget {
  AnimatedBar({Key key}) : super(key: key);

  @override
  _AnimatedBarState createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<AnimatedBar>
    with SingleTickerProviderStateMixin {
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0;
  var showOnlyFavorites = false;

  //default index of a first screen

  // AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.home,
    Icons.favorite,
    Icons.shopping_cart,
    Icons.person,
   // Icons.location_on_outlined
  ];

  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      //systemNavigationBarColor: HexColor('#373A36'),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false);
    final indexProvider = Provider.of<Animated>(context);
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        final color = isActive ? kPrimaryColor : ksecondaryColor;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconList[index],
              size: 24,
              color: color,
            ),
          ],
        );
      },
      backgroundColor: Colors.white,
      activeIndex: indexProvider.index,
      splashColor: HexColor('#FFA400'),
      notchAndCornersAnimation: animation,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapLocation: GapLocation.center,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: (index) {
        indexProvider.SetIndex(index);
        switch (index) {
          case 0:
            {
              product.showAll();
              //ProductsOverviewScreen();
              Navigator.of(context).pushReplacement
                (MaterialPageRoute(builder: (BuildContext context) =>
              ProductsOverviewScreen()));
              //pushNamed(ProductsOverviewScreen.routeName);
            }
            break;
          case 1:
            {
              product.showFavoritesOnly();
              Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName);
            }
            break;
          case 2:
            {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            }
            break;
          case 3:
            {

              Navigator.of(context).pushNamed(PersonalScreen.routeName);
            }
            break;
        }
      },
    );
  }

}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class Animated extends ChangeNotifier {
  int _index = 0;

  void SetIndex(int newValue) {
    _index = newValue;
  }

  int get index {
    return _index;
  }
}
