import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pfe/features/clients/models/client_model.dart';

class PositionsMapPage extends StatefulWidget {
  const PositionsMapPage({super.key});

  @override
  State<PositionsMapPage> createState() => _PositionsMapPageState();
}

class _PositionsMapPageState extends State<PositionsMapPage> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Position? currentPosition;
  String _error = '';
  bool _isLoading = true;

  Map<String, dynamic>? commercial;
  ClientModel? client;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      commercial = arguments['commercial'];
      client = arguments['client'];
    }

    await _getCurrentLocation();
    _addMarkers();
    _createRoute();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          setState(() {
            _error = 'Permission de localisation refusée.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _error = 'La permission de localisation est refusée de manière permanente.';
        });
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Erreur lors de l\'obtention de la position: ${e.toString()}';
      });
    }
  }

  void _addMarkers() {
    // Utiliser la position GPS actuelle pour le commercial connecté
    if (currentPosition != null) {
      markers.add(Marker(
        markerId: const MarkerId('commercial'),
        position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        infoWindow: InfoWindow(
          title: commercial != null 
            ? 'Commercial: ${commercial!['nom']} ${commercial!['prenom']}'
            : 'Votre Position',
          snippet: 'Position GPS actuelle',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }

    if (client != null && client!.latitude != null && client!.longitude != null) {
      markers.add(Marker(
        markerId: const MarkerId('client'),
        position: LatLng(client!.latitude!, client!.longitude!),
        infoWindow: InfoWindow(
          title: 'Client: ${client!.fullName}',
          snippet: client!.adresse,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }

    // Suppression du marqueur vert séparé car la position actuelle est maintenant le marqueur commercial
    // Le marqueur bleu représente déjà la position GPS actuelle du commercial
  }

  void _createRoute() {
    List<LatLng> routePoints = [];

    // Utiliser la position GPS actuelle comme point de départ
    if (currentPosition != null) {
      routePoints.add(LatLng(currentPosition!.latitude, currentPosition!.longitude));
    }

    if (client != null && client!.latitude != null && client!.longitude != null) {
      routePoints.add(LatLng(client!.latitude!, client!.longitude!));
    }

    if (routePoints.length >= 2) {
      polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: Colors.blue,
        width: 4,
        geodesic: true,
      ));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fitBounds();
  }

  void _fitBounds() {
    List<LatLng> allPoints = [];

    // Utiliser la position GPS actuelle au lieu des coordonnées fixes du commercial
    if (currentPosition != null) {
      allPoints.add(LatLng(currentPosition!.latitude, currentPosition!.longitude));
    }

    if (client != null && client!.latitude != null && client!.longitude != null) {
      allPoints.add(LatLng(client!.latitude!, client!.longitude!));
    }

    if (currentPosition != null) {
      bool isDifferentFromCommercial = true;
      if (commercial != null && commercial!['latitude'] != null && commercial!['longitude'] != null) {
        final commercialLat = (commercial!['latitude'] as num).toDouble();
        final commercialLng = (commercial!['longitude'] as num).toDouble();
        final distance = Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          commercialLat,
          commercialLng,
        );
        isDifferentFromCommercial = distance > 100;
      }

      if (isDifferentFromCommercial) {
        allPoints.add(LatLng(currentPosition!.latitude, currentPosition!.longitude));
      }
    }

    if (allPoints.isNotEmpty) {
      if (allPoints.length == 1) {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(allPoints.first, 15.0),
        );
      } else {
        double minLat = allPoints.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
        double maxLat = allPoints.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
        double minLng = allPoints.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
        double maxLng = allPoints.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

        mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(minLat, minLng),
              northeast: LatLng(maxLat, maxLng),
            ),
            50.0,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Positions sur la carte'),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Positions sur la carte'),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                _error,
                style: TextStyle(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    LatLng initialPosition;
    if (currentPosition != null) {
      // Utiliser la position GPS actuelle comme position initiale
      initialPosition = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    } else if (client != null && client!.latitude != null && client!.longitude != null) {
      initialPosition = LatLng(client!.latitude!, client!.longitude!);
    } else {
      initialPosition = const LatLng(48.8566, 2.3522); // Paris par défaut
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Positions sur la carte', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12.0,
        ),
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }
}
