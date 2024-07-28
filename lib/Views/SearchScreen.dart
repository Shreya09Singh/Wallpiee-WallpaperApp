import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpiie/Model/photosModel.dart';
import 'package:wallpiie/Views/Catagoriescreen.dart';
import 'package:wallpiie/Views/bigScreen.dart';
import 'package:wallpiie/Widgets/BottomNavigationbar.dart';
import 'package:wallpiie/controller/apiOperation.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<PhotosModel> searchWallpaperList = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> getSearchResult() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      searchWallpaperList =
          await ApiOperations.getSearchWallpapers(searchController.text);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch data. Please try again later.';
      });
      print('Error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Optionally, you can call getSearchResult() here if you want to load initial data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => BottomNavigationbar()));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
        title: Text(
          'Search Screen',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: searchController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Search for wallpapers",
                    hintStyle: GoogleFonts.poppins(color: Colors.white),
                    prefixIcon: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus(); // Hide the keyboard
                        getSearchResult(); // Fetch search results when icon is tapped
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (isLoading)
                Center(
                  child: SpinKitCircle(
                    color: Colors.red,
                  ),
                )
              else if (searchWallpaperList.isEmpty && !isLoading)
                Expanded(
                  child: Catagoriescreen(
                    showAppBar: false,
                  ), // Show the category list when not loading and no search results
                )
              else if (errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              else if (!isLoading && errorMessage.isEmpty)
                Expanded(
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 300,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: searchWallpaperList.length,
                    itemBuilder: (context, index) {
                      PhotosModel photo = searchWallpaperList[index];
                      return GridTile(
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BigScreen(
                                      imgUrl: photo.src.large,
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                photo.src.portrait,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
