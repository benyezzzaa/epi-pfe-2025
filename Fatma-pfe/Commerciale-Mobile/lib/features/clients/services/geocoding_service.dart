import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  
  /// Convertit une adresse en coordonnées GPS
  static Future<Map<String, dynamic>?> geocodeAddress(String address) async {
    try {
      // Ajouter "France" à la recherche pour prioriser les résultats français
      final searchAddress = address.trim().isEmpty ? 'France' : '$address, France';
      
      final uri = Uri.parse('$_baseUrl/search')
          .replace(queryParameters: {
        'q': searchAddress,
        'format': 'json',
        'limit': '5',
        'countrycodes': 'fr', // Limiter aux résultats français
        'addressdetails': '1', // Obtenir les détails de l'adresse
        'accept-language': 'fr', // Résultats en français
      });

      print('🔍 Recherche d\'adresse: $searchAddress');
      print('📡 URL: $uri');

      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        
        if (results.isNotEmpty) {
          final result = results.first;
          final lat = double.parse(result['lat']);
          final lon = double.parse(result['lon']);
          
          // Extraire les détails de l'adresse
          final addressDetails = result['address'] ?? {};
          final displayName = result['display_name'] ?? '';
          
          print('✅ Adresse trouvée: $displayName');
          print('📍 Coordonnées: $lat, $lon');
          
          return {
            'latitude': lat,
            'longitude': lon,
            'displayName': displayName,
            'addressDetails': addressDetails,
            'fullAddress': _formatAddress(addressDetails, displayName),
          };
        }
      }
      
      print('❌ Aucun résultat trouvé pour: $address');
      return null;
    } catch (e) {
      print('❌ Erreur de géocodage: $e');
      return null;
    }
  }

  /// Convertit des coordonnées GPS en adresse (reverse geocoding)
  static Future<String?> reverseGeocode(LatLng position) async {
    try {
      print('🌍 Reverse geocodage pour: ${position.latitude}, ${position.longitude}');
      
      final uri = Uri.parse('$_baseUrl/reverse')
          .replace(queryParameters: {
        'lat': position.latitude.toString(),
        'lon': position.longitude.toString(),
        'format': 'json',
        'addressdetails': '1',
        'accept-language': 'fr',
      });

      print('📡 URL de reverse geocodage: $uri');
      final response = await http.get(uri);
      
      print('📊 Statut de la réponse: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('📄 Données reçues: $result');
        
        final addressDetails = result['address'] ?? {};
        final displayName = result['display_name'] ?? '';
        
        final formattedAddress = _formatAddress(addressDetails, displayName);
        print('📍 Adresse formatée: $formattedAddress');
        
        return formattedAddress;
      } else {
        print('❌ Erreur HTTP: ${response.statusCode} - ${response.body}');
      }
      
      return null;
    } catch (e) {
      print('❌ Erreur de reverse geocodage: $e');
      return null;
    }
  }

  /// Formate l'adresse de manière lisible
  static String _formatAddress(Map<String, dynamic> addressDetails, String displayName) {
    final parts = <String>[];
    
    // Ajouter les éléments de l'adresse dans l'ordre logique
    if (addressDetails['house_number'] != null) {
      parts.add(addressDetails['house_number']);
    }
    
    if (addressDetails['road'] != null) {
      parts.add(addressDetails['road']);
    }
    
    // Ajouter le nom de la rue si disponible
    if (addressDetails['name'] != null && addressDetails['name'].toString().isNotEmpty) {
      parts.add(addressDetails['name']);
    }
    
    // Ajouter le quartier/village
    if (addressDetails['suburb'] != null) {
      parts.add(addressDetails['suburb']);
    }
    
    if (addressDetails['village'] != null) {
      parts.add(addressDetails['village']);
    }
    
    if (addressDetails['town'] != null) {
      parts.add(addressDetails['town']);
    }
    
    if (addressDetails['city'] != null) {
      parts.add(addressDetails['city']);
    }
    
    // Ajouter le code postal
    if (addressDetails['postcode'] != null) {
      parts.add(addressDetails['postcode']);
    }
    
    // Ajouter la région/état
    if (addressDetails['state'] != null) {
      parts.add(addressDetails['state']);
    }
    
    // Ajouter le pays
    if (addressDetails['country'] != null) {
      parts.add(addressDetails['country']);
    }
    
    // Si on a des parties formatées, les utiliser
    if (parts.isNotEmpty) {
      final formattedAddress = parts.join(', ');
      print('🏠 Adresse formatée avec détails: $formattedAddress');
      return formattedAddress;
    } else {
      // Sinon utiliser display_name nettoyé
      final cleanedDisplayName = displayName
          .replaceAll(', France', '')
          .replaceAll(', Tunisie', '')
          .trim();
      print('🏠 Utilisation du display_name nettoyé: $cleanedDisplayName');
      return cleanedDisplayName;
    }
  }

  /// Vérifie si une adresse est valide
  static bool isValidAddress(String address) {
    return address.trim().length >= 5;
  }
} 