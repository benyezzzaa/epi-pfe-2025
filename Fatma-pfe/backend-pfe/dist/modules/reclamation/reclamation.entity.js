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
exports.Reclamation = void 0;
const typeorm_1 = require("typeorm");
const users_entity_1 = require("../users/users.entity");
const client_entity_1 = require("../client/client.entity");
let Reclamation = class Reclamation {
    id;
    sujet;
    description;
    date;
    status;
    user;
    client;
};
exports.Reclamation = Reclamation;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Reclamation.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Reclamation.prototype, "sujet", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'text' }),
    __metadata("design:type", String)
], Reclamation.prototype, "description", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)(),
    __metadata("design:type", Date)
], Reclamation.prototype, "date", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: 'ouverte' }),
    __metadata("design:type", String)
], Reclamation.prototype, "status", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => users_entity_1.User, { eager: true }),
    __metadata("design:type", users_entity_1.User)
], Reclamation.prototype, "user", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => client_entity_1.Client, { eager: true }),
    __metadata("design:type", client_entity_1.Client)
], Reclamation.prototype, "client", void 0);
exports.Reclamation = Reclamation = __decorate([
    (0, typeorm_1.Entity)()
], Reclamation);
//# sourceMappingURL=reclamation.entity.js.map