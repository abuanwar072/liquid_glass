import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_glass/base_shader.dart';
import 'package:liquid_glass/shader_painter.dart';

class BackgroundCaptureWidget extends StatefulWidget {
  const BackgroundCaptureWidget({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.shader,
    this.initialPosition,
    // this.captureInterval = const Duration(milliseconds: 8),
    this.backgroundKey,
  });

  final Widget child;
  final double width;
  final double height;

  final Offset? initialPosition;
  // final Duration? captureInterval;
  final GlobalKey? backgroundKey;

  final BaseShader shader;

  @override
  State<BackgroundCaptureWidget> createState() =>
      _BackgroundCaptureWidgetState();
}

class _BackgroundCaptureWidgetState extends State<BackgroundCaptureWidget>
    with TickerProviderStateMixin {
  late Offset position;
  Timer? timer;
  bool isCapturing = false;
  ui.Image? capturedBackground;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition ?? const Offset(100, 100);

    _startContinuousCapture();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureBackground();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    capturedBackground?.dispose();
    super.dispose();
  }

  void _startContinuousCapture() {
    // if (widget.captureInterval != null) {
    //   timer = Timer.periodic(widget.captureInterval!, (timer) {
    //     if (mounted && !isCapturing) {
    //       _captureBackground();
    //     }
    //   });
    // }
    // if (mounted && !isCapturing) {
    //   _captureBackground();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final Widget child = SizedBox(
    //   width: widget.width,
    //   height: widget.height,
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(6),
    //     child: _buildWidgetContent(),
    //   ),
    // );

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: SizedBox.square(),
        // childWhenDragging: child,
        onDragUpdate: (details) {
          setState(() {
            position = position + details.delta;
          });

          if (!isCapturing) {
            _captureBackground();
          }
        },
        onDragEnd: (details) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _captureBackground();
          });
        },
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: _buildWidgetContent(),
        ),
      ),
    );
  }

  Widget _buildWidgetContent() {
    if (capturedBackground != null) {
      widget.shader.updateShaderUniforms(
        width: widget.width,
        height: widget.height,
        backgroundImage: capturedBackground,
      );
      return CustomPaint(
        size: Size(widget.width, widget.height),
        painter: ShaderPainter(widget.shader.shader),
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          child: RawImage(
            width: widget.width,
            height: widget.height,
            image: capturedBackground,
          ),
        ),
      );
      return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: CustomPaint(
          size: Size(widget.width, widget.height),
          painter: ShaderPainter(widget.shader.shader),
          child: widget.child,
        ),
      );
    }

    // Fallback to normal child
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: ClipOval(child: widget.child),
    );
  }

  Future<void> _captureBackground() async {
    if (isCapturing || !mounted) return;

    isCapturing = true;

    try {
      // 1. Get the RenderRepaintBoundary
      final boundary = widget.backgroundKey?.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      final ourBox = context.findRenderObject() as RenderBox?;

      if (boundary == null ||
          !boundary.attached ||
          ourBox == null ||
          !ourBox.hasSize) {
        return;
      }

      // 2. Calculate the capture region
      final boundaryBox = boundary as RenderBox;
      if (!boundaryBox.hasSize || widget.width <= 0 || widget.height <= 0) {
        return;
      }

      final widgetRectInBoundary = Rect.fromPoints(
        boundaryBox.globalToLocal(ourBox.localToGlobal(Offset.zero)),
        boundaryBox.globalToLocal(
          ourBox.localToGlobal(ourBox.size.bottomRight(Offset.zero)),
        ),
      );

      final boundaryRect = Rect.fromLTWH(
        0,
        0,
        boundaryBox.size.width,
        boundaryBox.size.height,
      );
      final Rect regionToCapture = widgetRectInBoundary.intersect(boundaryRect);

      if (regionToCapture.isEmpty) {
        return;
      }

      // 3. Capture the image
      final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final OffsetLayer offsetLayer = boundary.debugLayer! as OffsetLayer;
      final ui.Image croppedImage = await offsetLayer.toImage(
        regionToCapture,
        pixelRatio: pixelRatio,
      );

      // 5. Update state
      if (mounted) {
        setState(() {
          capturedBackground?.dispose();
          capturedBackground = croppedImage;
        });
      } else {
        croppedImage.dispose();
      }
    } catch (e) {
      debugPrint('Error capturing background: $e');
    } finally {
      if (mounted) {
        isCapturing = false;
      }
    }
  }
}
