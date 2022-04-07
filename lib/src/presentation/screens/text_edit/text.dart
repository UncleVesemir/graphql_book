import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/data.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/model.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:graphql_book/src/presentation/widgets/drag_image.dart';
import 'package:graphql_book/src/presentation/widgets/drag_text.dart';
import 'package:path/path.dart' as p;

class TextPage extends StatefulWidget {
  const TextPage({Key? key}) : super(key: key);

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  late List<DragAndDropList> lists;

  @override
  void initState() {
    super.initState();
    _initWidgets();
  }

  /// CREATE

  void _addText(int index) {
    setState(() {
      allLists[index].items.add(DraggableListItem(text: '...'));
      _initWidgets();
    });
  }

  void _addImage(File file, String name, int index) {
    setState(() {
      allLists[index].items.add(DraggableListItem(text: name, image: file));
      _initWidgets();
    });
  }

  void _attachFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String name = p.basename(file.path);
      String fileExtension = p.extension(file.path);
      if (name.length > 20) {
        name = name.substring(0, 20) + '...';
      }
      name += fileExtension;
      _addImage(file, name, index);
    } else {
      //
    }
  }

  void _addList() {
    setState(() {
      allLists.add(DraggableList(header: 'Header', items: []));
      lists.add(DragAndDropList(children: []));
      _initWidgets();
    });
  }

  /// UPDATE

  void _onChanged(String text, int listIndex, int itemIndex) {
    setState(() {
      allLists[listIndex].items[itemIndex].text = text;
      _initWidgets();
    });
  }

  void _onHeaderChanged(String text, int index) {
    setState(() {
      allLists[index].header = text;
      _initWidgets();
    });
  }

  /// DELETE

  void _deleteTextItem({required int listIndex, required int itemIndex}) {
    setState(() {
      allLists[listIndex].items.removeAt(itemIndex);
      _initWidgets();
    });
  }

  void _deleteList({required int index}) {
    setState(() {
      allLists.removeAt(index);
      _initWidgets();
    });
  }

  /// INIT AFTER CHANGES

  void _initWidgets() {
    lists = List.from(allLists
        .asMap()
        .map((i, e) => MapEntry(i, buildList(i, e)))
        .values
        .toList());
  }

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final oldDataListItems = allLists[oldListIndex].items;
      final newDataListItems = allLists[newListIndex].items;

      final movedDataItem = oldDataListItems.removeAt(oldItemIndex);
      newDataListItems.insert(newItemIndex, movedDataItem);

      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);

      _initWidgets();
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedDataList = allLists.removeAt(oldListIndex);
      allLists.insert(newListIndex, movedDataList);

      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);

      _initWidgets();
    });
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton(
      onPressed: _addList,
      backgroundColor: Colors.black,
      child: const Icon(
        Icons.add,
        size: 26,
        color: Colors.white,
      ),
    );
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: isList
            ? const EdgeInsets.only(right: 10, top: 25)
            : const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.menu,
          color: color,
          size: isList ? 20 : 15,
        ),
      ),
    );
  }

  DragAndDropList buildList(int index, DraggableList list) => DragAndDropList(
        rightSide: Padding(
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => _addText(index),
                child: const Icon(
                  Icons.text_fields_sharp,
                  size: 15,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async => _attachFile(index),
                child: const Icon(
                  Icons.image,
                  size: 15,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        header: Container(
          padding: const EdgeInsets.all(8),
          child: DraggableTextWidget(
            key: UniqueKey(),
            text: list.header,
            isHeader: true,
            onChanged: (text) => _onHeaderChanged(text, index),
            onDelete: (key) => _deleteList(index: index),
          ),
        ),
        children: list.items
            .asMap()
            .map(
              (i, e) {
                if (e.image != null) {
                  return MapEntry(
                    i,
                    DragAndDropItem(
                      child: DraggableImageWidget(
                        key: UniqueKey(),
                        name: e.text,
                        file: e.image!,
                        onChanged: (text) => _onChanged(text, index, i),
                        onDelete: (key) =>
                            _deleteTextItem(listIndex: index, itemIndex: i),
                      ),
                    ),
                  );
                } else {
                  return MapEntry(
                    i,
                    DragAndDropItem(
                      child: DraggableTextWidget(
                        key: UniqueKey(),
                        text: e.text,
                        onChanged: (text) => _onChanged(text, index, i),
                        onDelete: (key) =>
                            _deleteTextItem(listIndex: index, itemIndex: i),
                      ),
                    ),
                  );
                }
              },
            )
            .values
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: _buildFloatingButton(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Flexible(
                  flex: 6,
                  child: DragAndDropLists(
                    children: lists,
                    listDragHandle: buildDragHandle(isList: true),
                    itemDragHandle: buildDragHandle(),
                    onItemReorder: onReorderListItem,
                    onListReorder: onReorderList,
                    listPadding: const EdgeInsets.only(bottom: 30),
                    listInnerDecoration: BoxDecoration(
                      // color: Theme.of(context).canvasColor,
                      // color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemDecorationWhileDragging: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
