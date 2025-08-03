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
exports.updateLigneCommandeDto = void 0;
const swagger_1 = require("@nestjs/swagger");
const class_validator_1 = require("class-validator");
class updateLigneCommandeDto {
    id;
    numero_commande;
    nom_produit;
    quantite;
    prix_unitaire;
}
exports.updateLigneCommandeDto = updateLigneCommandeDto;
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", Number)
], updateLigneCommandeDto.prototype, "id", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], updateLigneCommandeDto.prototype, "numero_commande", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], updateLigneCommandeDto.prototype, "nom_produit", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ required: true, example: 5 }),
    (0, class_validator_1.IsNumber)(),
    (0, class_validator_1.IsPositive)(),
    (0, class_validator_1.IsInt)(),
    __metadata("design:type", Number)
], updateLigneCommandeDto.prototype, "quantite", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ required: true, example: 10.99 }),
    (0, class_validator_1.IsNumber)(),
    (0, class_validator_1.IsPositive)(),
    __metadata("design:type", Number)
], updateLigneCommandeDto.prototype, "prix_unitaire", void 0);
//# sourceMappingURL=update-ligneCommande.dto.js.map