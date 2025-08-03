"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategorieClientModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const categorie_client_entity_1 = require("./categorie-client.entity");
const categorie_client_service_1 = require("./categorie-client.service");
const categorie_client_controller_1 = require("./categorie-client.controller");
let CategorieClientModule = class CategorieClientModule {
};
exports.CategorieClientModule = CategorieClientModule;
exports.CategorieClientModule = CategorieClientModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([categorie_client_entity_1.CategorieClient])],
        providers: [categorie_client_service_1.CategorieClientService],
        controllers: [categorie_client_controller_1.CategorieClientController],
        exports: [categorie_client_service_1.CategorieClientService, typeorm_1.TypeOrmModule],
    })
], CategorieClientModule);
//# sourceMappingURL=categorie-client.module.js.map