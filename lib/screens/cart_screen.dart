//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';

import 'package:flutter_app/widgets/AnimatedBottomNavigationBar.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import 'location_info.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(2)} L.E',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    backgroundColor: kPrimaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                  cart.items.toList()[i].id,
                  cart.items.toList()[i].prodId,
                  cart.items.toList()[i].price,
                  cart.items.toList()[i].title,
                  cart.items.toList()[i].type,
                  cart.items.toList()[i].appetizer),
            ),
          )
        ],
      ),
      // floatingActionButton: AnimatedBottom(),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     // bottomNavigationBar: AnimatedBar(),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child:  Text('ORDER NOW'),
      onPressed: () => (widget.cart.totalAmount <= 0 )
          ? null
          : Navigator.push(
              context, MaterialPageRoute(builder: (context) => LocationInfo())),
      //     : () async {
      //   setState(() {
      //     _isLoading = true;
      //   });
      //   await Provider.of<Orders>(context, listen: false).addOrder(
      //     widget.cart.items.values.toList(),
      //     widget.cart.totalAmount,
      //   );
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   widget.cart.clear();
      // },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
