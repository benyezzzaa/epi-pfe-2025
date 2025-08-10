import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pfe/features/commande/models/commande_model.dart';
import 'package:pfe/features/commande/services/commandes_modifiees_service.dart';

class CommandeModifieeDetailsPage extends StatefulWidget {
  final CommandeModel commande;
  final Map<String, dynamic>? modifications;
  
  const CommandeModifieeDetailsPage({
    super.key, 
    required this.commande,
    this.modifications,
  });

  @override
  State<CommandeModifieeDetailsPage> createState() => _CommandeModifieeDetailsPageState();
}

class _CommandeModifieeDetailsPageState extends State<CommandeModifieeDetailsPage> {
  final CommandesModifieesService _service = CommandesModifieesService();
  dynamic detailsModifications;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetailsModifications();
  }

  Future<void> _loadDetailsModifications() async {
    setState(() => isLoading = true);
    try {
      final details = await _service.getDetailsCommandeModifiee(widget.commande.id);
      setState(() {
        detailsModifications = details;
        isLoading = false;
      });
      print("📄 Détails reçus: $details (type: ${details.runtimeType})");
    } catch (e) {
      print("Erreur chargement détails modifications : $e");
      setState(() => isLoading = false);
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _getAdminName(dynamic modifiePar) {
    if (modifiePar == null) return 'Admin';
    
    final nom = modifiePar['nom']?.toString() ?? '';
    final prenom = modifiePar['prenom']?.toString() ?? '';
    
    if (nom.isNotEmpty && prenom.isNotEmpty) {
      return '$prenom $nom';
    } else if (nom.isNotEmpty) {
      return nom;
    } else if (prenom.isNotEmpty) {
      return prenom;
    } else {
      return modifiePar['email']?.toString() ?? 'Admin';
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'en_attente':
        return 'En attente';
      case 'validee':
        return 'Validée';
      case 'livree':
        return 'Livrée';
      case 'annulee':
        return 'Annulée';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'en_attente':
        return Colors.orange;
      case 'validee':
        return Colors.green;
      case 'livree':
        return Colors.blue;
      case 'annulee':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    
    switch (status.toLowerCase()) {
      case 'en_attente':
        color = Colors.orange;
        text = 'En attente';
        break;
      case 'validee':
        color = Colors.green;
        text = 'Validée';
        break;
      case 'rejetee':
        color = Colors.red;
        text = 'Rejetée';
        break;
      case 'livree':
        color = Colors.blue;
        text = 'Livrée';
        break;
      default:
        color = Colors.grey;
        text = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildModificationCard(String title, String? oldValue, String? newValue, String? dateModification, dynamic modifiePar) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasChanged = oldValue != newValue;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: hasChanged ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: hasChanged 
            ? BorderSide(color: Colors.orange, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasChanged ? Icons.edit : Icons.check,
                  color: hasChanged ? Colors.orange : Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: hasChanged ? Colors.orange.shade700 : colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (hasChanged) ...[
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ancienne valeur:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          oldValue ?? 'Non définie',
                          style: TextStyle(color: Colors.red.shade600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nouvelle valeur:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          newValue ?? 'Non définie',
                          style: TextStyle(color: Colors.green.shade600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'Aucun changement',
                  style: TextStyle(color: Colors.green.shade600),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Modifié par: ${_getAdminName(modifiePar)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (dateModification != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDate(dateModification),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails des modifications'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detailsModifications == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun détail disponible',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête de la commande
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.receipt_long, color: colorScheme.primary, size: 24),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.commande.numeroCommande,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildStatusChip(widget.commande.statut),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Client: ${widget.commande.clientNom}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Date: ${_formatDate(widget.commande.dateCreation)}',
                                style: TextStyle(color: colorScheme.onSurfaceVariant),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Titre des modifications
                      Text(
                        'Historique des modifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Liste des modifications
                      if (detailsModifications is List && (detailsModifications as List).isNotEmpty)
                        ...(detailsModifications as List).map<Widget>((modification) {
                          return _buildModificationCard(
                            modification['champModifie'] ?? 'Champ inconnu',
                            modification['ancienneValeur']?.toString(),
                            modification['nouvelleValeur']?.toString(),
                            modification['dateModification'],
                            modification['modifiePar'],
                          );
                        }).toList()
                      else
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                'Aucune modification trouvée',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
} 