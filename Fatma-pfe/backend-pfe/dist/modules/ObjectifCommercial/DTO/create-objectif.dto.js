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
exports.CreateObjectifGlobalDto = exports.CreateObjectifDto = void 0;
const class_validator_1 = require("class-validator");
class CreateObjectifDto {
    commercialId;
    montantCible;
    prime;
    mission;
    dateDebut;
    dateFin;
}
exports.CreateObjectifDto = CreateObjectifDto;
__decorate([
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", Number)
], CreateObjectifDto.prototype, "commercialId", void 0);
__decorate([
    (0, class_validator_1.IsNumber)(),
    __metadata("design:type", Number)
], CreateObjectifDto.prototype, "montantCible", void 0);
__decorate([
    (0, class_validator_1.IsNumber)(),
    __metadata("design:type", Number)
], CreateObjectifDto.prototype, "prime", void 0);
__decorate([
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], CreateObjectifDto.prototype, "mission", void 0);
__decorate([
    (0, class_validator_1.IsDateString)(),
    __metadata("design:type", String)
], CreateObjectifDto.prototype, "dateDebut", void 0);
__decorate([
    (0, class_validator_1.IsDateString)(),
    __metadata("design:type", String)
], CreateObjectifDto.prototype, "dateFin", void 0);
class CreateObjectifGlobalDto {
    montantCible;
    prime;
    mission;
    dateDebut;
    dateFin;
}
exports.CreateObjectifGlobalDto = CreateObjectifGlobalDto;
__decorate([
    (0, class_validator_1.IsNumber)(),
    __metadata("design:type", Number)
], CreateObjectifGlobalDto.prototype, "montantCible", void 0);
__decorate([
    (0, class_validator_1.IsNumber)(),
    __metadata("design:type", Number)
], CreateObjectifGlobalDto.prototype, "prime", void 0);
__decorate([
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], CreateObjectifGlobalDto.prototype, "mission", void 0);
__decorate([
    (0, class_validator_1.IsDateString)(),
    __metadata("design:type", String)
], CreateObjectifGlobalDto.prototype, "dateDebut", void 0);
__decorate([
    (0, class_validator_1.IsDateString)(),
    __metadata("design:type", String)
], CreateObjectifGlobalDto.prototype, "dateFin", void 0);
//# sourceMappingURL=create-objectif.dto.js.map