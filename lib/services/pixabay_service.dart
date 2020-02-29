import 'dart:convert';
import 'package:http/http.dart' as http;

class PixabayImage {
  final int id;
  final String webformatURL;

  PixabayImage({this.id, this.webformatURL});

  factory PixabayImage.fromJson(Map<String, dynamic> json) {
    return PixabayImage(
      id: json['id'],
      webformatURL: json['webformatURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'webformatURL': webformatURL};
  }
}

class PixabayService {
  static Future<List<PixabayImage>> getPixabayPhotos(
    String keyword,
    int perPage,
  ) async {
    final url =
        'https://pixabay.com/api/?key=15187266-18d1b4e06ab6a3e5789630fdc&q=$keyword&per_page=$perPage&image_type=photo&pretty=true';

    try {
      final http.Response response = await http.get(url);
      final responseData = json.decode(response.body)['hits'];

      final List<PixabayImage> pixabayImages =
          responseData.map<PixabayImage>((img) {
        return PixabayImage.fromJson(img);
      }).toList();

      return pixabayImages;
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
