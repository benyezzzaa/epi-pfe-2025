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
exports.CreateFactureDto = void 0;
const swagger_1 = require("@nestjs/swagger");
const class_validator_1 = require("class-validator");
class CreateFactureDto {
    numeroFacture;
    montantTotal;
    dateEmission;
    commandeId;
    prixTotal;
    type;
}
exports.CreateFactureDto = CreateFactureDto;
__decorate([
    (0, swagger_1.ApiProperty)({ example: 'FAC-2025001', description: 'Numéro unique de la facture' }),
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], CreateFactureDto.prototype, "numeroFacture", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 500.99, description: 'Montant total de la facture' }),
    (0, class_validator_1.IsNumber)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Number)
], CreateFactureDto.prototype, "montantTotal", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: '2025-03-17', description: 'Date d’émission de la facture' }),
    (0, class_validator_1.IsDate)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Date)
], CreateFactureDto.prototype, "dateEmission", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 1, description: 'Identifiant de la commande associée' }),
    (0, class_validator_1.IsNumber)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Number)
], CreateFactureDto.prototype, "commandeId", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 250.50, description: 'Prix total de la facture' }),
    (0, class_validator_1.IsNumber)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Number)
], CreateFactureDto.prototype, "prixTotal", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 'Avoir', description: 'Type de facture' }),
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], CreateFactureDto.prototype, "type", void 0);
//# sourceMappingURL=create-facture.dto.js.map