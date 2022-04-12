import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

List<AlicePage> data = const [
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
  List<PageTurnWidget> widgets = [];
  List<GlobalObjectKey<_PageTurnWidgetState>> states = [];
  GlobalObjectKey<_PageTurnWidgetState>? activePage;
  PageTurnWidget test = PageTurnWidget(
    key: UniqueKey(),
    backgroundColor: Colors.white,
    child: const AlicePage(
      text: '1',
    ),
  );
  int activeIndex = 0;

  double direction = 0.0;
  int sensitivity = 5;

  @override
  void initState() {
    super.initState();
    _initChildren();
  }

  void _initChildren() {
    for (var i = activeIndex; i < 4; i++) {
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
      activePage = states[0];
    });
  }

  void next() {
    print(
        '$activeIndex - index ${widgets.length} - length ${states.length} - length');
    if (activePage != null && activeIndex < widget.data.length - 1) {
      setState(() {
        activePage?.currentState?.back().then((value) {
          if (activeIndex - 2 >= 0) {
            states.first.currentState?.dispose();
            states.removeAt(0);
            GlobalObjectKey<_PageTurnWidgetState> key =
                GlobalObjectKey(activeIndex + 1);
            AlicePage page = widget.data[activeIndex + 1];
            widgets.add(
              PageTurnWidget(
                key: key,
                backgroundColor: Colors.white,
                child: page,
              ),
            );
            states.add(key);
            widgets.removeAt(activeIndex - 2);
          }
        });
        activeIndex++;
        activePage = states[activeIndex];
      });
    }
    print(
        '$activeIndex - index ${widgets.length} - length ${states.length} - length');
  }

  void previous() {
    if (activePage != null && activeIndex > 0) {
      setState(() {
        activeIndex--;
        activePage = states[activeIndex];
        activePage!.currentState!.forward();
      });
    }
  }

  void _determineDirection(DragEndDetails details) {
    if (direction > sensitivity) previous();
    if (direction < -sensitivity) next();
  }

  void _updateDirection(DragUpdateDetails details) {
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

  void _backStart() async {
    if (activeIndex == states.length - 1) {
      for (var i = activeIndex; i > 0; i--) {
        await Future.delayed(const Duration(milliseconds: 60)).then((value) {
          setState(() {
            activeIndex--;
            activePage = states[activeIndex];
            activePage!.currentState!.forward();
          });
        });
      }
    } else {
      for (var i = activeIndex; i < states.length - 1; i++) {
        await Future.delayed(const Duration(milliseconds: 60)).then((value) {
          setState(() {
            activePage!.currentState!.back();
            activeIndex++;
            activePage = states[activeIndex];
          });
        });
      }
    }
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      onPressed: () async => _backStart(),
      backgroundColor: Colors.deepOrange,
      child: const Icon(Icons.arrow_forward_ios_sharp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloating(),
      body: GestureDetector(
        onHorizontalDragUpdate: _updateDirection,
        onHorizontalDragEnd: _determineDirection,
        child: Stack(
          fit: StackFit.expand,
          children: widgets,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
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
                "There was nothing so very remarkable in that; nor did Alice think it so very much out "
                "of the way to hear the Rabbit say to itself, `Oh dear! Oh dear! I shall be "
                "late!' (when she thought it over afterwards, it occurred to her that she ought to "
                "have wondered at this, but at the time it all seemed quite natural); but when the "
                "Rabbit actually took",
              ),
            ],
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
  }) : super(key: key);

  final Color backgroundColor;
  final Widget child;

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
    print('inited');
    _controller = AnimationController(
      value: 1.0,
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
  }

  @override
  void dispose() {
    print('disposed');
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
    final image = await boundary.toImage(pixelRatio: pixelRatio);
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
    this.radius = 0.28,
  }) : super(repaint: amount);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final pos = amount.value;
    final movX = (1.0 - pos) * 0.85;
    final calcR = (movX < 0.20) ? radius * movX * 5 : radius;
    final wHRatio = 1 - calcR;
    final hWRatio = image.height / image.width;
    final hWCorrection = (hWRatio - 1.0) / 2.0;

    final w = size.width.toDouble();
    final h = size.height.toDouble();
    final c = canvas;
    final shadowXf = (wHRatio - movX);
    final shadowSigma =
        Shadow.convertRadiusToSigma(8.0 + (2.0 * (1.0 - shadowXf)));

    /// 2 -> 32 bigger shadow
    final pageRect = Rect.fromLTRB(0.0, 0.0, w * shadowXf, h);
    c.drawRect(pageRect, Paint()..color = backgroundColor);
    c.drawRect(
      pageRect,
      Paint()
        ..color = Colors.black54
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, shadowSigma),
    );

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
      final dr = Rect.fromLTRB(xv * w, 0.0 - ds, xv * w + 1.0, h + ds);
      c.drawImageRect(image, sr, dr, ip);
    }
  }

  @override
  bool shouldRepaint(_PageTurnEffect oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.amount.value != amount.value;
  }
}
