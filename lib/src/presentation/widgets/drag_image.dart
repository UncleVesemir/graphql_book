import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql_book/src/presentation/styles/fonts.dart';

class DraggableImageWidget extends StatefulWidget {
  final String name;
  final File file;
  final Function(String text) onChanged;
  final Function(Key key) onDelete;
  const DraggableImageWidget({
    required this.onChanged,
    required this.onDelete,
    required this.file,
    required this.name,
    required Key key,
  }) : super(key: key);

  @override
  State<DraggableImageWidget> createState() => _DraggableImageWidgetState();
}

class _DraggableImageWidgetState extends State<DraggableImageWidget> {
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
          onDismissed: () => widget.onChanged(widget.name),
        ),
        children: [
          SlidableAction(
            flex: 4,
            onPressed: (ctx) => widget.onChanged(widget.name),
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
                      widget.file,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.name, style: AppFonts.smallFont)
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
