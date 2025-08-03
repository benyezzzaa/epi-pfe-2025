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
exports.LigneCommandeController = void 0;
const common_1 = require("@nestjs/common");
const lignecommande_service_1 = require("./lignecommande.service");
const swagger_1 = require("@nestjs/swagger");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const create_ligneCommande_dto_1 = require("./dto/create-ligneCommande.dto");
const update_ligneCommande_dto_1 = require("./dto/update-ligneCommande.dto");
let LigneCommandeController = class LigneCommandeController {
    ligneCommandeService;
    constructor(ligneCommandeService) {
        this.ligneCommandeService = ligneCommandeService;
    }
    async getAllLignesCommande() {
        const lignes = await this.ligneCommandeService.getAllLignesCommande();
        return lignes.map(ligne => ({
            id: ligne.id,
            numero_commande: ligne.commande?.numero_commande,
            nom_produit: ligne.produit?.nom,
            quantite: ligne.quantite,
            prix_unitaire: ligne.prixUnitaire,
        }));
    }
    async updateLigneCommande(id, updateDto) {
        return this.ligneCommandeService.updateLigneCommande(id, updateDto);
    }
};
exports.LigneCommandeController = LigneCommandeController;
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Voir toutes les lignes de commande (Bande de commande)' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Liste des lignes de commande', type: [create_ligneCommande_dto_1.LigneCommandeDto] }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], LigneCommandeController.prototype, "getAllLignesCommande", null);
__decorate([
    (0, common_1.Patch)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Modifier une ligne de commande' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Ligne modifiée' }),
    (0, common_1.Put)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, update_ligneCommande_dto_1.updateLigneCommandeDto]),
    __metadata("design:returntype", Promise)
], LigneCommandeController.prototype, "updateLigneCommande", null);
exports.LigneCommandeController = LigneCommandeController = __decorate([
    (0, swagger_1.ApiTags)('Lignes de Commande'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('lignes-commande'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [lignecommande_service_1.LigneCommandeService])
], LigneCommandeController);
//# sourceMappingURL=lignecommande.controller.js.map