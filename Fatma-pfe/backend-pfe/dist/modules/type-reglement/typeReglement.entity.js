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
exports.TypeReglement = void 0;
const typeorm_1 = require("typeorm");
const reglement_entity_1 = require("../reglement/reglement.entity");
let TypeReglement = class TypeReglement {
    id;
    nom;
    reglements;
};
exports.TypeReglement = TypeReglement;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], TypeReglement.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ unique: true, type: 'varchar', length: 50 }),
    __metadata("design:type", String)
], TypeReglement.prototype, "nom", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => reglement_entity_1.Reglement, (reglement) => reglement.typeReglement),
    __metadata("design:type", Array)
], TypeReglement.prototype, "reglements", void 0);
exports.TypeReglement = TypeReglement = __decorate([
    (0, typeorm_1.Entity)({ name: 'type_reglement' })
], TypeReglement);
//# sourceMappingURL=typeReglement.entity.js.map