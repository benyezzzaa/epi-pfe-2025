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
exports.Circuit = void 0;
const typeorm_1 = require("typeorm");
const users_entity_1 = require("../users/users.entity");
const client_entity_1 = require("../client/client.entity");
let Circuit = class Circuit {
    id;
    date;
    commercial;
    clients;
};
exports.Circuit = Circuit;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Circuit.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'date' }),
    __metadata("design:type", Date)
], Circuit.prototype, "date", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => users_entity_1.User, { eager: true }),
    __metadata("design:type", users_entity_1.User)
], Circuit.prototype, "commercial", void 0);
__decorate([
    (0, typeorm_1.ManyToMany)(() => client_entity_1.Client, { eager: true }),
    (0, typeorm_1.JoinTable)(),
    __metadata("design:type", Array)
], Circuit.prototype, "clients", void 0);
exports.Circuit = Circuit = __decorate([
    (0, typeorm_1.Entity)()
], Circuit);
//# sourceMappingURL=circuit.entity.js.map