// 📁 lib/features/client/services/client_service.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pfe/core/utils/app_api.dart';
import 'package:pfe/features/clients/models/client_model.dart';

class ClientService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppApi.baseUrl));

  Future<List<Map<String, dynamic>>> fetchClients() async {
    final response = await _dio.get("/client");
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception("Échec de chargement des clients");
    }
  }

  /// Vérifier si un numéro SIRET existe déjà
  Future<bool> checkSiretExists(String siret) async {
    try {
      final box = GetStorage();
      final token = box.read('token');

      final response = await _dio.get(
        '/clients/check-siret/$siret',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['exists'] ?? false;
      } else {
        throw Exception("Erreur lors de la vérification du SIRET");
      }
    } catch (e) {
      print('Erreur lors de la vérification du SIRET: $e');
      // En cas d'erreur, on considère que le SIRET existe pour éviter les doublons
      return true;
    }
  }

  Future<ClientModel> ajouterClient(Map<String, dynamic> data) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await _dio.post(
      '/clients',
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ClientModel.fromJson(response.data);
    } else {
      throw Exception("Erreur ajout client");
    }
  }
}
