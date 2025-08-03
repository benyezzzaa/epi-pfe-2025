# Tests de Validation du SIRET

## Scénarios de test

### ✅ Scénario 1 : SIRET valide et unique
1. Saisir un SIRET de 14 chiffres qui n'existe pas
2. **Résultat attendu** : Bordure normale, pas de message d'erreur
3. Soumettre le formulaire
4. **Résultat attendu** : Client ajouté avec succès

### ❌ Scénario 2 : SIRET existant
1. Saisir un SIRET de 14 chiffres qui existe déjà
2. **Résultat attendu** : Bordure orange, message d'erreur "Ce numéro SIRET existe déjà"
3. Essayer de soumettre le formulaire
4. **Résultat attendu** : Message d'erreur, formulaire non soumis

### 🔄 Scénario 3 : Modification après erreur
1. Saisir un SIRET existant (ex: 12345678901234)
2. **Résultat attendu** : Bordure orange, message d'erreur
3. Modifier les 2 derniers chiffres (ex: 12345678901235)
4. **Résultat attendu** : 
   - L'état se réinitialise immédiatement (bordure normale, pas de message)
   - Après 1 seconde, nouvelle vérification du SIRET modifié
   - Si le nouveau SIRET n'existe pas : bordure normale
   - Si le nouveau SIRET existe : bordure orange, message d'erreur

### ⏱️ Scénario 4 : Debounce et modifications rapides
1. Saisir rapidement "12345678901234"
2. Immédiatement modifier en "12345678901235"
3. Puis en "12345678901236"
4. **Résultat attendu** : 
   - Pas d'appel API pour les modifications intermédiaires
   - Seule la dernière valeur est vérifiée après 1 seconde de pause

### 🚫 Scénario 5 : SIRET incomplet
1. Saisir moins de 14 chiffres (ex: 123456789)
2. **Résultat attendu** : Bordure normale, pas de vérification
3. Ajouter des chiffres pour atteindre 14 chiffres
4. **Résultat attendu** : Vérification automatique après 1 seconde

### 🔒 Scénario 6 : Double vérification à la soumission
1. Saisir un SIRET existant
2. Attendre la vérification en temps réel
3. Essayer de soumettre le formulaire
4. **Résultat attendu** : 
   - Vérification supplémentaire au moment de la soumission
   - Message d'erreur si le SIRET existe toujours
   - Formulaire non soumis

## Comportements attendus

### Réinitialisation automatique
- À chaque modification du SIRET, l'état se réinitialise
- Bordure orange → normale
- Message d'erreur disparaît
- Indicateur de chargement s'arrête

### Vérification robuste
- Vérification que le SIRET n'a pas changé pendant la requête API
- Annulation des requêtes obsolètes
- Gestion des erreurs réseau

### Feedback utilisateur
- Indicateur de chargement pendant la vérification
- Bordure colorée selon l'état
- Messages d'erreur clairs et explicites
- Empêchement de la soumission si SIRET existe

## Points de validation

- [ ] Réinitialisation immédiate à chaque modification
- [ ] Debounce de 1 seconde fonctionne
- [ ] Vérification en temps réel
- [ ] Double vérification à la soumission
- [ ] Gestion des erreurs réseau
- [ ] Interface utilisateur réactive
- [ ] Empêchement des doublons SIRET 