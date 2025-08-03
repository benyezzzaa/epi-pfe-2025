"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AiPredictionService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const commande_entity_1 = require("../commande/commande.entity");
const lignecommande_entity_1 = require("../lignecommande/lignecommande.entity");
const produit_entity_1 = require("../produit/produit.entity");
const categorie_produit_entity_1 = require("../categorie-produit/categorie-produit.entity");
const client_entity_1 = require("../client/client.entity");
const axios_1 = require("axios");
let AiPredictionService = class AiPredictionService {
    commandeRepository;
    ligneCommandeRepository;
    produitRepository;
    categorieRepository;
    clientRepository;
    aiServiceUrl = process.env.AI_SERVICE_URL || 'http://localhost:8000';
    constructor(commandeRepository, ligneCommandeRepository, produitRepository, categorieRepository, clientRepository) {
        this.commandeRepository = commandeRepository;
        this.ligneCommandeRepository = ligneCommandeRepository;
        this.produitRepository = produitRepository;
        this.categorieRepository = categorieRepository;
        this.clientRepository = clientRepository;
    }
    async getPredictions(request = {}) {
        try {
            const response = await axios_1.default.get(`${this.aiServiceUrl}/predict`, {
                params: {
                    top_n: request.top_n || 10,
                },
            });
            return response.data;
        }
        catch (error) {
            console.error('Error calling AI service:', error);
            throw new common_1.HttpException('Failed to get predictions from AI service', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async retrainModels() {
        try {
            const response = await axios_1.default.post(`${this.aiServiceUrl}/retrain`);
            return response.data;
        }
        catch (error) {
            console.error('Error retraining models:', error);
            throw new common_1.HttpException('Failed to retrain AI models', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getHealthStatus() {
        try {
            const response = await axios_1.default.get(`${this.aiServiceUrl}/health`);
            return response.data;
        }
        catch (error) {
            console.error('Error checking AI service health:', error);
            return {
                status: 'unhealthy',
                models_loaded: false,
                timestamp: new Date().toISOString(),
            };
        }
    }
    async getSalesAnalytics() {
        try {
            const commandes = await this.commandeRepository.find({
                relations: ['lignesCommande', 'lignesCommande.produit', 'lignesCommande.produit.categorie'],
            });
            const salesData = commandes.map(commande => ({
                id: commande.id,
                date_creation: commande.dateCreation,
                client_id: commande.client?.id,
                prix_total_ttc: commande.prix_total_ttc,
                statut: commande.statut,
                lignes: commande.lignesCommande.map(ligne => ({
                    id: ligne.id,
                    commande_id: ligne.commande.id,
                    produit_id: ligne.produit.id,
                    quantite: ligne.quantite,
                    total: ligne.total,
                })),
            }));
            return {
                total_orders: commandes.length,
                total_revenue: commandes.reduce((sum, cmd) => sum + cmd.prix_total_ttc, 0),
                sales_data: salesData,
            };
        }
        catch (error) {
            console.error('Error getting sales analytics:', error);
            throw new common_1.HttpException('Failed to get sales analytics', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getTopProductsByPeriod(period = 'month') {
        try {
            const dateFilter = this.getDateFilter(period);
            const topProducts = await this.ligneCommandeRepository
                .createQueryBuilder('ligne')
                .leftJoinAndSelect('ligne.produit', 'produit')
                .leftJoinAndSelect('ligne.commande', 'commande')
                .where('commande.dateCreation >= :dateFilter', { dateFilter })
                .select([
                'produit.id as product_id',
                'produit.nom as product_name',
                'SUM(ligne.quantite) as total_quantity',
                'SUM(ligne.total) as total_revenue',
            ])
                .groupBy('produit.id, produit.nom')
                .orderBy('total_quantity', 'DESC')
                .limit(10)
                .getRawMany();
            return topProducts;
        }
        catch (error) {
            console.error('Error getting top products:', error);
            throw new common_1.HttpException('Failed to get top products', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getTopCategoriesByPeriod(period = 'month') {
        try {
            const dateFilter = this.getDateFilter(period);
            const topCategories = await this.ligneCommandeRepository
                .createQueryBuilder('ligne')
                .leftJoinAndSelect('ligne.produit', 'produit')
                .leftJoinAndSelect('produit.categorie', 'categorie')
                .leftJoinAndSelect('ligne.commande', 'commande')
                .where('commande.dateCreation >= :dateFilter', { dateFilter })
                .select([
                'categorie.id as category_id',
                'categorie.nom as category_name',
                'SUM(ligne.quantite) as total_quantity',
                'SUM(ligne.total) as total_revenue',
            ])
                .groupBy('categorie.id, categorie.nom')
                .orderBy('total_quantity', 'DESC')
                .limit(10)
                .getRawMany();
            return topCategories;
        }
        catch (error) {
            console.error('Error getting top categories:', error);
            throw new common_1.HttpException('Failed to get top categories', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    getDateFilter(period) {
        const now = new Date();
        switch (period) {
            case 'week':
                return new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
            case 'month':
                return new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
            case 'quarter':
                return new Date(now.getTime() - 90 * 24 * 60 * 60 * 1000);
            default:
                return new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
        }
    }
};
exports.AiPredictionService = AiPredictionService;
exports.AiPredictionService = AiPredictionService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(commande_entity_1.Commande)),
    __param(1, (0, typeorm_1.InjectRepository)(lignecommande_entity_1.LigneCommande)),
    __param(2, (0, typeorm_1.InjectRepository)(produit_entity_1.Produit)),
    __param(3, (0, typeorm_1.InjectRepository)(categorie_produit_entity_1.CategorieProduit)),
    __param(4, (0, typeorm_1.InjectRepository)(client_entity_1.Client)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], AiPredictionService);
//# sourceMappingURL=ai-prediction.service.js.map