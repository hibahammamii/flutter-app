

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/providers/appetizer.dart';
import 'package:flutter_app/providers/location.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final num amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final int orderStatus ;
  final String userId;
  String name;
  String lastName;
  String phoneNumber;
  String address;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    @required this.orderStatus,
    @required this.userId,
    this.name,
    this.lastName,
    this.phoneNumber,
    this.address

  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  List<OrderItem> _allOrdes = [];

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }
  List<OrderItem> get allOrders {
    return [..._allOrdes];
  }
  void setOrder (final newOrder){
    _orders = newOrder;
    notifyListeners();
  }
  void setAllOrder (final newOrder){
    _allOrdes = newOrder;
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    try{
      FirebaseFirestore.instance
          .collection('orders')
          .where("userId",isEqualTo: userId).orderBy("dateTime",descending: true)
          .snapshots()
          .listen((event) {
        final List<OrderItem> loadedOrder = [];

        event.docs.forEach((element) {
          loadedOrder.add(OrderItem(
            id: element.id,
            amount:element.data()['amount'],
            dateTime: DateTime.parse(element.data()['dateTime']),
            orderStatus:element.data()['orderStatus'] ,
            products: (element.data()['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                id: item['id'],
                price: item['price'],
                title: item['title'],
                type: item['type'],
                appetizer: (item['appetizer'] as List<dynamic>)
                    .map((e) => Appetizer(
                  appetizerName: e['title'],
                ))
                    .toList(),
              ),
            )
                .toList(),

          ))
          ;}

        );

        setOrder(loadedOrder.toList());

      }
      );



    } on FirebaseAuthException catch  (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }
  Future<void> fetchAndSetAllOrders() async {
   FirebaseFirestore.instance
        .collection('orders').orderBy('dateTime', descending: true).
        snapshots()
        .listen((event) {
      final List<OrderItem> loadedOrder = [];

      event.docs.forEach((element) {
        loadedOrder.add(OrderItem(
          id: element.id,
          amount:element.data()['amount'],
          dateTime: DateTime.parse(element.data()['dateTime']),
          orderStatus:element.data()['orderStatus'] ,
          products: (element.data()['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
              id: item['id'],
              price: item['price'],
              title: item['title'],
              type: item['type'],
              appetizer: (item['appetizer'] as List<dynamic>)
                  .map((e) => Appetizer(
                appetizerName: e['title'],
              ))
                  .toList(),
            ),
          )
              .toList(),
          name: element.data()['name'],
          lastName: element.data()['lastName'],
          phoneNumber: element.data()['phone'],
          address: element.data()['address'],

        )
        )
        ;}

      );

      setAllOrder(loadedOrder.toList());

    }
    );


  }

  Future<void> addOrder(BuildContext context,List<CartItem> cartProducts, double total,
      LocationItem locationItem) async {
    final FirebaseMessaging firebaseMessaging =FirebaseMessaging.instance;
    final userToken = await firebaseMessaging.getToken();

    final timestamp = DateTime.now();

    await  FirebaseFirestore.instance
        .collection('orders').doc().set({
      'amount': total,
      'userId': userId,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts
          .map((cp) => {
        'id': cp.id,
        'title': cp.title,
        'appetizer': cp.appetizer
            .map((e) => {'title': e.appetizerName})
            .toList(),
        'price': cp.price,
        'type': cp.type
      })
          .toList(),
      'name': locationItem.name,
      'lastName': locationItem.lastName,
      'phone': locationItem.phoneNumber,
      'address': locationItem.address,
      'orderStatus' : 0 ,
      'token' : userToken,
    });
  }
  Future<void> editOrder(String id,int idStatus) async{
    final locIndex = _allOrdes.indexWhere((loc) => loc.id == id);
    if (locIndex >= 0) {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(id)
          .update(
          { "orderStatus" : idStatus}
      );

    }
}
}
