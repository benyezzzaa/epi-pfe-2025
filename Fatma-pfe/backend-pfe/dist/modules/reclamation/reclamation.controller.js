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
exports.ReclamationController = void 0;
const common_1 = require("@nestjs/common");
const reclamation_service_1 = require("./reclamation.service");
const create_reclamation_dto_1 = require("./DTO/create-reclamation.dto");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const swagger_1 = require("@nestjs/swagger");
let ReclamationController = class ReclamationController {
    service;
    constructor(service) {
        this.service = service;
    }
    findOpen() {
        return this.service.findOpenReclamations();
    }
    create(dto, req) {
        return this.service.create(dto, req.user);
    }
    findAll() {
        return this.service.findAll();
    }
    findByUser(req) {
        return this.service.findByUser(req.user.id);
    }
    updateStatus(id, status) {
        return this.service.updateStatus(id, status);
    }
};
exports.ReclamationController = ReclamationController;
__decorate([
    (0, common_1.Get)('ouvertes'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ReclamationController.prototype, "findOpen", null);
__decorate([
    (0, common_1.Post)(),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_reclamation_dto_1.CreateReclamationDto, Object]),
    __metadata("design:returntype", void 0)
], ReclamationController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ReclamationController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('me'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ReclamationController.prototype, "findByUser", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)('status')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, String]),
    __metadata("design:returntype", void 0)
], ReclamationController.prototype, "updateStatus", null);
exports.ReclamationController = ReclamationController = __decorate([
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('reclamations'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [reclamation_service_1.ReclamationService])
], ReclamationController);
//# sourceMappingURL=reclamation.controller.js.map