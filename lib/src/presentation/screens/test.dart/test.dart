import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

List<AlicePage> data = const [
  AlicePage(text: '0'),
  AlicePage(text: '1'),
  AlicePage(text: '2'),
  AlicePage(text: '3'),
  AlicePage(text: '4'),
  AlicePage(text: '5'),
  AlicePage(text: '6'),
  AlicePage(text: '7'),
  AlicePage(text: '8'),
  AlicePage(text: '9'),
  AlicePage(text: '10'),
  AlicePage(text: '11'),
  AlicePage(text: '12'),
  AlicePage(text: '13'),
  AlicePage(text: '14'),
  AlicePage(text: '15'),
  AlicePage(text: '16'),
  AlicePage(text: '17'),
  AlicePage(text: '18'),
  AlicePage(text: '19'),
  AlicePage(text: '20'),
];

void main() {
  runApp(const TestPagesApp());
}

class TestPagesApp extends StatelessWidget {
  const TestPagesApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: PagesController(data: data),
    );
  }
}

class PagesController extends StatefulWidget {
  final List<AlicePage> data;
  const PagesController({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State<PagesController> createState() => _PagesControllerState();
}

class _PagesControllerState extends State<PagesController> {
  final int _first = 0;
  final int _middle = 1;
  final int _last = 2;

  bool onNextRebuild = false;
  bool onPreviousRebuild = false;

  List<PageTurnWidget> widgets = [];
  List<GlobalObjectKey<_PageTurnWidgetState>> states = [];
  GlobalObjectKey<_PageTurnWidgetState>? activePage;
  int dataPageIndex = 0;

  double direction = 0.0;
  int sensitivity = 5;

  @override
  void initState() {
    super.initState();
    _initChildren();
  }

  void _initChildren() {
    print('init children');
    for (var i = dataPageIndex; i < 3; i++) {
      GlobalObjectKey<_PageTurnWidgetState> key = GlobalObjectKey(i);
      AlicePage page = widget.data[i];
      widgets.add(
        PageTurnWidget(
          key: key,
          backgroundColor: Colors.white,
          child: page,
        ),
      );
      states.add(key);
    }
    setState(() {
      widgets = widgets.reversed.toList();
      states = states.reversed.toList();
    });
  }

  @override
  void didUpdateWidget(PagesController oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateW');
  }

  void printData() {
    for (var i = 0; i < states.length; i++) {
      print('$i state - ${states[i]}');
    }

    for (var i = 0; i < widgets.length; i++) {
      print('$i key - ${widgets[i]}');
    }
  }

  Future<void> next() async {
    if (dataPageIndex < widget.data.length - 1) {
      states[_last].currentState!.back().then((value) {
        var last = states[_last];
        var lastKey = widgets[_last];
        states.removeAt(_last);
        states.insert(_first, last);
        widgets.removeAt(_last);
        widgets.insert(_first, lastKey);
        //
        dataPageIndex++;
        _addNextPage();
        setState(() {});
      });
    }
  }

  void _addNextPage() {
    GlobalObjectKey<_PageTurnWidgetState> key =
        GlobalObjectKey(dataPageIndex + 1);
    AlicePage page = widget.data[dataPageIndex + 1];
    PageTurnWidget _page =
        PageTurnWidget(key: key, backgroundColor: Colors.white, child: page);
    _replace(_middle, key, _page);
  }

  void _addPreviousPage() {
    GlobalObjectKey<_PageTurnWidgetState> key =
        GlobalObjectKey(dataPageIndex - 1);
    AlicePage page = widget.data[dataPageIndex - 1];
    final PageTurnWidget _page = PageTurnWidget(
      key: key,
      backgroundColor: Colors.white,
      child: page,
      amount: 0.0,
    );
    _replace(_first, key, _page);
  }

  void _replace(
    int pos,
    GlobalObjectKey<_PageTurnWidgetState> key,
    PageTurnWidget page,
  ) {
    states.removeAt(pos);
    states.insert(pos, key);
    widgets.removeAt(pos);
    widgets.insert(pos, page);
  }

  Future<void> previous() async {
    if (dataPageIndex > 0) {
      var last = states[_last];
      var middle = states[_middle];
      var first = states[_first];
      var lastKey = widgets[_last];
      var middleKey = widgets[_middle];
      var firstKey = widgets[_first];
      _replace(_last, first, firstKey);
      _replace(_middle, last, lastKey);
      _replace(_first, middle, middleKey);
      setState(() {});
      states[_last].currentState!.forward().then((value) {
        dataPageIndex--;
        _addPreviousPage();
        setState(() {});
      });
    }
  }

  void _determineDirection(DragEndDetails details) {
    if (direction > sensitivity) previous();
    if (direction < -sensitivity) next();
  }

  void _updateDirection(DragUpdateDetails details) {
    _changeValue(details.globalPosition.dx * 0.01);
    if (details.delta.dx > sensitivity) {
      setState(() {
        direction = details.delta.dx;
      });
    } else if (details.delta.dx < -sensitivity) {
      setState(() {
        direction = details.delta.dx;
      });
    }
  }

  Widget _buildFloating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 250),
        FloatingActionButton(
          onPressed: () async => previous(),
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
          ),
        ),
        FloatingActionButton(
          onPressed: () async => next(),
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.arrow_forward_ios_sharp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _changeValue(double value) {
    states.last.currentState!._controller!.value = value / 3.8;
    // states.last.currentState!._controller!.value = value.abs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _buildFloating(),
      body: GestureDetector(
        onHorizontalDragUpdate: _updateDirection,
        onHorizontalDragEnd: _determineDirection,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Stack(
            fit: StackFit.expand,
            children: widgets,
          ),
        ),
      ),
    );
  }
}

