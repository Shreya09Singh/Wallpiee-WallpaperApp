// PhotoModell.dart

class PhotoModell {
  final int id;
  final String imageUrl;
  bool isLiked;

  PhotoModell({
    required this.id,
    required this.imageUrl,
    this.isLiked = false,
  });

  factory PhotoModell.fromJson(Map<String, dynamic> json) {
    return PhotoModell(
      id: json['id'],
      imageUrl: json['src']
          ['large2x'], // Adjust according to your JSON structure
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'src': {
        'large': imageUrl,
      },
      'isLiked': isLiked,
    };
  }
}
