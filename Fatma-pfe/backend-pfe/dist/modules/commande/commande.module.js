"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CommandeModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const commande_entity_1 = require("./commande.entity");
const lignecommande_entity_1 = require("../lignecommande/lignecommande.entity");
const produit_entity_1 = require("../produit/produit.entity");
const promotion_entity_1 = require("../Promotion/promotion.entity");
const historique_commande_entity_1 = require("./historique-commande.entity");
const client_entity_1 = require("../client/client.entity");
const client_module_1 = require("../client/client.module");
const commande_service_1 = require("./commande.service");
const commande_controller_1 = require("./commande.controller");
let CommandeModule = class CommandeModule {
};
exports.CommandeModule = CommandeModule;
exports.CommandeModule = CommandeModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forFeature([
                commande_entity_1.Commande,
                lignecommande_entity_1.LigneCommande,
                historique_commande_entity_1.HistoriqueCommande,
                produit_entity_1.Produit,
                promotion_entity_1.Promotion,
                client_entity_1.Client,
            ]),
            client_module_1.ClientModule,
        ],
        controllers: [commande_controller_1.CommandeController],
        providers: [commande_service_1.CommandeService],
        exports: [commande_service_1.CommandeService],
    })
], CommandeModule);
//# sourceMappingURL=commande.module.js.map