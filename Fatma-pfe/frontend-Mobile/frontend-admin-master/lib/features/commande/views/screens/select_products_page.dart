import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe/core/routes/app_routes.dart';
import 'package:pfe/core/utils/app_api.dart';
import 'package:pfe/features/commande/controllers/produit_controller.dart';
import '../../models/produit_model.dart';
import 'package:pfe/features/commande/controllers/commande_controller.dart';
import '../../models/promotion_model.dart';
import '../../services/promotion_service.dart';

class SelectProductsPage extends StatefulWidget {
  const SelectProductsPage({super.key});

  @override
  State<SelectProductsPage> createState() => _SelectProductsPageState();
}

class _SelectProductsPageState extends State<SelectProductsPage> {
  final ProduitController produitController = Get.put(ProduitController());
  final PromotionService promotionService = PromotionService();
  final CommandeController commandeController = Get.put(CommandeController());
  String selectedCategory = 'Tous';
  final Map<int, int> cart = {};
  List<Promotion> promotions = [];
  Promotion? selectedPromotion;

  Future<bool> _onWillPop() async {
    if (cartItemCount > 0) {
      final shouldClear = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Vider le panier ?'),
          content: const Text('Voulez-vous vider le panier avant de quitter la sélection des produits ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Non'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Oui, vider'),
            ),
          ],
        ),
      );
      if (shouldClear == true) {
        setState(() => cart.clear());
        return true;
      }
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (produitController.produits.isEmpty) {
      produitController.fetchProduits();
    }
    _loadPromotions();
  }

  Future<void> _loadPromotions() async {
    final promos = await promotionService.fetchPromotions();
    setState(() {
      promotions = promos.where((p) => p.isActive).toList();
    });
  }

  void addToCart(int productId) {
    setState(() {
      cart[productId] = (cart[productId] ?? 0) + 1;
    });
  }

  void removeFromCart(int productId) {
    setState(() {
      final currentQuantity = cart[productId] ?? 0;
      if (currentQuantity > 0) {
        cart[productId] = currentQuantity - 1;
        if (cart[productId] == 0) {
          cart.remove(productId);
        }
      }
    });
  }

  int get cartItemCount => cart.values.fold(0, (sum, qte) => sum + qte);

  Future<bool?> _showConfirmationDialog(BuildContext context, dynamic selectedClient) {
    final selectedProducts = (produitController.produits ?? []).where((p) => (cart[p.id] ?? 0) > 0).toList();
    final totalAmount = selectedProducts.fold<double>(
      0, (sum, p) => sum + (p.prixUnitaireTTC * (cart[p.id] ?? 0))
    );

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.shopping_cart_checkout, color: colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Confirmer la commande',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations du client
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: Icon(
                      Icons.person,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedClient.prenom} ${selectedClient.nom}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          selectedClient.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Résumé de la commande
            Text(
              'Résumé de votre commande :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            
            // Nombre de produits
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Produits sélectionnés :',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${selectedProducts.length} produit${selectedProducts.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            
            // Quantité totale
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantité totale :',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${cartItemCount} unité${cartItemCount > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            
            // Promotion sélectionnée
            if (selectedPromotion != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Promotion :',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                                     Text(
                     selectedPromotion?.titre ?? 'Aucune',
                     style: TextStyle(
                       fontSize: 14,
                       fontWeight: FontWeight.w600,
                       color: colorScheme.primary,
                     ),
                   ),
                ],
              ),
            const SizedBox(height: 12),
            
            // Ligne de séparation
            Divider(color: colorScheme.outlineVariant),
            const SizedBox(height: 8),
            
            // Montant total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Montant total :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${totalAmount.toStringAsFixed(2)} €',
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Annuler',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Confirmer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
      },
    );
  }

  Future<void> _showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Commande créée !',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              'Votre commande a été créée avec succès.',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vous recevrez une notification une fois que votre commande sera validée.',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
                      ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
      },
    );
  }

  void _showQuantityDialog(BuildContext context, ProduitModel product, int currentQuantity, VoidCallback onUpdate) {
    final colorScheme = Theme.of(context).colorScheme;
    final TextEditingController quantityController = TextEditingController(text: currentQuantity.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.edit, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Modifier la quantité'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.nom,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantité',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.shopping_cart, color: colorScheme.primary),
                suffixText: 'unités',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newQuantity = int.tryParse(quantityController.text) ?? 0;
              if (newQuantity > 0) {
                setState(() {
                  cart[product.id] = newQuantity;
                });
                onUpdate();
              } else if (newQuantity == 0) {
                setState(() {
                  cart.remove(product.id);
                });
                onUpdate();
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void showProductDetails(BuildContext context, ProduitModel product) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colorScheme.surface,
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "${AppApi.baseUrl}${product.images.first}",
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image_not_supported, size: 100, color: colorScheme.onSurfaceVariant);
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.nom,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Text(
              "${product.prixUnitaireTTC.toStringAsFixed(2)} € TTC",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.primary),
            ),
            const SizedBox(height: 6),
            Text(
              "HT : ${product.prixUnitaire.toStringAsFixed(2)} €",
              style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
            ),
            Text(
              "TVA : ${product.tva.toStringAsFixed(2)}%",
              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              addToCart(product.id);
              Navigator.pop(context);
            },
            icon: Icon(Icons.add_shopping_cart, color: colorScheme.onPrimary),
            label: Text("Ajouter au panier", style: TextStyle(color: colorScheme.onPrimary)),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  void showCartDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final produits = produitController.produits ?? [];
    final selectedProducts = produits.where((p) => (cart[p.id] ?? 0) > 0).toList();
    final totalAmount = selectedProducts.fold<double>(
      0, (sum, p) => sum + (p.prixUnitaireTTC * (cart[p.id] ?? 0))
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 600),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header avec dégradé
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3F51B5),
                      const Color(0xFF5C6BC0),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Votre Panier",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${selectedProducts.length} produit${selectedProducts.length > 1 ? 's' : ''} sélectionné${selectedProducts.length > 1 ? 's' : ''}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contenu du panier
              Expanded(
                child: selectedProducts.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                size: 60,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Votre panier est vide",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Ajoutez des produits pour commencer vos achats",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: selectedProducts.length,
                        itemBuilder: (context, index) {
                          final p = selectedProducts[index];
                          final qte = cart[p.id] ?? 0;
                            final total = (p.prixUnitaireTTC * qte).toStringAsFixed(2);
                          
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Image du produit avec bordure
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: colorScheme.outlineVariant.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        "${AppApi.baseUrl}${p.images.first}",
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: colorScheme.surfaceContainerLow,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 30,
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Informations du produit
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Nom du produit
                                        Text(
                                          p.nom,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        // Prix
                                        Text(
                                          "HT : ${p.prixUnitaire.toStringAsFixed(2)} €",
                                          style: TextStyle(color: colorScheme.onSurfaceVariant)
                                        ),
                                        Text(
                                          "TTC : ${p.prixUnitaireTTC.toStringAsFixed(2)} €",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.primary),
                                        ),
                                        Text(
                                          "TVA : ${p.tva.toStringAsFixed(2)}%",
                                          style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                                        ),
                                        const SizedBox(height: 12),
                                        
                                        // Contrôles de quantité - Nouvelle disposition sous l'image
                                        Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Label "Quantité"
                                              Text(
                                                'Quantité',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.onSurfaceVariant,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                                                                             // Contrôles horizontaux - Plus petits
                                               Container(
                                                 height: 40,
                                                 decoration: BoxDecoration(
                                                   color: colorScheme.surfaceContainerHighest,
                                                   borderRadius: BorderRadius.circular(12),
                                                   border: Border.all(
                                                     color: colorScheme.outlineVariant.withOpacity(0.3),
                                                     width: 1,
                                                   ),
                                                   boxShadow: [
                                                     BoxShadow(
                                                       color: Colors.black.withOpacity(0.05),
                                                       blurRadius: 4,
                                                       offset: const Offset(0, 1),
                                                     ),
                                                   ],
                                                 ),
                                                child: Row(
                                                  children: [
                                                                                                                                                               // Bouton moins - Plus petit
                                                      GestureDetector(
                                                        onTap: qte > 0 ? () { 
                                                          removeFromCart(p.id); 
                                                          Navigator.pop(context);
                                                          showProductDetails(context, p);
                                                        } : null,
                                                       child: Container(
                                                         width: 40,
                                                         height: 40,
                                                         decoration: BoxDecoration(
                                                           color: qte > 0 ? Colors.red.shade500 : Colors.grey.shade300,
                                                           borderRadius: const BorderRadius.only(
                                                             topLeft: Radius.circular(10),
                                                             bottomLeft: Radius.circular(10),
                                                           ),
                                                           border: Border.all(
                                                             color: qte > 0 ? Colors.red.shade700 : Colors.grey.shade500,
                                                             width: 2,
                                                           ),
                                                           boxShadow: [
                                                             BoxShadow(
                                                               color: qte > 0 ? Colors.red.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                                                               blurRadius: 4,
                                                               offset: const Offset(0, 1),
                                                             ),
                                                           ],
                                                         ),
                                                         child: Icon(
                                                           Icons.remove,
                                                           size: 20,
                                                           color: Colors.white,
                                                         ),
                                                       ),
                                                     ),
                                                    
                                                                                                                                                               // Zone de quantité - Plus claire et compacte
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () => _showQuantityDialog(context, p, qte, () {
                                                            Navigator.pop(context);
                                                            showProductDetails(context, p);
                                                          }),
                                                         child: Container(
                                                           height: 40,
                                                           decoration: BoxDecoration(
                                                             color: Colors.white,
                                                             border: Border.symmetric(
                                                               vertical: BorderSide(
                                                                 color: Colors.grey.shade400,
                                                                 width: 1,
                                                               ),
                                                             ),
                                                           ),
                                                           child: Center(
                                                             child: Column(
                                                               mainAxisAlignment: MainAxisAlignment.center,
                                                               children: [
                                                                 Text(
                                                                   '$qte',
                                                                   style: TextStyle(
                                                                     fontSize: 16,
                                                                     fontWeight: FontWeight.bold,
                                                                     color: Colors.black,
                                                                   ),
                                                                 ),
                                                                 Text(
                                                                   'Taper pour modifier',
                                                                   style: TextStyle(
                                                                     fontSize: 7,
                                                                     color: Colors.blue.shade600,
                                                                     fontWeight: FontWeight.w500,
                                                                   ),
                                                                 ),
                                                               ],
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                    
                                                                                                                                                               // Bouton plus - Plus petit
                                                      GestureDetector(
                                                        onTap: () { 
                                                          addToCart(p.id); 
                                                          Navigator.pop(context);
                                                          showProductDetails(context, p);
                                                        },
                                                       child: Container(
                                                         width: 40,
                                                         height: 40,
                                                         decoration: BoxDecoration(
                                                           color: Colors.green.shade500,
                                                           borderRadius: const BorderRadius.only(
                                                             topRight: Radius.circular(10),
                                                             bottomRight: Radius.circular(10),
                                                           ),
                                                           border: Border.all(
                                                             color: Colors.green.shade700,
                                                             width: 2,
                                                           ),
                                                           boxShadow: [
                                                             BoxShadow(
                                                               color: Colors.green.withOpacity(0.3),
                                                               blurRadius: 4,
                                                               offset: const Offset(0, 1),
                                                             ),
                                                           ],
                                                         ),
                                                         child: Icon(
                                                           Icons.add,
                                                           size: 20,
                                                           color: Colors.white,
                                                         ),
                                                       ),
                                                     ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Total pour ce produit
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "$total €",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Total",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              
              // Footer avec total et boutons
              if (selectedProducts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.surfaceContainerHighest,
                        colorScheme.surfaceContainerLow,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Ligne de séparation
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              colorScheme.outlineVariant,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Total à payer juste avant les boutons
                      Text(
                        "Total à payer : ${totalAmount.toStringAsFixed(2)} €",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Boutons d'action
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                side: BorderSide(
                                  color: colorScheme.outline,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    color: colorScheme.onSurface,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Continuer",
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Vérifier si une promotion est sélectionnée
                                if (promotions.isNotEmpty && selectedPromotion == null) {
                                  // Afficher un message d'erreur
                                  Get.snackbar(
                                    'Promotion requise',
                                    'Veuillez sélectionner une promotion pour commander.',
                                    backgroundColor: Colors.red.shade100,
                                    colorText: Colors.red.shade900,
                                    duration: const Duration(seconds: 3),
                                    snackPosition: SnackPosition.TOP,
                                  );
                                  return;
                                }
                                

                                
                                // Fermer le dialog du panier d'abord
                                Navigator.pop(context);
                                // Navigation vers la sélection du client
                                final result = await Get.toNamed('/select-client');
                                if (result == true) {
                                  final selectedClient = commandeController.selectedClient.value;
                                  if (selectedClient != null) {
                                    // Créer la commande directement
                                    await commandeController.createCommande(selectedClient.id, cart);
                                    // Vider le panier
                                    setState(() {
                                      cart.clear();
                                    });
                                    // Afficher la popup de succès
                                    await _showSuccessDialog(Get.context!);
                                    // Rediriger vers la page des commandes en attente
                                    Get.offAllNamed('/commandes');
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3F51B5),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.shopping_cart_checkout,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Commander",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
            ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F51B5),
        title: const Text("Sélection des produits", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        actions: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                  onPressed: () => showCartDialog(context),
                ),
              ),
                if (cart.values.where((qte) => qte > 0).length > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                        '${cart.values.where((qte) => qte > 0).length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (promotions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: DropdownButtonFormField<Promotion>(
                value: selectedPromotion,
                decoration: InputDecoration(
                  labelText: 'Promotion',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: promotions.where((p) => p.isActive).map((promo) => DropdownMenuItem(
                  value: promo,
                  child: Text(promo.titre),
                )).toList(),
                onChanged: (promo) {
                  setState(() {
                    selectedPromotion = promo;
                  });
                  // S'assurer que la promotion est bien assignée au contrôleur
                  commandeController.selectedPromotion.value = promo;
                  print('🔍 Promotion sélectionnée: ${promo?.titre} (ID: ${promo?.id})');
                },
                hint: const Text('Choisir une promotion'),
              ),
            ),
          Expanded(
            child: Obx(() {
              if (produitController.isLoading.value) {
                return Center(child: CircularProgressIndicator(color: colorScheme.primary));
              }

              final produits = produitController.produits.where((p) {
                final normalized = p.categorie.trim().toLowerCase();
                return selectedCategory == 'Tous' || normalized == selectedCategory.toLowerCase();
              }).toList();

              final categories = [
                'Tous',
                ...produitController.produits
                    .map((p) => p.categorie.trim())
                    .toSet()
                    .toList()
              ];

              return Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 6, offset: Offset(0, 3))]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                          childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: produits.length,
                      itemBuilder: (context, index) {
                        final p = produits[index];
                        final qte = cart[p.id] ?? 0;
                        return GestureDetector(
                          onTap: () => showProductDetails(context, p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image du produit
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      color: colorScheme.surfaceContainerLow,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: Image.network(
                                        "${AppApi.baseUrl}${p.images.first}",
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: colorScheme.surfaceContainerLow,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 60,
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Informations du produit
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Nom du produit
                                        Flexible(
                                          child: Text(
                                            p.nom,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                                fontSize: 11,
                                              color: colorScheme.onSurface,
                                            ),
                                              maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        
                                        // Prix
                                        Text(
                                            "${p.prixUnitaireTTC.toStringAsFixed(2)} € TTC",
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.primary),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        
                                        // Contrôles de quantité améliorés dans la grille
                                        Container(
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: colorScheme.surfaceContainerHighest,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: colorScheme.outlineVariant.withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Bouton moins - Plus grand
                                              GestureDetector(
                                                onTap: qte > 0 ? () => removeFromCart(p.id) : null,
                                                child: Container(
                                                  width: 45,
                                                  height: 42,
                                                  decoration: BoxDecoration(
                                                    color: qte > 0 ? Colors.red.shade100 : Colors.grey.shade200,
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(11),
                                                      bottomLeft: Radius.circular(11),
                                                    ),
                                                    border: Border.all(
                                                      color: qte > 0 ? Colors.red.shade300 : Colors.grey.shade400,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 20,
                                                    color: qte > 0 ? Colors.red.shade600 : Colors.grey.shade500,
                                                  ),
                                                ),
                                              ),
                                              
                                              // Zone de quantité avec saisie clavier
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () => _showQuantityDialog(context, p, qte, () {}),
                                                  child: Container(
                                                    height: 42,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.symmetric(
                                                        vertical: BorderSide(
                                                          color: Colors.grey.shade300,
                                                          width: 1,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            '$qte',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              color: colorScheme.onSurface,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Taper',
                                                            style: TextStyle(
                                                              fontSize: 8,
                                                              color: Colors.grey.shade600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              
                                              // Bouton plus - Plus grand
                                              GestureDetector(
                                                onTap: () => addToCart(p.id),
                                                child: Container(
                                                  width: 45,
                                                  height: 42,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.shade100,
                                                    borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(11),
                                                      bottomRight: Radius.circular(11),
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.green.shade300,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: Colors.green.shade600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }),
          ),
        ],
      ),
      floatingActionButton: cartItemCount > 0
          ? FloatingActionButton.extended(
              onPressed: (promotions.isNotEmpty && selectedPromotion == null)
                    ? null
                  : () async {
                      // Vérifier si une promotion est sélectionnée
                      if (promotions.isNotEmpty && selectedPromotion == null) {
                        Get.snackbar(
                          'Promotion requise',
                          'Veuillez sélectionner une promotion pour commander.',
                          backgroundColor: Colors.red.shade100,
                          colorText: Colors.red.shade900,
                          duration: const Duration(seconds: 3),
                          snackPosition: SnackPosition.TOP,
                        );
                        return;
                      }
                      
                      // Navigation vers la sélection du client
                      final result = await Get.toNamed('/select-client');
                      if (result == true) {
                        final selectedClient = commandeController.selectedClient.value;
                        if (selectedClient != null) {
                          // Créer la commande directement
                          await commandeController.createCommande(selectedClient.id, cart);
                          // Vider le panier
                          setState(() {
                            cart.clear();
                          });
                          // Afficher la popup de succès
                          await _showSuccessDialog(Get.context!);
                          // Rediriger vers la page des commandes en attente
                          Get.offAllNamed('/commandes');
                        }
                      }
                    },
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_cart_checkout,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'COMMANDER',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF3F51B5),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              extendedPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            )
          : null,
      // Message UX si une promotion est requise mais non sélectionnée
      bottomNavigationBar: (cartItemCount > 0 && promotions.isNotEmpty && selectedPromotion == null)
          ? Container(
              color: Colors.amber.shade100,
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Veuillez sélectionner une promotion pour commander.',
                    style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          : null,
      ),
    );
  }
}
