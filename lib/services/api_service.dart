import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  static const String _serverIP = '192.168.1.65';
  static const String baseUrl = 'http://$_serverIP:8000/api';
  static String get serverIP => _serverIP;
  static String currentIP = serverIP;

  // Ajoutez cette méthode pour obtenir l'adresse IP

  static Future<String?> getAuthToken() async {
    print("Fetching auth token from SharedPreferences...");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    print("Auth token: $token");
    return token ?? '';
  }

  static T _handleResponse<T>(
      http.Response response, T Function(dynamic) modelFromJson) {
    print("Handling response with status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      T model = modelFromJson(jsonDecode(response.body));
      print("Parsed model from response: $model");
      return model;
    } else {
      print("Request failed with status: ${response.statusCode}");
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

//reponse de d'envoie

  static Future<http.Response> _postData(
      String endpoint, Map<String, dynamic> data,
      {bool requireToken = true}) async {
    String? authToken;
    if (requireToken) {
      authToken = await getAuthToken();
    }

    final headers = {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
    if (kDebugMode) {
      print("Posting data to $endpoint with headers: $headers and data: $data");
    }
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(data),
    );
    if (kDebugMode) {
      print("Received response: ${response.body}");
    }
    return response;
  }

// affichage des données de publication
  static Future<http.Response> _indexData(String endpoint) async {
    final authToken = await getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    if (kDebugMode) {
      print("Fetching data from $endpoint with headers: $headers");
    }
    final response = await http.get(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
    );
    if (kDebugMode) {
      print("Received response: ${response.body}");
    }
    return response;
  }

//update publication
  static Future<http.Response> _updateData(
      String endpoint, Map<String, dynamic> data) async {
    final authToken = await getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    if (kDebugMode) {
      print("Updating data at $endpoint with headers: $headers and data: $data");
    }
    final response = await http.put(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(data),
    );
    if (kDebugMode) {
      print("Received response: ${response.body}");
    }
    return response;
  }

//post publication
  static Future<http.Response> postPublication(
      Map<String, dynamic> data) async {
    final authToken = await getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    if (kDebugMode) {
      print("Posting publication with headers: $headers and data: $data");
    }
    final response = await http.post(
      Uri.parse('$baseUrl/publications'),
      headers: headers,
      body: jsonEncode(data),
    );
    if (kDebugMode) {
      print("Received response: ${response.body}");
    }
    return response;
  }

  //méthode patch
  static Future<http.Response> _patchData(
      String endpoint, Map<String, dynamic> data) async {
    final authToken = await getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    // print("Patching data at $endpoint with headers: $headers and data: $data");
    final response = await http.patch(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(data),
    );
    if (kDebugMode) {
      print("Received response: ${response.body}");
    }
    return response;
  }

  //Pour supprimer les données
  static Future<http.Response> _deleteData(String endpoint) async {
    final authToken = await getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
    );

    return response;
  }

  //fonction pour gérer l'url des images
  static String fixImageUrl(String originalUrl) {
    // print("Original URL: $originalUrl"); // Affiche l'URL original

    // Si l'URL est relative (commence par "/img/uploads/..."), ajoutez le préfixe
    if (originalUrl.startsWith("/img/uploads/")) {
      String fixedUrl = "http://$currentIP:8000$originalUrl";
      //  print("Fixed URL: $fixedUrl"); // Affiche l'URL après modification
      return fixedUrl;
    }

    var regex = RegExp(r"http:\/\/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})");

    // Si l'URL contient déjà l'adresse IP actuelle, retournez l'URL original
    if (originalUrl.contains(currentIP)) {
      //   print("URL already contains the current IP. No changes made.");
      return originalUrl;
    }

    String fixedUrl =
        originalUrl.replaceAllMapped(regex, (match) => "http://$currentIP");
    if (kDebugMode) {
      print("Fixed URL: $fixedUrl");
    } // Affiche l'URL après modification

    return fixedUrl;
  }

  //-------------- AUTHENTICATION --------------
  static Future<http.Response> login(Map<String, dynamic> data) {
    return _postData('/login', data);
  }

  //recuperer l'id de l'utilisateur
  static Future<int> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('userId') ?? 0;
  }

//-------------- s'enregeistrer dans la base de données
  static Future<http.Response> register(Map<String, dynamic> data) {
    return _postData('/register', data, requireToken: false);
  }

  ///mise à  jour  vendredi 11
  static Future<bool> updateUsername(String newUsername) async {
    Map<String, dynamic> userData = {'username': newUsername};
    final response = await updateUser(userData);
    if (response.statusCode == 200) {
      return true;
    } else {
      if (kDebugMode) {
        print(
          "Erreur lors de la mise à jour du nom d'utilisateur: ${response.body}");
      }
      return false;
    }
  }

  //MISE A JOUR

