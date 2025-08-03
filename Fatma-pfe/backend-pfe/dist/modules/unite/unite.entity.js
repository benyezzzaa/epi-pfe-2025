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
exports.Unite = void 0;
const typeorm_1 = require("typeorm");
const produit_entity_1 = require("../produit/produit.entity");
let Unite = class Unite {
    id;
    nom;
    isActive;
    produits;
};
exports.Unite = Unite;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Unite.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ unique: true }),
    __metadata("design:type", String)
], Unite.prototype, "nom", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: true }),
    __metadata("design:type", Boolean)
], Unite.prototype, "isActive", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => produit_entity_1.Produit, (produit) => produit.unite),
    __metadata("design:type", Array)
], Unite.prototype, "produits", void 0);
exports.Unite = Unite = __decorate([
    (0, typeorm_1.Entity)({ name: 'unite' })
], Unite);
//# sourceMappingURL=unite.entity.js.map