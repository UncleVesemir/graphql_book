import 'package:flutter/material.dart';

enum Painters { arrow, star, circle }

class SymbolsPainter extends CustomPainter {
  Path getTrianglePath(double x, double y, double start) {
    double height = 20;
    return Path()
      ..moveTo(start, 0)
      ..lineTo(start, height)
      ..lineTo(start + height, 0)
      ..lineTo(start, 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const double _length = 40;
    final paint = Paint()..strokeWidth = 1;
    // canvas.drawLine(Offset.zero, Offset(_length, 0), paint);
    // canvas.drawPath(getTrianglePath(size.width, size.height, _length), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UpdatedText extends StatelessWidget {
  final Widget child;
  const UpdatedText({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SymbolsPainter(),
      child: child,
    );
  }
}
