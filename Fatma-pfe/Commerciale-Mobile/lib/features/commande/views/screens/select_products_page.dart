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
      if ((cart[productId] ?? 0) > 0) {
        cart[productId] = cart[productId]! - 1;
      }
    });
  }

  int get cartItemCount => cart.values.fold(0, (sum, qte) => sum + qte);

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
    final produits = produitController.produits;
    final selectedProducts = produits.where((p) => cart[p.id] != null && cart[p.id]! > 0).toList();
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
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                p.nom,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: colorScheme.onSurface,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: colorScheme.primary.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'x$qte',
                                                style: TextStyle(
                                                  color: colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "HT : ${p.prixUnitaire.toStringAsFixed(2)} €",
                                            style: TextStyle(color: colorScheme.onSurfaceVariant)),
                                          Text(
                                            "TTC : ${p.prixUnitaireTTC.toStringAsFixed(2)} €",
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.primary),
                                          ),
                                          Text(
                                            "TVA : ${p.tva.toStringAsFixed(2)}%",
                                            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                                        ),
                                        const SizedBox(height: 8),
                                        
                                        // Contrôles de quantité
                                        Container(
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: colorScheme.surfaceContainerHighest,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: colorScheme.outlineVariant.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Bouton moins
                                              GestureDetector(
                                                onTap: qte > 0 ? () { 
                                                  removeFromCart(p.id); 
                                                  setStateDialog(() {}); 
                                                } : null,
                                                child: Container(
                                                  width: 50,
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    color: qte > 0 ? Colors.red.shade200 : Colors.grey.shade300,
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(12),
                                                      bottomLeft: Radius.circular(12),
                                                    ),
                                                    border: Border.all(
                                                      color: qte > 0 ? Colors.red.shade500 : Colors.grey.shade500,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 28,
                                                    color: qte > 0 ? Colors.red.shade800 : Colors.grey.shade700,
                                                  ),
                                                ),
                                              ),
                                              
                                              // Quantité
                                              Expanded(
                                                child: Container(
                                                  height: 55,
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
                                                    child: Text(
                                                      '$qte',
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              
                                              // Bouton plus
                                              GestureDetector(
                                                onTap: () { 
                                                  addToCart(p.id); 
                                                  setStateDialog(() {}); 
                                                },
                                                child: Container(
                                                  width: 50,
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.shade200,
                                                    borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(12),
                                                      bottomRight: Radius.circular(12),
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.green.shade500,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 28,
                                                    color: Colors.green.shade800,
                                                  ),
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
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigation vers la sélection du client
                                Get.toNamed('/select-client');
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
                                        
                                        // Contrôles de quantité
                                        Container(
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: colorScheme.surfaceContainerHighest,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: colorScheme.outlineVariant.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Bouton moins
                                              GestureDetector(
                                                onTap: qte > 0 ? () => removeFromCart(p.id) : null,
                                                child: Container(
                                                  width: 40,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    color: qte > 0 ? colorScheme.errorContainer : colorScheme.surfaceContainerLow,
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(8),
                                                      bottomLeft: Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 18,
                                                    color: qte > 0 ? colorScheme.onErrorContainer : colorScheme.onSurfaceVariant,
                                                  ),
                                                ),
                                              ),
                                              
                                              // Quantité
                                              Expanded(
                                                child: Container(
                                                  height: 36,
                                                  child: Center(
                                                    child: Text(
                                                      '$qte',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: colorScheme.onSurface,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              
                                              // Bouton plus
                                              GestureDetector(
                                                onTap: () => addToCart(p.id),
                                                child: Container(
                                                  width: 40,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    color: colorScheme.tertiaryContainer,
                                                    borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(8),
                                                      bottomRight: Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 18,
                                                    color: colorScheme.onTertiaryContainer,
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
                      commandeController.selectedPromotion.value = selectedPromotion;
                      final result = await Get.toNamed('/select-client');
                      if (result == true) {
                        final selectedClient = commandeController.selectedClient.value;
                        if (selectedClient != null) {
                          await commandeController.createCommande(selectedClient.id, cart);
                        }
                      }
                    },
                label: const Text(
                  'COMMANDER',
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                    letterSpacing: 1.2,
                ),
              ),
              icon: const Icon(
                Icons.shopping_cart_checkout,
                color: Colors.white,
                size: 24,
              ),
              backgroundColor: const Color(0xFF3F51B5),
                elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
