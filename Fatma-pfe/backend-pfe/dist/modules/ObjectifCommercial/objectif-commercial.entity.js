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
exports.ObjectifCommercial = void 0;
const typeorm_1 = require("typeorm");
const users_entity_1 = require("../users/users.entity");
let ObjectifCommercial = class ObjectifCommercial {
    id;
    commercial;
    dateDebut;
    dateFin;
    totalVentes;
    montantCible;
    categorieProduit;
    prime;
    atteint;
    mission;
    ventes;
    bonus;
    pourcentageCible;
    isActive;
};
exports.ObjectifCommercial = ObjectifCommercial;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], ObjectifCommercial.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => users_entity_1.User, { nullable: true, onDelete: 'SET NULL' }),
    (0, typeorm_1.JoinColumn)({ name: 'commercialId' }),
    __metadata("design:type", Object)
], ObjectifCommercial.prototype, "commercial", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'date' }),
    __metadata("design:type", Date)
], ObjectifCommercial.prototype, "dateDebut", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'date' }),
    __metadata("design:type", Date)
], ObjectifCommercial.prototype, "dateFin", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: 0, type: 'float' }),
    __metadata("design:type", Number)
], ObjectifCommercial.prototype, "totalVentes", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', nullable: false, default: 0 }),
    __metadata("design:type", Number)
], ObjectifCommercial.prototype, "montantCible", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", String)
], ObjectifCommercial.prototype, "categorieProduit", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'float', default: 0 }),
    __metadata("design:type", Number)
], ObjectifCommercial.prototype, "prime", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: false }),
    __metadata("design:type", Boolean)
], ObjectifCommercial.prototype, "atteint", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", String)
], ObjectifCommercial.prototype, "mission", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', default: 0 }),
    __metadata("design:type", Number)
], ObjectifCommercial.prototype, "ventes", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'float', nullable: true }),
    __metadata("design:type", Number)
], ObjectifCommercial.prototype, "bonus", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'float', nullable: true }),
    __metadata("design:type", Number)
], ObjectifCommercial.prototype, "pourcentageCible", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: true }),
    __metadata("design:type", Boolean)
], ObjectifCommercial.prototype, "isActive", void 0);
exports.ObjectifCommercial = ObjectifCommercial = __decorate([
    (0, typeorm_1.Entity)('objectif_commercial')
], ObjectifCommercial);
//# sourceMappingURL=objectif-commercial.entity.js.map