import 'dart:io';

import 'package:flutter/material.dart';

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
  bool isAttached;
  TextAlign? alignment;
  Color? backgroundColor;
  Color? fontColor;
  FontWeight? fontWeight;
  final List<DraggableListItem> items;

  DraggableList({
    required this.header,
    required this.isAttached,
    required this.items,
    this.alignment,
    this.backgroundColor,
    this.fontColor,
    this.fontWeight,
  });

  DraggableList copyWith({
    String? header,
    List<DraggableListItem>? items,
    TextAlign? alignment,
    bool? isAttached,
    Color? backgroundColor,
    Color? fontColor,
    FontWeight? fontWeight,
    File? file,
  }) =>
      DraggableList(
        isAttached: isAttached ?? this.isAttached,
        header: header ?? this.header,
        items: items ?? this.items,
        alignment: alignment ?? this.alignment,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        fontColor: fontColor ?? this.fontColor,
        fontWeight: fontWeight ?? this.fontWeight,
      );
}

class DraggableListItem {
  String text;
  bool isBookmarked;
  DateTime time;
  TextAlign? alignment;
  Color? backgroundColor;
  Color? fontColor;
  FontWeight? fontWeight;
  File? file;

  DraggableListItem({
    required this.text,
    required this.isBookmarked,
    required this.time,
    this.alignment,
    this.backgroundColor,
    this.fontColor,
    this.fontWeight,
    this.file,
  });

  DraggableListItem copyWith({
    String? text,
    DateTime? time,
    bool? isAttached,
    TextAlign? alignment,
    Color? backgroundColor,
    Color? fontColor,
    FontWeight? fontWeight,
    File? file,
  }) =>
      DraggableListItem(
        text: text ?? this.text,
        time: time ?? this.time,
        isBookmarked: isAttached ?? this.isBookmarked,
        alignment: alignment ?? this.alignment,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        fontColor: fontColor ?? this.fontColor,
        fontWeight: fontWeight ?? this.fontWeight,
        file: file ?? this.file,
      );
}
