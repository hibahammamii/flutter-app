import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Appetizer extends ChangeNotifier {
  final String appetizerId;
  final num appetizerPrice;
  final String appetizerName;
  bool _isChecked = false;

  //String selected;

  Appetizer({
    this.appetizerId,
    this.appetizerName,
    this.appetizerPrice,
  });

  void setFavValue(bool newValue) {
    _isChecked = newValue;
    notifyListeners();
  }

  bool get ischeck {
    return _isChecked;
  }
}

class AppetizerProvider extends ChangeNotifier {
  List<Appetizer> _items = [];
  AppetizerProvider(this._items);


  List<Appetizer> get items {
    return [..._items];
  }
  void setAppetizer(List<Appetizer> newValue) {
    _items = newValue;
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    List<Appetizer> loadAdds = [];
    FirebaseFirestore.instance.collection('adds').snapshots().listen((event) {
      event.docs.forEach((element) {
        loadAdds.add(Appetizer(
            appetizerId: element.data()['id'],
            appetizerName: element.data()['title'],
            appetizerPrice: element.data()['price']));
      });
      setAppetizer(loadAdds);
    }

    ).onError((e) => print(e));
    // // setAppetizer(loadAdds);
    // _items = loadAdds;

    //  final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    // var url =Uri.parse('https://test-8de9e.firebaseio.com/appetizer.json');
    // //  '?auth=$authToken&$filterString;
    // try {
    //   final response = await http.get(url);
    //   print(json.decode(response.body));
    //   final extractedData = json.decode(response.body) as Map<
    //       dynamic,
    //       dynamic>;
    //   if (extractedData == null) {
    //     return;
    //   }
    //
    //
    //   final List<Appetizer> loadedProducts = [];
    //   extractedData.forEach((prodId, prodData) {
    //     loadedProducts.add(Appetizer(
    //    appetizerId: prodId,
    //       appetizerName: prodData['title'],
    //       appetizerPrice: prodData['price']
    //     ));
    //   });
    //   _items = loadedProducts;
    //   print(_items);

    //   } catch (error) {
    //     throw (error);
    //   }
    // }
  }
}
