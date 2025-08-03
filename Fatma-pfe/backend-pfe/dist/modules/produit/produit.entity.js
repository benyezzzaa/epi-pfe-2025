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
exports.Produit = void 0;
const typeorm_1 = require("typeorm");
const categorie_produit_entity_1 = require("../categorie-produit/categorie-produit.entity");
const unite_entity_1 = require("../unite/unite.entity");
const lignecommande_entity_1 = require("../lignecommande/lignecommande.entity");
let Produit = class Produit {
    id;
    nom;
    description;
    tva;
    colisage;
    images;
    prix_unitaire;
    categorieId;
    prix_unitaire_ttc;
    categorie;
    uniteId;
    unite;
    lignesCommande;
    isActive;
};
exports.Produit = Produit;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Produit.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], Produit.prototype, "nom", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], Produit.prototype, "description", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', precision: 5, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Produit.prototype, "tva", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'int', default: 1 }),
    __metadata("design:type", Number)
], Produit.prototype, "colisage", void 0);
__decorate([
    (0, typeorm_1.Column)('text', { array: true, nullable: true }),
    __metadata("design:type", Array)
], Produit.prototype, "images", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', precision: 10, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Produit.prototype, "prix_unitaire", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Produit.prototype, "categorieId", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', precision: 10, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Produit.prototype, "prix_unitaire_ttc", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => categorie_produit_entity_1.CategorieProduit, (categorie) => categorie.produits, { eager: true, onDelete: 'CASCADE' }),
    (0, typeorm_1.JoinColumn)({ name: 'categorieId' }),
    __metadata("design:type", categorie_produit_entity_1.CategorieProduit)
], Produit.prototype, "categorie", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Produit.prototype, "uniteId", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => unite_entity_1.Unite, (unite) => unite.produits, { eager: true }),
    (0, typeorm_1.JoinColumn)({ name: 'uniteId', referencedColumnName: 'id' }),
    __metadata("design:type", unite_entity_1.Unite)
], Produit.prototype, "unite", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => lignecommande_entity_1.LigneCommande, (ligne) => ligne.produit),
    __metadata("design:type", Array)
], Produit.prototype, "lignesCommande", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'isactive', type: 'boolean', default: true }),
    __metadata("design:type", Boolean)
], Produit.prototype, "isActive", void 0);
exports.Produit = Produit = __decorate([
    (0, typeorm_1.Entity)('produit')
], Produit);
//# sourceMappingURL=produit.entity.js.map