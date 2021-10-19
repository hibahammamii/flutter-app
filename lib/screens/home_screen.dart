import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/app_bar_model.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/screens/about_papas_Screen.dart';
import 'package:flutter_app/screens/cart_screen.dart';
import 'package:flutter_app/screens/pesonal_screen.dart';
import 'package:flutter_app/screens/products_overview_screen.dart';
import 'package:flutter_app/widgets/confirmation_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';



class HomeScreen extends StatefulWidget {
  static const routeName = "/HomeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    var p = Provider.of<AppbarModel>(context, listen: true);
    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (c) => AppConfirmDialog(
                  positiveColor: kPrimaryColor,
                  description: "exit_app",
                  positiveAction: () {
                    Navigator.pop(context);
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  negativeAction: () {
                    Navigator.pop(context);
                  },
                ));

        return Future.value(false);
      },
      child: Scaffold(
        body: ChangeNotifierProvider.value(
          value: p,
          child: IndexedStack(
            children: [ProductsOverviewScreen(),
              ProductsOverviewScreen(),CartScreen(),PersonalScreen(),AboutScreen()],
            index: p.selectedTab,
          ),
        ),
        bottomNavigationBar: bottomBar(),
      ),
    );
  }

  Widget bottomBar() {
    final product = Provider.of<Products>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      child: BottomAppBar(
        elevation: 0.5,

        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Container(
          padding: EdgeInsets.only(top: 5),
         // margin: EdgeInsets.only(top: 8),
         height: 70.h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                iconSize: 35.w,
                icon: Icon(Icons.home),
                color: Provider.of<AppbarModel>(context, listen: false)
                  .selectedTab ==
                  0
                  ? kPrimaryColor
                  :kThirdColor ,
                onPressed: () {

                  product.showAll();
                  setState(() {
                    Provider.of<AppbarModel>(context, listen: false)
                        .selectedTab = 0;
                  });
                },
              ),
              IconButton(
                iconSize: 35.w,
                icon: Icon(
                  Icons.favorite

                ),
                color:
                Provider.of<AppbarModel>(context, listen: false)
                            .selectedTab ==
                        1
                    ? kPrimaryColor
                    :
                kThirdColor,
                onPressed: () {
                  product.showFavoritesOnly();
                  setState(() {
                    Provider.of<AppbarModel>(context, listen: false)
                        .selectedTab = 1;
                  });
                },
              ),
              IconButton(
                iconSize: 35.w,
                icon: Icon(Icons.shopping_cart),
                color: Provider.of<AppbarModel>(context, listen: false)
                    .selectedTab ==
                    2
                    ? kPrimaryColor
                    :kThirdColor ,

                onPressed: () {
                  setState(() {
                    Provider.of<AppbarModel>(context, listen: false)
                        .selectedTab = 2;
                  });
                },
              ),
              IconButton(
                iconSize: 35.w,
                icon: Icon(
                  Icons.account_circle,

                   color:
                  Provider.of<AppbarModel>(context, listen: false)
                      .selectedTab ==
                      3
                      ? kPrimaryColor
                      :
                  kThirdColor
                ),

                onPressed: () {
                  setState(() {
                    Provider.of<AppbarModel>(context, listen: false)
                        .selectedTab = 3;
                  });
                },
              ),
              IconButton(
                iconSize: 35.w,
                icon: Icon(
                    Icons.location_on

                ),
                color:
                Provider.of<AppbarModel>(context, listen: false)
                    .selectedTab ==
                    4
                    ? kPrimaryColor
                    :
                kThirdColor,
                onPressed: () {

                  setState(() {
                    Provider.of<AppbarModel>(context, listen: false)
                        .selectedTab = 4;
                  });
                },
              ),
            ],
          ),
        ),
        color: backGroundColor,
      ),
    );
  }
}
