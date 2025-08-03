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
exports.Facture = void 0;
const typeorm_1 = require("typeorm");
const commande_entity_1 = require("../commande/commande.entity");
const reglement_facture_entity_1 = require("../reglement-facture/reglement-facture.entity");
let Facture = class Facture {
    id;
    numero_facture;
    date_emission;
    montant_total;
    commande;
    reglementsFactures;
};
exports.Facture = Facture;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Facture.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Facture.prototype, "numero_facture", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'date' }),
    __metadata("design:type", Date)
], Facture.prototype, "date_emission", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', precision: 10, scale: 2 }),
    __metadata("design:type", Number)
], Facture.prototype, "montant_total", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => commande_entity_1.Commande, (commande) => commande.factures, { onDelete: 'CASCADE' }),
    (0, typeorm_1.JoinColumn)({ name: 'commande_id' }),
    __metadata("design:type", commande_entity_1.Commande)
], Facture.prototype, "commande", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => reglement_facture_entity_1.ReglementFacture, (reglementFacture) => reglementFacture.facture),
    __metadata("design:type", Array)
], Facture.prototype, "reglementsFactures", void 0);
exports.Facture = Facture = __decorate([
    (0, typeorm_1.Entity)({ name: 'facture' })
], Facture);
//# sourceMappingURL=facture.entity.js.map