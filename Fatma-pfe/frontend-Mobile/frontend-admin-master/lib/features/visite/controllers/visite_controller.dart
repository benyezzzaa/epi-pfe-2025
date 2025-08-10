import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pfe/core/utils/storage_services.dart';
import 'package:pfe/core/routes/app_routes.dart';
import 'package:pfe/features/clients/models/client_model.dart';
import '../models/raison_model.dart';
import '../models/visite_model.dart';
import '../services/visite_service.dart';

class VisiteController extends GetxController {
  final VisiteService _service = VisiteService();
  
  final clients = <ClientModel>[].obs;
  final raisons = <RaisonModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  final selectedDate = DateTime.now().obs;
  final selectedClient = Rx<ClientModel?>(null);
  final selectedRaison = Rx<RaisonModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final token = StorageService.getToken();
      if (token == null) {
        error.value = 'Token non trouvé. Veuillez vous reconnecter.';
        return;
      }
      
      print('🔄 Chargement des clients...');
      final clientsData = await _service.getClients(token);
      print('✅ Clients chargés: ${clientsData.length}');
      
      print('🔄 Chargement des raisons...');
      final raisonsData = await _service.getRaisons(token);
      print('✅ Raisons chargées: ${raisonsData.length}');
      
      clients.value = clientsData;
      raisons.value = raisonsData;
    } catch (e) {
      print('❌ Erreur lors du chargement: $e');
      error.value = 'Erreur lors du chargement des données: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createVisite() async {
    if (selectedClient.value == null || selectedRaison.value == null) {
      error.value = 'Veuillez sélectionner un client et une raison';
      return false;
    }

    isLoading.value = true;
    error.value = '';
    
    try {
      final token = StorageService.getToken();
      if (token == null) {
        error.value = 'Token non trouvé. Veuillez vous reconnecter.';
        return false;
      }
      
      final visiteResult = await _service.createVisite(
        token: token,
        date: selectedDate.value,
        clientId: selectedClient.value!.id,
        raisonId: selectedRaison.value!.id,
      );

      if (visiteResult.isSuccess) {
        print("Visite créée avec succès");
        
        // Ne pas naviguer ici, laisser la page de création gérer la navigation
        // La page de création utilisera Navigator.pop(context, true) pour revenir à la carte
        return true;
      } else {
        error.value = visiteResult.error ?? 'Une erreur inconnue est survenue lors de la création de la visite.';
        return false;
      }
      
    } catch (e) {
      error.value = 'Erreur inattendue lors de la création de la visite : '+e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }



  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setClient(ClientModel? client) {
    selectedClient.value = client;
  }

  void setRaison(RaisonModel? raison) {
    selectedRaison.value = raison;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Méthode pour récupérer les informations du commercial connecté
  Map<String, dynamic>? getConnectedCommercial() {
    return StorageService.getUser();
  }

  // Méthode pour afficher la carte avec les positions
  void showPositionsMap() {
    if (selectedClient.value == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez d\'abord sélectionner un client',
        backgroundColor: Get.theme?.colorScheme?.errorContainer,
        colorText: Get.theme?.colorScheme?.onErrorContainer,
      );
      return;
    }

    final commercial = getConnectedCommercial();
    if (commercial == null) {
      Get.snackbar(
        'Erreur',
        'Impossible de récupérer les informations du commercial',
        backgroundColor: Get.theme?.colorScheme?.errorContainer,
        colorText: Get.theme?.colorScheme?.onErrorContainer,
      );
      return;
    }

    // Naviguer vers la page de carte avec les positions
    Get.toNamed('/positions-map', arguments: {
      'commercial': commercial,
      'client': selectedClient.value,
    });
  }
} 