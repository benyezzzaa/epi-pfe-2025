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
exports.VisiteController = void 0;
const common_1 = require("@nestjs/common");
const visite_service_1 = require("./visite.service");
const create_visite_dto_1 = require("./dto/create-visite.dto");
const swagger_1 = require("@nestjs/swagger");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
let VisiteController = class VisiteController {
    visiteService;
    constructor(visiteService) {
        this.visiteService = visiteService;
    }
    async createVisite(dto, req) {
        return this.visiteService.createVisite(dto, req.user);
    }
    getMyVisites(req) {
        return this.visiteService.getVisitesByCommercial(req.user.id);
    }
    async getAllVisites() {
        return this.visiteService.getAllVisites();
    }
    async getVisitesByCommercial(id, req) {
        if (req.user.role === 'commercial' && req.user.id !== Number(id)) {
            throw new common_1.ForbiddenException('Vous ne pouvez voir que vos propres visites.');
        }
        return this.visiteService.getVisitesByCommercial(id);
    }
    async deleteVisite(id, req) {
        return this.visiteService.deleteVisite(id, req.user);
    }
    findAll() {
        return this.visiteService.getAllVisites();
    }
};
exports.VisiteController = VisiteController;
__decorate([
    (0, common_1.Post)(),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Ajouter une visite (Commercial uniquement)' }),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_visite_dto_1.CreateVisiteDto, Object]),
    __metadata("design:returntype", Promise)
], VisiteController.prototype, "createVisite", null);
__decorate([
    (0, common_1.Get)('me'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Voir mes propres visites' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], VisiteController.prototype, "getMyVisites", null);
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Voir toutes les visites (Admin uniquement)' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], VisiteController.prototype, "getAllVisites", null);
__decorate([
    (0, common_1.Get)('commercial/:id'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Voir les visites d’un commercial' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", Promise)
], VisiteController.prototype, "getVisitesByCommercial", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Supprimer une visite (Admin ou propriétaire)' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", Promise)
], VisiteController.prototype, "deleteVisite", null);
__decorate([
    (0, common_1.Get)('all'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], VisiteController.prototype, "findAll", null);
exports.VisiteController = VisiteController = __decorate([
    (0, swagger_1.ApiTags)('Visites'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('visites'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [visite_service_1.VisiteService])
], VisiteController);
//# sourceMappingURL=visite.controller.js.map