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
exports.UniteController = void 0;
const common_1 = require("@nestjs/common");
const unite_service_1 = require("./unite.service");
const CreateUniteDto_1 = require("./dto/CreateUniteDto");
const swagger_1 = require("@nestjs/swagger");
let UniteController = class UniteController {
    uniteService;
    constructor(uniteService) {
        this.uniteService = uniteService;
    }
    create(dto) {
        return this.uniteService.create(dto);
    }
    getAllUnites() {
        return this.uniteService.findAll();
    }
    toggleStatus(id, isActive) {
        return this.uniteService.toggleStatus(id, isActive);
    }
    findAllUnitesFromProduit(search, page, limit) {
        return this.uniteService.findAll({ search, page, limit });
    }
    findOne(id) {
        return this.uniteService.findOne(id);
    }
    update(id, dto) {
        return this.uniteService.update(id, dto);
    }
    delete(id) {
        return this.uniteService.delete(id);
    }
};
exports.UniteController = UniteController;
__decorate([
    (0, common_1.Post)(),
    (0, swagger_1.ApiOperation)({ summary: 'Créer une unité' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [CreateUniteDto_1.CreateUniteDto]),
    __metadata("design:returntype", void 0)
], UniteController.prototype, "create", null);
__decorate([
    (0, common_1.Get)('unites'),
    (0, swagger_1.ApiOperation)({ summary: 'Lister toutes les unités (alias)' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], UniteController.prototype, "getAllUnites", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    (0, swagger_1.ApiOperation)({ summary: 'Activer ou désactiver une unité' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)('isActive')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Boolean]),
    __metadata("design:returntype", void 0)
], UniteController.prototype, "toggleStatus", null);
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Lister toutes les unités (avec recherche et pagination)' }),
    __param(0, (0, common_1.Query)('search')),
    __param(1, (0, common_1.Query)('page')),
    __param(2, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Number, Number]),
    __metadata("design:returntype", void 0)
], UniteController.prototype, "findAllUnitesFromProduit", null);
__decorate([
    (0, common_1.Get)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Obtenir une unité par ID' }),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], UniteController.prototype, "findOne", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Mettre à jour une unité' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, CreateUniteDto_1.CreateUniteDto]),
    __metadata("design:returntype", void 0)
], UniteController.prototype, "update", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Supprimer une unité' }),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], UniteController.prototype, "delete", null);
exports.UniteController = UniteController = __decorate([
    (0, swagger_1.ApiTags)('Unite'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('unite'),
    __metadata("design:paramtypes", [unite_service_1.UniteService])
], UniteController);
//# sourceMappingURL=unite.controller.js.map