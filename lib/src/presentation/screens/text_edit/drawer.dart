import 'package:flutter/material.dart';

enum Patterns { arrow, star, circle }

class LinesPainter extends CustomPainter {
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
    canvas.drawLine(Offset.zero, Offset(_length, 0), paint);
    canvas.drawPath(getTrianglePath(size.width, size.height, _length), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadialPainter extends CustomPainter {
  final double progressRemoval;
  final Color color;
  final StrokeCap strokeCap;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final double progress;
  RadialPainter(
      {required this.progressRemoval,
      required this.color,
      required this.strokeWidth,
      required this.strokeCap,
      required this.paintingStyle,
      required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..style = paintingStyle
      ..strokeCap = strokeCap;

    var progressRemoval = 0.50;

    var path = Path();

    //LINEA SUPERIOR DEL CUADRADO
    path.moveTo((size.width * 0.30), 0);
    path.quadraticBezierTo((size.width * 0.30), 0, size.width, 0);

    //LATERAL DERECHO
    path.moveTo(size.width, 0);
    path.quadraticBezierTo(size.width, 0, size.width, size.height);

    //LINEA INFERIOR DEL CUADRADO
    path.moveTo(size.width, size.height);
    path.quadraticBezierTo(size.width, size.height, 0, size.height);

    //LINEA IZQUIERDA
    path.moveTo(0, size.height);
    path.quadraticBezierTo(0, (size.height * 0.75), 0, ((size.height * 0.75)));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(RadialPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

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
