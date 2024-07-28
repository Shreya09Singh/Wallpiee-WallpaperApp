import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:wallpiie/Model/PhotoModell.dart';
import 'package:wallpiie/Model/photosModel.dart';
import 'package:wallpiie/controller/customCache.dart';

List<PhotoModell> trendingWallpapers = [];
List<PhotosModel> searchWallpaperlist = [];
List<PhotoModell> catagoryWallpaperlist = [];

class ApiOperations {
  static Future<List<PhotoModell>> getTrendingWallpaper() async {
    // final String apiKey = dotenv.env['Api_Key'] ?? '';
    List<PhotoModell> photos = [];
    final response = await http.get(
      Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
      headers: {
        "Authorization":
            "I2KHcRqEqc0RbL3ZzVo168Vszz8vfxiBVj7RgK2VfaS5gAufJJBb8s6Z",
      },
    );

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      List photosJson = result['photos'];

      photos = photosJson.map((json) => PhotoModell.fromJson(json)).toList();

      print("Length of the images: ${photos.length}");
    } else {
      throw Exception('Failed to load photos');
    }

    return photos;
  }

  static Future<List<PhotosModel>> getSearchWallpapers(String query) async {
    // final String apiKey = dotenv.env['Api_Key'] ?? '';
    List<PhotosModel> searchWallpaperList = [];
    final url =
        "https://api.pexels.com/v1/search?query=$query&per_page=80&page=1";
    final cacheManager = Customcache();

    try {
      // Check cache first
      final fileInfo = await cacheManager.getFileFromCache(url);
      if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
        // Cache hit
        final cachedData = await fileInfo.file.readAsString();
        Map<String, dynamic> jsonData = jsonDecode(cachedData);
        if (jsonData['photos'] != null) {
          List<dynamic> photos = jsonData['photos'];
          searchWallpaperList =
              photos.map((element) => PhotosModel.fromJson(element)).toList();
        }
      } else {
        // Cache miss, fetch data from API
        final response = await http.get(Uri.parse(url), headers: {
          "Authorization":
              "I2KHcRqEqc0RbL3ZzVo168Vszz8vfxiBVj7RgK2VfaS5gAufJJBb8s6Z"
        });

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonData = jsonDecode(response.body);
          if (jsonData['photos'] != null) {
            List<dynamic> photos = jsonData['photos'];
            searchWallpaperList =
                photos.map((element) => PhotosModel.fromJson(element)).toList();

            // Store response in cache
            await cacheManager.putFile(url, response.bodyBytes);
          } else {
            print("No photos found in the response.");
          }
        } else if (response.statusCode == 429) {
          print("Rate limit exceeded. Implement rate limiting logic.");
          // Implement rate limiting logic here, e.g., retry after a delay
        } else {
          print("Failed to fetch data: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    return searchWallpaperList;
  }

  static Future<String> fetchPhotoUrl(String category) async {
    final response = await http.get(
      Uri.parse('https://api.pexels.com/v1/search?query=$category&per_page=1'),
      headers: {
        "Authorization":
            "I2KHcRqEqc0RbL3ZzVo168Vszz8vfxiBVj7RgK2VfaS5gAufJJBb8s6Z",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('API Response: $jsonResponse'); // Debugging
      final imageUrl = jsonResponse['photos'][0]['src']
          ['medium']; // Adjust as per actual response structure
      return imageUrl;
    } else {
      throw Exception('Failed to load images');
    }
  }

  static Future<List<PhotoModell>> getCatagoryWallpapers() async {
    // final String apiKey = dotenv.env['Api_Key'] ?? '';
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=10"),
        headers: {
          "Authorization":
              "I2KHcRqEqc0RbL3ZzVo168Vszz8vfxiBVj7RgK2VfaS5gAufJJBb8s6Z"
        }).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      // catagoryWallpaperlist = photos.map((e) => PhotoModels.fromJson(e)).toList().sublist
      photos.forEach((element) {
        catagoryWallpaperlist.add(PhotoModell.fromJson(element));
        // catagoryWallpaperlist.add(NewPhotoModel.fromApi2APP(element));
      });
    });

    return catagoryWallpaperlist;
  }
}
