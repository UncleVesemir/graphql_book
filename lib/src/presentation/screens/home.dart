import 'package:flutter/material.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const TextPage();
  }
}
