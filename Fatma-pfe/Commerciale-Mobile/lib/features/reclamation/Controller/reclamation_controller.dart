import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pfe/core/utils/app_api.dart';

class ReclamationController extends GetxController {
  final Dio dio = Dio(BaseOptions(baseUrl: AppApi.baseUrl));
  final token = GetStorage().read('token');

  final RxList clients = [].obs;
  final RxBool isLoading = true.obs;
  final selectedClientId = Rxn<int>();
  final selectedClientName = ''.obs;
  final RxList filteredClients = [].obs;

  final sujetController = TextEditingController();
  final descriptionController = TextEditingController();
  final clientSearchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Map<String, String> get headers => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  // Fonction utilitaire pour valider et formater les dates
  static String formatDateForDisplay(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Date non disponible';
    }
    
    try {
      final date = DateTime.tryParse(dateString);
      if (date != null) {
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else {
        print('❌ Impossible de parser la date: $dateString');
        return 'Date invalide';
      }
    } catch (e) {
      print('❌ Erreur formatage date: $e');
      return 'Erreur de date';
    }
  }

  // Fonction pour valider et corriger une date
  static String validateAndFixDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now().toIso8601String();
    }
    
    try {
      final date = DateTime.tryParse(dateString);
      if (date != null) {
        return date.toIso8601String();
      } else {
        print('⚠️ Date invalide, utilisation de la date actuelle: $dateString');
        return DateTime.now().toIso8601String();
      }
    } catch (e) {
      print('❌ Erreur validation date: $e');
      return DateTime.now().toIso8601String();
    }
  }

  @override
  void onInit() {
    fetchClients();
     fetchMyReclamations();
    super.onInit();
  }
final RxList mesReclamations = [].obs;

Future<void> fetchMyReclamations() async {
  isLoading.value = true;
  try {
    print('🔄 Récupération des réclamations...');
    final res = await dio.get('/reclamations/me', options: Options(headers: headers));
    
    // Debug des données reçues
    print('📡 Données reçues: ${res.data.runtimeType}');
    print('📊 Nombre de réclamations: ${res.data.length}');
    
    // Validation et nettoyage des données
    List processedData = [];
    for (var reclamation in res.data) {
      print('🔍 Traitement réclamation: ${reclamation.runtimeType}');
      
      // Validation de la date
      reclamation['created_at'] = validateAndFixDate(reclamation['created_at']);
      
      // Validation des autres champs
      reclamation['sujet'] = reclamation['sujet'] ?? 'Sujet non spécifié';
      reclamation['description'] = reclamation['description'] ?? 'Aucune description';
      reclamation['status'] = reclamation['status'] ?? 'Ouverte';
      
      processedData.add(reclamation);
    }
    
    mesReclamations.value = processedData;
    print('✅ Réclamations traitées: ${processedData.length}');
  } catch (e) {
    print('❌ Erreur fetchMyReclamations: $e');
    Get.snackbar('Erreur', 'Impossible de récupérer les réclamations');
  } finally {
    isLoading.value = false;
  }
}
  Future<void> fetchClients() async {
    try {
      final res = await dio.get('/client/mes-clients', options: Options(headers: headers));
      clients.value = res.data;
      // Initialiser la liste filtrée avec tous les clients
      filteredClients.value = res.data;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les clients');
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour rechercher des clients
  void searchClient(String query) {
    if (query.isEmpty) {
      filteredClients.value = clients;
    } else {
      filteredClients.value = clients.where((client) {
        final nom = (client['nom'] ?? '').toString().toLowerCase();
        final adresse = (client['adresse'] ?? '').toString().toLowerCase();
        final searchQuery = query.toLowerCase();
        
        return nom.contains(searchQuery) || adresse.contains(searchQuery);
      }).toList();
    }
  }

  // Méthode pour sélectionner un client
  void selectClient(Map<String, dynamic> client) {
    selectedClientId.value = client['id'];
    selectedClientName.value = client['nom'] ?? 'Client inconnu';
    clientSearchController.text = client['nom'] ?? '';
    // Vider la liste filtrée après sélection
    filteredClients.clear();
  }

  // Méthode pour effacer la sélection de client
  void clearSelectedClient() {
    selectedClientId.value = null;
    selectedClientName.value = '';
    clientSearchController.clear();
    // Remettre tous les clients dans la liste filtrée
    filteredClients.value = clients;
  }

 Future<void> submitReclamation() async {
  if (!formKey.currentState!.validate()) return;

  try {
    final res = await dio.post(
      '/reclamations',
      data: jsonEncode({
        'clientId': selectedClientId.value,
        'sujet': sujetController.text,
        'description': descriptionController.text,
      }),
      options: Options(headers: headers),
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      // ✅ Rafraîchir les réclamations après ajout
      await fetchMyReclamations();

      // ✅ Fermer le formulaire et passer un message de succès
      Get.back(result: 'added'); // on envoie 'added' comme résultat
    } else {
      Get.snackbar('Erreur', 'Échec de l’envoi');
    }
  } catch (e) {
    Get.snackbar('Erreur', 'Exception : $e');
  }
}
}
