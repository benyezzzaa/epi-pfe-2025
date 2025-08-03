"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ObjectifCommercialModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const objectif_commercial_entity_1 = require("./objectif-commercial.entity");
const objectif_commercial_service_1 = require("./objectif-commercial.service");
const objectif_commercial_controller_1 = require("./objectif-commercial.controller");
const users_entity_1 = require("../users/users.entity");
const commande_entity_1 = require("../commande/commande.entity");
let ObjectifCommercialModule = class ObjectifCommercialModule {
};
exports.ObjectifCommercialModule = ObjectifCommercialModule;
exports.ObjectifCommercialModule = ObjectifCommercialModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([objectif_commercial_entity_1.ObjectifCommercial, users_entity_1.User, commande_entity_1.Commande])],
        providers: [objectif_commercial_service_1.ObjectifCommercialService],
        controllers: [objectif_commercial_controller_1.ObjectifCommercialController],
    })
], ObjectifCommercialModule);
//# sourceMappingURL=objectif-commercial.module.js.map