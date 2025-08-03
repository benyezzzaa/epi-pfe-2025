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
exports.HistoriqueCommande = void 0;
const typeorm_1 = require("typeorm");
const commande_entity_1 = require("./commande.entity");
const users_entity_1 = require("../users/users.entity");
let HistoriqueCommande = class HistoriqueCommande {
    id;
    commande;
    champModifie;
    ancienneValeur;
    nouvelleValeur;
    modifiePar;
    dateModification;
    vuParCommercial;
};
exports.HistoriqueCommande = HistoriqueCommande;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], HistoriqueCommande.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => commande_entity_1.Commande, commande => commande.id, { onDelete: 'CASCADE' }),
    __metadata("design:type", commande_entity_1.Commande)
], HistoriqueCommande.prototype, "commande", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], HistoriqueCommande.prototype, "champModifie", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], HistoriqueCommande.prototype, "ancienneValeur", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], HistoriqueCommande.prototype, "nouvelleValeur", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => users_entity_1.User),
    __metadata("design:type", users_entity_1.User)
], HistoriqueCommande.prototype, "modifiePar", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)(),
    __metadata("design:type", Date)
], HistoriqueCommande.prototype, "dateModification", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: false }),
    __metadata("design:type", Boolean)
], HistoriqueCommande.prototype, "vuParCommercial", void 0);
exports.HistoriqueCommande = HistoriqueCommande = __decorate([
    (0, typeorm_1.Entity)()
], HistoriqueCommande);
//# sourceMappingURL=historique-commande.entity.js.map