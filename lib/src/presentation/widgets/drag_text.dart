import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql_book/src/presentation/styles/fonts.dart';

class DraggableTextWidget extends StatefulWidget {
  final String text;
  final Function(Key key) onAddText;
  final Function(Key key) onAddImage;
  final Function(String text) onChanged;
  final Function(Key key) onDelete;
  final bool isHeader;
  const DraggableTextWidget({
    required this.onAddText,
    required this.onAddImage,
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

  TextAlign textAlign = TextAlign.justify;
  late TextStyle textStyle;
  Color backgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    textStyle = widget.isHeader ? AppFonts.header : AppFonts.item;
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
    if (!_focus.hasFocus) {
      widget.onChanged(_controller.text);
    }
    setState(() {});
  }

  List<SlidableAction> _headerActions() {
    return [
      SlidableAction(
        flex: 4,
        onPressed: (ctx) => widget.onAddImage(widget.key!),
        backgroundColor: Colors.deepOrange[100]!,
        foregroundColor: Colors.white,
        icon: Icons.image,
        label: 'Image',
      ),
      SlidableAction(
        flex: 4,
        onPressed: (ctx) => widget.onAddText(widget.key!),
        backgroundColor: Colors.deepOrange[200]!,
        foregroundColor: Colors.white,
        icon: Icons.text_fields_sharp,
        label: 'Text',
      ),
    ];
  }

  List<SlidableAction> _itemsActions() {
    return [
      SlidableAction(
        flex: 4,
        onPressed: (ctx) => widget.onChanged(_controller.text),
        backgroundColor: Colors.deepOrange[200]!,
        foregroundColor: Colors.white,
        icon: Icons.star,
        label: 'Favorite',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slidable(
          key: widget.key,
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
                onDismissed: () => widget.onDelete(widget.key!)),
            children: [
              SlidableAction(
                onPressed: (ctx) => widget.onDelete(widget.key!),
                backgroundColor: Colors.redAccent[100]!,
                foregroundColor: backgroundColor,
                icon: Icons.delete,
                label: 'Delete',
                spacing: 4,
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: !widget.isHeader
                ? DismissiblePane(
                    onDismissed: () => widget.onChanged(_controller.text),
                  )
                : null,
            children: widget.isHeader ? _headerActions() : _itemsActions(),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 3, bottom: 3, top: 3, right: 3),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      dashPattern: const [14, 5],
                      padding: _focus.hasFocus
                          ? const EdgeInsets.all(10)
                          : const EdgeInsets.all(0),
                      color: _focus.hasFocus
                          ? Colors.deepOrange[200]!
                          : Colors.transparent,
                      radius: const Radius.circular(12),
                      strokeWidth: 1,
                      child: TextFormField(
                        textAlign: textAlign,
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
                        style: textStyle,
                        decoration: InputDecoration(
                            suffixIcon: _focus.hasFocus
                                ?
                                //  Column(
                                //     crossAxisAlignment: CrossAxisAlignment.end,
                                //     children: [
                                //       InkWell(
                                //         onTap: () => widget.onChanged(_controller.text),
                                //         child: const Icon(
                                //           Icons.done,
                                //           size: 15,
                                //         ),
                                //       ),
                                //       const SizedBox(height: 35),
                                //       InkWell(
                                //         onTap: () {},
                                //         child: const Icon(
                                //           Icons.remove_circle_outline,
                                //           size: 15,
                                //         ),
                                //       ),
                                //     ],
                                //   )
                                null
                                : null,
                            border: InputBorder.none,
                            hintText: '...',
                            hintStyle: AppFonts.hint),
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
        ),
        _focus.hasFocus
            ? Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.tag,
                          color: Colors.black54,
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.format_align_center_sharp,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 15),
                            Icon(
                              Icons.text_fields,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 15),
                            Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
