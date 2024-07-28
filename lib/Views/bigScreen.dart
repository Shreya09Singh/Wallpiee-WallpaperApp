import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wallpiie/Box/Boxes.dart';
import 'package:wallpiie/Model/NotesModel.dart';
import 'package:wallpiie/Widgets/sharefile.dart';
import 'package:wallpiie/Widgets/showdialogBox.dart';
import 'package:wallpiie/methods/downloadServies.dart';

class BigScreen extends StatefulWidget {
  final String imgUrl;
  BigScreen({
    Key? key,
    required this.imgUrl,
  }) : super(key: key);

  @override
  State<BigScreen> createState() => _BigScreenState();
}

class _BigScreenState extends State<BigScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void deleteNote(int index) {
    var box = Hive.box<NotesModel>('notes');
    box.deleteAt(index);
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Image.network(
                  widget.imgUrl,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                ),
                Positioned(
                  top: 30,
                  left: 30,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                          height: 67,
                          width:
                              37), // Add spacing between IconButton and ElevatedButton
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () async {
                          await showMyDialog(
                            context,
                            titleController,
                            contentController,
                            widget.imgUrl,
                          );
                          // Clear the text controllers after adding the note
                          titleController.clear();
                          contentController.clear();
                          setState(() {}); // Refresh the UI
                        },
                        child: Text(
                          'Add Custom Note',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 42,
                    right: 16,
                    // bottom: 300,
                    child: IconButton(
                      onPressed: () async {
                        if (await ShareUtils.hasNotesForImage(widget.imgUrl)) {
                          await ShareUtils.saveAndShareAnnotatedImages(context);
                        } else {
                          await ShareUtils.shareImageOnly(widget.imgUrl);
                        }
                      },
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    )),
                Positioned(
                  bottom: 400,
                  left: 20,
                  right: 20,
                  child: ValueListenableBuilder(
                    valueListenable: Boxes.getData().listenable(),
                    builder: (context, Box<NotesModel> box, _) {
                      var data = box.values
                          .where((note) => note.imgUrl == widget.imgUrl)
                          .toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(data[index].title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown.shade800,
                                                fontSize: 23)),
                                        SizedBox(height: 4),
                                        Text(data[index].note,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 12,
                                    ),
                                    onPressed: () {
                                      deleteNote(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  left: 20,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () async {
                      DownloadServices downloadServices = DownloadServices();
                      await downloadServices.handleDownload(
                          context, widget.imgUrl);
                    },
                    child: Text(
                      'Download',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
