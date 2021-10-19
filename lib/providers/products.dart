import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/appetizer.dart';
import 'package:flutter_app/providers/price.dart';
import 'package:http/http.dart' as http;

import '../models/http_excption.dart';
import './product.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Products with ChangeNotifier {
  //static const routeName = '/category-detail';
  List<Product> _item = [];
  List<Product> _items = [];
  var _showFavoritesOnly = false;
  final String authToken;
  final String userId;
  String catid ;


  Products(this.authToken, this.userId, this._items,this._item,this.catid);

  List<Product> get items {
    if (_showFavoritesOnly) {
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }
    return [..._items];
  }
  List<Product> get item {

    return [..._item];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }
  String get category {
    return catid;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
  Product findByIdCart(String id) {
    return _item.firstWhere((prod) => prod.id == id);
  }


  void findByCat(String cat) {
    List<Product> cat_product = [];
    catid = cat;
    _item.forEach((element) {
      if (element.category == catid) {
        cat_product.add(element);
      }
    });
    _items = cat_product;
    notifyListeners();
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }
  void setProduct(List<Product> newValue) {
    _item = newValue;
    notifyListeners();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {

    var favoriteData;

    // final favoriteData= json.decode(FirebaseFirestore.instance
    //     .collection('isFavorites').doc(userId).collection());
    // final favoriteData=await FirebaseFirestore.instance
    //    .collection('isFavorites').doc(userId);
    // var favoriteData =
    // await FirebaseFirestore.instance.collection('isFavorites').doc('userId');
    // print(favoriteData);
    await FirebaseFirestore.instance.collection('isFavorites').where(
        FieldPath.documentId,
        isEqualTo: userId
    ).get().then((event) {
      if (event.docs.isNotEmpty) {
        favoriteData = event.docs.single.data();
        print(favoriteData);//if it is a single document
      }
    }).catchError((e) => print("error fetching data:"));

   //  final favoriteData= FirebaseFirestore.instance
   //      .collection('isFavorites').doc(userId) as Map<dynamic,dynamic>;

    await  FirebaseFirestore.instance
        .collection('foods')
        .snapshots()
        .listen((event) {
      final List<Product> loadedcat = [];
      event.docs.forEach((element) {
        loadedcat.add(Product(
          id: element.id,
          category:element.data()['category'],
          description:element.data()['description'],
          imageUrl:element.data()['imageUrl'],
          title:element.data()['title'],
        isFavorite: favoriteData == null ? false : favoriteData[element.id] ?? false,


          type: element.data()['type'] != null?
          (element.data()['type'] as List<dynamic>)
              .map((item) =>
              Price(typeId: item['title'], price: item['price']))

              .toList() :[],
          isMeal: element.data()['isMeals'],
          priceMeal: element.data()['priceMeal'],
        ));

      });
     // print(favoriteData);


      setProduct(loadedcat);
      List<Product> cat_products = [];
      _item.forEach((element) {
        if (element.category == catid) cat_products.add(element);
      });
      _items = cat_products;
      // print(loadedcat.length);

    });

    // //  final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    // var url =Uri.parse( 'https://test-8de9e.firebaseio.com/products.json');
    // //  '?auth=$authToken&$filterString;
    // try {
    //   final response = await http.get(url);
    //   print(json.decode(response.body));
    //   final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //   if (extractedData == null) {
    //     return;
    //   }
    //   url =
    //      Uri.parse('https://test-8de9e.firebaseio.com/isFavorites/$userId.json?auth=$authToken') ;
    //   final favoriteResponse = await http.get(url);
    //   final favoriteData = json.decode(favoriteResponse.body);
    //   final List<Product> loadedProducts = [];
    //   extractedData.forEach((prodId, prodData) {
    //     loadedProducts.add(Product(
    //         id: prodId,
    //         title: prodData['title'],
    //         description: prodData['description'],
    //         category: prodData['category'],
    //         isFavorite:
    //             favoriteData == null ? false : favoriteData[prodId] ?? false,
    //         imageUrl: prodData['imageUrl'],
    //         type: (prodData['type'] as List<dynamic>)
    //             .map((item) =>
    //                 Price(typeId: item['title'], price: item['price']))
    //             .toList(),
    //
    //     ));
    //   });
    //   item = loadedProducts;
    //
    //   List<Product> cat_products = [];
    //   item.forEach((element) {
    //     if (element.category == catid) cat_products.add(element);
    //   });
    //   _items = cat_products;
    //   print(authToken);
    //   print("userid"+userId);
    //

    //
    //   notifyListeners();
    // } catch (error) {
    //   throw (error);
    // }
  }

//void getPrice() {}
/*Future<void> getCategories()async{
 QuerySnapshot querySnapshot= await   FirebaseFirestore.instance.collection('burger').get();
 querySnapshot.docs.forEach((element) {
   print(element);

 });
  }*/

/*Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-update.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-update.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }*/
}
