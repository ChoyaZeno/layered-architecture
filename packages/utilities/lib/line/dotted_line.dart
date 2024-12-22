import 'package:flutter/material.dart';

class DottedLineBoxDecoration extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DottedLineBoxPainter();
  }
}

class _DottedLineBoxPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final max = configuration.size?.width ?? 0;
    const dashWidth = 5;
    const dashSpace = 5;
    double startX = offset.dx;

    while (startX < max) {
      canvas.drawLine(Offset(startX, configuration.size!.height + offset.dy),
          Offset(startX + dashWidth, configuration.size!.height + offset.dy), paint);
      startX += dashWidth + dashSpace;
    }
  }
}