import 'package:flutter/material.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/data.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/model.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/text.dart';
import 'package:graphql_book/src/presentation/widgets/custom_inner_shadow.dart';
import 'package:graphql_book/src/presentation/widgets/custom_list_wheel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<BookWidget> books;
  int selectedBook = 0;

  @override
  void initState() {
    super.initState();
    _initWidgets();
  }

  void _initWidgets() {
    books = List.from(allBooks
        .asMap()
        .map((i, e) => MapEntry(i, buildList(i, e)))
        .values
        .toList());
  }

  BookWidget buildList(int index, BookData list) => BookWidget(
        key: UniqueKey(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[100],
      body: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const TextPage()));
        },
        child: ListWheelScrollViewX(
          scrollDirection: Axis.horizontal,
          itemExtent: 240,
          squeeze: 0.9,
          perspective: 0.0001,
          children: books,
        ),
      ),
    );
  }
}

class BookWidget extends StatefulWidget {
  const BookWidget({
    required Key key,
  }) : super(key: key);

  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 350,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/book.jpeg'),
          fit: BoxFit.fill,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange[200]!,
            blurRadius: 20,
            offset: const Offset(25, 30),
            spreadRadius: 5,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(36),
          bottomRight: Radius.circular(36),
          bottomLeft: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        color: Colors.orangeAccent[100]!,
      ),
    );
  }
}
