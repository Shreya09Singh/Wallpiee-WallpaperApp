import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpiie/Views/CatagoryPhotoScreen.dart';
import 'package:wallpiie/Views/SearchScreen.dart';
import 'package:wallpiie/Widgets/BottomNavigationbar.dart';
import 'package:wallpiie/controller/apiOperation.dart';

class Catagoriescreen extends StatefulWidget {
  final bool showAppBar; // Add this parameter

  const Catagoriescreen({Key? key, this.showAppBar = true}) : super(key: key);

  @override
  State<Catagoriescreen> createState() => _CatagoriescreenState();
}

class _CatagoriescreenState extends State<Catagoriescreen> {
  bool _isLoading = false;
  final List<String> categories = [
    'Nature',
    'Technology',
    'Animals',
    'People',
    'Architecture',
    'Food',
    'Travel',
    'Sports',
    'Fashion',
    'Art',
  ];

  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    fetchCategoryImages().then((imageUrls) {
      setState(() {
        _imageUrls = imageUrls;
        _isLoading = false;
      });
    }).catchError((error) {
      print("Error fetching category images: $error");
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<List<String>> fetchCategoryImages() async {
    List<Future<String>> futures = categories.map((category) async {
      try {
        String url = await ApiOperations.fetchPhotoUrl(category);
        print('Fetched URL for $category: $url'); // Debugging
        return url;
      } catch (e) {
        print('Error fetching image for $category: $e');
        return ''; // Add an empty string if there is an error
      }
    }).toList();

    return await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BottomNavigationbar()));
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              backgroundColor: Colors.black,
              title: Text(
                'Categories',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 13, top: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          : null, // Hide the AppBar if showAppBar is false
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(
              child: SpinKitCircle(
                color: Colors.white,
              ),
            )
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final imageUrl =
                    _imageUrls.length > index ? _imageUrls[index] : '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPhotoScreen(
                          category: categories[index],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Container(
                          height: height * .18,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: imageUrl.isNotEmpty
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.darken,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Center(
                                          child: Text(
                                            'Failed to load image',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Image not available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 130,
                        child: Text(
                          categories[index],
                          style: GoogleFonts.poppins(
                            fontSize: 33,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
