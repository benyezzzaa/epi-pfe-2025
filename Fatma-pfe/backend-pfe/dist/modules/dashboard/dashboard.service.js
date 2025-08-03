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
exports.DashboardService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const commande_entity_1 = require("../commande/commande.entity");
const produit_entity_1 = require("../produit/produit.entity");
const users_entity_1 = require("../users/users.entity");
const typeorm_2 = require("typeorm");
let DashboardService = class DashboardService {
    commandeRepository;
    produitRepository;
    userRepository;
    constructor(commandeRepository, produitRepository, userRepository) {
        this.commandeRepository = commandeRepository;
        this.produitRepository = produitRepository;
        this.userRepository = userRepository;
    }
    async getStats() {
        const totalCommandes = await this.commandeRepository.count();
        const totalProduits = await this.produitRepository.count();
        const totalUtilisateurs = await this.userRepository.count();
        return { totalCommandes, totalProduits, totalUtilisateurs };
    }
    async getVentesParCommercial() {
        const result = await this.commandeRepository
            .createQueryBuilder('commande')
            .leftJoin('commande.commercial', 'commercial')
            .select('commercial.prenom', 'commercial')
            .addSelect('SUM(commande.prix_total_ttc)', 'total')
            .groupBy('commercial.prenom')
            .getRawMany();
        return result.map(r => ({
            commercial: r.commercial,
            total: parseFloat(r.total),
        }));
    }
    async getVentesParCategorie() {
        const result = await this.produitRepository
            .createQueryBuilder('produit')
            .leftJoin('produit.categorie', 'categorie')
            .select('categorie.nom', 'categorie')
            .addSelect('COUNT(produit.id)', 'quantite')
            .groupBy('categorie.nom')
            .getRawMany();
        return result.map(r => ({
            categorie: r.categorie,
            quantite: parseInt(r.quantite, 10),
        }));
    }
    async getVentesParMois() {
        const currentYear = new Date().getFullYear();
        const result = await this.commandeRepository
            .createQueryBuilder('commande')
            .select("EXTRACT(MONTH FROM commande.dateCreation)", 'mois_num')
            .addSelect("TO_CHAR(commande.dateCreation, 'TMMonth')", 'mois')
            .addSelect('COALESCE(SUM(commande.prix_total_ttc), 0)', 'montant')
            .where("EXTRACT(YEAR FROM commande.dateCreation) = :year", { year: currentYear })
            .groupBy('mois_num, mois')
            .orderBy('mois_num', 'ASC')
            .getRawMany();
        const allMonths = Array.from({ length: 12 }, (_, i) => {
            const date = new Date(currentYear, i, 1);
            return {
                mois_num: i + 1,
                mois: date.toLocaleString('fr-FR', { month: 'long' })
            };
        });
        return allMonths.map(month => {
            const found = result.find(r => r.mois_num == month.mois_num);
            return {
                mois: month.mois.charAt(0).toUpperCase() + month.mois.slice(1),
                montant: found ? parseFloat(found.montant) : 0
            };
        });
    }
};
exports.DashboardService = DashboardService;
exports.DashboardService = DashboardService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(commande_entity_1.Commande)),
    __param(1, (0, typeorm_1.InjectRepository)(produit_entity_1.Produit)),
    __param(2, (0, typeorm_1.InjectRepository)(users_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], DashboardService);
//# sourceMappingURL=dashboard.service.js.map