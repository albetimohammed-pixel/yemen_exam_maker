import 'package:flutter/material.dart';

class PageBorderConfig {
  bool isEnabled;
  Color outerBorderColor;
  double outerBorderWidth;
  double spacing;
  Color innerBorderColor;
  double innerBorderWidth;
  double cornerRadius;
  Color backgroundColor;

  PageBorderConfig({
    this.isEnabled = true,
    this.outerBorderColor = Colors.green,
    this.outerBorderWidth = 3.0,
    this.spacing = 4.0,
    this.innerBorderColor = Colors.black,
    this.innerBorderWidth = 1.0,
    this.cornerRadius = 0.0,
    this.backgroundColor = Colors.white,
  });
}
