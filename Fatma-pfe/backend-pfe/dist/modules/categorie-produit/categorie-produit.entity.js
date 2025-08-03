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
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategorieProduit = void 0;
const typeorm_1 = require("typeorm");
const swagger_1 = require("@nestjs/swagger");
const produit_entity_1 = require("../produit/produit.entity");
let CategorieProduit = class CategorieProduit {
    id;
    nom;
    produits;
    isActive;
};
exports.CategorieProduit = CategorieProduit;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    (0, swagger_1.ApiProperty)({ example: 1 }),
    __metadata("design:type", Number)
], CategorieProduit.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'varchar', nullable: false, unique: true }),
    (0, swagger_1.ApiProperty)({ example: 'Boissons' }),
    __metadata("design:type", String)
], CategorieProduit.prototype, "nom", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => produit_entity_1.Produit, (produit) => produit.categorie),
    __metadata("design:type", Array)
], CategorieProduit.prototype, "produits", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'boolean', default: true }),
    (0, swagger_1.ApiProperty)({ example: true }),
    __metadata("design:type", Boolean)
], CategorieProduit.prototype, "isActive", void 0);
exports.CategorieProduit = CategorieProduit = __decorate([
    (0, typeorm_1.Entity)({ name: 'categorie_produit' })
], CategorieProduit);
//# sourceMappingURL=categorie-produit.entity.js.map