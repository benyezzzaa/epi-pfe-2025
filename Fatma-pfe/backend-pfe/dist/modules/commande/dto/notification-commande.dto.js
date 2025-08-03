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
exports.NotificationCommandeDto = exports.ModificationDto = void 0;
const swagger_1 = require("@nestjs/swagger");
class ModificationDto {
    champ;
    ancienneValeur;
    nouvelleValeur;
    date;
}
exports.ModificationDto = ModificationDto;
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], ModificationDto.prototype, "champ", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], ModificationDto.prototype, "ancienneValeur", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], ModificationDto.prototype, "nouvelleValeur", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", Date)
], ModificationDto.prototype, "date", void 0);
class NotificationCommandeDto {
    commandeId;
    numeroCommande;
    date;
    modifications;
}
exports.NotificationCommandeDto = NotificationCommandeDto;
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", Number)
], NotificationCommandeDto.prototype, "commandeId", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", String)
], NotificationCommandeDto.prototype, "numeroCommande", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    __metadata("design:type", Date)
], NotificationCommandeDto.prototype, "date", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: [ModificationDto] }),
    __metadata("design:type", Array)
], NotificationCommandeDto.prototype, "modifications", void 0);
//# sourceMappingURL=notification-commande.dto.js.map