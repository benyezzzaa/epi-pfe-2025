# Validation du SIRET Existant

## Description
Cette fonctionnalité empêche l'ajout d'un client avec un numéro SIRET déjà existant dans la base de données.

## Fonctionnalités implémentées

### 1. Vérification en temps réel
- Le système vérifie automatiquement si le SIRET existe dès que l'utilisateur saisit 14 chiffres
- Un debounce de 1 seconde évite les appels API trop fréquents
- Affichage visuel immédiat avec bordure orange et message d'erreur

### 2. Validation avant soumission
- Double vérification lors de la soumission du formulaire
- Empêche l'ajout si le SIRET existe déjà
- Message d'erreur clair pour l'utilisateur

### 3. Interface utilisateur améliorée
- Indicateur de chargement pendant la vérification
- Bordure colorée selon l'état de validation
- Message d'erreur explicite sous le champ SIRET

## Fichiers modifiés

### 1. `lib/features/commande/services/client_service.dart`
- Ajout de la méthode `checkSiretExists()` pour vérifier l'existence du SIRET via l'API

### 2. `lib/features/clients/controllers/client_controller.dart`
- Ajout de la méthode `checkSiretExists()` dans le contrôleur
- Intégration de la vérification dans la méthode `addClient()`
- Gestion des erreurs avec messages appropriés

### 3. `lib/features/clients/widgets/fiscal_textfield_with_camera.dart`
- Ajout des paramètres pour la validation en temps réel
- Affichage visuel de l'état de validation
- Message d'erreur intégré

### 4. `lib/features/clients/views/add_client_page.dart`
- Variables d'état pour la validation du SIRET
- Méthode `_checkSiretExists()` avec debounce
- Intégration du widget modifié
- Validation supplémentaire dans `_submitForm()`

## API Backend requise

L'endpoint suivant doit être implémenté côté backend :

```
GET /clients/check-siret/{siret}
Authorization: Bearer {token}
```

**Réponse attendue :**
```json
{
  "exists": true/false
}
```

## Flux de validation

1. **Saisie utilisateur** : L'utilisateur tape le numéro SIRET
2. **Validation format** : Vérification que le SIRET contient 14 chiffres
3. **Debounce** : Attente de 1 seconde après la dernière modification
4. **Appel API** : Vérification de l'existence dans la base de données
5. **Affichage résultat** : Bordure orange + message si le SIRET existe
6. **Validation finale** : Vérification lors de la soumission du formulaire

## Messages d'erreur

- **SIRET incomplet** : "Le SIRET doit contenir exactement 14 chiffres"
- **SIRET existant** : "Ce numéro SIRET existe déjà dans la base de données. Impossible d'ajouter ce client."
- **Erreur API** : "Erreur lors de la vérification du SIRET"

## Avantages

- ✅ Prévention des doublons SIRET
- ✅ Feedback immédiat à l'utilisateur
- ✅ Performance optimisée avec debounce
- ✅ Interface utilisateur intuitive
- ✅ Gestion d'erreurs robuste 