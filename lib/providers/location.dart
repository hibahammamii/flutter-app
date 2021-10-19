import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LocationItem {
  final String id;
  String name;
   String lastName;
   String phoneNumber;
   String address;
  // final String city;
  // final String area;
  // final String building;
  // final String floor;
  // final String homeNum;

  LocationItem({@required this.id,@required this.name, this.lastName, this.phoneNumber,this.address});

}
class Location extends ChangeNotifier
{
   String _selectedLocation;
  void setValue(String newLoc) {
    _selectedLocation = newLoc;
   // print(_selectedType);
    notifyListeners();
  }

  String get selectedLocation {
    return _selectedLocation;
  }
  List<LocationItem> _location = [];
  final String authToken;
  final String userId;
  Location(this.authToken,this.userId,this._location);
  List<LocationItem> get location {
    return [..._location];
  }
   void setLocation(final newloc)
   {
     _location =newloc;
     notifyListeners();

   }
   fetchAndSetLocation()  {

   FirebaseFirestore.instance
        .collection('locations').doc(userId).collection('location')
        .snapshots()
        .listen((event) {
      final List<LocationItem> loadedLocation = [];

      event.docs.forEach((element) {
        loadedLocation.add(LocationItem(
            id: element.id,
            name: element.data()['name'],
          lastName: element.data()['lastName'],
          phoneNumber: element.data()['number'],
          address: element.data()['address'],

        ))
        ;}

        );

setLocation(loadedLocation.reversed.toList());

        }
        );




    print(_location);

    // final url =
    //    Uri.parse('https://test-8de9e.firebaseio.com/locations/$userId.json?auth=$authToken') ;
    // final response = await http.get(url);
    // final List<LocationItem> loadedLocation = [];
    // final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // if (extractedData == null) {
    //   return;
    // }
    // extractedData.forEach((locationId, locationData) {
    //   loadedLocation.add(
    //     LocationItem(
    //       id: locationId,
    //       name: locationData['name'],
    //       lastName: locationData['lastName'],
    //       phoneNumber: locationData['number'],
    //       address: locationData['address']
    //
    //     ),
    //   );
    // });


  }
  Future <void> addUserLocation(LocationItem locationItem) async
  {
    await  FirebaseFirestore.instance
        .collection('locations').doc(userId).collection("location").doc().set({'name' : locationItem.name,
      'lastName' : locationItem.lastName,
      'number' : locationItem.phoneNumber,
      'address' : locationItem.address,});
    // final url =
    //     Uri.parse('https://test-8de9e.firebaseio.com/locations/$userId.json?auth=$authToken');
    // final response = await http.post(
    //     url,
    //     body: json.encode({
    //       'name' : locationItem.name,
    //       'lastName' : locationItem.lastName,
    //       'number' : locationItem.phoneNumber,
    //       'address' : locationItem.address,
    //     }));


  }
  Future<void> updateLocation(String id, LocationItem locationItem) async {
  final locIndex = _location.indexWhere((loc) => loc.id == id);
  if (locIndex >= 0) {
    await FirebaseFirestore.instance
        .collection('locations').doc(userId).collection("location")
        .doc(id)
        .update(
     { 'name' : locationItem.name,
            'lastName' : locationItem.lastName,
            'number' : locationItem.phoneNumber,
            'address' : locationItem.address,}
    );

    // final url =
    //   Uri.parse('https://test-8de9e.firebaseio.com/locations/$userId/$id.json?auth=$authToken')  ;
    // await http.patch(url,
    //     body: json.encode({
    //       'name' : locationItem.name,
    //       'lastName' : locationItem.lastName,
    //       'number' : locationItem.phoneNumber,
    //       'address' : locationItem.address,
    //
    //     }));
    _location[locIndex] = locationItem;
    print(locationItem);
    print('done');
    notifyListeners();
  } else {
    print('...');
  }
}
  Future<void> deleteLocation(String id) async {
   // final url =
      //Uri.parse('https://test-8de9e.firebaseio.com/locations/$userId/$id.json?auth=$authToken') ;
    final existingProductIndex = _location.indexWhere((prod) => prod.id == id);
    var existingProduct = _location[existingProductIndex];
    _location.removeAt(existingProductIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('locations').doc(userId).collection("location")
          .doc(id)
          .delete();
    }
    on  FirebaseAuthException catch  (e) {
      _location.insert(existingProductIndex, existingProduct);
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  //   final response = await http.delete(url);
  //   if (response.statusCode >= 400) {
  //     _location.insert(existingProductIndex, existingProduct);
  //     notifyListeners();
  //     throw HttpException('Could not delete product.');
  //   }
  //   existingProduct = null;
   }
}
