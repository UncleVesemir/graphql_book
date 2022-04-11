import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/model.dart';
import 'package:graphql_book/src/presentation/styles/fonts.dart';

class DraggableImageWidget extends StatefulWidget {
  final DraggableListItem item;
  final Function(DraggableListItem item) onChangedItem;
  final Function(Key key) onDelete;
  const DraggableImageWidget({
    required this.onChangedItem,
    required this.onDelete,
    required this.item,
    required Key key,
  }) : super(key: key);

  @override
  State<DraggableImageWidget> createState() => _DraggableImageWidgetState();
}

class _DraggableImageWidgetState extends State<DraggableImageWidget> {
  void _onChangedItem() {
    widget.onChangedItem(widget.item.copyWith());
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key,
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible:
            DismissiblePane(onDismissed: () => widget.onDelete(widget.key!)),
        children: [
          SlidableAction(
            onPressed: (ctx) => widget.onDelete(widget.key!),
            backgroundColor: Colors.redAccent[100]!,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => _onChangedItem(),
        ),
        children: [
          SlidableAction(
            flex: 4,
            onPressed: (ctx) => _onChangedItem(),
            backgroundColor: Colors.deepOrange[200]!,
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      widget.item.file!,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.item.text, style: AppFonts.smallFont)
                ],
              ),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
