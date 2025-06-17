import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BackgroundCaptureWidget extends StatefulWidget {
  const BackgroundCaptureWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.backgroundKey,
      this.intialPosition});

  final double width, height;
  final GlobalKey backgroundKey;
  final Offset? intialPosition;

  @override
  State<BackgroundCaptureWidget> createState() =>
      _BackgroundCaptureWidgetState();
}

class _BackgroundCaptureWidgetState extends State<BackgroundCaptureWidget> {
  late Offset position;

  bool isCapturing = false;
  ui.Image? capturedBackground;

  @override
  void initState() {
    position = widget.intialPosition ?? Offset(100, 100);
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      _captureBackground();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Now the goal is to capture what inder the box
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: SizedBox.square(),
        onDragUpdate: (details) {
          setState(() {
            position = position + details.delta;
          });
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          // not working, because we need to call our capture image function
          child: RawImage(
            image: capturedBackground,
            width: widget.width,
            height: widget.height,
          ),
        ),
      ),
    );
  }

  // Now we will create a function that capture the bg
  Future<void> _captureBackground() async {
    if (isCapturing || !mounted) return;

    isCapturing = true;
    try {
      // Step 1: get the RenderRepaintBoundary
      final boundary = widget.backgroundKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      final ourBox = context.findRenderObject() as RenderBox?;

      if (boundary == null ||
          !boundary.attached ||
          ourBox == null ||
          !ourBox.hasSize) {
        return;
      }

      // Step 2: We calculate the capture region
      final boundaryBox = boundary as RenderBox;

      if (!boundaryBox.hasSize) return;

      final widgetRectInBoundary = Rect.fromPoints(
        boundaryBox.globalToLocal(ourBox.globalToLocal(Offset.zero)),
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

      if (regionToCapture.isEmpty) return;

      // Finally, lets get the background
      final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final OffsetLayer offsetLayer = boundary.debugLayer as OffsetLayer;

      final ui.Image croppedImage =
          await offsetLayer.toImage(regionToCapture, pixelRatio: pixelRatio);
// Let's see if it's able to capture the background
      if (mounted) {
        setState(() {
          capturedBackground?.dispose();
          capturedBackground = croppedImage;
        });
      } else {
        capturedBackground?.dispose();
      }
    } catch (e) {
      debugPrint("error capturing background: $e");
    } finally {
      if (mounted) {
        isCapturing = false;
      }
    }
  }
}
