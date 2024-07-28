// category_screen.dart

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpiie/Model/PhotoModell.dart';
import 'package:wallpiie/Views/Likescreen.dart';
import 'package:wallpiie/Views/bigScreen.dart';
import 'package:wallpiie/controller/apiServices.dart';

class CategoryPhotoScreen extends StatefulWidget {
  final String category;

  const CategoryPhotoScreen({required this.category, Key? key})
      : super(key: key);

  @override
  _CategoryPhotoScreenState createState() => _CategoryPhotoScreenState();
}

class _CategoryPhotoScreenState extends State<CategoryPhotoScreen> {
  final ApiService apiService = ApiService();
  List<PhotoModell> categoryPhotos = [];
  List<PhotoModell> likedphotoList = [];
  bool isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchCategoryPhotos();
  }

  Future<void> fetchCategoryPhotos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final photos = await apiService.fetchCategoryPhotos(widget.category);
      setState(() {
        categoryPhotos.clear();
        categoryPhotos.addAll(photos);
        currentPage++;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleLike(PhotoModell photo) {
    setState(() {
      photo.isLiked = !photo.isLiked;
      if (photo.isLiked) {
        likedphotoList.add(photo);
      } else {
        likedphotoList.remove(photo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        // automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        title: Text(
          '${widget.category} Photos',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LikedScreen(likedPhotos: likedphotoList)));
            },
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
              size: 25,
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: SpinKitCircle(
              color: Colors.blue,
            ))
          : GridView.builder(
              padding: EdgeInsets.all(7),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                mainAxisExtent: 300,
                crossAxisSpacing: 10,
              ),
              itemCount: categoryPhotos.length,
              itemBuilder: (context, index) {
                final photo = categoryPhotos[index];
                return GridTile(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BigScreen(
                            // dataa: [],
                            imgUrl: photo.imageUrl,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(children: [
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
                              photo.isLiked ? Icons.favorite : Icons.favorite,
                              color: photo.isLiked
                                  ? Color.fromARGB(255, 154, 15, 5)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              }),
    );
  }
}
