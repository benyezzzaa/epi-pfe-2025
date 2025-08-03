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
exports.CategorieClientController = void 0;
const common_1 = require("@nestjs/common");
const categorie_client_service_1 = require("./categorie-client.service");
const create_categorie_client_dto_1 = require("./DTO/create-categorie-client.dto");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const swagger_1 = require("@nestjs/swagger");
const update_categorie_status_dto_1 = require("./DTO/update-categorie-status.dto");
let CategorieClientController = class CategorieClientController {
    categorieService;
    constructor(categorieService) {
        this.categorieService = categorieService;
    }
    createCategorie(dto, req) {
        return this.categorieService.create(dto);
    }
    getAll() {
        return this.categorieService.findAll();
    }
    updateCategorie(id, dto) {
        return this.categorieService.update(id, dto);
    }
    updateStatusPut(id, body) {
        console.log('BODY PUT statut catégorie:', body);
        return this.categorieService.updateStatus(id, body.isActive);
    }
};
exports.CategorieClientController = CategorieClientController;
__decorate([
    (0, common_1.Post)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Ajouter une catégorie (admin uniquement)' }),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_categorie_client_dto_1.CreateCategorieClientDto, Object]),
    __metadata("design:returntype", void 0)
], CategorieClientController.prototype, "createCategorie", null);
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Lister toutes les catégories (admin et commercial)' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], CategorieClientController.prototype, "getAll", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Modifier une catégorie (admin uniquement)' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, create_categorie_client_dto_1.CreateCategorieClientDto]),
    __metadata("design:returntype", void 0)
], CategorieClientController.prototype, "updateCategorie", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Activer/désactiver une catégorie (PUT)' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, update_categorie_status_dto_1.UpdateCategorieStatusDto]),
    __metadata("design:returntype", void 0)
], CategorieClientController.prototype, "updateStatusPut", null);
exports.CategorieClientController = CategorieClientController = __decorate([
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiTags)('categorie-client'),
    (0, common_1.Controller)('categorie-client'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [categorie_client_service_1.CategorieClientService])
], CategorieClientController);
//# sourceMappingURL=categorie-client.controller.js.map