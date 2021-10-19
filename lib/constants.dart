import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFfcb813);
const ksecondaryColor = Color(0xFFB5BFD0);
const kThirdColor = Color(0xff4d2715);
const kColor = Color(0xadff3a);
const kTextColor = Color(0xFF50505D);
const kTextLightColor = Color(0xFF6A727D);
const backGroundColor =Color(0xffFFF2E6);

extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}
