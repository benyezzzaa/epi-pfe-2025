import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';
import 'package:pfe/features/commande/controllers/commande_controller.dart';
import '../../models/commande_model.dart';
import 'commande_details_page.dart';

class CommercialOrdersPage extends StatefulWidget {
  const CommercialOrdersPage({super.key});

  @override
  State<CommercialOrdersPage> createState() => _CommercialOrdersPageState();
}

class _CommercialOrdersPageState extends State<CommercialOrdersPage>
    with SingleTickerProviderStateMixin {
  final CommandeController controller = Get.put(CommandeController());
  String searchQuery = '';
  String sortMode = 'date';
  DateTime? selectedDate;
  String? selectedStatus;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
    if (controller.commandes.isEmpty) {
      controller.fetchCommandes();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'en_attente':
      case 'en attente':
      case 'pending':
      case 'non_validee':
      case 'non validee':
        return colorScheme.secondaryContainer;
      case 'validee':
      case 'validée':
      case 'validated':
        return colorScheme.primaryContainer;
      case 'livree':
      case 'livrée':
      case 'delivered':
        return colorScheme.tertiaryContainer;
      case 'annulee':
      case 'annulée':
      case 'cancelled':
        return colorScheme.errorContainer;
      case 'en_preparation':
      case 'en préparation':
      case 'preparing':
        return colorScheme.tertiaryContainer.withOpacity(0.8);
      case 'en_livraison':
      case 'en livraison':
      case 'shipping':
        return colorScheme.primaryContainer.withOpacity(0.8);
      default:
        return colorScheme.surfaceVariant;
    }
  }

  Color _getStatusTextColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'en_attente':
      case 'en attente':
      case 'pending':
      case 'non_validee':
      case 'non validee':
        return colorScheme.onSecondaryContainer;
      case 'validee':
      case 'validée':
      case 'validated':
        return colorScheme.onPrimaryContainer;
      case 'livree':
      case 'livrée':
      case 'delivered':
        return colorScheme.onTertiaryContainer;
      case 'annulee':
      case 'annulée':
      case 'cancelled':
        return colorScheme.onErrorContainer;
      case 'en_preparation':
      case 'en préparation':
      case 'preparing':
        return colorScheme.onTertiaryContainer;
      case 'en_livraison':
      case 'en livraison':
      case 'shipping':
        return colorScheme.onPrimaryContainer;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'en_attente':
      case 'en attente':
      case 'pending':
      case 'non_validee':
      case 'non validee':
        return 'En attente';
      case 'validee':
      case 'validée':
      case 'validated':
        return 'Validée';
      case 'livree':
      case 'livrée':
      case 'delivered':
        return 'Livrée';
      case 'annulee':
      case 'annulée':
      case 'cancelled':
        return 'Annulée';
      case 'en_preparation':
      case 'en préparation':
      case 'preparing':
        return 'En préparation';
      case 'en_livraison':
      case 'en livraison':
      case 'shipping':
        return 'En livraison';
      default:
        return status.isNotEmpty ? status : 'En attente';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'en_attente':
      case 'en attente':
      case 'pending':
      case 'non_validee':
      case 'non validee':
        return Icons.schedule_rounded;
      case 'validee':
      case 'validée':
      case 'validated':
        return Icons.check_circle_rounded;
      case 'livree':
      case 'livrée':
      case 'delivered':
        return Icons.local_shipping_rounded;
      case 'annulee':
      case 'annulée':
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'en_preparation':
      case 'en préparation':
      case 'preparing':
        return Icons.inventory_2_rounded;
      case 'en_livraison':
      case 'en livraison':
      case 'shipping':
        return Icons.delivery_dining_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Lundi';
      case 2:
        return 'Mardi';
      case 3:
        return 'Mercredi';
      case 4:
        return 'Jeudi';
      case 5:
        return 'Vendredi';
      case 6:
        return 'Samedi';
      case 7:
        return 'Dimanche';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        color: colorScheme.background,
        child: Column(
          children: [
            AppBar(
              backgroundColor: const Color(0xFF3F51B5),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Get.offAllNamed('/bottom-nav-wrapper');
                },
              ),
              title: const Text(
                'Commandes en Attente',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) => setState(() => sortMode = value),
                  icon: const Icon(Icons.sort, color: Colors.white),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'date',
                      child: Text('Trier par date',
                          style: TextStyle(color: colorScheme.onSurface)),
                    ),
                    PopupMenuItem(
                      value: 'montant',
                      child: Text('Trier par montant',
                          style: TextStyle(color: colorScheme.onSurface)),
                    ),
                  ],
                ),

                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      size: 28, color: Colors.white),
                  tooltip: 'Nouvelle commande',
                  onPressed: () {
                    Get.toNamed('/select-products');
                  },
                )
              ],
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 2,
            ),
            // Section de recherche et filtres avec design amélioré
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer.withOpacity(0.1),
                    colorScheme.secondaryContainer.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Barre de recherche améliorée
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: ' Rechercher une commande ou un client...',
                        hintStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 16,
                        ),
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.search,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                      ),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                      ),
                      onChanged: (val) => setState(() => searchQuery = val),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Filtre par date avec design amélioré et calendrier personnalisé
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.surface,
                          colorScheme.surfaceContainerLow.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: colorScheme,
                                  dialogTheme: DialogTheme(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // Icône de calendrier stylisée
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.primary.withOpacity(0.1),
                                      colorScheme.primary.withOpacity(0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.calendar_month_rounded,
                                  color: colorScheme.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Informations de date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedDate != null 
                                        ? '📅 Date sélectionnée'
                                        : '📅 Filtrer par date',
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectedDate != null 
                                        ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
                                        : 'Cliquez pour choisir une date',
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (selectedDate != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        _getDayName(selectedDate!),
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              
                              // Icône de flèche ou bouton de suppression
                              if (selectedDate != null)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        setState(() {
                                          selectedDate = null;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              colorScheme.errorContainer,
                                              colorScheme.error.withOpacity(0.1),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: colorScheme.error.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: colorScheme.onErrorContainer,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: colorScheme.primary,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: colorScheme.primary));
                }

                var filtered = controller.commandes
                    .where((c) {
                      // Filtre par statut - uniquement les commandes en attente
                      bool statusMatch = c.statut.toLowerCase() == 'en_attente' ||
                                       c.statut.toLowerCase() == 'en attente' ||
                                       c.statut.toLowerCase() == 'pending' ||
                                       c.statut.toLowerCase() == 'non_validee' ||
                                       c.statut.toLowerCase() == 'non validee';
                      
                      // Filtre par recherche
                      bool searchMatch = c.numeroCommande
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          c.clientNom
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase());
                      
                      // Filtre par date
                      bool dateMatch = true;
                      if (selectedDate != null) {
                        try {
                          final commandeDate = DateTime.parse(c.dateCreation);
                          dateMatch = commandeDate.year == selectedDate!.year &&
                                     commandeDate.month == selectedDate!.month &&
                                     commandeDate.day == selectedDate!.day;
                        } catch (e) {
                          print('Erreur parsing date commande: $e');
                          dateMatch = false;
                        }
                      }
                      
                      return statusMatch && searchMatch && dateMatch;
                    })
                    .toList();

                if (sortMode == 'date') {
                  filtered.sort(
                      (a, b) => b.dateCreation.compareTo(a.dateCreation));
                } else if (sortMode == 'montant') {
                  filtered
                      .sort((a, b) => b.prixTotalTTC.compareTo(a.prixTotalTTC));
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.all(32),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.surfaceContainerLow.withOpacity(0.3),
                            colorScheme.surfaceContainerLow.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icône animée
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary.withOpacity(0.1),
                                  colorScheme.secondary.withOpacity(0.1),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Titre principal
                          Text(
                            searchQuery.isEmpty && selectedDate == null
                                ? "Aucune commande en attente"
                                : searchQuery.isNotEmpty && selectedDate != null
                                    ? "Aucun résultat"
                                    : searchQuery.isNotEmpty
                                        ? "Aucun résultat"
                                        : "Aucune commande en attente",
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          
                          // Message détaillé
                          Text(
                            searchQuery.isEmpty && selectedDate == null
                                ? "Vous n'avez pas de commandes en attente"
                                : searchQuery.isNotEmpty && selectedDate != null
                                    ? "Aucune commande en attente correspondant à '$searchQuery' le ${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}"
                                    : searchQuery.isNotEmpty
                                        ? "Aucune commande en attente correspondant à '$searchQuery'"
                                        : "Aucune commande en attente le ${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}",
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          if (searchQuery.isEmpty && selectedDate == null) ...[
                            const SizedBox(height: 24),
                            
                            // Message informatif
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.primary.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Cette page affiche uniquement les commandes en attente de validation. Les commandes validées, livrées ou annulées ne sont pas visibles ici.",
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 24),
                            
                            // Bouton pour effacer les filtres
                            OutlinedButton.icon(
                              icon: Icon(Icons.clear_all, color: colorScheme.primary),
                              label: Text(
                                "Effacer les filtres",
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  searchQuery = '';
                                  selectedDate = null;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: colorScheme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchCommandes();
                    },
                    color: colorScheme.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final cmd = filtered[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.surface,
                                colorScheme.surfaceContainerLow,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: colorScheme.shadow.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => Get.toNamed('/commandes/details', arguments: {
                                'commande': cmd.toJson(),
                              }),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // En-tête avec numéro de commande et statut
                                    Row(
                                      children: [
                                        // Icône de commande
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                colorScheme.primary.withOpacity(0.1),
                                                colorScheme.primary.withOpacity(0.2),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Icon(
                                            Icons.shopping_cart_rounded,
                                            color: colorScheme.primary,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        
                                        // Numéro de commande
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Commande',
                                                style: TextStyle(
                                                  color: colorScheme.onSurfaceVariant,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                cmd.numeroCommande,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: colorScheme.onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                        // Statut de la commande
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(cmd.statut, colorScheme),
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _getStatusColor(cmd.statut, colorScheme).withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Icône selon le statut
                                              Icon(
                                                _getStatusIcon(cmd.statut),
                                                size: 16,
                                                color: _getStatusTextColor(cmd.statut, colorScheme),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                _getStatusText(cmd.statut),
                                                style: TextStyle(
                                                  color: _getStatusTextColor(cmd.statut, colorScheme),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Informations du client
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainerLow.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: colorScheme.outlineVariant.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          // Nom du client
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: colorScheme.secondaryContainer,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  size: 16,
                                                  color: colorScheme.onSecondaryContainer,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Client',
                                                      style: TextStyle(
                                                        color: colorScheme.onSurfaceVariant,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      cmd.clientNom,
                                                      style: TextStyle(
                                                        color: colorScheme.onSurface,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          const SizedBox(height: 12),
                                          
                                          // Date de création
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: colorScheme.tertiaryContainer,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.calendar_today_rounded,
                                                  size: 16,
                                                  color: colorScheme.onTertiaryContainer,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Date de création',
                                                      style: TextStyle(
                                                        color: colorScheme.onSurfaceVariant,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      _formatDate(cmd.dateCreation),
                                                      style: TextStyle(
                                                        color: colorScheme.onSurface,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          // Téléphone du client (si disponible)
                                          if (cmd.clientTelephone != null) ...[
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: colorScheme.primaryContainer,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    Icons.phone_rounded,
                                                    size: 16,
                                                    color: colorScheme.onPrimaryContainer,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Téléphone',
                                                        style: TextStyle(
                                                          color: colorScheme.onSurfaceVariant,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        cmd.clientTelephone!,
                                                        style: TextStyle(
                                                          color: colorScheme.onSurface,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Informations de la commande
                                    Row(
                                      children: [
                                        // Nombre de produits
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: colorScheme.surfaceContainerLow.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.shopping_bag_rounded,
                                                  size: 18,
                                                  color: colorScheme.primary,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "${cmd.lignes.length} produit${cmd.lignes.length > 1 ? 's' : ''}",
                                                  style: TextStyle(
                                                    color: colorScheme.onSurface,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        
                                        const SizedBox(width: 12),
                                        
                                        // Prix total
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  colorScheme.primary.withOpacity(0.1),
                                                  colorScheme.primary.withOpacity(0.2),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: colorScheme.primary.withOpacity(0.3),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Total TTC',
                                                  style: TextStyle(
                                                    color: colorScheme.onSurfaceVariant,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "${cmd.prixTotalTTC.toStringAsFixed(2)} €",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: colorScheme.primary,
                                                  ),
                                                ),
                                                Text(
                                                  "HT: ${cmd.prixHorsTaxe.toStringAsFixed(2)} €",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: colorScheme.onSurfaceVariant,
                                                  ),
                                                ),
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
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
