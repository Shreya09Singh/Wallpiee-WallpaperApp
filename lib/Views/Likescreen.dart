import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wallpiie/Model/PhotoModell.dart';
import 'package:wallpiie/Views/bigScreen.dart';

class LikedScreen extends StatelessWidget {
  final List<PhotoModell> likedPhotos;

  LikedScreen({required this.likedPhotos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        title: Text(
          'Liked Photos',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: GridView.builder(
        padding: EdgeInsets.all(7),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          mainAxisExtent: 300,
          crossAxisSpacing: 10,
        ),
        itemCount: likedPhotos.length,
        itemBuilder: (context, index) {
          final photo = likedPhotos[index];
          return GridTile(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BigScreen(
                      imgUrl: photo.imageUrl,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  photo.imageUrl,
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
