import 'package:flutter/material.dart';

abstract class AppRadius {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;

  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(100));
}
