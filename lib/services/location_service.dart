import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static const String apiKey = 'AIBEilIuISSFHLbArteSd2h21szUMcTlLJiQPw'; // Remplacez par votre clé API
  static Future<List<Place>> getSuggestions(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=fr';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> predictions = json.decode(response.body)['predictions'];
      return predictions.map((json) => Place.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}

class Place {
  final String description;

  Place({required this.description});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      description: json['description'],
    );
  }
}




