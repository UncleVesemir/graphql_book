import 'package:flutter/material.dart';
import 'package:graphql_book/src/presentation/screens/home.dart';
import 'package:graphql_book/src/presentation/screens/home_page/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
