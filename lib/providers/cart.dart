import 'package:flutter/foundation.dart';
import 'package:flutter_app/providers/appetizer.dart';

class CartItem {
  final String id;
  final String prodId;
  final String title;
  //final int quantity;
  final num price;
  final String type;
  List<Appetizer> appetizer;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.prodId,
    //@required this.quantity,
    @required this.price,
    this.type,
    this.appetizer

  });
}

class Cart with ChangeNotifier {
List<CartItem> _items = [];
Cart(this._items);

  List<CartItem> get items {
    return _items;
  }

  int get itemCount {
    return _items.length;
  }

  num get totalAmount {
    var total = 0.0;
    _items.forEach((cartItem) {
      total += cartItem.price ;
    });
    return total;
  }


  void addItem(
    String productId,
    num price,
    String title,
      String typeId,
      List<Appetizer> appetizer
  ) {
    _items.add(CartItem(
                  id: DateTime.now().toString(),
                  title: title,
                  prodId: productId,
                  price: price,
                  type: typeId,
              appetizer: appetizer
                ),
    );


    // String Fkey =productId+typeId;
    // print(Fkey);
    //
    // if (_items.containsKey(Fkey)) {
    //
    //
    //   // change quantity...
    //   _items.update(
    //     Fkey,
    //     (existingCartItem) => CartItem(
    //           id: existingCartItem.id,
    //           title: existingCartItem.title,
    //           price: existingCartItem.price,
    //           quantity: existingCartItem.quantity + 1,
    //           type: existingCartItem.type,
    //       appetizer: existingCartItem.appetizer
    //         ),
    //   );}
    //
    //  else {
    //   _items.putIfAbsent(
    //     Fkey,
    //     () => CartItem(
    //           id: DateTime.now().toString(),
    //           title: title,
    //           price: price,
    //           quantity: 1,
    //           type: typeId,
    //       appetizer: appetizer
    //         ),
    //   );
    // }


    notifyListeners();
  }

  void removeItem(String productId) {
   int index = _items.indexWhere((element) => element.id ==productId) ;
    _items.removeAt(index);

    notifyListeners();
  }

  // void removeSingleItem(String productId) {
  //   if (!_items.containsKey(productId)) {
  //     return;
  //   }
  //   if (_items[productId].quantity > 1) {
  //     _items.update(
  //         productId,
  //         (existingCartItem) => CartItem(
  //               id: existingCartItem.id,
  //               title: existingCartItem.title,
  //               price: existingCartItem.price,
  //               quantity: existingCartItem.quantity - 1,
  //
  //             ));
  //   } else {
  //     _items.remove(productId);
  //   }
  //   notifyListeners();
  // }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
