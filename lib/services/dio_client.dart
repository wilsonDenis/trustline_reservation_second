import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trust_reservation_second/services/local_storage.dart';

class DioClient {
  final Dio dio; // Instance de la bibliothèque Dio pour les requêtes HTTP

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://laconciergerie-i-carre.com/testApi/api',
            connectTimeout: const Duration(seconds: 9),
            receiveTimeout: const Duration(seconds: 6),
          ),
        ) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Exécuté avant chaque requête HTTP
        final token = await LocalStorageService.getData('token'); // Récupérer le jeton d'accès du stockage local
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token"; // Ajouter l'en-tête d'autorisation avec le jeton
        }
        options.headers["Content-Type"] = "application/json"; // Définir le type de contenu de la requête
        if (kDebugMode) {
          // Afficher des informations de débogage en mode débogage
          print('Request: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');
        }
        return handler.next(options); // Passer à l'étape suivante de la requête
      },
      onResponse: (response, handler) {
        // Exécuté après chaque réponse HTTP
        if (kDebugMode) {
          print('Response: ${response.statusCode} ${response.data}');
        }
        return handler.next(response); // Passer à l'étape suivante de la réponse
      },
      onError: (DioException e, handler) async {
        // Exécuté en cas d'erreur HTTP
        if (kDebugMode) {
          print('Error: ${e.response?.statusCode} ${e.response?.data}');
        }

        if (e.response?.statusCode == 401) {
          // Gestion d'une erreur 401 (non autorisé)
          try {
            final newToken = await _refreshToken(); // Essayer de rafraîchir le jeton
            if (newToken != null) {
              e.requestOptions.headers["Authorization"] =
                  "Bearer $newToken"; // Mettre à jour l'en-tête d'autorisation avec le nouveau jeton
              final cloneReq = await dio.request(
                e.requestOptions.path, // Relancer la requête avec les mêmes options
                options: Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers,
                ),
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
              );
              return handler.resolve(cloneReq); // Renvoyer la nouvelle réponse
            }
          } catch (e) {
            if (kDebugMode) {
              print('Token refresh failed: $e'); // Afficher une erreur si le rafraîchissement du jeton échoue
            }
          }
        }

        return handler.next(e); // Passer l'erreur à la prochaine étape
      },
    ));
  }

  Future<String?> _refreshToken() async {
    // Fonction pour rafraîchir le jeton d'accès
    try {
      final refreshToken = await LocalStorageService.getData('refreshToken'); // Récupérer le jeton de rafraîchissement du stockage local
      if (refreshToken == null) return null; // Retourner null si aucun jeton de rafraîchissement n'est trouvé

      final response = await dio.post(
        '/auth/token/refresh/', // Envoyer une requête POST à l'endpoint de rafraîchissement
        data: {'refresh': refreshToken}, // Envoyer le jeton de rafraîchissement dans la requête
      );
      if (response.statusCode == 200) {
        // Si le rafraîchissement réussit
        final newToken = response.data['access']; // Extraire le nouveau jeton d'accès de la réponse
        await LocalStorageService.saveData('token', newToken); // Enregistrer le nouveau jeton dans le stockage local
        return newToken; // Retourner le nouveau jeton d'accès
      } else {
        throw Exception('Failed to refresh token'); // Lancer une exception si le rafraîchissement échoue
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing token: $e'); // Afficher une erreur si une exception se produit pendant le rafraîchissement
      }
      return null; // Retourner null si une erreur se produit
    }
  }
}
