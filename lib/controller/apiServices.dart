// api_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:wallpiie/Model/PhotoModell.dart';

class ApiService {
  // final String apiKey = dotenv.env['Api_Key'] ?? '';

  Future<List<PhotoModell>> fetchCategoryPhotos(String category) async {
    final String url =
        'https://api.pexels.com/v1/search?query=$category&per_page=80';

    int retryAttempts = 3; // Number of retry attempts
    int delayFactor = 2; // Exponential backoff delay factor

    while (retryAttempts > 0) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization':
                'I2KHcRqEqc0RbL3ZzVo168Vszz8vfxiBVj7RgK2VfaS5gAufJJBb8s6Z'
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List<dynamic> photosJson = data['photos'];
          return photosJson.map((json) => PhotoModell.fromJson(json)).toList();
        } else if (response.statusCode == 429) {
          // Retry after a delay using exponential backoff
          await Future.delayed(Duration(seconds: delayFactor));
          delayFactor *= 2; // Increase delay for subsequent retries
        } else {
          throw Exception('Failed to load photos: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching photos: $e');
        throw Exception('Failed to load photos: $e');
      }

      retryAttempts--;
    }

    throw Exception('Failed to load photos after retry attempts');
  }
}
