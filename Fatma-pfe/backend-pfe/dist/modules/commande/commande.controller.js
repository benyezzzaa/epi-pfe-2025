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
exports.CommandeController = void 0;
const common_1 = require("@nestjs/common");
const commande_service_1 = require("./commande.service");
const create_commande_dto_1 = require("./dto/create-commande.dto");
const swagger_1 = require("@nestjs/swagger");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const update_commande_dto_1 = require("./dto/update-commande.dto");
let CommandeController = class CommandeController {
    commandeService;
    constructor(commandeService) {
        this.commandeService = commandeService;
    }
    async createCommande(dto, req) {
        return this.commandeService.createCommande(dto, req.user);
    }
    async getAllCommandes() {
        return this.commandeService.getAllCommandes();
    }
    async getMyCommandes(req) {
        return this.commandeService.findAllByCommercial(req.user.id);
    }
    async updateCommande(id, dto) {
        console.log('REÇU:', dto);
        return this.commandeService.updateCommande(id, dto);
    }
    validerCommande(id) {
        return this.commandeService.validerCommande(+id);
    }
    rejeterCommande(id, body) {
        return this.commandeService.rejeterCommande(+id, body.motif_rejet);
    }
    async deleteCommande(id) {
        return this.commandeService.deleteCommande(id);
    }
    async cleanOldCommandeNumbers() {
        return this.commandeService.cleanOldCommandeNumbers();
    }
    async fixDuplicateCommandeNumbers() {
        return this.commandeService.fixDuplicateCommandeNumbers();
    }
    async rejeterCommandeViaDelete(id, body) {
        const motif = body.motif_rejet || 'Commande rejetée par l\'administrateur';
        return this.commandeService.rejeterCommande(+id, motif);
    }
    async deleteCommandeDefinitivement(id) {
        return this.commandeService.deleteCommandeDefinitivement(id);
    }
    async getBandeDeCommande(id) {
        return this.commandeService.getBandeDeCommande(id);
    }
    async getCommandesValidees() {
        return this.commandeService.getCommandesValidees();
    }
    async getCommandesRejetees(req) {
        return this.commandeService.getCommandesRejeteesPourCommercial(req.user.id);
    }
    async downloadPdf(id, res) {
        const pdfBuffer = await this.commandeService.generatePdf(+id);
        res.set({
            'Content-Type': 'application/pdf',
            'Content-Disposition': `attachment; filename="commande_${id}.pdf"`,
        });
        res.send(pdfBuffer);
    }
    async getCommandesModifiees(req) {
        return this.commandeService.getCommandesModifieesPourCommercial(req.user.id);
    }
    async getDetailsCommandeModifiee(id) {
        return this.commandeService.getDetailsCommandeModifiee(id);
    }
    async marquerNotificationCommeVue(id) {
        return this.commandeService.getNombreNotificationsNonVues(id);
    }
    async getNombreNotificationsNonVues(req) {
        return this.commandeService.getNombreNotificationsNonVues(req.user.id);
    }
};
exports.CommandeController = CommandeController;
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_commande_dto_1.CreateCommandeDto, Object]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "createCommande", null);
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Voir toutes les commandes' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "getAllCommandes", null);
__decorate([
    (0, common_1.Get)('me'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "getMyCommandes", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Modifier une commande (admin)' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, update_commande_dto_1.UpdateCommandeDto]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "updateCommande", null);
__decorate([
    (0, common_1.Put)('valider/:id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], CommandeController.prototype, "validerCommande", null);
__decorate([
    (0, common_1.Put)('rejeter/:id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Rejeter une commande (admin)' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", void 0)
], CommandeController.prototype, "rejeterCommande", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Supprimer définitivement une commande' }),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "deleteCommande", null);
__decorate([
    (0, common_1.Post)('clean-numbers'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Nettoyer les anciens numéros de commande incorrects' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "cleanOldCommandeNumbers", null);
__decorate([
    (0, common_1.Post)('fix-duplicates'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Corriger les numéros de commande en double' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "fixDuplicateCommandeNumbers", null);
__decorate([
    (0, common_1.Delete)('rejeter/:id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Rejeter une commande (marquer comme rejetée au lieu de supprimer)' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "rejeterCommandeViaDelete", null);
__decorate([
    (0, common_1.Delete)('definitif/:id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Supprimer définitivement une commande (irréversible)' }),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "deleteCommandeDefinitivement", null);
__decorate([
    (0, common_1.Get)('bande/:id'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "getBandeDeCommande", null);
__decorate([
    (0, common_1.Get)('validees'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "getCommandesValidees", null);
__decorate([
    (0, common_1.Get)('rejetees'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Récupérer les commandes rejetées par l\'admin' }),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "getCommandesRejetees", null);
__decorate([
    (0, common_1.Get)('pdf/:id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "downloadPdf", null);
__decorate([
    (0, common_1.Get)('modifiees'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Récupérer les commandes modifiées par l\'admin' }),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "getCommandesModifiees", null);
__decorate([
    (0, common_1.Get)('modifiees/details/:id'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Récupérer les détails d\'une commande modifiée' }),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "getDetailsCommandeModifiee", null);
__decorate([
    (0, common_1.Put)('notifications/:id/vu'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Marquer une notification comme vue' }),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "marquerNotificationCommeVue", null);
__decorate([
    (0, common_1.Get)('notifications'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Nombre de notifications non vues pour un commercial' }),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], CommandeController.prototype, "getNombreNotificationsNonVues", null);
exports.CommandeController = CommandeController = __decorate([
    (0, swagger_1.ApiTags)('Commandes'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('commandes'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [commande_service_1.CommandeService])
], CommandeController);
//# sourceMappingURL=commande.controller.js.map