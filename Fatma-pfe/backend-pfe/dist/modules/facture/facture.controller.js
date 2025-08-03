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
exports.FactureController = void 0;
const common_1 = require("@nestjs/common");
const facture_service_1 = require("./facture.service");
const swagger_1 = require("@nestjs/swagger");
let FactureController = class FactureController {
    factureService;
    constructor(factureService) {
        this.factureService = factureService;
    }
    async getAllFactures() {
        return this.factureService.findAll();
    }
    async getOne(id) {
        const facture = await this.factureService.findById(id);
        if (!facture) {
            throw new common_1.NotFoundException('Facture non trouvée');
        }
        return facture;
    }
    async createFacture(factureData) {
        return this.factureService.create(factureData);
    }
    async deleteFacture(id) {
        return this.factureService.delete(id);
    }
};
exports.FactureController = FactureController;
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], FactureController.prototype, "getAllFactures", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], FactureController.prototype, "getOne", null);
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], FactureController.prototype, "createFacture", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], FactureController.prototype, "deleteFacture", null);
exports.FactureController = FactureController = __decorate([
    (0, swagger_1.ApiTags)('Factures'),
    (0, common_1.Controller)('factures'),
    __metadata("design:paramtypes", [facture_service_1.FactureService])
], FactureController);
//# sourceMappingURL=facture.controller.js.map