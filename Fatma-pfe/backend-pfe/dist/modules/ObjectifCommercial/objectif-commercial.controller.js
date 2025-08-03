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
exports.ObjectifCommercialController = void 0;
const common_1 = require("@nestjs/common");
const objectif_commercial_service_1 = require("./objectif-commercial.service");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const swagger_1 = require("@nestjs/swagger");
const create_objectif_dto_1 = require("./DTO/create-objectif.dto");
let ObjectifCommercialController = class ObjectifCommercialController {
    objectifService;
    constructor(objectifService) {
        this.objectifService = objectifService;
    }
    createObjectifGlobal(dto) {
        return this.objectifService.createGlobal(dto);
    }
    create(dto) {
        return this.objectifService.create(dto);
    }
    async findAll() {
        return this.objectifService.findAll();
    }
    getGlobalProgress() {
        return this.objectifService.getProgressForAdmin();
    }
    getGlobalMontantProgress() {
        return this.objectifService.getGlobalMontantProgress();
    }
    getMyProgress(req) {
        console.log(`🔍 Controller: getMyProgress appelé pour userId: ${req.user.id}`);
        console.log(`👤 Commercial connecté: ${req.user.nom} ${req.user.prenom}`);
        console.log(`🔑 Token: ${req.headers.authorization?.substring(0, 20)}...`);
        return this.objectifService.getObjectifsProgress(req.user.id);
    }
    debugAll(req) {
        console.log(`🔍 Controller: debugAll appelé pour userId: ${req.user.id}`);
        return this.objectifService.findAll();
    }
    debugMyObjectifs(req) {
        console.log(`🔍 Controller: debugMyObjectifs appelé pour userId: ${req.user.id}`);
        console.log(`👤 Commercial connecté: ${req.user.nom} ${req.user.prenom}`);
        return this.objectifService.getObjectifsProgress(req.user.id);
    }
    getMySalesByCategory(req) {
        return this.objectifService.getSalesByCategory(req.user.userId);
    }
    getMyObjectifs(req) {
        return this.objectifService.getByCommercialGroupedByYear(req.user.userId);
    }
    update(id, data) {
        return this.objectifService.update(id, data);
    }
    toggleStatus(id) {
        return this.objectifService.toggleStatus(id);
    }
    remove(id) {
        return this.objectifService.remove(id);
    }
};
exports.ObjectifCommercialController = ObjectifCommercialController;
__decorate([
    (0, common_1.Post)('global'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_objectif_dto_1.CreateObjectifGlobalDto]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "createObjectifGlobal", null);
__decorate([
    (0, common_1.Post)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_objectif_dto_1.CreateObjectifDto]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], ObjectifCommercialController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('admin/progress'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "getGlobalProgress", null);
__decorate([
    (0, common_1.Get)('admin/progress-montant'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "getGlobalMontantProgress", null);
__decorate([
    (0, common_1.Get)('me/progress'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "getMyProgress", null);
__decorate([
    (0, common_1.Get)('debug/all'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "debugAll", null);
__decorate([
    (0, common_1.Get)('debug/my-objectifs'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "debugMyObjectifs", null);
__decorate([
    (0, common_1.Get)('me/sales-by-category'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "getMySalesByCategory", null);
__decorate([
    (0, common_1.Get)('me/by-year'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "getMyObjectifs", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "update", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "toggleStatus", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], ObjectifCommercialController.prototype, "remove", null);
exports.ObjectifCommercialController = ObjectifCommercialController = __decorate([
    (0, swagger_1.ApiTags)('Objectifs commerciaux'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('objectifs'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [objectif_commercial_service_1.ObjectifCommercialService])
], ObjectifCommercialController);
//# sourceMappingURL=objectif-commercial.controller.js.map