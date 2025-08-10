class ProduitModel {
  final int id;
  final String nom;
  final String description;
  final double prix;
  final int stock;
  final String categorie;
  final String unite;
  final List<String> images;
  final double prixUnitaire;
  final double prixUnitaireTTC;
  final double tva;

  ProduitModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.stock,
    required this.categorie,
    required this.unite,
    required this.images,
    required this.prixUnitaire,
    required this.prixUnitaireTTC,
    required this.tva,
  });

  factory ProduitModel.fromJson(Map<String, dynamic> json) {
    return ProduitModel(
      id: json['id'],
      nom: json['nom'],
      description: json['description'] ?? '',
      prix: double.tryParse(json['prix'].toString()) ?? 0.0,
      stock: json['stock'] ?? 0,
      categorie: json['categorie']?['nom'] ?? 'Inconnue',
      unite: json['unite']?['nom'] ?? 'Inconnue',
      images: List<String>.from(json['images'] ?? []),
      prixUnitaire: double.tryParse(json['prix_unitaire']?.toString() ?? json['prix']?.toString() ?? '0') ?? 0.0,
      prixUnitaireTTC: double.tryParse(json['prix_unitaire_ttc']?.toString() ?? '0') ?? 0.0,
      tva: double.tryParse(json['tva']?.toString() ?? '0') ?? 0.0,
    );
  }
}