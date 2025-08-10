# Script de déploiement DevOps pour Fatma PFE
param(
    [string]$Environment = "development",
    [switch]$Build,
    [switch]$Deploy,
    [switch]$Test
)

Write-Host "🚀 Déploiement DevOps - Fatma PFE" -ForegroundColor Green
Write-Host "Environment: $Environment" -ForegroundColor Yellow

# Variables
$DockerComposeFile = "docker-compose.yml"
$BackendPath = "backend-pfe"
$FrontendPath = "frontend-pfe-admin"
$AIServicePath = "ai-prediction-service"

# Fonction pour vérifier les prérequis
function Test-Prerequisites {
    Write-Host "🔍 Vérification des prérequis..." -ForegroundColor Blue
    
    # Vérifier Docker
    try {
        $dockerVersion = docker --version
        Write-Host "✅ Docker: $dockerVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Docker non installé" -ForegroundColor Red
        exit 1
    }
    
    # Vérifier Docker Compose
    try {
        $composeVersion = docker-compose --version
        Write-Host "✅ Docker Compose: $composeVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Docker Compose non installé" -ForegroundColor Red
        exit 1
    }
    
    # Vérifier Node.js
    try {
        $nodeVersion = node --version
        Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Node.js non installé" -ForegroundColor Red
        exit 1
    }
}

# Fonction pour construire les images
function Build-Images {
    Write-Host "🔨 Construction des images Docker..." -ForegroundColor Blue
    
    # Construire le backend
    Write-Host "📦 Construction du backend..." -ForegroundColor Yellow
    Set-Location $BackendPath
    docker build -t fatma-pfe-backend .
    Set-Location ..
    
    # Construire le frontend
    Write-Host "📦 Construction du frontend..." -ForegroundColor Yellow
    Set-Location $FrontendPath
    docker build -t fatma-pfe-frontend .
    Set-Location ..
    
    # Construire le service AI
    Write-Host "📦 Construction du service AI..." -ForegroundColor Yellow
    Set-Location $AIServicePath
    docker build -t fatma-pfe-ai .
    Set-Location ..
    
    Write-Host "✅ Construction terminée" -ForegroundColor Green
}

# Fonction pour exécuter les tests
function Run-Tests {
    Write-Host "🧪 Exécution des tests..." -ForegroundColor Blue
    
    # Tests backend
    Write-Host "🧪 Tests backend..." -ForegroundColor Yellow
    Set-Location $BackendPath
    npm test
    Set-Location ..
    
    # Tests frontend
    Write-Host "🧪 Tests frontend..." -ForegroundColor Yellow
    Set-Location $FrontendPath
    npm test -- --watchAll=false
    Set-Location ..
    
    Write-Host "✅ Tests terminés" -ForegroundColor Green
}

# Fonction pour déployer
function Deploy-Application {
    Write-Host "🚀 Déploiement de l'application..." -ForegroundColor Blue
    
    # Arrêter les conteneurs existants
    Write-Host "🛑 Arrêt des conteneurs existants..." -ForegroundColor Yellow
    docker-compose -f $DockerComposeFile down
    
    # Démarrer les services
    Write-Host "▶️ Démarrage des services..." -ForegroundColor Yellow
    docker-compose -f $DockerComposeFile up -d
    
    # Attendre que les services soient prêts
    Write-Host "⏳ Attente du démarrage des services..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    
    # Vérifier l'état des services
    Write-Host "🔍 Vérification de l'état des services..." -ForegroundColor Yellow
    docker-compose -f $DockerComposeFile ps
    
    Write-Host "✅ Déploiement terminé" -ForegroundColor Green
    Write-Host "🌐 Services disponibles:" -ForegroundColor Cyan
    Write-Host "   - Frontend: http://localhost:8080" -ForegroundColor White
    Write-Host "   - Backend: http://localhost:4000" -ForegroundColor White
    Write-Host "   - AI Service: http://localhost:8000" -ForegroundColor White
    Write-Host "   - Database: localhost:5432" -ForegroundColor White
}

# Exécution principale
try {
    Test-Prerequisites
    
    if ($Build) {
        Build-Images
    }
    
    if ($Test) {
        Run-Tests
    }
    
    if ($Deploy) {
        Deploy-Application
    }
    
    # Si aucun paramètre spécifié, exécuter tout
    if (-not $Build -and -not $Deploy -and -not $Test) {
        Build-Images
        Run-Tests
        Deploy-Application
    }
}
catch {
    Write-Host "❌ Erreur lors du déploiement: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} 