// ----------------- se deconnecter
  static Future<void> logout() async {
    final response = await _postData('/logout', {});
    if (response.statusCode == 200) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('token');
      await pref.remove(
          'userId'); // Supposant que vous stockez également l'ID de l'utilisateur
    }
    // Vous pouvez également gérer d'autres codes de statut ou erreurs ici si nécessaire
  }

//----------Avoir les details de l'utilisateur
  static Future<http.Response> getUser() {
    return _indexData('/user');
  }

//----------Modifier les informations de l'utilisateur
  static Future<http.Response> updateUser(Map<String, dynamic> data) {
    return _updateData('/user', data);
  }

//----------avoir les images
  static String? getStringImage(File? file) {
    if (file == null) return null;
    return base64Encode(file.readAsBytesSync());
  }

  //

  //-------------- PUBLICATIONS --------------
  static Future<http.Response> getPublications() {
    return _indexData('/publications');
  }

  static Future<http.Response> getPublicationsByUserId(int userId) {
    return _indexData('/users/$userId/publications');
  }

  /* static Future<http.Response> deletePublication(int id) {
    return _deleteData('/publications/$id');
  }*/
  //supprimer une publication
  static Future<bool> deletePublication(int id) async {
    final response = await _deleteData('/publications/$id');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete publication.');
    }
  }

  //envoie des images de profil ou des images aux serveurs
  static Future<bool> sendBase64ImageToServer(String? base64Image) async {
    if (base64Image == null) return false;

    final authToken = await ApiService.getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    var response = await http.post(
      Uri.parse('${ApiService.baseUrl}/uploadImage'), // URL de l'Endpoint
      headers: headers,
      body: json.encode({
        'image': base64Image,
      }),
    );

    if (response.statusCode == 200) {
      // Si le code de statut est 200, cela signifie que l'opération a réussi.
      return true;
    } else {
      // Gérer les erreurs
      if (kDebugMode) {
        print("Erreur lors du téléchargement de l'image: ${response.body}");
      }
      return false;
    }
  }

//-------------- VISITES --------------
  static Future<http.Response> storeVisit(Map<String, dynamic> data) {
    return _postData('/visites', data);
  }

  static Future<http.Response> updateVisit(int id, Map<String, dynamic> data) {
    return _patchData('/visites/$id', data);
  }

  static Future<http.Response> showVisit(int id) {
    return _indexData('/visites/$id');
  }

  static Future<http.Response> getMyVisits() {
    return _indexData('/my-visites');
  }

  static Future<http.Response> getMyPublicationVisits() {
    return _indexData('/my-publication-visites');
  }

  //-------------- FAVORIS --------------
  /* static Future<http.Response> toggleFavoris(int publicationId) {
    return _postData('/toggle-favoris/$publicationId', {});
  }*/

  static Future<http.Response> toggleFavoris(int publicationId) async {
    try {
      final response = await _postData('/toggle-favoris/$publicationId', {});
      return response;
    } catch (error) {
      rethrow;
    }
  }

//avoir les favoris de l'utilisateurs
  static Future<http.Response> getUserFavoris([int? userId]) {
    if (userId != null) {
      return _indexData('/user-favoris/$userId');
    }
    return _indexData('/user-favoris');
  }

  //-------------- SEARCH --------------
  static Future<http.Response> search(Map<String, dynamic> data) {
    return _postData('/search', data);
  }

  static Future<http.Response> searchByDescription(Map<String, dynamic> data) {
    return _postData('/search/description', data);
  }

  //-------------- CHAT --------------
  static Future<http.Response> checkChatExists(int userId1, int userId2) {
    return _indexData('/chat/exists/$userId1/$userId2');
  }

  static Future<http.Response> getChatMessages(int userId1, int userId2) {
    return _indexData('/chat/get/$userId1/$userId2');
  }

  static Future<http.Response> sendChatMessage(
      int receiverId, String message, int type) {
    Map<String, dynamic> data = {
      'recepteur_id': receiverId,
      'message': message,
      'type': type,
    };
    return _postData('/chat/send', data);
  }

  static Future<http.Response> initiateOrGetChatForPublication(
      int publicationId) {
    return _postData('/chat/initiate/$publicationId', {});
  }

  static Future<http.Response> getRecentChats() {
    return _indexData('/chat/recent');
  }

//-------------- STATISTIQUES --------------
  //STATIQUE voir tous  les utilisateurs
  static Future<http.Response> getTotalUsers() {
    return _indexData('/total-users');
  }
  //STATIQUE voir tous les publications
  static Future<http.Response> getTotalPublications() {
    return _indexData('/total-publications');
  }
  //STATIQUE voir les publications tous les publications -----
  static Future<http.Response> getUserPublicationCount() {
    return _indexData('/user-publication-count');
  }

}
