// home_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpiie/Model/PhotoModell.dart';
import 'package:wallpiie/Views/Likescreen.dart';
import 'package:wallpiie/Views/bigScreen.dart';
import 'package:wallpiie/controller/apiOperation.dart';
import 'package:wallpiie/controller/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PhotoModell> photos = [];

  int page = 1;

  @override
  void initState() {
    super.initState();
    ApiOperations.getTrendingWallpaper();
    loadmore(page);
  }

  Future<void> loadmore(int nextpage) async {
    setState(() {
      page = nextpage + 1;
    });
    String url =
        "https://api.pexels.com/v1/curated?per_page=80&page=" + page.toString();
    await DefaultCacheManager().getSingleFile(url, headers: {
      "Authorization":
          "I2KHcRqEqc0RbL3ZzVo168Vszz8vfxiBVj7RgK2VfaS5gAufJJBb8s6Z"
    }).then((file) async {
      String contents = await file.readAsString();
      Map res = jsonDecode(contents);
      setState(() {
        photos.addAll((res['photos'] as List)
            .map((photoJson) => PhotoModell.fromJson(photoJson))
            .toList());
      });
    }).catchError((error) {
      // Handle error
      print("Error: $error");
    });
  }

  void toggleLike(PhotoModell photo) async {
    setState(() {
      photo.isLiked = !photo.isLiked;
    });
    await LikedPhotosStorage.toggleLike(photo.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        backgroundColor: const Color.fromARGB(255, 19, 19, 19),
        title: Text(
          "Wallpie",
          style: GoogleFonts.tiltWarp(
            fontWeight: FontWeight.bold,
            fontSize: 37,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              List<PhotoModell> likedPhotos =
                  photos.where((photo) => photo.isLiked).toList();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LikedScreen(likedPhotos: likedPhotos)));
            },
            icon: Icon(
              Icons.favorite,
              // color: const Color.fromARGB(255, 122, 25, 25),
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      body: Stack(
        children: [
          GridView.builder(
              padding: EdgeInsets.all(7),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                mainAxisExtent: 300,
                crossAxisSpacing: 10,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return GridTile(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BigScreen(
                            imgUrl: photos[index].imageUrl,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        children: [
                          Image.network(
                            photo.imageUrl,
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 20,
                            child: IconButton(
                              onPressed: () {
                                toggleLike(photo);
                              },
                              icon: Icon(
                                photo.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: photo.isLiked
                                    ? Color.fromARGB(255, 154, 15, 5)
                                    : Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
          Positioned(
            bottom: 16,
            right: 16,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                // foregroundColor: Colors.red,

                onPressed: () {
                  loadmore(page);
                },
                child: SpinKitWaveSpinner(
                  color: Colors.white,
                  size: 60,
                  waveColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
