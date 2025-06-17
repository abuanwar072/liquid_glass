import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:liquid_glass/base_shader.dart';

class LiquidGlassLensShader extends BaseShader {
  LiquidGlassLensShader()
      : super(shaderAssetPath: "shaders/liquid_glass_lens.frag");

  @override
  void updateShaderUniforms({
    required double width,
    required double height,
    required ui.Image? backgroundImage,
  }) {
    if (!isLoaded) return;

    // Set resolution (indices 0-1)
    shader.setFloat(0, width);
    shader.setFloat(1, height);

    // Set mouse position (indices 2-3)
    shader.setFloat(2, width / 2);
    shader.setFloat(3, height / 2);

    // Set effect size (index 4)
    shader.setFloat(4, 5.0);

    // Set blur intensity (index 5)
    shader.setFloat(5, 0);

    // Set dispersion strength (index 6)
    shader.setFloat(6, 0.4);

    // Set background texture (sampler index 0)
    if (backgroundImage != null &&
        backgroundImage.width > 0 &&
        backgroundImage.height > 0) {
      try {
        shader.setImageSampler(0, backgroundImage);
      } catch (e) {
        debugPrint('Error setting background texture: $e');
      }
    }

    // Set resolution (indices 0-1)

    // Set mouse position (indices 2-3)

    // Set effect size (index 4)

    // Set blur intensity (index 5)

    // Set dispersion strength (index 6)

    // Set background texture (sampler index 0)
  }
}
