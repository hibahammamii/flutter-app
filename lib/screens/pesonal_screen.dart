import 'package:flutter/material.dart';
import 'package:flutter_app/screens/cart_screen.dart';
import 'package:flutter_app/widgets/AnimatedBottomNavigationBar.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
//import '../screens/user_products_screen.dart';
import '../providers/auth.dart';

class PersonalScreen extends StatelessWidget {
  static const routeName = '/personalScreen';
  @override
  Widget build(BuildContext context) {
    final indexProvider = Provider.of<Animated>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Column(
        children: <Widget>[


          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Your cart'),
            onTap: () {
              indexProvider.SetIndex(2);
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Your Orders'),
            onTap: () {
              indexProvider.SetIndex(3);
              Navigator.of(context)
                  .pushNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          /*  ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),*/
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/');

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    //  bottomNavigationBar: AnimatedBar(),
    );
  }
}
