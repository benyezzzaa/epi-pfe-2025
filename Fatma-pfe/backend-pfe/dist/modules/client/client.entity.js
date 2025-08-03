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
exports.Client = void 0;
const typeorm_1 = require("typeorm");
const users_entity_1 = require("../users/users.entity");
const commande_entity_1 = require("../commande/commande.entity");
const categorie_client_entity_1 = require("./categorie-client.entity");
let Client = class Client {
    id;
    latitude;
    longitude;
    nom;
    prenom;
    email;
    telephone;
    codeFiscale;
    adresse;
    importance;
    isActive;
    commandes;
    commercial;
    categorie;
};
exports.Client = Client;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Client.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'double precision', nullable: true }),
    __metadata("design:type", Number)
], Client.prototype, "latitude", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'double precision', nullable: true }),
    __metadata("design:type", Number)
], Client.prototype, "longitude", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], Client.prototype, "nom", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], Client.prototype, "prenom", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], Client.prototype, "email", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], Client.prototype, "telephone", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", String)
], Client.prototype, "codeFiscale", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], Client.prototype, "adresse", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: 3 }),
    __metadata("design:type", Number)
], Client.prototype, "importance", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: true }),
    __metadata("design:type", Boolean)
], Client.prototype, "isActive", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => commande_entity_1.Commande, commande => commande.client),
    __metadata("design:type", Array)
], Client.prototype, "commandes", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => users_entity_1.User, (user) => user.clients, {
        onDelete: 'CASCADE',
        eager: true,
    }),
    (0, typeorm_1.JoinColumn)({ name: 'commercial_id' }),
    __metadata("design:type", users_entity_1.User)
], Client.prototype, "commercial", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => categorie_client_entity_1.CategorieClient, (categorie) => categorie.clients, {
        nullable: true,
        eager: true,
    }),
    (0, typeorm_1.JoinColumn)({ name: 'categorie_id' }),
    __metadata("design:type", categorie_client_entity_1.CategorieClient)
], Client.prototype, "categorie", void 0);
exports.Client = Client = __decorate([
    (0, typeorm_1.Entity)({ name: 'client' })
], Client);
//# sourceMappingURL=client.entity.js.map