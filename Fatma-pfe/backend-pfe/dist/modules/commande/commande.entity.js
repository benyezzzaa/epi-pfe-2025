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
exports.Commande = void 0;
const typeorm_1 = require("typeorm");
const users_entity_1 = require("../users/users.entity");
const lignecommande_entity_1 = require("../lignecommande/lignecommande.entity");
const facture_entity_1 = require("../facture/facture.entity");
const client_entity_1 = require("../client/client.entity");
const promotion_entity_1 = require("../Promotion/promotion.entity");
const historique_commande_entity_1 = require("./historique-commande.entity");
let Commande = class Commande {
    id;
    numero_commande;
    promotion;
    dateCreation;
    prix_total_ttc;
    date_validation;
    prix_hors_taxe;
    tva;
    lignesCommande;
    commercial;
    client;
    factures;
    statut;
    estModifieParAdmin;
    motif_rejet;
    historique;
};
exports.Commande = Commande;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Commande.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ unique: true, nullable: false }),
    __metadata("design:type", String)
], Commande.prototype, "numero_commande", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => promotion_entity_1.Promotion, { nullable: true, eager: true }),
    __metadata("design:type", promotion_entity_1.Promotion)
], Commande.prototype, "promotion", void 0);
__decorate([
    (0, typeorm_1.Column)({
        name: 'date_creation',
        type: 'timestamp',
        default: () => 'CURRENT_TIMESTAMP',
    }),
    __metadata("design:type", Date)
], Commande.prototype, "dateCreation", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', precision: 10, scale: 2, nullable: false }),
    __metadata("design:type", Number)
], Commande.prototype, "prix_total_ttc", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'timestamp', nullable: true }),
    __metadata("design:type", Date)
], Commande.prototype, "date_validation", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'decimal', precision: 10, scale: 2, nullable: false }),
    __metadata("design:type", Number)
], Commande.prototype, "prix_hors_taxe", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'float', nullable: false }),
    __metadata("design:type", Number)
], Commande.prototype, "tva", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => lignecommande_entity_1.LigneCommande, ligne => ligne.commande, { cascade: true }),
    __metadata("design:type", Array)
], Commande.prototype, "lignesCommande", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => users_entity_1.User, (user) => user.commandes, { onDelete: 'SET NULL' }),
    __metadata("design:type", users_entity_1.User)
], Commande.prototype, "commercial", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => client_entity_1.Client, client => client.commandes, { eager: true }),
    __metadata("design:type", client_entity_1.Client)
], Commande.prototype, "client", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => facture_entity_1.Facture, (facture) => facture.commande, { cascade: true }),
    __metadata("design:type", Array)
], Commande.prototype, "factures", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: 'en_attente' }),
    __metadata("design:type", String)
], Commande.prototype, "statut", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: false }),
    __metadata("design:type", Boolean)
], Commande.prototype, "estModifieParAdmin", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", String)
], Commande.prototype, "motif_rejet", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => historique_commande_entity_1.HistoriqueCommande, h => h.commande),
    __metadata("design:type", Array)
], Commande.prototype, "historique", void 0);
exports.Commande = Commande = __decorate([
    (0, typeorm_1.Entity)({ name: 'commande' })
], Commande);
//# sourceMappingURL=commande.entity.js.map