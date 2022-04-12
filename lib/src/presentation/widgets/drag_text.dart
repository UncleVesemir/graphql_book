import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/model.dart';
import 'package:graphql_book/src/presentation/styles/fonts.dart';
import 'package:graphql_book/src/presentation/utils/utils.dart';

class DraggableTextWidget extends StatefulWidget {
  final DraggableListItem? item;
  final DraggableList? list;
  final Function(Key key) onAddText;
  final Function(Key key) onAddImage;
  final Function(DraggableListItem item)? onChangedItem;
  final Function(DraggableList list)? onChangedList;
  final Function(Key key) onDelete;
  final bool isHeader;
  const DraggableTextWidget({
    required this.onAddText,
    required this.onAddImage,
    this.list,
    this.item,
    this.isHeader = false,
    required this.onDelete,
    this.onChangedItem,
    this.onChangedList,
    required Key key,
  }) : super(key: key);

  @override
  State<DraggableTextWidget> createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  late TextAlign textAlign;
  late FontWeight textWeight;
  late bool isAttached;

  int selectedAlign = 0;
  final List<TextAlign> _textAligns = [
    TextAlign.center,
    TextAlign.left,
    TextAlign.right,
    TextAlign.justify,
  ];

  int selectedWeight = 0;
  final List<FontWeight> _textWeights = [
    FontWeight.w200,
    FontWeight.w400,
    FontWeight.w600,
    FontWeight.w800,
  ];

  late TextStyle textStyle;
  Color backgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    textStyle = widget.isHeader ? AppFonts.header : AppFonts.item;
    _initText();
    _controller.addListener(() {});
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _controller.dispose();
    super.dispose();
  }

  void _initText() {
    if (widget.item != null) {
      isAttached = widget.item!.isBookmarked;
      if (widget.item!.text != '...') _controller.text = widget.item!.text;
      if (widget.item!.fontWeight != null) {
        selectedWeight = _textWeights
            .indexWhere((element) => element == widget.item!.fontWeight);
      } else {
        selectedWeight = 1;
      }
      textWeight = _textWeights[selectedWeight];

      if (widget.item!.alignment != null) {
        selectedAlign = _textAligns
            .indexWhere((element) => element == widget.item!.alignment);
        textAlign = _textAligns[selectedAlign];
      } else {
        selectedAlign = 1;
        textAlign = _textAligns[selectedAlign];
      }
    }
    if (widget.list != null) {
      isAttached = widget.list!.isAttached;
      _controller.text = widget.list!.header;
      if (widget.list!.fontWeight != null) {
        selectedWeight = _textWeights
            .indexWhere((element) => element == widget.list!.fontWeight);
      } else {
        selectedWeight = 3;
      }
      textWeight = _textWeights[selectedWeight];
      if (widget.list!.alignment != null) {
        selectedAlign = _textAligns
            .indexWhere((element) => element == widget.list!.alignment);
      } else {
        selectedAlign = 0;
      }
      textAlign = _textAligns[selectedAlign];
    }
  }

  void _changeAlign() {
    setState(() {
      if (selectedAlign < _textAligns.length - 1) {
        selectedAlign++;
      } else {
        selectedAlign = 0;
      }
      textAlign = _textAligns[selectedAlign];
    });
  }

  void _changeWeight() {
    setState(() {
      if (selectedWeight < _textWeights.length - 1) {
        selectedWeight++;
      } else {
        selectedWeight = 0;
      }
      textWeight = _textWeights[selectedWeight];
    });
  }

  Icon _getAlignIcon() {
    switch (selectedAlign) {
      case 0:
        return const Icon(
          Icons.format_align_center_sharp,
          color: Colors.black54,
          size: 15,
        );
      case 1:
        return const Icon(
          Icons.format_align_left_sharp,
          color: Colors.black54,
          size: 15,
        );
      case 2:
        return const Icon(
          Icons.format_align_right_sharp,
          color: Colors.black54,
          size: 15,
        );
      case 3:
        return const Icon(
          Icons.format_align_justify_sharp,
          color: Colors.black54,
          size: 15,
        );
      default:
        return const Icon(
          Icons.format_align_center_sharp,
          color: Colors.black54,
          size: 15,
        );
    }
  }

  Icon _getWeightIcon() {
    switch (selectedWeight) {
      case 0:
        return const Icon(
          Icons.text_fields,
          color: Colors.black38,
          size: 15,
        );
      case 1:
        return const Icon(
          Icons.text_fields,
          color: Colors.black45,
          size: 15,
        );
      case 2:
        return const Icon(
          Icons.text_fields,
          color: Colors.black54,
          size: 15,
        );
      case 3:
        return const Icon(
          Icons.text_fields,
          color: Colors.black87,
          size: 15,
        );
      default:
        return const Icon(
          Icons.text_fields,
          color: Colors.black38,
          size: 15,
        );
    }
  }

  void _attach() => setState(() => isAttached = !isAttached);

  void _onChanged({bool? attach}) {
    if (widget.isHeader) {
      widget.onChangedList!(
        widget.list!.copyWith(
          header: _controller.text,
          alignment: textAlign,
          fontWeight: textWeight,
          isAttached: attach != null
              ? isAttached != attach
                  ? attach
                  : false
              : isAttached,
        ),
      );
    } else {
      widget.onChangedItem!(
        widget.item!.copyWith(
          text: _controller.text,
          alignment: textAlign,
          fontWeight: textWeight,
          isAttached: attach != null
              ? isAttached != attach
                  ? attach
                  : false
              : isAttached,
        ),
      );
    }
  }

  void _onFocusChange() {
    if (!_focus.hasFocus) _onChanged();
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
        onPressed: (ctx) => _onChanged(),
        backgroundColor: Colors.deepOrange[200]!,
        foregroundColor: Colors.white,
        icon: Icons.star,
        label: isAttached ? 'Remove' : 'Favorite',
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
                foregroundColor: Colors.white,
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
                    onDismissed: () => _onChanged(attach: true),
                  )
                : null,
            children: widget.isHeader ? _headerActions() : _itemsActions(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    isAttached
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              width: 3,
                              color: Colors.deepOrange,
                            ),
                          )
                        : Container(),
                    Flexible(
                      flex: isAttached ? 7 : 8,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 3, bottom: 3, top: 3, right: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // color: Colors.white,
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
                              style: textStyle.copyWith(fontWeight: textWeight),
                              decoration: InputDecoration(
                                  suffixIcon: _focus.hasFocus
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: _attach,
                                              child: Icon(
                                                Icons.attach_file_sharp,
                                                color: isAttached
                                                    ? Colors.deepOrange
                                                    : Colors.black54,
                                                size: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            InkWell(
                                              onTap: _changeAlign,
                                              child: _getAlignIcon(),
                                            ),
                                            const SizedBox(height: 15),
                                            InkWell(
                                                onTap: _changeWeight,
                                                child: _getWeightIcon()),
                                            const SizedBox(height: 15),
                                            InkWell(
                                              onTap: _onChanged,
                                              child: Icon(
                                                Icons.done,
                                                color:
                                                    Colors.orangeAccent[200]!,
                                                size: 15,
                                              ),
                                            ),
                                          ],
                                        )
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
              widget.item != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        PresentationUtils.getFormattedTime(widget.item!.time),
                        style: AppFonts.time,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
