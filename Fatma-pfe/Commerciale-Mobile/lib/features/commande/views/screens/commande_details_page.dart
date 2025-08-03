import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommandeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> commande;

  const CommandeDetailsPage({
    super.key,
    required this.commande,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalTtc = double.tryParse(commande['prix_total_ttc']?.toString() ?? '0') ?? 0.0;
    final totalHt = double.tryParse(commande['prix_hors_taxe']?.toString() ?? '0') ?? 0.0;
    final tva = double.tryParse(commande['tva']?.toString() ?? '0') ?? 0.0;
    final lignesCommande = commande['lignesCommande'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Commande ${commande['numero_commande']}'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                        Text(
                          commande['numero_commande'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        _buildStatusChip(commande['statut']),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Informations client
                    Row(
                      children: [
                        Icon(Icons.person, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${commande['client']?['prenom'] ?? ''} ${commande['client']?['nom'] ?? 'Inconnu'}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Date de création
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: colorScheme.onSurfaceVariant, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(commande['dateCreation'])),
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    
                    // Date de validation si applicable
                    if (commande['date_validation'] != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Validée le: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(commande['date_validation']))}',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Motif de rejet si applicable
            if (commande['motif_rejet'] != null) ...[
              Card(
                elevation: 2,
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.cancel, color: Colors.red.shade600, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Motif du rejet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        commande['motif_rejet'],
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Produits commandés
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_cart, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Produits commandés',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (lignesCommande.isEmpty)
                      Center(
                        child: Text(
                          'Aucun produit dans cette commande',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      ...lignesCommande.map<Widget>((ligne) => _buildLigneCommande(ligne)).toList(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Résumé des totaux
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Résumé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total HT:', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        Text('${totalHt.toStringAsFixed(2)} €', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TVA (${tva.toStringAsFixed(2)}%):', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        Text('${(totalTtc - totalHt).toStringAsFixed(2)} €', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Divider(),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total TTC:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          '${totalTtc.toStringAsFixed(2)} €',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildLigneCommande(Map<String, dynamic> ligne) {
    final produit = ligne['produit'] as Map<String, dynamic>? ?? {};
    final quantite = ligne['quantite'] ?? 0;
    final prixUnitaire = double.tryParse(ligne['prixUnitaire']?.toString() ?? '0') ?? 0.0;
    final total = double.tryParse(ligne['total']?.toString() ?? '0') ?? 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produit['nom'] ?? 'Produit inconnu',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (produit['description'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    produit['description'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'x$quantite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${prixUnitaire.toStringAsFixed(2)} €',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Text(
              '${total.toStringAsFixed(2)} €',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.blue,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
