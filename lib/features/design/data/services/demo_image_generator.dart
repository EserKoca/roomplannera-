import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Generates demo design images locally without any API key.
/// Creates beautiful gradient-based room mockups with overlay text.
class DemoImageGenerator {
  static final _random = Random();

  /// Style-specific color palettes for demo images
  static const Map<String, List<List<int>>> _styleColors = {
    'modern': [[74, 105, 189], [30, 60, 114]],
    'minimalist': [[245, 237, 225], [200, 180, 160]],
    'scandinavian': [[230, 218, 200], [180, 160, 140]],
    'industrial': [[80, 80, 90], [40, 45, 55]],
    'bohemian': [[ 210, 120, 70], [180, 80, 60]],
    'classic': [[160, 130, 100], [100, 80, 60]],
    'japanese': [[140, 170, 130], [90, 130, 80]],
    'art_deco': [[200, 170, 100], [160, 130, 60]],
    'mid_century': [[200, 120, 80], [180, 100, 60]],
    'coastal': [[130, 200, 220], [80, 160, 190]],
    'rustic': [[170, 140, 110], [120, 100, 80]],
    'tropical': [[100, 190, 120], [60, 150, 80]],
    'contemporary': [[130, 140, 160], [90, 100, 120]],
    'traditional': [[150, 120, 100], [110, 90, 70]],
    'farmhouse': [[220, 210, 195], [190, 180, 160]],
  };

  /// Generate a demo design image and save it locally.
  /// Returns the local file path.
  static Future<String> generateDemoImage({
    required String styleId,
    required String styleName,
    required String roomTypeName,
    required String designId,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/design_$designId.png';

    // Create a gradient image with style info
    final colors = _styleColors[styleId] ?? [[150, 150, 150], [100, 100, 100]];
    final c1 = colors[0];
    final c2 = colors[1];

    // Create image using picture recorder
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 1024, 1024));

    // Draw gradient background
    final gradientPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(1024, 1024),
        [
          Color.fromARGB(255, c1[0], c1[1], c1[2]),
          Color.fromARGB(255, c2[0], c2[1], c2[2]),
        ],
      );
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1024, 1024), gradientPaint);

    // Draw decorative elements
    _drawDecorativeElements(canvas, c1, c2);

    // Draw room icon placeholder
    _drawRoomPlaceholder(canvas);

    // Draw style label
    _drawLabel(canvas, styleName, roomTypeName);

    // Convert to image
    final picture = recorder.endRecording();
    final image = await picture.toImage(1024, 1024);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to generate demo image');
    }

    // Save to file
    final file = File(filePath);
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return filePath;
  }

  static void _drawDecorativeElements(Canvas canvas, List<int> c1, List<int> c2) {
    final paint = Paint()
      ..color = Color.fromARGB(30, 255, 255, 255)
      ..style = PaintingStyle.fill;

    // Draw decorative circles
    for (int i = 0; i < 5; i++) {
      final x = _random.nextDouble() * 1024;
      final y = _random.nextDouble() * 1024;
      final radius = 50 + _random.nextDouble() * 200;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw some geometric lines
    final linePaint = Paint()
      ..color = Color.fromARGB(15, 255, 255, 255)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final y = 100.0 + i * 120;
      canvas.drawLine(
        Offset(50, y),
        Offset(974, y + _random.nextDouble() * 30),
        linePaint,
      );
    }

    // Draw furniture-like rectangles
    final furniturePaint = Paint()
      ..color = Color.fromARGB(20, 0, 0, 0)
      ..style = PaintingStyle.fill;

    // "Sofa" rectangle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(180, 600, 664, 180),
        const Radius.circular(20),
      ),
      furniturePaint,
    );

    // "Table" rectangle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(350, 480, 324, 100),
        const Radius.circular(12),
      ),
      furniturePaint..color = Color.fromARGB(15, 0, 0, 0),
    );

    // "Window" rectangle
    final windowPaint = Paint()
      ..color = Color.fromARGB(25, 255, 255, 255)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(300, 80, 424, 300),
        const Radius.circular(8),
      ),
      windowPaint,
    );
  }

  static void _drawRoomPlaceholder(Canvas canvas) {
    // Central design icon
    final iconPaint = Paint()
      ..color = Color.fromARGB(60, 255, 255, 255)
      ..style = PaintingStyle.fill;

    // Diamond shape in center
    final path = Path()
      ..moveTo(512, 380)
      ..lineTo(562, 430)
      ..lineTo(512, 480)
      ..lineTo(462, 430)
      ..close();
    canvas.drawPath(path, iconPaint);

    // Sparkle dots
    final sparklePaint = Paint()
      ..color = Color.fromARGB(80, 255, 255, 255)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(512, 360), 4, sparklePaint);
    canvas.drawCircle(const Offset(580, 430), 4, sparklePaint);
    canvas.drawCircle(const Offset(512, 500), 4, sparklePaint);
    canvas.drawCircle(const Offset(444, 430), 4, sparklePaint);
  }

  static void _drawLabel(Canvas canvas, String styleName, String roomTypeName) {
    // Semi-transparent overlay at bottom
    final overlayPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 824),
        const Offset(0, 1024),
        [
          const Color(0x00000000),
          const Color(0x99000000),
        ],
      );
    canvas.drawRect(const Rect.fromLTWH(0, 824, 1024, 200), overlayPaint);

    // Style name
    final styleBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 36,
      fontWeight: FontWeight.bold,
    ))
      ..pushStyle(ui.TextStyle(color: const Color(0xFFFFFFFF)))
      ..addText(styleName);
    final styleParagraph = styleBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 900));
    canvas.drawParagraph(styleParagraph, const Offset(62, 900));

    // Room type
    final roomBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 22,
    ))
      ..pushStyle(ui.TextStyle(color: const Color(0xBBFFFFFF)))
      ..addText(roomTypeName);
    final roomParagraph = roomBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 900));
    canvas.drawParagraph(roomParagraph, const Offset(62, 950));

    // "DEMO" watermark
    final demoBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 16,
    ))
      ..pushStyle(ui.TextStyle(color: const Color(0x66FFFFFF)))
      ..addText('DEMO • Generated by RoomAI');
    final demoParagraph = demoBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 900));
    canvas.drawParagraph(demoParagraph, const Offset(62, 985));
  }
}
