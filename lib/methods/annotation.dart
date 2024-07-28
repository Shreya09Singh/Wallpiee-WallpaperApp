import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';

Future<Uint8List> annotateImageWithCard(
    Uint8List imageData, String title, String note) async {
  final image = await decodeImageFromList(imageData);

  // Create a canvas to draw the image and text
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));

  // Draw the image on the canvas
  canvas.drawImage(image, Offset.zero, Paint());

  // Define padding, margin, and font sizes
  final double padding = 16.0;
  final double margin = 20.0;
  final double titleFontSize = 24.0;
  final double noteFontSize = 18.0;

  // Draw the card background
  final cardHeight = 120.0; // Height of the card
  final cardWidth = image.width * 0.78; // Width of the card
  final cardTop = (image.height - cardHeight) / 2; // Centered vertically
  final cardLeft = (image.width - cardWidth) / 2; // Centered horizontally

  final cardPaint = Paint()..color = Colors.white.withOpacity(0.8);
  canvas.drawRect(
      Rect.fromLTWH(cardLeft, cardTop, cardWidth, cardHeight), cardPaint);

  // Set up the text style
  final titleTextStyle = ui.TextStyle(
    color: Colors.brown,
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
  );

  final noteTextStyle = ui.TextStyle(
    color: Colors.black,
    fontSize: noteFontSize,
  );

  final titleParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.center,
    maxLines: 1,
    ellipsis: '...',
  );

  final noteParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.center,
    maxLines: 2,
    ellipsis: '...',
  );

  final titleBuilder = ui.ParagraphBuilder(titleParagraphStyle)
    ..pushStyle(titleTextStyle)
    ..addText(title);

  final noteBuilder = ui.ParagraphBuilder(noteParagraphStyle)
    ..pushStyle(noteTextStyle)
    ..addText(note);

  final titleParagraph = titleBuilder.build()
    ..layout(ui.ParagraphConstraints(width: cardWidth - 2 * margin));

  final noteParagraph = noteBuilder.build()
    ..layout(ui.ParagraphConstraints(width: cardWidth - 2 * margin));

  // Draw the text on the card with space between title and note
  final verticalSpacing = 10.0; // Space between title and note
  canvas.drawParagraph(
      titleParagraph, Offset(cardLeft + margin, cardTop + margin));
  canvas.drawParagraph(
      noteParagraph,
      Offset(cardLeft + margin,
          cardTop + margin + titleParagraph.height + verticalSpacing));

  // Finalize the drawing
  final picture = recorder.endRecording();
  final img = await picture.toImage(image.width, image.height);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
