import 'package:flutter/material.dart';

void main() {
  runApp(const TestPagesApp());
}

class TestPagesApp extends StatelessWidget {
  const TestPagesApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: TestSlidePage(),
    );
  }
}

class TestSlidePage extends StatefulWidget {
  const TestSlidePage({Key? key}) : super(key: key);

  @override
  State<TestSlidePage> createState() => _TestSlidePageState();
}

class _TestSlidePageState extends State<TestSlidePage>
    with SingleTickerProviderStateMixin {
  final PageController pageController = PageController();

  late AnimationController animationController;
  late Animation<Color?> animation;

  final List<TweenSequenceItem<Color?>> colors = [
    TweenSequenceItem(
      weight: 1.0,
      tween:
          ColorTween(begin: Colors.redAccent[200], end: Colors.blueAccent[200]),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
          begin: Colors.blueAccent[200], end: Colors.greenAccent[200]),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
          begin: Colors.greenAccent[200], end: Colors.yellowAccent[200]),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
          begin: Colors.yellowAccent[200], end: Colors.redAccent[200]),
    ),
  ];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = TweenSequence<Color?>(colors).animate(animationController)
      ..addListener(() {});
  }

  final List<Widget> pages = [
    Container(
      // color: Colors.yellowAccent[100],
      color: Colors.redAccent[100],
      child: const Center(
        child: Text('0'),
      ),
    ),
    Container(
      color: Colors.redAccent[100],
      child: const Center(
        child: Text('1'),
      ),
    ),
    Container(
      color: Colors.blueAccent[100],
      child: const Center(
        child: Text('2'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return PageView.builder(
            itemCount: colors.length,
            physics: const PageScrollPhysics(),
            controller: pageController,
            itemBuilder: (context, index) {
              return Container(
                color: animation.value,
                child: Center(
                  child: Text(
                    index.toString(),
                  ),
                ),
              );
            },
            onPageChanged: ((int index) {
              animationController.animateTo(index / colors.length);
            }),
          );
        },
      ),
    );
  }
}
