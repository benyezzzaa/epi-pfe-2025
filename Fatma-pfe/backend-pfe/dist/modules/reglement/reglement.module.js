"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReglementModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const reglement_service_1 = require("./reglement.service");
const reglement_controller_1 = require("./reglement.controller");
const reglement_entity_1 = require("./reglement.entity");
const facture_entity_1 = require("../facture/facture.entity");
const typeReglement_entity_1 = require("../type-reglement/typeReglement.entity");
let ReglementModule = class ReglementModule {
};
exports.ReglementModule = ReglementModule;
exports.ReglementModule = ReglementModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([reglement_entity_1.Reglement, facture_entity_1.Facture, typeReglement_entity_1.TypeReglement])],
        providers: [reglement_service_1.ReglementService],
        controllers: [reglement_controller_1.ReglementController],
        exports: [reglement_service_1.ReglementService],
    })
], ReglementModule);
//# sourceMappingURL=reglement.module.js.map