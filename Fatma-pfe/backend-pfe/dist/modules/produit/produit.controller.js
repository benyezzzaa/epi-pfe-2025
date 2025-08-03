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
exports.ProduitController = void 0;
const common_1 = require("@nestjs/common");
const produit_service_1 = require("./produit.service");
const create_produit_dto_1 = require("./dto/create-produit.dto");
const swagger_1 = require("@nestjs/swagger");
const platform_express_1 = require("@nestjs/platform-express");
const multer_1 = require("multer");
const path_1 = require("path");
const setRoles_decorator_1 = require("../auth/setRoles.decorator");
const update_produit_dto_1 = require("./dto/update-produit.dto");
let ProduitController = class ProduitController {
    produitService;
    constructor(produitService) {
        this.produitService = produitService;
    }
    async createProduit(dto, files) {
        const imagePaths = files.map(file => `/uploads/${file.filename}`);
        return this.produitService.createProduit(dto, imagePaths);
    }
    async getProduits() {
        return this.produitService.getAllProduits();
    }
    async createTestProducts() {
        return this.produitService.createTestProducts();
    }
    async updateProduit(id, dto, files) {
        const imagePaths = files.map(file => `/uploads/${file.filename}`);
        return this.produitService.updateProduit(Number(id), dto, imagePaths);
    }
    async updateStatutProduit(id, body) {
        return this.produitService.updateStatut(Number(id), body.isActive);
    }
};
exports.ProduitController = ProduitController;
__decorate([
    (0, common_1.Post)(),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FilesInterceptor)('images', 5, {
        storage: (0, multer_1.diskStorage)({
            destination: './uploads',
            filename: (req, file, callback) => {
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
                callback(null, file.fieldname + '-' + uniqueSuffix + (0, path_1.extname)(file.originalname));
            },
        }),
    })),
    (0, swagger_1.ApiOperation)({ summary: 'Ajouter un produit' }),
    (0, swagger_1.ApiConsumes)('multipart/form-data'),
    (0, swagger_1.ApiBody)({
        schema: {
            type: 'object',
            properties: {
                nom: { type: 'string' },
                description: { type: 'string' },
                prix: { type: 'number' },
                prix_unitaire: { type: 'number' },
                categorieId: { type: 'string' },
                uniteId: { type: 'number' },
                images: {
                    type: 'array',
                    items: { type: 'string', format: 'binary' },
                },
            },
        },
    }),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.UploadedFiles)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_produit_dto_1.CreateProduitDto, Array]),
    __metadata("design:returntype", Promise)
], ProduitController.prototype, "createProduit", null);
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Lister les produits' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], ProduitController.prototype, "getProduits", null);
__decorate([
    (0, common_1.Post)('test-data'),
    (0, swagger_1.ApiOperation)({ summary: 'Créer des produits de test' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], ProduitController.prototype, "createTestProducts", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FilesInterceptor)('images', 5, {
        storage: (0, multer_1.diskStorage)({
            destination: './uploads',
            filename: (req, file, callback) => {
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
                callback(null, file.fieldname + '-' + uniqueSuffix + (0, path_1.extname)(file.originalname));
            },
        }),
    })),
    (0, swagger_1.ApiOperation)({ summary: 'Modifier un produit' }),
    (0, swagger_1.ApiConsumes)('multipart/form-data'),
    (0, swagger_1.ApiBody)({}),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.UploadedFiles)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, update_produit_dto_1.UpdateProduitDto, Array]),
    __metadata("design:returntype", Promise)
], ProduitController.prototype, "updateProduit", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    (0, setRoles_decorator_1.SetRoles)('admin'),
    (0, swagger_1.ApiOperation)({ summary: 'Activer/Désactiver un produit' }),
    (0, swagger_1.ApiConsumes)('application/json'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], ProduitController.prototype, "updateStatutProduit", null);
exports.ProduitController = ProduitController = __decorate([
    (0, swagger_1.ApiTags)('Produits'),
    (0, common_1.Controller)('produits'),
    __metadata("design:paramtypes", [produit_service_1.ProduitService])
], ProduitController);
//# sourceMappingURL=produit.controller.js.map