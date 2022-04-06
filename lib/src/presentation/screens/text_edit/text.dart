import 'package:graphql_book/src/presentation/screens/text_edit/model.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

class TextPage extends StatefulWidget {
  const TextPage({Key? key}) : super(key: key);

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  List<DraggableList> allLists = [
    DraggableList(
      header: 'Best Fruits',
      items: [
        DraggableListItem(
          text: 'Lemon',
        ),
      ],
    ),
    DraggableList(
      header: 'Good Fruits',
      items: [
        DraggableListItem(
          text: 'Orange',
        ),
        DraggableListItem(
          text: 'Papaya',
        ),
      ],
    ),
    DraggableList(
      header: 'Disliked Fruits',
      items: [
        DraggableListItem(
          text: 'Grapefruit',
        ),
        DraggableListItem(
          text: 'Strawberries',
        ),
        DraggableListItem(
          text: 'Banana',
        ),
      ],
    ),
  ];

  late List<DragAndDropList> lists;

  var selectedList = 0;

  int? textEditingIndex;

  @override
  void initState() {
    super.initState();
    _initWidgets();
  }

  DragAndDropItem _text() {
    return DragAndDropItem(
      child: DraggableTextWidget(
        key: UniqueKey(),
        onEntry: (key) => _onEntry(key),
        onChanged: (text, key) => _onChanged(text, key),
      ),
    );
  }

  void _onEntry(Key key) {
    int i = 0;
    int j = 0;
    for (var list in lists) {
      for (var element in list.children) {
        if (element.child.key == key) {
          setState(() {
            textEditingIndex = i;
          });
          _initWidgets();
          return;
        }
        j++;
      }
      i++;
      j = 0;
    }
  }

  void _onHeaderEntry(Key key) {
    int i = 0;
    for (var list in lists) {
      if (list.header!.key == key) {
        setState(() {
          textEditingIndex = i;
          _initWidgets();
        });
        return;
      }
      i++;
    }
  }

  void _onChanged(String text, Key key) {
    int i = 0;
    int j = 0;
    for (var list in lists) {
      for (var element in list.children) {
        if (element.child.key == key) {
          setState(() {
            allLists[i].items[j].text = text;
            _initWidgets();
          });
        }
        j++;
      }
      i++;
      j = 0;
    }
  }

  void _onHeaderChanged(String text, Key key) {
    int i = 0;
    for (var list in lists) {
      if (list.header!.key == key) {
        setState(() {
          allLists[i].header = text;
          _initWidgets();
        });
      }
      i++;
    }
  }

  void _initWidgets() {
    lists = List.from(allLists
        .asMap()
        .map((i, e) => MapEntry(i, buildList(i, e)))
        .values
        .toList());
  }

  void _addText() {
    setState(() {
      if (lists.isEmpty) {
        lists.add(DragAndDropList(children: []));
      }
      lists.last.children.add(_text());
    });
  }

  void _addList() {
    setState(() {
      allLists.add(DraggableList(header: 'Header', items: []));
      lists.add(DragAndDropList(children: []));
    });
    _initWidgets();
  }

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);

      // final oldDataListItems = allLists[oldListIndex].items;
      // final newDataListItems = allLists[newListIndex].items;

      // final movedDataItem = oldDataListItems.removeAt(oldItemIndex);
      // newDataListItems.insert(newItemIndex, movedDataItem);
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);

      // final movedDataList = allLists.removeAt(oldListIndex);
      // allLists.insert(newListIndex, movedDataList);
    });
  }

  Widget _buildFloatingButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: _addText,
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.text_fields_outlined,
            size: 26,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 5),
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.image,
            size: 26,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 5),
        FloatingActionButton(
          onPressed: _addList,
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.list,
            size: 26,
            color: Colors.white,
          ),
        ),
      ],
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
            : const EdgeInsets.only(right: 10, top: 8),
        child: Icon(
          Icons.menu,
          color: color,
          size: isList ? 20 : 15,
        ),
      ),
    );
  }

  DragAndDropList buildList(int index, DraggableList list) => DragAndDropList(
        rightSide: textEditingIndex != null && textEditingIndex == index
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, size: 15),
                  SizedBox(height: 10),
                  Icon(Icons.delete, size: 15),
                ],
              )
            : null,
        header: Container(
          padding: const EdgeInsets.all(8),
          child: DraggableTextWidget(
            key: UniqueKey(),
            text: list.header,
            isHeader: true,
            onEntry: (key) => _onHeaderEntry(key),
            onChanged: (text, key) => _onHeaderChanged(text, key),
          ),
        ),
        children: list.items
            .map((item) => DragAndDropItem(
                    child: DraggableTextWidget(
                  key: UniqueKey(),
                  text: item.text,
                  onEntry: (key) => _onEntry(key),
                  onChanged: (text, key) => _onChanged(text, key),
                )))
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
            padding: const EdgeInsets.all(24.0),
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

class DraggableWidget {
  final TextFormField? textWidget;
  final Image? imageWidget;
  const DraggableWidget(this.textWidget, this.imageWidget);
}

class DraggableTextWidget extends StatefulWidget {
  final String text;
  final Function(String text, Key key) onChanged;
  final Function(Key key) onEntry;
  final bool isHeader;
  const DraggableTextWidget({
    this.text = '...',
    this.isHeader = false,
    required this.onEntry,
    required this.onChanged,
    required Key key,
  }) : super(key: key);

  @override
  State<DraggableTextWidget> createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
    if (widget.text != '...') {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('tapped');
      },
      child: Row(
        children: [
          Flexible(
            flex: 8,
            child: TextFormField(
              onTap: () => widget.onEntry(widget.key!),
              onFieldSubmitted: (text) {
                print('SUBMITTED');
                widget.onChanged(text, widget.key!);
              },
              onSaved: (text) => print('saved'),
              onEditingComplete: () => print('complete'),
              controller: _controller,
              keyboardType: TextInputType.multiline,
              autofocus: false,
              maxLines: null,
              style: widget.isHeader
                  ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  : null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '...',
                hintStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ),
          const Flexible(
            flex: 1,
            child: SizedBox(width: 20, height: 20),
          ),
        ],
      ),
    );
  }
}
