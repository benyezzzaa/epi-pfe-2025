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
exports.RaisonVisiteController = void 0;
const common_1 = require("@nestjs/common");
const raison_visite_service_1 = require("./raison-visite.service");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const swagger_1 = require("@nestjs/swagger");
let RaisonVisiteController = class RaisonVisiteController {
    service;
    constructor(service) {
        this.service = service;
    }
    findActives() {
        return this.service.findActive();
    }
    findAll() {
        return this.service.findAll();
    }
    create(nom) {
        return this.service.create(nom);
    }
    update(id, body) {
        if (!body.nom || typeof body.nom !== 'string') {
            throw new common_1.NotFoundException('Le champ "nom" est requis.');
        }
        return this.service.update(id, body.nom);
    }
    toggleActive(id) {
        return this.service.toggleActive(id);
    }
};
exports.RaisonVisiteController = RaisonVisiteController;
__decorate([
    (0, common_1.Get)('actives'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], RaisonVisiteController.prototype, "findActives", null);
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], RaisonVisiteController.prototype, "findAll", null);
__decorate([
    (0, common_1.Post)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Body)('nom')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], RaisonVisiteController.prototype, "create", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", void 0)
], RaisonVisiteController.prototype, "update", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], RaisonVisiteController.prototype, "toggleActive", null);
exports.RaisonVisiteController = RaisonVisiteController = __decorate([
    (0, swagger_1.ApiTags)('Raisons de Visite'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('raisons'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [raison_visite_service_1.RaisonVisiteService])
], RaisonVisiteController);
//# sourceMappingURL=raison-visite.controller.js.map