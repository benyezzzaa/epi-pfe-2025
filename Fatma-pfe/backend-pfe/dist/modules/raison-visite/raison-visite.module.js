"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RaisonVisiteModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const raison_visite_entity_1 = require("./raison-visite.entity");
const raison_visite_service_1 = require("./raison-visite.service");
const raison_visite_controller_1 = require("./raison-visite.controller");
let RaisonVisiteModule = class RaisonVisiteModule {
};
exports.RaisonVisiteModule = RaisonVisiteModule;
exports.RaisonVisiteModule = RaisonVisiteModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([raison_visite_entity_1.RaisonVisite])],
        controllers: [raison_visite_controller_1.RaisonVisiteController],
        providers: [raison_visite_service_1.RaisonVisiteService],
    })
], RaisonVisiteModule);
//# sourceMappingURL=raison-visite.module.js.map