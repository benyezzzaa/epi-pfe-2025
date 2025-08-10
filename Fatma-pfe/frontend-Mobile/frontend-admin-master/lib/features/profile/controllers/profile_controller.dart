import 'package:get/get.dart';
import 'package:pfe/core/utils/storage_services.dart';
import 'package:pfe/core/utils/app_api.dart';
import 'package:dio/dio.dart';

class ProfileController extends GetxController {
  var nom = ''.obs;
  var prenom = ''.obs;
  var email = ''.obs;
  var tel = ''.obs;
  var role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final user = StorageService.getUser();
    if (user != null) {
      nom.value = user['nom'] ?? '';
      prenom.value = user['prenom'] ?? '';
      email.value = user['email'] ?? '';
      tel.value = user['tel'] ?? '';
      role.value = user['role'] ?? '';
    }
  }

  Future<void> updateProfile({
    required String nom,
    required String prenom,
    required String email,
    required String tel,
    String? password,
  }) async {
    try {
      final token = StorageService.getToken();
      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final user = StorageService.getUser();
      if (user == null) {
        throw Exception('Données utilisateur non trouvées');
      }
      
      final dio = Dio(BaseOptions(baseUrl: AppApi.baseUrl));
      
      // Si un mot de passe est fourni, l'envoyer à l'API
      if (password != null && password.isNotEmpty) {
        print('🔐 Mot de passe fourni pour mise à jour');
        
        final response = await dio.put(
          '/users/profile',
          data: {'password': password},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );

        print('📥 Réponse reçue - Status: ${response.statusCode}');
        print('📥 Réponse body: ${response.data}');

        if (response.statusCode != 200) {
          String errorMessage = 'Erreur lors de la mise à jour du mot de passe';
          if (response.data != null && response.data is Map) {
            if (response.data['message'] != null) {
              errorMessage = response.data['message'].toString();
            } else if (response.data['error'] != null) {
              errorMessage = response.data['error'].toString();
            }
          }
          throw Exception('Erreur ${response.statusCode}: $errorMessage');
        }
        
        print('✅ Mot de passe mis à jour avec succès');
      } else {
        print('🔐 Aucun mot de passe fourni - pas de mise à jour du mot de passe');
      }
      
      // Mettre à jour les valeurs locales (même si l'API ne les accepte pas)
      this.nom.value = nom;
      this.prenom.value = prenom;
      this.email.value = email;
      this.tel.value = tel;
      
      // Mettre à jour les données en local storage
      if (user != null) {
        user['nom'] = nom;
        user['prenom'] = prenom;
        user['email'] = email;
        user['tel'] = tel;
        StorageService.saveUser(user);
      }
      
      print('✅ Profil mis à jour avec succès');
      
    } catch (e) {
      print('❌ Erreur mise à jour profil: $e');
      if (e is DioException) {
        print('❌ DioException details:');
        print('   - Type: ${e.type}');
        print('   - Message: ${e.message}');
        print('   - Response: ${e.response?.data}');
        print('   - Status: ${e.response?.statusCode}');
        
        if (e.response?.data != null) {
          String errorMessage = 'Erreur serveur';
          if (e.response?.data is Map) {
            if (e.response?.data['message'] != null) {
              errorMessage = e.response?.data['message'].toString() ?? 'Erreur serveur';
            }
          }
          throw Exception(errorMessage);
        }
      }
      throw Exception('Erreur lors de la mise à jour du profil: $e');
    }
  }
}
