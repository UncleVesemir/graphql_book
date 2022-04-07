import 'dart:io';

class BookData {
  final List<DraggableList> content;
  final String name;

  BookData({
    required this.content,
    required this.name,
  });
}

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
  File? image;

  DraggableListItem({
    required this.text,
    this.image,
  });
}
