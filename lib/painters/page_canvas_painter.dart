import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../models/page_border_config.dart';
import '../models/watermark_config.dart';

class PageCanvasPainter extends CustomPainter {
  final PageBorderConfig borderConfig;
  final WatermarkConfig watermarkConfig;
  final ui.Image? watermarkImage;

  PageCanvasPainter({
    required this.borderConfig,
    required this.watermarkConfig,
    this.watermarkImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. رسم لون خلفية الصفحة
    final bgPaint = Paint()..color = borderConfig.backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. رسم الإطار الخارجي والداخلي
    if (borderConfig.isEnabled) {
      final RRect outerRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderConfig.cornerRadius),
      );
      final outerPaint = Paint()
        ..color = borderConfig.outerBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderConfig.outerBorderWidth;
      canvas.drawRRect(outerRect, outerPaint);

      // رسم الإطار الداخلي بحساب المسافة الفاصلة (Spacing)
      final double inset = borderConfig.outerBorderWidth + borderConfig.spacing;
      if (size.width > inset * 2 && size.height > inset * 2) {
        final RRect innerRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            inset,
            inset,
            size.width - (inset * 2),
            size.height - (inset * 2),
          ),
          Radius.circular(math.max(0, borderConfig.cornerRadius - inset)),
        );
        final innerPaint = Paint()
          ..color = borderConfig.innerBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderConfig.innerBorderWidth;
        canvas.drawRRect(innerRect, innerPaint);
      }
    }

    // 3. رسم العلامة المائية في منتصف الصفحة
    if (watermarkConfig.isEnabled && watermarkImage != null) {
      canvas.save();

      final double centerX = size.width / 2;
      final double centerY = size.height / 2;
      canvas.translate(centerX, centerY);
      canvas.rotate(watermarkConfig.rotationDegree * math.pi / 180);

      // حساب العرض المباشر
      double drawWidth = size.shortestSide * watermarkConfig.sizePercentage;
      if (drawWidth < watermarkConfig.minDp) drawWidth = watermarkConfig.minDp;
      if (drawWidth > watermarkConfig.maxDp) drawWidth = watermarkConfig.maxDp;

      final double aspectRatio = watermarkImage!.height / watermarkImage!.width;
      final double drawHeight = drawWidth * aspectRatio;

      final watermarkPaint = Paint()
        ..colorFilter = ColorFilter.mode(
          Colors.white.withOpacity(watermarkConfig.opacity),
          BlendMode.modulate,
        );

      final Rect targetRect = Rect.fromCenter(
        center: Offset.zero,
        width: drawWidth,
        height: drawHeight,
      );

      canvas.drawImageRect(
        watermarkImage!,
        Rect.fromLTWH(
          0,
          0,
          watermarkImage!.width.toDouble(),
          watermarkImage!.height.toDouble(),
        ),
        targetRect,
        watermarkPaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant PageCanvasPainter oldDelegate) => true;
}
