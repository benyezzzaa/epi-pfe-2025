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
exports.PromotionController = void 0;
const common_1 = require("@nestjs/common");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const swagger_1 = require("@nestjs/swagger");
const CreatePromotionDto_dto_1 = require("./DTO/CreatePromotionDto.dto");
const Promotion_Service_1 = require("./Promotion.Service");
let PromotionController = class PromotionController {
    promoService;
    constructor(promoService) {
        this.promoService = promoService;
    }
    create(dto) {
        return this.promoService.create(dto);
    }
    findActivePromotionsForCommercial() {
        return this.promoService.findActives();
    }
    findAll(req) {
        console.log('👤 Role:', req.user.role);
        return this.promoService.findAll();
    }
    getActives() {
        return this.promoService.getPromotionsActives();
    }
    updateFromBody(dto) {
        return this.promoService.update(dto.id, dto);
    }
    toggleStatus(id) {
        return this.promoService.toggleStatus(id);
    }
};
exports.PromotionController = PromotionController;
__decorate([
    (0, common_1.Post)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [CreatePromotionDto_dto_1.CreatePromotionDto]),
    __metadata("design:returntype", void 0)
], PromotionController.prototype, "create", null);
__decorate([
    (0, common_1.Get)('commercial/actives'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], PromotionController.prototype, "findActivePromotionsForCommercial", null);
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], PromotionController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('actives'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], PromotionController.prototype, "getActives", null);
__decorate([
    (0, common_1.Put)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], PromotionController.prototype, "updateFromBody", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], PromotionController.prototype, "toggleStatus", null);
exports.PromotionController = PromotionController = __decorate([
    (0, swagger_1.ApiTags)('Promotions'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('promotions'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [Promotion_Service_1.PromotionService])
], PromotionController);
//# sourceMappingURL=Promotion.Controller.js.map