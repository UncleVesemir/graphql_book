import 'package:flutter/material.dart';

class AppFonts {
  static const String _bold = 'Raleway-Bold';
  static const String _semibold = 'Raleway-SemiBold';
  static const String _regular = 'Raleway-Regular';

  static const smallFont = TextStyle(
    fontSize: 12,
  );

  static final header = TextStyle(
    fontSize: 20,
    fontFamily: _bold,
    fontWeight: FontWeight.w600,
    color: Colors.deepOrange[200],
  );

  static const item = TextStyle(
    fontSize: 15,
    fontFamily: _regular,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static const appBar = TextStyle(
    fontSize: 20,
    fontFamily: _regular,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static final hint = TextStyle(
    fontSize: 24,
    fontFamily: _regular,
    fontWeight: FontWeight.w600,
    color: Colors.black.withOpacity(0.6),
  );

  static final time = TextStyle(
    fontSize: 10,
    fontFamily: _regular,
    fontWeight: FontWeight.w400,
    color: Colors.black.withOpacity(0.6),
  );
}
