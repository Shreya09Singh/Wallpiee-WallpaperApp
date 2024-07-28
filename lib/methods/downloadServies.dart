import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:wallpiie/Model/NotesModel.dart';
import 'package:wallpiie/methods/annotation.dart';

class DownloadServices {
  Future<void> handleDownload(BuildContext context, String imgUrl) async {
    // Retrieve notes from Hive
    var box = Hive.box<NotesModel>('notes');
    var notes = box.values.toList().cast<NotesModel>();
    var hasNotes = notes.any((note) => note.imgUrl == imgUrl);

    if (hasNotes) {
      await saveWithNotes(context, imgUrl);
    } else {
      await _save(context, imgUrl);
    }
  }

  Future<void> _save(BuildContext context, String imgUrl) async {
    try {
      var response = await Dio().get(
        imgUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
      );
      print("Image saved: $result");
    } catch (e) {
      print('Error saving image: $e');
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> saveWithNotes(BuildContext context, String imgUrl) async {
    try {
      // Retrieve notes from Hive
      var box = Hive.box<NotesModel>('notes');
      var notes = box.values.toList().cast<NotesModel>();

      for (var note in notes) {
        try {
          // Fetch the image data from the URL in the note
          var response = await Dio().get(note.imgUrl,
              options: Options(responseType: ResponseType.bytes));
          final imageData = Uint8List.fromList(response.data);

          // Annotate the image with note details
          final annotatedImage = await annotateImageWithCard(
            imageData,
            note.title,
            note.note,
          );

          // Save the annotated image to the gallery
          final result = await ImageGallerySaver.saveImage(annotatedImage);
          print("Image saved: $result");
        } catch (e) {
          print('Error saving image: $e');
        }
      }

      Navigator.pop(context);
    } catch (e) {
      print('Error retrieving notes: $e');
    }
  }
}
