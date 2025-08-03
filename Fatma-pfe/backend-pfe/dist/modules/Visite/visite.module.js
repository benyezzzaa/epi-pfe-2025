"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.VisiteModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const visite_entity_1 = require("./visite.entity");
const visite_service_1 = require("./visite.service");
const visite_controller_1 = require("./visite.controller");
const client_entity_1 = require("../client/client.entity");
const raison_visite_entity_1 = require("../raison-visite/raison-visite.entity");
let VisiteModule = class VisiteModule {
};
exports.VisiteModule = VisiteModule;
exports.VisiteModule = VisiteModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([visite_entity_1.Visite, client_entity_1.Client, raison_visite_entity_1.RaisonVisite])],
        controllers: [visite_controller_1.VisiteController],
        providers: [visite_service_1.VisiteService],
        exports: [visite_service_1.VisiteService],
    })
], VisiteModule);
//# sourceMappingURL=visite.module.js.map