import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:wallpiie/Model/NotesModel.dart';

Future<void> showMyDialog(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController contentController,
    String imgUrl) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Add Note',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.brown.shade900),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                      color: Colors.brown.shade700,
                      fontWeight: FontWeight.w500),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  labelStyle: TextStyle(
                      color: Colors.brown.shade700,
                      fontWeight: FontWeight.w500),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.brown.shade800),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Add',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.brown.shade800),
            ),
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                final data = NotesModel(
                  title: titleController.text,
                  note: contentController.text,
                  imgUrl: imgUrl,
                );

                final box = Hive.box<NotesModel>('notes');
                await box.add(data);

                // Clear the text controllers after adding the note
                titleController.clear();
                contentController.clear();

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
