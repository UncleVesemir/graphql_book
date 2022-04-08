import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_book/src/internal/app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const App());
}