class AlicePage extends StatelessWidget {
  final String text;
  const AlicePage({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(fontSize: 16.0),
      child: SafeArea(
        bottom: false,
        // top: false,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "CHAPTER ${text}",
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Down the Rabbit-Hole",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                          "Alice was beginning to get very tired of sitting by her sister on the bank, and of"
                          " having nothing to do: once or twice she had peeped into the book her sister was "
                          "reading, but it had no pictures or conversations in it, `and what is the use of "
                          "a book,' thought Alice `without pictures or conversation?'"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12.0),
                      color: Colors.black26,
                      width: 160.0,
                      height: 220.0,
                      child: const Placeholder(),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text(
                    "So she was considering in her own mind (as well as she could, for the hot day made her "
                    "feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be "
                    "worth the trouble of getting up and picking the daisies, when suddenly a White "
                    "Rabbit with pink eyes ran close by her.\n"
                    "\n"
                    // "There was nothing so very remarkable in that; nor did Alice think it so very much out "
                    // "of the way to hear the Rabbit say to itself, `Oh dear! Oh dear! I shall be "
                    // "late!' (when she thought it over afterwards, it occurred to her that she ought to "
                    // "have wondered at this, but at the time it all seemed quite natural); but when the "
                    // "Rabbit actually took",
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageTurnWidget extends StatefulWidget {
  const PageTurnWidget({
    required Key key,
    required this.backgroundColor,
    required this.child,
    this.amount,
  }) : super(key: key);

  final Color backgroundColor;
  final Widget child;
  final double? amount;

  @override
  _PageTurnWidgetState createState() => _PageTurnWidgetState();
}

class _PageTurnWidgetState extends State<PageTurnWidget>
    with SingleTickerProviderStateMixin {
  final _boundaryKey = GlobalKey();
  AnimationController? _controller;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    print('inited ${widget.key}');
    _controller = AnimationController(
      value: 1.0,
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    widget.amount != null ? _controller!.value = widget.amount! : 1.0;
  }

  @override
  void dispose() {
    print('disposed ${widget.key}');
    _controller?.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller?.status == AnimationStatus.dismissed ||
        _controller?.status == AnimationStatus.reverse) {
      _controller?.forward();
    } else {
      _controller?.reverse();
    }
  }

  Future<bool> forward() async {
    if (_controller?.status == AnimationStatus.dismissed ||
        _controller?.status == AnimationStatus.reverse) {
      await _controller?.forward();
    }
    return Future.value(true);
  }

  Future<bool> back() async {
    await _controller?.reverse();
    return Future.value(true);
  }

  @override
  void didUpdateWidget(PageTurnWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _image = null;
    }
  }

  void _captureImage(Duration timeStamp) async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final boundary = _boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio - 1);
    setState(() => _image = image);
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return CustomPaint(
        painter: _PageTurnEffect(
          amount: _controller!,
          image: _image!,
          backgroundColor: widget.backgroundColor,
        ),
        size: Size.infinite,
      );
    } else {
      WidgetsBinding.instance?.addPostFrameCallback(_captureImage);
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final size = constraints.biggest;
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: 1 + size.width,
                top: 1 + size.height,
                width: size.width,
                height: size.height,
                child: RepaintBoundary(
                  key: _boundaryKey,
                  child: widget.child,
                ),
              ),
            ],
          );
        },
      );
    }
  }
}

class _PageTurnEffect extends CustomPainter {
  final Animation<double> amount;
  final ui.Image image;
  final Color backgroundColor;
  final double radius;

  _PageTurnEffect({
    required this.amount,
    required this.image,
    required this.backgroundColor,
    this.radius = 0.32,
  }) : super(repaint: amount);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final pos = amount.value;
    final movX = (1.0 - pos) * 0.85;
    final calcR = (movX < 0.20) ? radius * movX * 5 : radius;
    final wHRatio = 1 - calcR;
    final hWRatio = image.height / image.width;
    final hWCorrection = (hWRatio - 1.0) / 2.0;

    final w = size.width.toDouble() - 0; // Padding?
    final h = size.height.toDouble() - 0; // Padding?
    final c = canvas;
    final shadowXf = (wHRatio - movX);
    final shadowSigma =
        Shadow.convertRadiusToSigma(8.0 + (2.0 * (1.0 - shadowXf)));

    final ip = Paint();
    for (double x = 0; x < size.width; x++) {
      final xf = (x / w);
      final v = (calcR * (math.sin(math.pi / 0.5 * (xf - (1.0 - pos)))) +
          (calcR * 1.1));
      final xv = (xf * wHRatio) - movX;
      final sx = (xf * image.width);
      final sr = Rect.fromLTRB(sx, 0.0, sx + 1.0, image.height.toDouble());
      final yv = ((h * calcR * movX) * hWRatio) - hWCorrection;
      final ds = (yv * v);
      //
      /// 0 -> 2 -> N bigger shadow
      // final pageRect = Rect.fromLTRB(0.0, 0.0, w * shadowXf, h);
      final pageRect = Rect.fromLTRB(xv * w, 0.0 + 45, xv * w + 60.0, h + ds);
      // c.drawRect(pageRect, Paint()..color = backgroundColor);
      c.drawRect(pageRect, Paint()..color = Colors.black.withOpacity(0.005)
          // ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10),
          );
      //
      final dr = Rect.fromLTRB(xv * w, 0.0 - ds, xv * w + 1.0, h + ds); // ?
      c.drawImageRect(image, sr, dr, ip);
    }
  }

  @override
  bool shouldRepaint(_PageTurnEffect oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.amount.value != amount.value;
  }
}
