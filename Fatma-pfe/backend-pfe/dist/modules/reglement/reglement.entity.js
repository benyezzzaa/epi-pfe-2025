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
exports.Reglement = void 0;
const typeorm_1 = require("typeorm");
const typeReglement_entity_1 = require("../type-reglement/typeReglement.entity");
const reglement_facture_entity_1 = require("../reglement-facture/reglement-facture.entity");
let Reglement = class Reglement {
    id;
    mode_paiement;
    montant;
    montantPaye;
    datePaiement;
    statut;
    typeReglement;
    reglementsFactures;
};
exports.Reglement = Reglement;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Reglement.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Reglement.prototype, "mode_paiement", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', precision: 10, scale: 2 }),
    __metadata("design:type", Number)
], Reglement.prototype, "montant", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', precision: 10, scale: 2, nullable: true }),
    __metadata("design:type", Number)
], Reglement.prototype, "montantPaye", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'date', nullable: true }),
    __metadata("design:type", Date)
], Reglement.prototype, "datePaiement", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", String)
], Reglement.prototype, "statut", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => typeReglement_entity_1.TypeReglement, (typeReglement) => typeReglement.reglements, { nullable: true }),
    (0, typeorm_1.JoinColumn)({ name: 'type_reglement_id' }),
    __metadata("design:type", typeReglement_entity_1.TypeReglement)
], Reglement.prototype, "typeReglement", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => reglement_facture_entity_1.ReglementFacture, (reglementFacture) => reglementFacture.reglement),
    __metadata("design:type", Array)
], Reglement.prototype, "reglementsFactures", void 0);
exports.Reglement = Reglement = __decorate([
    (0, typeorm_1.Entity)({ name: 'reglement' })
], Reglement);
//# sourceMappingURL=reglement.entity.js.map