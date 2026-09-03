import 'package:flutter/material.dart';

/// Fixed elevation tokens (not part of the remote design payload) used by [AppCard].
class AppElevation {
  const AppElevation._();

  static const List<BoxShadow> level0 = [];

  static const List<BoxShadow> level1 = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x1A000000), blurRadius: 2, offset: Offset(0, -1)),
  ];

  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 15,
      offset: Offset(0, 10),
      spreadRadius: -3,
    ),
  ];
}
