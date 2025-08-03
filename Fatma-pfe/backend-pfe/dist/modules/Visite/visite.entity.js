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
exports.Visite = void 0;
const typeorm_1 = require("typeorm");
const users_entity_1 = require("../users/users.entity");
const client_entity_1 = require("../client/client.entity");
const raison_visite_entity_1 = require("../raison-visite/raison-visite.entity");
let Visite = class Visite {
    id;
    date;
    client;
    user;
    raison;
};
exports.Visite = Visite;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Visite.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' }),
    __metadata("design:type", Date)
], Visite.prototype, "date", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => client_entity_1.Client, { eager: true }),
    (0, typeorm_1.JoinColumn)({ name: 'client_id' }),
    __metadata("design:type", client_entity_1.Client)
], Visite.prototype, "client", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => users_entity_1.User, { eager: true }),
    __metadata("design:type", users_entity_1.User)
], Visite.prototype, "user", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => raison_visite_entity_1.RaisonVisite, { eager: true }),
    (0, typeorm_1.JoinColumn)({ name: 'raison_id' }),
    __metadata("design:type", raison_visite_entity_1.RaisonVisite)
], Visite.prototype, "raison", void 0);
exports.Visite = Visite = __decorate([
    (0, typeorm_1.Entity)()
], Visite);
//# sourceMappingURL=visite.entity.js.map