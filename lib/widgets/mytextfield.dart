import 'package:flutter/material.dart';

class MyText {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        width: 80,
        child: TextField(
            autofocus: false,
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(141, 141, 141, 1.0),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              prefixIcon: Icon(
                Icons.search,
                color: Color.fromRGBO(41, 41, 41, 1),
              ),
              hintText: "search food",
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(240, 240, 240, 1), width: 32.0),
                  borderRadius: BorderRadius.circular(17.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(240, 240, 240, 1), width: 32.0),
                  borderRadius: BorderRadius.circular(17.0)),
              focusColor: Color.fromRGBO(141, 141, 141, 1),
            )));
  }
}
