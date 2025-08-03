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
      
      final response = await dio.put(
        '/users/${user['id']}',
        data: {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'tel': tel,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        // Mettre à jour les valeurs locales
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
      } else {
        throw Exception('Erreur lors de la mise à jour du profil');
      }
    } catch (e) {
      print('❌ Erreur mise à jour profil: $e');
      throw Exception('Erreur lors de la mise à jour du profil: $e');
    }
  }
}
