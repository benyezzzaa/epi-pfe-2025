import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/visite_controller.dart';
import 'package:pfe/features/clients/models/client_model.dart';
import '../models/raison_model.dart';
import '../models/visite_model.dart';
import '../services/visite_service.dart';
import 'package:pfe/core/utils/storage_services.dart';
import 'package:pfe/features/visite/views/all_visites_map_page.dart';

class CreateVisitePage extends StatefulWidget {
  final DateTime? initialDate;
  const CreateVisitePage({Key? key, this.initialDate}) : super(key: key);

  @override
  State<CreateVisitePage> createState() => _CreateVisitePageState();
}

class _CreateVisitePageState extends State<CreateVisitePage> with SingleTickerProviderStateMixin {
  final VisiteController controller = Get.put(VisiteController());
  List<VisiteModel> mesVisites = [];
  bool isLoadingVisites = false;
  String errorVisites = '';

  // Variables d'état à ajouter dans le State
  String _searchQuery = '';
  DateTime? _filterDate = DateTime.now(); // Initialiser avec la date d'aujourd'hui
  
  // Variables pour les onglets
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    
    // Initialiser avec la date d'aujourd'hui
    controller.setDate(DateTime.now());
    
    if (widget.initialDate != null) {
      controller.setDate(widget.initialDate!);
    }
    _loadMesVisites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMesVisites() async {
    setState(() {
      isLoadingVisites = true;
      errorVisites = '';
    });
    try {
      final t = StorageService.getToken();
      if (t != null && t.isNotEmpty) {
        mesVisites = await VisiteService().getAllVisites(t);
      } else {
        errorVisites = 'Token non trouvé.';
      }
    } catch (e) {
      errorVisites = 'Erreur lors du chargement des visites : $e';
    }
    setState(() {
      isLoadingVisites = false;
    });
  }

  // Méthode pour filtrer les visites selon les critères
  List<VisiteModel> _getFilteredVisites() {
    return mesVisites.where((visite) {
      // Filtre par nom/prénom du client
      bool matchesSearch = _searchQuery.isEmpty || 
          visite.client.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filtre par date (toujours une date sélectionnée maintenant)
      bool matchesDate = visite.date.year == _filterDate!.year && 
                        visite.date.month == _filterDate!.month && 
                        visite.date.day == _filterDate!.day;
      
      return matchesSearch && matchesDate;
    }).toList();
  }

