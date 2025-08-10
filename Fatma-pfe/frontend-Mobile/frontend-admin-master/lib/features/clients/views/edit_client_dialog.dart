import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pfe/features/clients/controllers/client_controller.dart';
import 'package:pfe/features/clients/models/client_model.dart';
import 'package:pfe/core/utils/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:pfe/core/utils/app_api.dart';
import 'package:pfe/features/clients/services/geocoding_service.dart';
import 'dart:async';

class EditClientDialog extends StatefulWidget {
  final ClientModel client;
  const EditClientDialog({Key? key, required this.client}) : super(key: key);

  @override
  State<EditClientDialog> createState() => _EditClientDialogState();
}

class _EditClientDialogState extends State<EditClientDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;
  late TextEditingController _adresseController;
  late TextEditingController _codeFiscaleController;

  final ClientController clientController = Get.find<ClientController>();

  LatLng? selectedLocation;
  Set<Marker> markers = {};
  List<dynamic> categories = [];
  dynamic selectedCategorie;
  bool isLoading = false;
  Timer? _debounceTimer;
  bool _isGeocoding = false;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.client.nom);
    _prenomController = TextEditingController(text: widget.client.prenom);
    _emailController = TextEditingController(text: widget.client.email);
    _telephoneController = TextEditingController(text: widget.client.telephone);
    _adresseController = TextEditingController(text: widget.client.adresse);
    _codeFiscaleController = TextEditingController(text: widget.client.codeFiscale ?? '');
    selectedLocation = (widget.client.latitude != null && widget.client.longitude != null)
        ? LatLng(widget.client.latitude!, widget.client.longitude!)
        : null;
    selectedCategorie = null; // On attend le fetch pour l'initialiser
    fetchCategories();
    if (selectedLocation != null) {
      markers = {
        Marker(
          markerId: const MarkerId('selectedLocation'),
          position: selectedLocation!,
          infoWindow: const InfoWindow(title: 'Position actuelle'),
        ),
      };
    }
  }

  Future<void> fetchCategories() async {
    try {
      final token = await StorageService.getToken();
      final response = await Dio().get(
        '${AppApi.baseUrl}/categorie-client',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final cats = response.data is List ? response.data : response.data['data'];
      int? initialCategorieId;
      if (widget.client.categorieNom != null && widget.client.categorieNom!.isNotEmpty) {
        final found = cats.firstWhere(
          (cat) => cat['nom'] == widget.client.categorieNom,
          orElse: () => null,
        );
        if (found != null) initialCategorieId = found['id'];
      }
      setState(() {
        categories = cats;
        selectedCategorie = initialCategorieId;
      });
    } catch (e) {
      // ignore
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _adresseController.dispose();
    _codeFiscaleController.dispose();
    super.dispose();
  }

  void _onMapTap(LatLng location) async {
    print('🗺️ Clic sur la carte à la position: ${location.latitude}, ${location.longitude}');
    
    setState(() {
      selectedLocation = location;
      markers = {
        Marker(
          markerId: const MarkerId('selectedLocation'),
          position: location,
          infoWindow: const InfoWindow(title: 'Position sélectionnée'),
        ),
      };
    });

    // Obtenir l'adresse à partir des coordonnées
    print('🔍 Début du reverse geocodage...');
    final address = await GeocodingService.reverseGeocode(location);
    
    if (address != null) {
      print('✅ Adresse trouvée: $address');
      setState(() {
        _adresseController.text = address;
      });
      print('📝 Adresse mise à jour dans le champ');
    } else {
      print('❌ Aucune adresse trouvée pour cette position');
      Get.snackbar(
        'Information',
        'Impossible de récupérer l\'adresse pour cette position',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _geocodeAddress(String address) async {
    if (address.trim().length < 5) return;
    setState(() => _isGeocoding = true);
    try {
      final result = await GeocodingService.geocodeAddress(address);
      if (result != null) {
        final lat = result['latitude'];
        final lon = result['longitude'];
        final location = LatLng(lat, lon);
        setState(() {
          selectedLocation = location;
          markers = {
            Marker(
              markerId: const MarkerId('selectedLocation'),
              position: location,
              infoWindow: InfoWindow(title: 'Adresse trouvée'),
            ),
          };
        });
      }
    } finally {
      setState(() => _isGeocoding = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedLocation == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner une position sur la carte', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedCategorie == null) {
      Get.snackbar('Erreur', 'Veuillez choisir une catégorie', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    setState(() => isLoading = true);
    final updated = await clientController.updateClient(
      id: widget.client.id,
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
      adresse: _adresseController.text,
      telephone: _telephoneController.text,
      latitude: selectedLocation!.latitude,
      longitude: selectedLocation!.longitude,
      codeFiscale: _codeFiscaleController.text,
      categorieId: selectedCategorie,
    );
    setState(() => isLoading = false);
    if (updated != null) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Modifier le client', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: colorScheme.primary)),
                const SizedBox(height: 16),
                
                // Section Informations de base
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F51B5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3F51B5).withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Informations de base',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Raison sociale *', border: OutlineInputBorder()),
                  validator: (v) => v == null || v.isEmpty ? 'La raison sociale est requise' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prenomController,
                  decoration: const InputDecoration(labelText: 'Responsable *', border: OutlineInputBorder()),
                  validator: (v) => v == null || v.isEmpty ? 'Le responsable est requis' : null,
                ),
                const SizedBox(height: 16),
                
                // Section Contact
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F51B5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3F51B5).withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email *', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'L\'email est requis';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Veuillez saisir un email valide';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _telephoneController,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone * (format: 06 12 34 56 78)',
                    border: OutlineInputBorder(),
                    hintText: 'Ex: 06 12 34 56 78 ou +33 6 12 34 56 78',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Le téléphone est requis';
                    final cleanNumber = v.replaceAll(RegExp(r'[\s\-\.]'), '').replaceAll(RegExp(r'[^\d+]'), '');
                    if (!RegExp(r'^(\+33|0|33)[1-9](\d{8})$').hasMatch(cleanNumber)) return 'Format invalide. Utilisez: 06 12 34 56 78, +33 6 12 34 56 78 ou 33 6 12 34 56 78';
                    return null;
                  },
                  onChanged: (value) {
                    // Nettoyer et formater automatiquement
                    final cleanNumber = value.replaceAll(RegExp(r'[\s\-\.]'), '').replaceAll(RegExp(r'[^\d+]'), '');
                    
                    if (cleanNumber.length > 0) {
                      String formatted = cleanNumber;
                      
                      // Convertir en format international si nécessaire
                      if (cleanNumber.startsWith('0') && cleanNumber.length == 10) {
                        formatted = '+33${cleanNumber.substring(1)}';
                      } else if (cleanNumber.startsWith('33') && cleanNumber.length == 11) {
                        formatted = '+$cleanNumber';
                      } else if (cleanNumber.startsWith('+33') && cleanNumber.length == 12) {
                        // Déjà au bon format
                        formatted = cleanNumber;
                      }
                      
                      // Ajouter des espaces pour une meilleure lisibilité
                      if (formatted.startsWith('+33')) {
                        formatted = formatted.replaceAllMapped(
                          RegExp(r'^(\+33)(\d{1})(\d{2})(\d{2})(\d{2})(\d{2})$'),
                          (match) => '${match[1]} ${match[2]} ${match[3]} ${match[4]} ${match[5]} ${match[6]}'
                        );
                      }
                      
                      if (formatted != value) {
                        _telephoneController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _adresseController,
                  maxLines: 2,
                  validator: (v) => v == null || v.isEmpty ? 'L\'adresse est requise' : null,
                  onChanged: (value) {
                    _debounceTimer?.cancel();
                    if (value.trim().length < 5) return;
                    _debounceTimer = Timer(const Duration(milliseconds: 1200), () {
                      _geocodeAddress(value);
                    });
                  },
                  // Ajoute un indicateur de chargement si géocodage en cours
                  decoration: InputDecoration(
                    labelText: 'Adresse *',
                    border: const OutlineInputBorder(),
                    suffixIcon: _isGeocoding
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Section Informations légales
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F51B5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3F51B5).withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Informations légales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _codeFiscaleController,
                  decoration: const InputDecoration(
                    labelText: 'SIRET *',
                    border: OutlineInputBorder(),
                    hintText: 'Ex: 12345678901234',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 14,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Le SIRET est requis';
                    final clean = v.trim().replaceAll(RegExp(r'\s+'), '');
                    if (!RegExp(r'^\d{14}$').hasMatch(clean)) return 'Le SIRET doit contenir exactement 14 chiffres';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  value: selectedCategorie,
                  items: categories.map<DropdownMenuItem>((cat) {
                    return DropdownMenuItem(
                      value: cat['id'],
                      child: Text(cat['nom']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategorie = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Catégorie de client *', border: OutlineInputBorder()),
                  validator: (value) => value == null ? 'La catégorie est requise' : null,
                ),
                const SizedBox(height: 16),
                
                // Section Localisation
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F51B5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3F51B5).withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Localisation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: GoogleMap(
                      onTap: _onMapTap,
                      initialCameraPosition: CameraPosition(
                        target: selectedLocation ?? const LatLng(48.8566, 2.3522),
                        zoom: selectedLocation != null ? 14 : 6,
                      ),
                      markers: markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _submitForm,
                      icon: isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
                      label: const Text('Enregistrer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 