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
exports.CreateReglementFactureDto = void 0;
const swagger_1 = require("@nestjs/swagger");
const class_validator_1 = require("class-validator");
class CreateReglementFactureDto {
    reglementId;
    factureId;
    montantPaye;
    dateReglement;
}
exports.CreateReglementFactureDto = CreateReglementFactureDto;
__decorate([
    (0, swagger_1.ApiProperty)({ example: 1, description: 'Identifiant du règlement' }),
    (0, class_validator_1.IsNumber)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Number)
], CreateReglementFactureDto.prototype, "reglementId", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 1, description: 'Identifiant de la facture associée' }),
    (0, class_validator_1.IsNumber)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Number)
], CreateReglementFactureDto.prototype, "factureId", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: 200.50, description: 'Montant payé pour cette facture' }),
    (0, class_validator_1.IsNumber)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Number)
], CreateReglementFactureDto.prototype, "montantPaye", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ example: '2025-03-18', description: 'Date du règlement' }),
    (0, class_validator_1.IsDate)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Date)
], CreateReglementFactureDto.prototype, "dateReglement", void 0);
//# sourceMappingURL=create-reglement-facture.dto.js.map