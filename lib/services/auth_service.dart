import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trust_reservation_second/services/api_service.dart';
import 'package:trust_reservation_second/services/local_storage.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Response> login(Map<String, dynamic> credentials) async {
    final response = await _apiService.postData('/auth/login/', credentials, requireToken: false);
    if (response.statusCode == 200) {
      final jwtToken = response.data['jwt'];
      final refreshToken = response.data['refresh'];
      await LocalStorageService.saveData('token', jwtToken);
      await LocalStorageService.saveData('refreshToken', refreshToken);
      final userId = response.data['user_id'];
      await LocalStorageService.saveData('userId', userId);
      final userType = response.data['user_type'];
      await LocalStorageService.saveData('user_type', userType);
      final specificId = response.data['specific_id']; 
      await LocalStorageService.saveData('specific_id', specificId); 
    }
    return response;
  }

  Future<void> logout() async {
    try {
      final refreshToken = await LocalStorageService.getData('refreshToken');
      if (refreshToken == null) {
        if (kDebugMode) {
          print('Refresh token is missing');
        }
        return;
      }
      final response = await _apiService.postData('/auth/logout/', {'refresh': refreshToken}, requireToken: true);
      if (response.statusCode == 205) {
        await LocalStorageService.clearAllData();
        if (kDebugMode) {
          print('Déconnexion réussie.');
        }
      } else {
        if (kDebugMode) {
          print('Erreur lors de la déconnexion : ${response.statusCode} - ${response.data}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception lors de la déconnexion : $e');
      }
    }
  }

  Future<Response?> passwordResetRequest(String emailOrPhone) async {
    final data = {
      'action': 'request_reset',
      'email_or_phone': emailOrPhone,
    };
    try {
      return await _apiService.postData('/auth/password/reset/', data, requireToken: false);
      // return await _apiService.postData('/auth/passwordResetFlutter/reset/', data, requireToken: false);
    } catch (e) {
      if (kDebugMode) {
        print('Exception lors de la demande de réinitialisation du mot de passe : $e');
      }
      return null;
    }
  }

  Future<Response?> resetPassword(String email, String verificationCode, String newPassword, String confirmNewPassword) async {
    final data = {
      'action': 'reset_password',
      'email': email,
      'verification_code': verificationCode,
      'new_password': newPassword,
      'confirm_new_password': confirmNewPassword,
    };
    try {
      return await _apiService.postData('/auth/password/reset/', data, requireToken: false);
      // return await _apiService.postData('/auth/passwordResetFlutter/reset/', data, requireToken: false);
    } catch (e) {
      if (kDebugMode) {
        print('Exception lors de la réinitialisation du mot de passe : $e');
      }
      return null;
    }
  }
}

// / import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:trust_reservation_second/services/api_service.dart';
// import 'package:trust_reservation_second/services/local_storage.dart';

// class AuthService {
//   final ApiService _apiService = ApiService();

//   Future<Response> login(Map<String, dynamic> credentials) async {
//     final response = await _apiService.postData('/auth/login/', credentials, requireToken: false);
//     if (response.statusCode == 200) {
//       final jwtToken = response.data['jwt'];
//       final refreshToken = response.data['refresh'];
//       await LocalStorageService.saveData('token', jwtToken);
//       await LocalStorageService.saveData('refreshToken', refreshToken);
//       final userId = response.data['user_id'];
//       await LocalStorageService.saveData('userId', userId);
//       final userType = response.data['user_type'];
//       await LocalStorageService.saveData('user_type', userType);
//       final specificId = response.data['specific_id']; 
//       await LocalStorageService.saveData('specific_id', specificId); 
//     }
//     return response;
//   }

//   Future<void> logout() async {
//   if (kDebugMode) {
//     print('Début de la déconnexion...');
//   }
//   try {
//     final refreshToken = await LocalStorageService.getData('refreshToken');
//     if (refreshToken == null) {
//       if (kDebugMode) {
//         print('Refresh token is missing');
//       }
//       return;
//     }

//     if (kDebugMode) {
//       print('Refresh token: $refreshToken');
//     }

//     final response = await _apiService.postData('/auth/logout/', {'refresh': refreshToken}, requireToken: true);
//     if (response.statusCode == 205) {
//       await LocalStorageService.removeData('token');
//       await LocalStorageService.removeData('refreshToken');
//       await LocalStorageService.removeData('userId');
//       await LocalStorageService.removeData('userType');
//       await LocalStorageService.removeData('specificId');
//       if (kDebugMode) {
//         print('Déconnexion réussie.');
//       }
//     } else {
//       if (kDebugMode) {
//         print('Erreur lors de la déconnexion : ${response.statusCode} - ${response.data}');
//       }
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print('Exception lors de la déconnexion : $e');
//     }
//   }
// }
  // Future<void> logout() async {
  //   try {
  //     final refreshToken = await LocalStorageService.getData('refreshToken');
  //     if (refreshToken == null) {
  //       print('Refresh token is missing');
  //       return;
  //     }

  //     final response = await _apiService.postData('/auth/logout/', {'refresh': refreshToken}, requireToken: true);
  //     if (response.statusCode == 205) {
  //       await LocalStorageService.clearAllData();
  //       print('Déconnexion réussie.');
  //     } else {
  //       print('Erreur lors de la déconnexion : ${response.statusCode} - ${response.data}');
  //     }
  //   } catch (e) {
  //     print('Exception lors de la déconnexion : $e');
  //   }
  // }

 

//   Future<Response?> passwordResetRequest(String emailOrPhone) async {
//     final data = {
//       'action': 'request_reset',
//       'email_or_phone': emailOrPhone,
//     };
//     try {
//       return await _apiService.postData('/auth/password/reset/', data, requireToken: false);
//       // return await _apiService.postData('/auth/passwordResetFlutter/reset/', data, requireToken: false);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Exception lors de la demande de réinitialisation du mot de passe : $e');
//       }
//       return null;
//     }
//   }

//   Future<Response?> resetPassword(String email, String verificationCode, String newPassword, String confirmNewPassword) async {
//     final data = {
//       'action': 'reset_password',
//       'email': email,
//       'verification_code': verificationCode,
//       'new_password': newPassword,
//       'confirm_new_password': confirmNewPassword,
//     };
//     try {
//       return await _apiService.postData('/auth/password/reset/', data, requireToken: false);
//       // return await _apiService.postData('/auth/passwordResetFlutter/reset/', data, requireToken: false);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Exception lors de la réinitialisation du mot de passe : $e');
//       }
//       return null;
//     }
//   }
// }
