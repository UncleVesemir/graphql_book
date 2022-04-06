import 'package:flutter/material.dart';

class DraggableList {
  String header;
  final List<DraggableListItem> items;

  DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  String text;
  Widget? image;

  DraggableListItem({
    required this.text,
    this.image,
  });
}
