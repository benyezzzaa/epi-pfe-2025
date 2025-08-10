import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import 'package:pfe/core/utils/app_api.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppApi.baseUrl,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final GetStorage _storage = GetStorage();

  /// GET
  Future<Response> get(String endpoint) async {
    _dio.options.headers['Authorization'] = 'Bearer ${_storage.read('token')}';
    return await _dio.get(endpoint);
  }

  /// POST
  Future<Response> post(String endpoint, Map<String, dynamic> data, {bool useToken = true}) async {
    try {
      print('📡 ApiService.post - URL: $endpoint');
      print('📡 ApiService.post - Data: $data');
      print('📡 ApiService.post - UseToken: $useToken');
      
      if (useToken) {
        final token = _storage.read('token');
        if (token != null) {
          _dio.options.headers['Authorization'] = 'Bearer $token';
          print('📡 ApiService.post - Token ajouté');
        } else {
          print('📡 ApiService.post - Aucun token trouvé');
        }
      }
      
      final response = await _dio.post(endpoint, data: data);
      print('📡 ApiService.post - Réponse reçue: ${response.statusCode}');
      return response;
    } catch (e) {
      print('❌ Erreur dans ApiService.post: $e');
      
      // Log détaillé pour les erreurs Dio
      if (e.toString().contains('DioException')) {
        print('❌ Type d\'erreur: DioException');
        if (e.toString().contains('status code of 400')) {
          print('❌ Erreur 400 - Bad Request');
        } else if (e.toString().contains('status code of 404')) {
          print('❌ Erreur 404 - Not Found');
        } else if (e.toString().contains('status code of 500')) {
          print('❌ Erreur 500 - Internal Server Error');
        }
      }
      
      rethrow;
    }
  }

  /// PATCH
  Future<Response> patch(String endpoint, Map<String, dynamic> data) async {
    final token = _storage.read('token');
    return await _dio.patch(
      endpoint,
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// PUT
  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    final token = _storage.read('token');
    return await _dio.put(
      endpoint,
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// DOWNLOAD PDF
  Future<void> downloadPdf(int commandeId) async {
    try {
      print('📄 Début du téléchargement PDF pour la commande: $commandeId');
      
      // Récupérer le token d'authentification
      final token = _storage.read('token');
      if (token == null) {
        throw Exception('Token d\'authentification non trouvé');
      }
      
      print('📄 Token récupéré, préparation du téléchargement...');
      
      // Créer le répertoire de téléchargement
      final dir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${dir.path}/downloads');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      
      // Nom du fichier avec timestamp pour éviter les conflits
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'commande_${commandeId}_$timestamp.pdf';
      final savePath = "${downloadsDir.path}/$fileName";
      
      print('📄 Chemin de sauvegarde: $savePath');
      
      // Configuration de la requête avec timeout plus long pour les gros fichiers
      final response = await _dio.get(
        "${AppApi.getCommandeUrl}/pdf/$commandeId",
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/pdf',
          },
          receiveTimeout: const Duration(minutes: 5), // Timeout plus long pour les PDFs
          sendTimeout: const Duration(seconds: 30),
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(1);
            print('📄 Progression: $progress% ($received/$total bytes)');
          }
        },
      );
      
      print('📄 Réponse reçue - Status: ${response.statusCode}');
      print('📄 Taille des données: ${response.data?.length ?? 0} bytes');
      
      // Vérifier que nous avons reçu des données
      if (response.data == null || response.data.isEmpty) {
        throw Exception('Aucune donnée reçue du serveur');
      }
      
      // Vérifier le type de contenu
      final contentType = response.headers.map['content-type']?.first;
      print('📄 Type de contenu: $contentType');
      
      if (contentType != null && !contentType.contains('application/pdf')) {
        print('⚠️ Attention: Le contenu reçu n\'est pas un PDF (type: $contentType)');
      }
      
      // Écrire le fichier
      final file = File(savePath);
      await file.writeAsBytes(response.data);
      
      print('📄 Fichier sauvegardé: $savePath');
      print('📄 Taille du fichier: ${await file.length()} bytes');
      
      // Vérifier que le fichier a été créé et n'est pas vide
      if (!await file.exists()) {
        throw Exception('Le fichier n\'a pas été créé');
      }
      
      final fileSize = await file.length();
      if (fileSize == 0) {
        throw Exception('Le fichier créé est vide');
      }
      
      print('📄 Fichier PDF créé avec succès (${fileSize} bytes)');
      
      // Ouvrir le fichier
      try {
        final result = await OpenFile.open(savePath);
        print('📄 Résultat de l\'ouverture: $result');
        
        if (result.type != ResultType.done) {
          print('⚠️ Problème lors de l\'ouverture: ${result.message}');
          // Le fichier a été téléchargé mais n'a pas pu être ouvert
          // On peut quand même considérer que c'est un succès
        }
      } catch (openError) {
        print('❌ Erreur lors de l\'ouverture du fichier: $openError');
        // Le fichier a été téléchargé mais n'a pas pu être ouvert automatiquement
        // L'utilisateur peut le trouver dans le dossier de téléchargement
      }
      
    } catch (e) {
      print('❌ Erreur téléchargement PDF: $e');
      
      // Messages d'erreur plus spécifiques
      String errorMessage = 'Erreur lors du téléchargement';
      
      if (e.toString().contains('DioException')) {
        if (e.toString().contains('status code of 404')) {
          errorMessage = 'PDF non trouvé pour cette commande';
        } else if (e.toString().contains('status code of 401')) {
          errorMessage = 'Accès non autorisé - Veuillez vous reconnecter';
        } else if (e.toString().contains('status code of 500')) {
          errorMessage = 'Erreur serveur - Veuillez réessayer plus tard';
        } else if (e.toString().contains('timeout')) {
          errorMessage = 'Délai d\'attente dépassé - Vérifiez votre connexion';
        }
      } else if (e.toString().contains('Permission')) {
        errorMessage = 'Permission refusée pour sauvegarder le fichier';
      } else if (e.toString().contains('Token')) {
        errorMessage = 'Session expirée - Veuillez vous reconnecter';
      }
      
      throw Exception(errorMessage);
    }
  }

  Dio get dio => _dio;
}
