// share_utils.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';

import 'package:wallpiie/Model/NotesModel.dart';
import 'package:wallpiie/methods/annotation.dart';

class ShareUtils {
  static Future<void> shareImageOnly(String imgUrl) async {
    try {
      final uri = Uri.parse(imgUrl);
      final response = await http.get(uri);
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/image.jpg';

      await File(path).writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(path)],
        // text: contentController.text,
      );
    } catch (e) {
      print('Error sharing image: $e');
    }
  }

  static Future<void> saveAndShareAnnotatedImages(BuildContext context) async {
    try {
      var box = Hive.box<NotesModel>('notes');
      var notes = box.values.toList().cast<NotesModel>();

      List<XFile> savedXFiles = [];

      for (var note in notes) {
        try {
          var response = await Dio().get(note.imgUrl,
              options: Options(responseType: ResponseType.bytes));
          final imageData = Uint8List.fromList(response.data);

          final annotatedImage = await annotateImageWithCard(
            imageData,
            note.title,
            note.note,
          );

          final tempDir = await getTemporaryDirectory();
          final file = await File('${tempDir.path}/${note.title}.png').create();
          await file.writeAsBytes(annotatedImage);

          savedXFiles.add(XFile(file.path));
          print("Image saved: ${file.path}");

          if (savedXFiles.isNotEmpty) {
            Share.shareXFiles(savedXFiles,
                text: 'Check out these images with notes!');
          }
          await note.delete();
          print("Note deleted: ${note.title}");
        } catch (e) {
          print('Error saving image: $e');
        }
      }

      // Navigator.pop(context);
    } catch (e) {
      print('Error retrieving notes: $e');
    }
  }

  static Future<bool> hasNotesForImage(String imgUrl) async {
    var box = Hive.box<NotesModel>('notes');
    var notes = box.values.toList().cast<NotesModel>();
    return notes.any((note) => note.imgUrl == imgUrl);
  }
}
