import 'dart:ui' as ui;
import 'package:flutter/material.dart';
// We are done

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader});

  final ui.FragmentShader shader;
  @override
  void paint(Canvas canvas, Size size) {
    try {
      final paint = Paint()..shader = shader;
      canvas.drawRect(Offset.zero & size, paint);
    } catch (e) {
      debugPrint("Error paint shader: $e");
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
