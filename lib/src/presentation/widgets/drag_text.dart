import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DraggableTextWidget extends StatefulWidget {
  final String text;
  final Function(String text, Key key) onChanged;
  final Function(Key key) onDelete;
  final bool isHeader;
  const DraggableTextWidget({
    this.text = '...',
    this.isHeader = false,
    required this.onDelete,
    required this.onChanged,
    required Key key,
  }) : super(key: key);

  @override
  State<DraggableTextWidget> createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
    _focus.addListener(_onFocusChange);
    if (widget.text != '...') {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
    // _focus.requestFocus();
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
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => widget.onChanged(_controller.text, widget.key!),
        ),
        children: [
          SlidableAction(
            onPressed: (ctx) {},
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
          SlidableAction(
            onPressed: (ctx) => widget.onChanged(_controller.text, widget.key!),
            backgroundColor: const Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 8,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10, bottom: 3, top: 3, right: 3),
              child: DottedBorder(
                dashPattern: const [14],
                padding: _focus.hasFocus
                    ? const EdgeInsets.all(10)
                    : const EdgeInsets.all(0),
                color: _focus.hasFocus
                    ? Colors.blueAccent[100]!
                    : Colors.transparent,
                radius: const Radius.circular(5),
                strokeWidth: 2,
                child: TextFormField(
                  focusNode: _focus,
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                  maxLines: null,
                  toolbarOptions: const ToolbarOptions(
                    copy: true,
                    cut: true,
                    selectAll: true,
                    paste: true,
                  ),
                  style: widget.isHeader
                      ? const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)
                      : null,
                  decoration: InputDecoration(
                    suffixIcon: _focus.hasFocus
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () => widget.onChanged(
                                    _controller.text, widget.key!),
                                child: const Icon(
                                  Icons.done,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(height: 7),
                              InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 15,
                                ),
                              ),
                            ],
                          )
                        : null,
                    border: InputBorder.none,
                    hintText: '...',
                    hintStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
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
