# 🚀 Guide DevOps - Fatma PFE

## 📋 Prérequis

### Outils requis
- ✅ Docker Desktop
- ✅ Docker Compose
- ✅ Node.js 18+
- ✅ Python 3.11+
- ✅ Azure DevOps (pour CI/CD)

### Variables d'environnement
Créez un fichier `.env` dans chaque service :

**Backend (.env)**
```env
DATABASE_HOST=db-1
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=fatma
DATABASE_NAME=postgres
JWT_SECRET=your-secret-key
```

## 🔧 Configuration Azure DevOps

### 1. Créer un Pipeline
1. Allez dans Azure DevOps > Pipelines
2. Cliquez sur "New Pipeline"
3. Sélectionnez "Azure Repos Git"
4. Choisissez votre repository
5. Sélectionnez "Existing Azure Pipelines YAML file"
6. Spécifiez le chemin : `azure-pipelines.yml`

### 2. Variables de Pipeline
Dans Azure DevOps, ajoutez ces variables :
- `DOCKER_REGISTRY`: Votre registry Docker
- `DOCKER_USERNAME`: Nom d'utilisateur Docker
- `DOCKER_PASSWORD`: Mot de passe Docker

## 🚀 Déploiement Local

### Option 1: Script PowerShell
```powershell
# Déploiement complet
.\deploy-devops.ps1

# Construction uniquement
.\deploy-devops.ps1 -Build

# Tests uniquement
.\deploy-devops.ps1 -Test

# Déploiement uniquement
.\deploy-devops.ps1 -Deploy
```

### Option 2: Docker Compose
```bash
# Construire et démarrer
docker-compose up --build

# Démarrer en arrière-plan
docker-compose up -d

# Arrêter
docker-compose down

# Voir les logs
docker-compose logs -f
```

## 🔍 Vérification

### Services disponibles
- 🌐 **Frontend**: http://localhost:8080
- 🔧 **Backend**: http://localhost:4000
- 🤖 **AI Service**: http://localhost:8000
- 🗄️ **Database**: localhost:5432

### Health Checks
```bash
# Vérifier l'état des conteneurs
docker-compose ps

# Vérifier les logs
docker-compose logs [service-name]

# Tester les endpoints
curl http://localhost:4000/health
curl http://localhost:8000/health
```

## 🐛 Dépannage

### Problèmes courants

#### 1. Ports déjà utilisés
```bash
# Vérifier les ports utilisés
netstat -ano | findstr :4000
netstat -ano | findstr :8000
netstat -ano | findstr :8080

# Tuer le processus
taskkill /PID [PID] /F
```

#### 2. Erreurs de build Docker
```bash
# Nettoyer les images
docker system prune -a

# Reconstruire sans cache
docker-compose build --no-cache
```

#### 3. Problèmes de base de données
```bash
# Redémarrer la base de données
docker-compose restart db-1

# Vérifier les logs
docker-compose logs db-1
```

## 📊 Monitoring

### Logs en temps réel
```bash
# Tous les services
docker-compose logs -f

# Service spécifique
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f ia
```

### Métriques Docker
```bash
# Utilisation des ressources
docker stats

# Espace disque
docker system df
```

## 🔄 CI/CD Pipeline

### Étapes du pipeline
1. **Build**: Construction des images Docker
2. **Test**: Exécution des tests unitaires
3. **Deploy**: Déploiement en production

### Déclencheurs
- Push sur la branche `main`
- Pull Request vers `main`

## 📝 Notes importantes

### Sécurité
- ⚠️ Changez les mots de passe par défaut
- ⚠️ Utilisez des secrets pour les variables sensibles
- ⚠️ Activez HTTPS en production

### Performance
- 🚀 Utilisez des volumes pour la persistance
- 🚀 Configurez des health checks
- 🚀 Optimisez les images Docker

### Maintenance
- 🔄 Mettez à jour régulièrement les dépendances
- 🔄 Surveillez les logs d'erreur
- 🔄 Sauvegardez la base de données

## 📞 Support

En cas de problème :
1. Vérifiez les logs : `docker-compose logs`
2. Consultez ce guide de dépannage
3. Contactez l'équipe DevOps 