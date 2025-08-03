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
exports.ClientController = void 0;
const common_1 = require("@nestjs/common");
const client_service_1 = require("./client.service");
const create_client_dto_1 = require("./DTO/create-client.dto");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const swagger_1 = require("@nestjs/swagger");
const update_client_status_dto_1 = require("./DTO/update-client-status.dto");
let ClientController = class ClientController {
    clientService;
    constructor(clientService) {
        this.clientService = clientService;
    }
    async createClient(dto, req) {
        return this.clientService.createClient(dto, req.user);
    }
    async getPlanning(lat, lon, req) {
        const parsedLat = parseFloat(lat);
        const parsedLon = parseFloat(lon);
        if (isNaN(parsedLat) || isNaN(parsedLon)) {
            throw new common_1.BadRequestException('Latitude et longitude invalides.');
        }
        return this.clientService.getOptimizedPlanning(req.user, parsedLat, parsedLon);
    }
    async getMesCategories(req) {
        return this.clientService.getCategoriesDuCommercial(req.user);
    }
    async getClients(commercialId) {
        if (commercialId) {
            return this.clientService.getClientsByCommercialId(commercialId);
        }
        return this.clientService.getAllClients();
    }
    async getMesClients(req) {
        console.log('user:', req.user);
        return this.clientService.getClientsDuCommercial(req.user);
    }
    getClient(id) {
        return this.clientService.getClientById(id);
    }
    async updateClient(id, dto, req) {
        try {
            return await this.clientService.updateClient(id, dto, req.user);
        }
        catch (error) {
            if (error instanceof common_1.HttpException)
                throw error;
            throw new common_1.InternalServerErrorException('Erreur interne lors de la mise à jour du client');
        }
    }
    async deleteClient(id, req) {
        return this.clientService.deleteClient(id, req.user);
    }
    async updateClientStatus(id, body, req) {
        return this.clientService.updateClientStatus(id, body.isActive, req.user);
    }
    async optionsClientStatus() {
        return {
            status: 'OK',
            methods: 'PATCH, OPTIONS',
            allowedHeaders: 'Content-Type, Authorization',
        };
    }
};
exports.ClientController = ClientController;
__decorate([
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    (0, common_1.Post)(),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Ajouter un client (Commercial uniquement)' }),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_client_dto_1.CreateClientDto, Object]),
    __metadata("design:returntype", Promise)
], ClientController.prototype, "createClient", null);
__decorate([
    (0, common_1.Get)('planning'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Obtenir la tournée optimisée des clients' }),
    __param(0, (0, common_1.Query)('lat')),
    __param(1, (0, common_1.Query)('lon')),
    __param(2, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object]),
    __metadata("design:returntype", Promise)
], ClientController.prototype, "getPlanning", null);
__decorate([
    (0, common_1.Get)('mes-categories'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Catégories des clients du commercial connecté' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], ClientController.prototype, "getMesCategories", null);
__decorate([
    (0, common_1.Get)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Voir tous les clients ou filtrer par commercial' }),
    __param(0, (0, common_1.Query)('commercialId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], ClientController.prototype, "getClients", null);
__decorate([
    (0, common_1.Get)('mes-clients'),
    (0, setRoles_decorator_1.SetRoles)('commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Récupérer les clients du commercial connecté' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], ClientController.prototype, "getMesClients", null);
__decorate([
    (0, common_1.Get)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Voir un client par ID' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], ClientController.prototype, "getClient", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Modifier un client' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, create_client_dto_1.CreateClientDto, Object]),
    __metadata("design:returntype", Promise)
], ClientController.prototype, "updateClient", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Supprimer un client' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", Promise)
], ClientController.prototype, "deleteClient", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    (0, setRoles_decorator_1.SetRoles)('admin', 'commercial'),
    (0, swagger_1.ApiOperation)({ summary: 'Activer ou désactiver un client' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, update_client_status_dto_1.UpdateClientStatusDto, Object]),
    __metadata("design:returntype", Promise)
], ClientController.prototype, "updateClientStatus", null);
__decorate([
    (0, common_1.Options)(':id/status'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], ClientController.prototype, "optionsClientStatus", null);
exports.ClientController = ClientController = __decorate([
    (0, swagger_1.ApiTags)('client'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('client'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [client_service_1.ClientService])
], ClientController);
//# sourceMappingURL=client.controller.js.map