import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:liquid_glass/base_shader.dart';

// Last thing we need to do is, apply this shader to our container, how?
// Let's do it

class LiquideGlassLensShader extends BaseShader {
  LiquideGlassLensShader()
      : super(shaderAssetPath: "shaders/liquid_glass_lens.frag");

  @override
  void updateShaderUniforms({
    required double width,
    required double height,
    required ui.Image? backgroundImage,
  }) {
    if (!isLoaded) return;

    // Now we pass the peramiter

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

    // Future we will chnage the values to see how it effect

    // Last, Set background texture (sampler index 0)

    if (backgroundImage != null) {
      try {
        shader.setImageSampler(0, backgroundImage);
      } catch (e) {
        debugPrint("Error on set shader image: $e");
      }
    }
  }
}
