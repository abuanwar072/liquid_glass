import 'dart:ui' as ui;

import 'package:liquid_glass/base_shader.dart';

class LiquidGlassLensShader extends BaseShader {
  LiquidGlassLensShader() : super(shaderAssetPath: '');

  @override
  void updateShaderUniforms({
    required double width,
    required double height,
    required ui.Image? backgroundImage,
  }) {
    // Set resolution (indices 0-1)

    // Set mouse position (indices 2-3)

    // Set effect size (index 4)

    // Set blur intensity (index 5)

    // Set dispersion strength (index 6)

    // Set background texture (sampler index 0)
  }
}
