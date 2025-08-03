# Changement de Statut des Réclamations

## 🔄 Modification Effectuée

**Remplacement de "En attente" par "Ouverte"**

## 📝 Détails des Changements

### 1. **Page des Réclamations** (`reclamations_page.dart`)

#### **Dropdown de Filtrage**
```dart
// Avant
const DropdownMenuItem(value: 'en attente', child: Text('En attente')),

// Après  
const DropdownMenuItem(value: 'ouverte', child: Text('Ouverte')),
```

#### **Gestion des Couleurs**
```dart
// Avant
case 'en attente':
  statusColor = colorScheme.secondaryContainer;
  onStatusColor = colorScheme.onSecondaryContainer;
  break;

// Après
case 'ouverte':
  statusColor = colorScheme.secondaryContainer;
  onStatusColor = colorScheme.onSecondaryContainer;
  break;
```

### 2. **Contrôleur des Réclamations** (`reclamation_controller.dart`)

#### **Statut par Défaut**
```dart
// Avant
reclamation['status'] = reclamation['status'] ?? 'En attente';

// Après
reclamation['status'] = reclamation['status'] ?? 'Ouverte';
```

### 3. **Page d'Accueil** (`commercial_home_page.dart`)

#### **Commentaire**
```dart
// Avant
// Réclamations en attente - juste en dessous du message Bonjour

// Après
// Réclamations ouvertes - juste en dessous du message Bonjour
```

## 🎨 Statuts Actuels

Les statuts des réclamations sont maintenant :

1. **Ouverte** (remplace "En attente")
2. **Traitée**

*Note : "Fermée" a été supprimée du filtre mais peut toujours être affichée si elle existe dans les données.*

## 🔧 Impact

### **Sur l'Interface**
- Le filtre par statut affiche maintenant "Ouverte" au lieu de "En attente"
- Le filtre ne contient plus que "Ouverte" et "Traitée" (suppression de "Fermée")
- Les nouvelles réclamations ont le statut "Ouverte" par défaut
- La couleur reste la même (secondaryContainer)

### **Sur les Données**
- Les réclamations existantes avec le statut "en attente" continueront à s'afficher
- Les nouvelles réclamations auront le statut "Ouverte"
- Le filtrage fonctionne avec les statuts "Ouverte" et "Traitée"
- Les réclamations avec le statut "Fermée" ne peuvent plus être filtrées mais restent visibles

## ⚠️ Notes Importantes

1. **Compatibilité Backend** : Assurez-vous que le backend accepte le statut "ouverte"
2. **Données Existantes** : Les réclamations existantes avec "en attente" peuvent nécessiter une migration
3. **Tests** : Vérifiez que le filtrage fonctionne correctement avec le nouveau statut

## 🚀 Prochaines Étapes

1. **Tester** le filtrage par statut "Ouverte" et "Traitée"
2. **Vérifier** l'affichage des nouvelles réclamations
3. **Migrer** les données existantes si nécessaire
4. **Mettre à jour** la documentation backend si applicable
5. **Vérifier** que les réclamations "Fermée" s'affichent correctement même sans filtre 