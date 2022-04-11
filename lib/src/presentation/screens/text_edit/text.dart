import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/data.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/model.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:graphql_book/src/presentation/styles/fonts.dart';
import 'package:graphql_book/src/presentation/widgets/drag_image.dart';
import 'package:graphql_book/src/presentation/widgets/drag_text.dart';
import 'package:path/path.dart' as p;

class TextPage extends StatefulWidget {
  const TextPage({Key? key}) : super(key: key);

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage>
    with SingleTickerProviderStateMixin {
  late List<DragAndDropList> lists;

  final ScrollController _scrollController = ScrollController();
  AnimationController? animationController;
  Animation? heightAnimation;
  Animation? opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initWidgets();
  }

  void _initAnimations() async {
    animationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );
    heightAnimation =
        Tween(begin: 0.0, end: 60.0).animate(animationController!);
    opacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(animationController!);
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.position.userScrollDirection ==
                ScrollDirection.reverse &&
            heightAnimation!.value != 0.0) {
          animationController!.reverse();
        } else if (_scrollController.position.userScrollDirection ==
                ScrollDirection.forward &&
            heightAnimation!.value != 60.0) {
          animationController!.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  /// CREATE

  void _addText(int index) {
    setState(() {
      allLists[index].items.add(DraggableListItem(
            text: '...',
            isAttached: false,
            time: DateTime.now(),
          ));
      _initWidgets();
    });
  }

  void _addImage(File file, String name, int index) {
    setState(() {
      allLists[index].items.add(DraggableListItem(
            text: name,
            isAttached: false,
            file: file,
            time: DateTime.now(),
          ));
      _initWidgets();
    });
  }

  Future<void> _attachFile(int index) async {
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
      allLists.add(
        DraggableList(
          header: 'Header',
          isAttached: false,
          items: [],
        ),
      );
      lists.add(DragAndDropList(children: []));
      _initWidgets();
    });
  }

  /// UPDATE

  void _onChanged(DraggableListItem item, int listIndex, int itemIndex) {
    setState(() {
      allLists[listIndex].items[itemIndex] = item;
      _initWidgets();
    });
  }

  void _onHeaderChanged(DraggableList list, int index) {
    setState(() {
      allLists[index] = list;
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
      backgroundColor: Colors.deepOrange[100],
      splashColor: Colors.deepOrange,
      child: const Icon(
        Icons.add,
        size: 20,
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
            : const EdgeInsets.only(right: 10, left: 10),
        child: Icon(
          Icons.menu,
          color: color,
          size: isList ? 20 : 17,
        ),
      ),
    );
  }

  DragAndDropList buildList(int index, DraggableList list) => DragAndDropList(
        header: Container(
          padding: const EdgeInsets.all(8),
          child: DraggableTextWidget(
            key: UniqueKey(),
            list: list,
            isHeader: true,
            onChangedList: (list) => _onHeaderChanged(list, index),
            onDelete: (key) => _deleteList(index: index),
            onAddText: (key) => _addText(index),
            onAddImage: (key) async => await _attachFile(index),
          ),
        ),
        children: list.items
            .asMap()
            .map(
              (i, e) {
                if (e.file != null) {
                  return MapEntry(
                    i,
                    DragAndDropItem(
                      child: DraggableImageWidget(
                        key: UniqueKey(),
                        item: e,
                        onChangedItem: (item) => _onChanged(item, index, i),
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
                        item: e,
                        onAddImage: (key) {},
                        onAddText: (key) {},
                        onChangedItem: (item) => _onChanged(item, index, i),
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: Column(
        children: [
          Flexible(
            flex: 6,
            child: DragAndDropLists(
              scrollController: _scrollController,
              children: lists,
              listDragHandle: buildDragHandle(isList: true),
              itemDragHandle: buildDragHandle(),
              onItemReorder: onReorderListItem,
              onListReorder: onReorderList,
              listPadding: const EdgeInsets.only(bottom: 50),
              listInnerDecoration: BoxDecoration(
                // color: Theme.of(context).canvasColor,
                // color: Colors.deepOrange.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              itemDecorationWhileDragging: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.4),
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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: heightAnimation!.value,
      elevation: 0.0,
      title: const Text('Notes', style: AppFonts.appBar),
      centerTitle: true,
      leading: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black87,
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.more_vert,
            color: Colors.black87,
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: opacityAnimation!.value,
            sigmaY: opacityAnimation!.value,
          ),
          child: Container(
            color: Colors.white.withOpacity(opacityAnimation!.value),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        floatingActionButton: _buildFloatingButton(),
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }
}
