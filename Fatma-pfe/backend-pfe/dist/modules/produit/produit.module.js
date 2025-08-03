"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProduitModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const produit_entity_1 = require("./produit.entity");
const produit_service_1 = require("./produit.service");
const produit_controller_1 = require("./produit.controller");
const categorie_produit_entity_1 = require("../categorie-produit/categorie-produit.entity");
const unite_entity_1 = require("../unite/unite.entity");
const unite_service_1 = require("../unite/unite.service");
let ProduitModule = class ProduitModule {
};
exports.ProduitModule = ProduitModule;
exports.ProduitModule = ProduitModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([produit_entity_1.Produit, categorie_produit_entity_1.CategorieProduit, unite_entity_1.Unite])],
        providers: [produit_service_1.ProduitService, unite_service_1.UniteService],
        controllers: [produit_controller_1.ProduitController],
        exports: [produit_service_1.ProduitService],
    })
], ProduitModule);
//# sourceMappingURL=produit.module.js.map