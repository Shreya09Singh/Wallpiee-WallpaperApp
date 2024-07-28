// liked_photos_storage.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LikedPhotosStorage {
  static const String _storageKey = 'liked_photos';

  static Future<List<int>> getLikedPhotoIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? likedPhotosString = prefs.getString(_storageKey);
    if (likedPhotosString != null) {
      final List<dynamic> likedPhotoIds = jsonDecode(likedPhotosString);
      return likedPhotoIds.map((id) => id as int).toList();
    }
    return [];
  }

  static Future<void> toggleLike(int photoId) async {
    final List<int> likedPhotoIds = await getLikedPhotoIds();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (likedPhotoIds.contains(photoId)) {
      likedPhotoIds.remove(photoId);
    } else {
      likedPhotoIds.add(photoId);
    }

    await prefs.setString(_storageKey, jsonEncode(likedPhotoIds));
  }

  static Future<bool> isPhotoLiked(int photoId) async {
    final List<int> likedPhotoIds = await getLikedPhotoIds();
    return likedPhotoIds.contains(photoId);
  }
}
