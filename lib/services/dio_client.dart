import 'package:dio/dio.dart';
import 'package:trust_reservation_second/services/local_storage.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'http://192.168.1.77:8080/api',
            connectTimeout: Duration(seconds: 5),
            receiveTimeout: Duration(seconds: 3),
          ),
        ) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Ajouter les en-têtes communs ici
        final token = await LocalStorageService.getData('token');
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Gérer la réponse ici
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Gérer les erreurs ici
        return handler.next(e);
      },
    ));
  }
}
