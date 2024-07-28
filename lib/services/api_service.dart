import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trust_reservation_second/services/local_storage.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://laconciergerie-i-carre.com/testApi/api', // Remplacez par votre URL ngrok actuelle
      connectTimeout: const Duration(seconds: 15), // Délai d'attente de connexion (9 secondes)
      receiveTimeout: const Duration(seconds: 15), // Délai d'attente de réception (6 secondes)
    ),
  );

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await LocalStorageService.getData('token');
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        options.headers["Content-Type"] = "application/json";
        if (kDebugMode) {
          print('Request: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('Response: ${response.statusCode} ${response.data}');
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (kDebugMode) {
          print('Error: ${e.response?.statusCode} ${e.response?.data}');
        }

        if (e.response?.statusCode == 401) {
          // Gestion d'une erreur 401 (non autorisé)
          try {
            final newToken = await _refreshToken(); // Essayer de rafraîchir le jeton
            if (newToken != null) {
              // Mettre à jour l'en-tête d'autorisation avec le nouveau jeton
              e.requestOptions.headers["Authorization"] = "Bearer $newToken"; 
              // Relancer la requête avec les mêmes options
              final cloneReq = await _dio.request(
                e.requestOptions.path,
                options: Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers,
                ),
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
              );
              // Renvoyer la nouvelle réponse
              return handler.resolve(cloneReq); 
            }
          } catch (e) {
            if (kDebugMode) {
              print('Token refresh failed: $e');
            }
            // Gérer l'échec du rafraîchissement du jeton 
            // (par exemple, afficher une notification à l'utilisateur)
          }
        }

        return handler.next(e);
      },
    ));
  }

  Future<String?> _refreshToken() async {
    // Fonction pour rafraîchir le jeton d'accès
    try {
      final refreshToken = await LocalStorageService.getData('refreshToken');
      if (refreshToken == null) return null;

      final response = await _dio.post('/auth/token/refresh/', data: {'refresh': refreshToken});
      if (response.statusCode == 200) {
        final newToken = response.data['access'];
        await LocalStorageService.saveData('token', newToken);
        return newToken;
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing token: $e');
      }
      return null;
    }
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> data, {bool requireToken = true}) async {
    if (kDebugMode) {
      print('POST request to: ${_dio.options.baseUrl}$endpoint');
      print('Headers: ${_dio.options.headers}');
      print('Body: $data');
    }

    try {
      final response = await _dio.post(endpoint, data: data);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.data}');
      }

      return response;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Request error: ${e.response?.statusCode} ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> getData(String endpoint) async {
    if (kDebugMode) {
      print('GET request to: ${_dio.options.baseUrl}$endpoint');
      print('Headers: ${_dio.options.headers}');
    }

    try {
      final response = await _dio.get(endpoint);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.data}');
      }

      return response;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Request error: ${e.response?.statusCode} ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> putData(String endpoint, Map<String, dynamic> data) async {
    if (kDebugMode) {
      print('PUT request to: ${_dio.options.baseUrl}$endpoint');
      print('Headers: ${_dio.options.headers}');
      print('Body: $data');
    }

    try {
      final response = await _dio.put(endpoint, data: data);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.data}');
      }

      return response;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Request error: ${e.response?.statusCode} ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> deleteData(String endpoint) async {
    if (kDebugMode) {
      print('DELETE request to: ${_dio.options.baseUrl}$endpoint');
      print('Headers: ${_dio.options.headers}');
    }

    try {
      final response = await _dio.delete(endpoint);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.data}');
      }

      return response;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Request error: ${e.response?.statusCode} ${e.response?.data}');
      }
      rethrow;
    }
  }
}

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:trust_reservation_second/services/local_storage.dart';
// import 'dio_client.dart';

// class ApiService {
//   final DioClient _dioClient = DioClient();
  
//   Future<String?> getAuthToken() async {
//     return await LocalStorageService.getData('token');
//   }
  
//   Future<Response> postData(String endpoint, Map<String, dynamic> data, {bool requireToken = true}) async {
//     if (requireToken) {
//       final token = await getAuthToken();
//       if (token != null) {
//         _dioClient.dio.options.headers["Authorization"] = "Bearer $token";
//       }
//     }

//     if (kDebugMode) {
//       print('POST request to: ${_dioClient.dio.options.baseUrl}$endpoint');
//       print('Headers: ${_dioClient.dio.options.headers}');
//       print('Body: $data');
//     }

//     try {
//       final response = await _dioClient.dio.post(endpoint, data: data);

//       if (kDebugMode) {
//         print('Response status: ${response.statusCode}');
//         print('Response body: ${response.data}');
//       }

//       return response;
//     } on DioException catch (e) {
//       if (kDebugMode) {
//         print('Request error: ${e.response?.statusCode} ${e.response?.data}');
//       }
//       rethrow;
//     }
//   }

//   Future<Response> getData(String endpoint) async {
//     final token = await getAuthToken();
//     if (token != null) {
//       _dioClient.dio.options.headers["Authorization"] = "Bearer $token";
//     }

//     if (kDebugMode) {
//       print('GET request to: ${_dioClient.dio.options.baseUrl}$endpoint');
//       print('Headers: ${_dioClient.dio.options.headers}');
//     }

//     final response = await _dioClient.dio.get(endpoint);

//     if (kDebugMode) {
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.data}');
//     }

//     return response;
//   }

//   Future<Response> putData(String endpoint, Map<String, dynamic> data) async {
//     final token = await getAuthToken();
//     if (token != null) {
//       _dioClient.dio.options.headers["Authorization"] = "Bearer $token";
//     }

//     if (kDebugMode) {
//       print('PUT request to: ${_dioClient.dio.options.baseUrl}$endpoint');
//       print('Headers: ${_dioClient.dio.options.headers}');
//       print('Body: $data');
//     }

//     final response = await _dioClient.dio.put(endpoint, data: data);

//     if (kDebugMode) {
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.data}');
//     }

//     return response;
//   }

//   Future<Response> deleteData(String endpoint) async {
//     final token = await getAuthToken();
//     if (token != null) {
//       _dioClient.dio.options.headers["Authorization"] = "Bearer $token";
//     }

//     if (kDebugMode) {
//       print('DELETE request to: ${_dioClient.dio.options.baseUrl}$endpoint');
//       print('Headers: ${_dioClient.dio.options.headers}');
//     }

//     final response = await _dioClient.dio.delete(endpoint);

//     if (kDebugMode) {
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.data}');
//     }

//     return response;
//   }
// }