  // Ajouter la méthode utilitaire pour grouper par date
  Map<String, List<VisiteModel>> _groupVisitesByDate(List<VisiteModel> visites) {
    final map = <String, List<VisiteModel>>{};
    for (final v in visites) {
      final dateStr = DateFormat('dd/MM/yyyy').format(v.date);
      map.putIfAbsent(dateStr, () => []).add(v);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer Visite', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3F51B5),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              Get.toNamed('/clients')?.then((added) {
                if (added == true) {
                  controller.loadData();
                }
              });
            },
            tooltip: 'Ajouter un client',
          ),
        ],
      ),
      body: Column(
        children: [
          // Onglets
          Container(
            color: colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              tabs: const [
                Tab(
                  icon: Icon(Icons.list),
                  text: 'Mes Visites',
                ),
                Tab(
                  icon: Icon(Icons.add),
                  text: 'Créer Visite',
                ),
              ],
            ),
          ),
          
          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Onglet "Mes Visites"
                _buildMesVisitesTab(),
                
                // Onglet "Créer Visite"
                _buildCreerVisiteTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMesVisitesTab() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section de recherche et filtres
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes Visites',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Champ de recherche
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Rechercher un client...',
                            prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Sélecteur de date
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _filterDate ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (date != null) setState(() => _filterDate = date);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.primary),
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.surfaceContainerLow,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today, size: 18, color: colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd/MM/yyyy').format(_filterDate!),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // La date d'aujourd'hui est toujours affichée par défaut
                              // Pas de bouton de suppression pour garder une date sélectionnée
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Liste des visites
          if (isLoadingVisites)
            const Center(child: CircularProgressIndicator())
          else if (errorVisites.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(errorVisites, style: TextStyle(color: colorScheme.error)),
              ),
            )
          else if (mesVisites.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 64, color: colorScheme.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune visite trouvée',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Créez votre première visite dans l\'onglet "Créer Visite"',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else
            // Filtrer les visites selon les critères
            ..._groupVisitesByDate(_getFilteredVisites()).entries.map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text(
                    entry.key,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.primary),
                  ),
                ),
                ...entry.value.map((visite) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(Icons.person, color: colorScheme.onPrimaryContainer),
                    ),
                    title: Text(visite.client.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (visite.client.adresse.isNotEmpty)
                          Text(visite.client.adresse, style: TextStyle(fontSize: 13)),
                        Text('Date : ' + DateFormat('dd/MM/yyyy').format(visite.date)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.map, color: colorScheme.primary),
                      onPressed: () {
                        controller.setClient(visite.client);
                        controller.showPositionsMap();
                      },
                      tooltip: 'Voir sur la carte',
                    ),
                  ),
                )),
              ],
            )),
        ],
      ),
    );
  }

  Widget _buildCreerVisiteTab() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: colorScheme.primary));
      }

      // Debug: afficher le nombre de clients et raisons chargés
      print('🔍 Debug - Clients chargés: ${controller.clients.length}');
      print('🔍 Debug - Raisons chargées: ${controller.raisons.length}');
      print('🔍 Debug - Client sélectionné: ${controller.selectedClient.value?.fullName ?? "Aucun"}');
      print('🔍 Debug - Raison sélectionnée: ${controller.selectedRaison.value?.nom ?? "Aucune"}');

      // Si aucune donnée n'est chargée, afficher un message et un bouton de rechargement
      if (controller.clients.isEmpty && controller.raisons.isEmpty && !controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 64, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                'Aucune donnée chargée',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vérifiez votre connexion internet',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => controller.loadData(),
                icon: const Icon(Icons.refresh),
                label: const Text('Recharger'),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date de visite
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date de visite',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: colorScheme,
                                dialogBackgroundColor: colorScheme.surface,
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null) {
                          controller.setDate(date);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
                              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
                            ),
                            Icon(Icons.calendar_today, color: colorScheme.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Client
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Indicateur de chargement des clients
                    if (controller.clients.isEmpty && !controller.isLoading.value)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: colorScheme.error, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Aucun client trouvé. Vérifiez votre connexion.',
                                style: TextStyle(color: colorScheme.error),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      // Champ de recherche avec autocomplétion
                      Autocomplete<ClientModel>(
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Tapez le prénom du client...',
                            prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                            suffixIcon: controller.selectedClient.value != null
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: colorScheme.error),
                                    onPressed: () {
                                      textEditingController.clear();
                                      controller.setClient(null);
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: colorScheme.outlineVariant),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerLow,
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          onChanged: (value) {
                            print('🔍 Texte saisi: "$value"');
                            // Si le champ est vide, désélectionner le client
                            if (value.isEmpty) {
                              controller.setClient(null);
                            }
                          },
                        );
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        print('🔍 OptionsBuilder appelé avec: "${textEditingValue.text}"');
                        print('🔍 Nombre total de clients: ${controller.clients.length}');
                        
                        if (textEditingValue.text.isEmpty) {
                          print('🔍 Retourne tous les clients: ${controller.clients.length}');
                          return controller.clients;
                        }
                        
                        final filteredClients = controller.clients.where((client) {
                          final matches = client.fullName.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ) ||
                              client.prenom.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ) ||
                              client.nom.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              );
                          print('🔍 Client ${client.fullName}: $matches');
                          return matches;
                        }).toList();
                        
                        print('🔍 Clients filtrés: ${filteredClients.length}');
                        return filteredClients;
                      },
                      displayStringForOption: (ClientModel client) => client.fullName,
                      onSelected: (ClientModel client) {
                        print('🔍 Client sélectionné: ${client.fullName}');
                        controller.setClient(client);
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Material(
                          elevation: 4,
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final client = options.elementAt(index);
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: colorScheme.primaryContainer,
                                    child: Text(
                                      client.prenom.isNotEmpty 
                                          ? client.prenom[0].toUpperCase()
                                          : client.nom.isNotEmpty 
                                              ? client.nom[0].toUpperCase()
                                              : '?',
                                      style: TextStyle(
                                        color: colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    client.fullName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  subtitle: client.adresse.isNotEmpty
                                      ? Text(
                                          client.adresse,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    onSelected(client);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    // Affichage du client sélectionné
                    if (controller.selectedClient.value != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: colorScheme.primary,
                              child: Icon(
                                Icons.person,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.selectedClient.value!.fullName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  if (controller.selectedClient.value!.adresse.isNotEmpty)
                                    Text(
                                      controller.selectedClient.value!.adresse,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => controller.showPositionsMap(),
                          icon: Icon(Icons.map, color: colorScheme.primary),
                          label: Text(
                            'Voir les positions sur la carte',
                            style: TextStyle(color: colorScheme.primary),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: colorScheme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Raison de visite
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Raison de visite',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Indicateur de chargement des raisons
                    if (controller.raisons.isEmpty && !controller.isLoading.value)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: colorScheme.error, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Aucune raison trouvée. Vérifiez votre connexion.',
                                style: TextStyle(color: colorScheme.error),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      DropdownButtonFormField<RaisonModel>(
                        value: controller.selectedRaison.value,
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: colorScheme.outlineVariant),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerLow,
                        ),
                        items: controller.raisons.map((raison) {
                          return DropdownMenuItem(
                            value: raison,
                            child: Text(raison.nom, style: TextStyle(color: colorScheme.onSurface), overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (raison) {
                          print('🔍 Raison sélectionnée: ${raison?.nom ?? "Aucune"}');
                          controller.setRaison(raison);
                        },
                        hint: Text('Sélectionnez une raison', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        dropdownColor: colorScheme.surface,
                        icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Bouton créer la visite
            ElevatedButton(
              onPressed: () async {
                if (!controller.isLoading.value) {
                  final success = await controller.createVisite();
                  if (success) {
                    // Popup de succès
                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 28),
                            const SizedBox(width: 12),
                            const Text('Succès'),
                          ],
                        ),
                        content: const Text(
                          'Votre visite a été créée avec succès !',
                          style: TextStyle(fontSize: 16),
                        ),
                                                 actions: [
                           ElevatedButton(
                             onPressed: () {
                               Get.back();
                               // Réinitialiser les sélections
                               controller.setClient(null);
                               controller.setRaison(null);
                               // Recharger les visites
                               _loadMesVisites();
                               // Aller à l'onglet "Mes Visites"
                               _tabController.animateTo(0);
                               // Afficher un message de confirmation
                               Get.snackbar(
                                 'Visite créée',
                                 'Votre visite a été ajoutée à la liste',
                                 backgroundColor: Colors.green,
                                 colorText: Colors.white,
                                 duration: const Duration(seconds: 2),
                               );
                             },
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.green,
                               foregroundColor: Colors.white,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8),
                               ),
                             ),
                             child: const Text('OK'),
                           ),
                         ],
                      ),
                    );
                  } else if (controller.error.isNotEmpty) {
                    // Afficher l'erreur dans une popup
                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red, size: 28),
                            const SizedBox(width: 12),
                            const Text('Erreur'),
                          ],
                        ),
                        content: Text(
                          controller.error.value,
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              controller.error.value = '';
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              child: controller.isLoading.value ?
               SizedBox(
                 width: 20,
                 height: 20,
                 child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2),
               ) : const Text(
                'Créer la visite',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    });
  }
} 