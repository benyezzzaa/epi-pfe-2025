"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AiPredictionModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const ai_prediction_controller_1 = require("./ai-prediction.controller");
const ai_prediction_service_1 = require("./ai-prediction.service");
const commande_entity_1 = require("../commande/commande.entity");
const lignecommande_entity_1 = require("../lignecommande/lignecommande.entity");
const produit_entity_1 = require("../produit/produit.entity");
const categorie_produit_entity_1 = require("../categorie-produit/categorie-produit.entity");
const client_entity_1 = require("../client/client.entity");
let AiPredictionModule = class AiPredictionModule {
};
exports.AiPredictionModule = AiPredictionModule;
exports.AiPredictionModule = AiPredictionModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forFeature([
                commande_entity_1.Commande,
                lignecommande_entity_1.LigneCommande,
                produit_entity_1.Produit,
                categorie_produit_entity_1.CategorieProduit,
                client_entity_1.Client,
            ]),
        ],
        controllers: [ai_prediction_controller_1.AiPredictionController],
        providers: [ai_prediction_service_1.AiPredictionService],
        exports: [ai_prediction_service_1.AiPredictionService],
    })
], AiPredictionModule);
//# sourceMappingURL=ai-prediction.module.js.map