import 'dart:io';

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
