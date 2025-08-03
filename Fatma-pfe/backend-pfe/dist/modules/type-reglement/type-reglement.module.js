"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TypeReglementModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeReglement_entity_1 = require("./typeReglement.entity");
const type_reglement_service_1 = require("./type-reglement.service");
const type_reglement_controller_1 = require("./type-reglement.controller");
let TypeReglementModule = class TypeReglementModule {
};
exports.TypeReglementModule = TypeReglementModule;
exports.TypeReglementModule = TypeReglementModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([typeReglement_entity_1.TypeReglement])],
        controllers: [type_reglement_controller_1.TypeReglementController],
        providers: [type_reglement_service_1.TypeReglementService],
        exports: [type_reglement_service_1.TypeReglementService],
    })
], TypeReglementModule);
//# sourceMappingURL=type-reglement.module.js.map