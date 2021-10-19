import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CategoryP with ChangeNotifier {
  final String id;
  final String name;
  final String image;
  bool isActive;

  String selected;

  CategoryP(
      {@required this.id,
      @required this.name,
      @required this.image,
      this.isActive = false});

  void setValue(String newItem) {
    selected = newItem;

    notifyListeners();
  }
}

class Categories with ChangeNotifier {
  String selected;

  Categories(this.selected);

  void setValue(String newitem) {
    selected = newitem;

    notifyListeners();
  }

  List<CategoryP> _cat = [];

  void setCategory(List<CategoryP> newValue) {
    _cat = newValue;
    notifyListeners();
  }

  List<CategoryP> get cat {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._cat];
  }

  // final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('categories').snapshots();

  Future<void> fetchAndSetProducts() async {
    FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .listen((event) {
      final List<CategoryP> loadedcat = [];
      event.docs.forEach((element) {
        loadedcat.add(CategoryP(
          id: element.data()['id'],
          name: element.data()['name'],
        ));
       });

      setCategory(loadedcat.reversed.toList());
    }).onError((e) => print(e));

    //  _cat = loadedcat;
    // print(_cat[0].name);
  }
}
