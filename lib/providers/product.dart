import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/providers/appetizer.dart';
import 'package:http/http.dart' as http;
import 'price.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;

  final String imageUrl;
  final String category;
  bool isFavorite;
  final List<Price> type;
  final bool isMeal;
  final num priceMeal;

  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  Product({
    @required this.id,
    @required this.title,
    @required this.description,

    @required this.imageUrl,
    @required this.category,

    this.isFavorite = false,
    @required this.type,
    @required this.isMeal,
    this.priceMeal

  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    bool exist;
    //  Map<String,dynamic> Data ={id : isFavorite};

    notifyListeners();

    await FirebaseFirestore.instance.doc("isFavorites/$userId").get().then((
        doc) async {
      exist = doc.exists;
      if (exist) {
      await FirebaseFirestore.instance.collection("isFavorites")
            .doc(userId).update({id: isFavorite});

      }
      else
        FirebaseFirestore.instance.collection("isFavorites")
           .doc(userId).set({id: isFavorite});


      // final url =
      //    Uri.parse('https://test-8de9e.firebaseio.com/isFavorites/$userId/$id.json?auth=$token') ;
      // try {
      //   final response = await http.put(
      //     url,
      //     body: json.encode(
      //       isFavorite,
      //     ),
      //   );
      //   if (response.statusCode >= 400) {
      //     _setFavValue(oldStatus);
      //   }
      // } catch (error) {
      //   _setFavValue(oldStatus);
      // }
    });
  }

}
