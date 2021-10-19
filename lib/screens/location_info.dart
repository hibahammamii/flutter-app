import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:flutter_app/providers/connectivity.dart';
import 'package:flutter_app/providers/location.dart' show Location;
import 'package:flutter_app/providers/orders.dart';
import 'package:flutter_app/screens/orders_screen.dart';
import 'package:flutter_app/widgets/location_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'location_screen.dart';

class LocationInfo extends StatelessWidget {
  static const routeName = '/location';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Info'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
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
                    SizedBox(
                      width: 30,
                    ),
                    Chip(
                      label: Text(
                        '${cart.totalAmount.toStringAsFixed(2)} L.E',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: kPrimaryColor,
                    ),
                    ConfirmationButton(cart: cart),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Choose your location",
              style: TextStyle(
                  fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 8.0, right: 20.0, bottom: 0.0),
              child: FutureBuilder(
                future: Provider.of<Location>(context, listen: false)
                    .fetchAndSetLocation(),
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (dataSnapshot.error != null) {
                      // ...
                      // Do error handling stuff
                      return Center(
                        child: Text('An error occurred!'),
                      );
                    } else {
                      return Consumer<Location>(
                        builder: (ctx, locationData, child) => ListView.builder(
                          itemCount: locationData.location.length,
                          itemBuilder: (ctx, i) =>
                              LocationItem(locationData.location[i]),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                },
                child: Text(
                  "check you orders",
                  style: TextStyle(color: kPrimaryColor),
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocationScreen(isEdite: false)));
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}

class ConfirmationButton extends StatefulWidget {
  const ConfirmationButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _ConfirmatrionButtonState createState() => _ConfirmatrionButtonState();
}

class _ConfirmatrionButtonState extends State<ConfirmationButton> {
  var _isLoading = false;
  LocationItem locationItem;

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<Location>(context, listen: true);
    int index = locationProvider.location.indexWhere(
        (element) => element.id == locationProvider.selectedLocation);

    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('Submit'),
      onPressed: (_isLoading || locationProvider.selectedLocation == null)
          ? null
          : () async {
              await check().then((intenet) async {
                if (intenet != null && intenet) {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<Orders>(context, listen: false)
                      .addOrder(
                    context,
                    widget.cart.items.toList(),
                    widget.cart.totalAmount,
                    locationProvider.location[index],
                  )
                      .catchError((e) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: ksecondaryColor,
                        content: Text("failed",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ))));
                  }).whenComplete(() {
                    widget.cart.clear();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: ksecondaryColor,
                        content: Text("order confirmed",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ))));
                    //
                  });
                  setState(() {
                    _isLoading = false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Check your internet connection and try again!"),
                    //  width: 200.0.w,
                    backgroundColor: ksecondaryColor,
                    width: 280.0,
                    duration: const Duration(seconds: 2),
                    // Width of the SnackBar.
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, // Inner padding for SnackBar content.
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ));
                }
              });

              //     .timeout(const Duration(seconds:20),onTimeout:() {
              //  // FirebaseFirestore.instance.enablePersistence();
              //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //       duration: const Duration(seconds: 3),
              //       backgroundColor: ksecondaryColor,
              //       content: Text("Something wrong, your order wi ",
              //           textAlign: TextAlign.start,
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //             fontWeight: FontWeight.bold,
              //           ))));
              // });

              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text("order confirmed"),
              //   //  width: 200.0.w,
              //   backgroundColor: ksecondaryColor,
              //   width: 280.0,
              //   duration: const Duration(milliseconds: 1000),
              //   // Width of the SnackBar.
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 20.0, // Inner padding for SnackBar content.
              //   ),
              //   behavior: SnackBarBehavior.floating,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              // ));
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
