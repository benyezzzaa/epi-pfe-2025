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
exports.CircuitController = void 0;
const common_1 = require("@nestjs/common");
const circuit_service_1 = require("./circuit.service");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const create_circuit_dto_1 = require("./DTO/create-circuit.dto");
const swagger_1 = require("@nestjs/swagger");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
let CircuitController = class CircuitController {
    service;
    constructor(service) {
        this.service = service;
    }
    async create(dto, req) {
        return this.service.create(dto, req.user);
    }
    async getTodayCircuit(req) {
        const today = new Date();
        const dateStr = today.toISOString().split('T')[0];
        return this.service.getCircuitByDate(req.user, dateStr);
    }
    async getByDate(req, date) {
        return this.service.getCircuitByDate(req.user, date);
    }
};
exports.CircuitController = CircuitController;
__decorate([
    (0, common_1.Post)(),
    (0, swagger_1.ApiOperation)({ summary: 'Créer un circuit' }),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_circuit_dto_1.CreateCircuitDto, Object]),
    __metadata("design:returntype", Promise)
], CircuitController.prototype, "create", null);
__decorate([
    (0, common_1.Get)('me/today'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], CircuitController.prototype, "getTodayCircuit", null);
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Query)('date')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], CircuitController.prototype, "getByDate", null);
exports.CircuitController = CircuitController = __decorate([
    (0, swagger_1.ApiTags)('Circuits'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, common_1.Controller)('circuits'),
    __metadata("design:paramtypes", [circuit_service_1.CircuitService])
], CircuitController);
//# sourceMappingURL=circuit.controller.js.map