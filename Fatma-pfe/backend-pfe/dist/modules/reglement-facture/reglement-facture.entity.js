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
exports.ReglementFacture = void 0;
const typeorm_1 = require("typeorm");
const reglement_entity_1 = require("../reglement/reglement.entity");
const facture_entity_1 = require("../facture/facture.entity");
let ReglementFacture = class ReglementFacture {
    id;
    reglement;
    facture;
};
exports.ReglementFacture = ReglementFacture;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], ReglementFacture.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => reglement_entity_1.Reglement, (reglement) => reglement.reglementsFactures, { onDelete: 'CASCADE' }),
    (0, typeorm_1.JoinColumn)({ name: 'reglement_id' }),
    __metadata("design:type", reglement_entity_1.Reglement)
], ReglementFacture.prototype, "reglement", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => facture_entity_1.Facture, (facture) => facture.reglementsFactures, { onDelete: 'CASCADE' }),
    (0, typeorm_1.JoinColumn)({ name: 'facture_id' }),
    __metadata("design:type", facture_entity_1.Facture)
], ReglementFacture.prototype, "facture", void 0);
exports.ReglementFacture = ReglementFacture = __decorate([
    (0, typeorm_1.Entity)({ name: 'reglement_facture' })
], ReglementFacture);
//# sourceMappingURL=reglement-facture.entity.js.map