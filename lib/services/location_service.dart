import 'package:dio/dio.dart';

class LocationService {
  static const String apiKey = 'AIzaSyBEilIuILbArteSd2h21UUMcTsolLJiQPw';
  static final Dio _dio = Dio();

  static Future<List<Place>> getSuggestions(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=fr';

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> predictions = response.data['predictions'];
        return predictions.map((json) => Place.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      throw Exception('Failed to load suggestions: $e');
    }
  }

  static Future<String> getCurrentLocationAddress() async {
    // Remplacez par votre logique pour obtenir l'adresse actuelle
    const String currentLocationAddress = 'Adresse actuelle de l\'hôtel'; // Remplacez par l'appel à votre service de localisation réel
    return currentLocationAddress;
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

// import 'package:dio/dio.dart';

// class LocationService {
//   static const String apiKey = 'AIzaSyBEilIuILbArteSd2h21UUMcTsolLJiQPw'; // Remplacez par votre clé API
//   static final Dio _dio = Dio();

//   static Future<List<Place>> getSuggestions(String input) async {
//     final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=fr';

//     try {
//       final response = await _dio.get(url);

//       if (response.statusCode == 200) {
//         final List<dynamic> predictions = response.data['predictions'];
//         return predictions.map((json) => Place.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load suggestions');
//       }
//     } catch (e) {
//       throw Exception('Failed to load suggestions: $e');
//     }
//   }
// }

// class Place {
//   final String description;

//   Place({required this.description});

//   factory Place.fromJson(Map<String, dynamic> json) {
//     return Place(
//       description: json['description'],
//     );
//   }
// }
