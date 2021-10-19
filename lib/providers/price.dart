

import 'package:flutter/foundation.dart';

import 'appetizer.dart';


class Price with ChangeNotifier {
  final String typeId;
  final num price;

  //String selected;

  Price({
    @required this.typeId,
    this.price,

  });}

  class PriceProvider with ChangeNotifier {
  String _selectedType;
   num _selectedPrice;

  String get selected {
  return _selectedType;
  }

  void setValue(String newItem) {
  _selectedType = newItem;

  print(_selectedType);
  notifyListeners();
  }

  num get price {
  return _selectedPrice;
  }

  void setPrice(num value) {
  _selectedPrice = value;
  print(_selectedPrice);
  notifyListeners();
  }
  void addPrice(num price)
  {
    _selectedPrice += price;
    notifyListeners();

  }
  void minPrice(num price)
  {
    _selectedPrice -= price;
    notifyListeners();

  }


  }



