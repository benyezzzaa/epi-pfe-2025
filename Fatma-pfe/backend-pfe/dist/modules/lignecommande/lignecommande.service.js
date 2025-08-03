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
exports.LigneCommandeService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const lignecommande_entity_1 = require("./lignecommande.entity");
const commande_service_1 = require("../commande/commande.service");
let LigneCommandeService = class LigneCommandeService {
    ligneCommandeRepository;
    commandeService;
    constructor(ligneCommandeRepository, commandeService) {
        this.ligneCommandeRepository = ligneCommandeRepository;
        this.commandeService = commandeService;
    }
    async getAllLignesCommande() {
        return this.ligneCommandeRepository.find({ relations: ['commande', 'produit'] });
    }
    async updateLigneCommande(id, updateDto) {
        const ligne = await this.ligneCommandeRepository.findOne({
            where: { id },
            relations: ['produit', 'commande'],
        });
        if (!ligne) {
            throw new common_1.NotFoundException(`Ligne de commande ${id} non trouvée`);
        }
        if (updateDto.prix_unitaire === undefined) {
            throw new common_1.BadRequestException('Prix unitaire requis');
        }
        if (updateDto.quantite === undefined) {
            throw new common_1.BadRequestException('Quantité requise');
        }
        const prixUnitaire = Number(updateDto.prix_unitaire);
        const quantite = Number(updateDto.quantite);
        if (isNaN(prixUnitaire) || prixUnitaire <= 0) {
            throw new common_1.BadRequestException('Prix unitaire invalide');
        }
        if (isNaN(quantite) || quantite <= 0 || !Number.isInteger(quantite)) {
            throw new common_1.BadRequestException('Quantité invalide');
        }
        ligne.prixUnitaireTTC = prixUnitaire;
        ligne.quantite = quantite;
        ligne.total = prixUnitaire * quantite;
        await this.ligneCommandeRepository.save(ligne);
        await this.commandeService.recalculerTotauxCommande(ligne.commande.id);
        return ligne;
    }
};
exports.LigneCommandeService = LigneCommandeService;
exports.LigneCommandeService = LigneCommandeService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(lignecommande_entity_1.LigneCommande)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        commande_service_1.CommandeService])
], LigneCommandeService);
//# sourceMappingURL=lignecommande.service.js.map