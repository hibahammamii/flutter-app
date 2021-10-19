//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/screens/location_screen.dart';
import 'package:provider/provider.dart';


import '../providers/location.dart' as loc;

import '../screens/location_screen.dart';


class LocationItem extends StatelessWidget {
  final loc.LocationItem location;

  LocationItem(this.location);
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<loc.Location>(context,listen: false);
    String _value = '';
    return Dismissible(
        key: ValueKey(location.id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text(
                'Do you want to remove location?',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          Provider.of<loc.Location>(context, listen: false)
              .deleteLocation(location.id);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: Row(
              children: [
                Radio(value: location.id, groupValue: locationProvider.selectedLocation, onChanged: (value){

                  locationProvider.setValue(location.id);

                  print('new');
                  print(_value);
                  print(value);

                }),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            location.name != null
                                ? location.name.inCaps
                                : 'null',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Flexible(
                            flex: 4,
                            child: Text(location.lastName != null
                                    ? location.lastName.inCaps
                                    : 'null',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          location.phoneNumber != null
                              ? location.phoneNumber
                              : 'null',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        location.address != null
                            ? location.address
                            : 'null',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),

                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LocationScreen(isEdite:true,locId: location.id,)));
                          },
                          child: Text(
                            'Change Address',
                            style: TextStyle(color: kPrimaryColor),
                          ))

                      // Text( location.phoneNumber.toString()),
                      // Text( location.address),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
    // TODO: implement build
    throw UnimplementedError();
  }
}


