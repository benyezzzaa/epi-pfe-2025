"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const users_module_1 = require("./modules/users/users.module");
const auth_module_1 = require("./modules/auth/auth.module");
const produit_module_1 = require("./modules/produit/produit.module");
const users_entity_1 = require("./modules/users/users.entity");
const categorie_produit_module_1 = require("./modules/categorie-produit/categorie-produit.module");
const unite_module_1 = require("./modules/unite/unite.module");
const client_entity_1 = require("./modules/client/client.entity");
const client_module_1 = require("./modules/client/client.module");
const unite_entity_1 = require("./modules/unite/unite.entity");
const visite_module_1 = require("./modules/Visite/visite.module");
const lignecommande_entity_1 = require("./modules/lignecommande/lignecommande.entity");
const commande_module_1 = require("./modules/commande/commande.module");
const lignecommande_module_1 = require("./modules/lignecommande/lignecommande.module");
const commande_entity_1 = require("./modules/commande/commande.entity");
const facture_entity_1 = require("./modules/facture/facture.entity");
const reglement_entity_1 = require("./modules/reglement/reglement.entity");
const reglement_module_1 = require("./modules/reglement/reglement.module");
const type_reglement_module_1 = require("./modules/type-reglement/type-reglement.module");
const reglement_facture_module_1 = require("./modules/reglement-facture/reglement-facture.module");
const typeReglement_entity_1 = require("./modules/type-reglement/typeReglement.entity");
const facture_module_1 = require("./modules/facture/facture.module");
const reglement_facture_entity_1 = require("./modules/reglement-facture/reglement-facture.entity");
const dashboard_module_1 = require("./modules/dashboard/dashboard.module");
const raison_visite_module_1 = require("./modules/raison-visite/raison-visite.module");
const objectif_commercial_module_1 = require("./modules/ObjectifCommercial/objectif-commercial.module");
const promotion_module_1 = require("./modules/Promotion/promotion.module");
const circuit_module_1 = require("./modules/circuit/circuit.module");
const reclamation_module_1 = require("./modules/reclamation/reclamation.module");
const satisfaction_module_1 = require("./modules/SatisfactionSurveyV2/satisfaction.module");
const survey_module_1 = require("./modules/survey/survey.module");
const path_1 = require("path");
const mailer_1 = require("@nestjs-modules/mailer");
const handlebars_adapter_1 = require("@nestjs-modules/mailer/dist/adapters/handlebars.adapter");
const categorie_client_entity_1 = require("./modules/client/categorie-client.entity");
const categorie_client_module_1 = require("./modules/client/categorie-client.module");
const ai_prediction_module_1 = require("./modules/ai-prediction/ai-prediction.module");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forRoot({
                type: 'postgres',
                host: process.env.DATABASE_HOST || 'localhost',
                port: process.env.DATABASE_PORT ? parseInt(process.env.DATABASE_PORT, 10) : 5432,
                username: process.env.DATABASE_USER || 'postgres',
                password: process.env.DATABASE_PASSWORD || 'NouveauMotDePasse',
                database: process.env.DATABASE_NAME || 'postgres',
                autoLoadEntities: true,
                synchronize: true,
                entities: [commande_entity_1.Commande, facture_entity_1.Facture, reglement_entity_1.Reglement, typeReglement_entity_1.TypeReglement, lignecommande_entity_1.LigneCommande, users_entity_1.User, client_entity_1.Client,
                    unite_entity_1.Unite, reglement_facture_entity_1.ReglementFacture, raison_visite_module_1.RaisonVisiteModule, objectif_commercial_module_1.ObjectifCommercialModule, promotion_module_1.PromotionModule, circuit_module_1.CircuitModule, categorie_client_entity_1.CategorieClient],
            }),
            mailer_1.MailerModule.forRoot({
                transport: {
                    service: 'gmail',
                    auth: {
                        user: process.env.EMAIL_USER || 'fatmabenyezza90@gmail.com',
                        pass: process.env.EMAIL_PASS || 'frmo kdfw bqpr iari',
                    },
                },
                defaults: {
                    from: '"Sales Force App" <no-reply@salesforce.com>',
                },
                template: {
                    dir: (0, path_1.join)(__dirname, 'templates'),
                    adapter: new handlebars_adapter_1.HandlebarsAdapter(),
                    options: {
                        strict: true,
                    },
                },
            }),
            users_module_1.UsersModule,
            auth_module_1.AuthModule,
            produit_module_1.ProduitModule,
            categorie_produit_module_1.CategorieProduitModule,
            unite_module_1.UniteModule,
            client_module_1.ClientModule,
            unite_module_1.UniteModule,
            visite_module_1.VisiteModule,
            lignecommande_module_1.LigneCommandeModule,
            commande_module_1.CommandeModule,
            reglement_module_1.ReglementModule,
            type_reglement_module_1.TypeReglementModule,
            reglement_facture_module_1.ReglementFactureModule,
            facture_module_1.FactureModule,
            dashboard_module_1.DashboardModule,
            raison_visite_module_1.RaisonVisiteModule,
            objectif_commercial_module_1.ObjectifCommercialModule,
            promotion_module_1.PromotionModule,
            circuit_module_1.CircuitModule,
            reclamation_module_1.ReclamationModule,
            satisfaction_module_1.SatisfactionModule,
            survey_module_1.SurveyModule,
            categorie_client_module_1.CategorieClientModule,
            ai_prediction_module_1.AiPredictionModule,
        ],
        providers: [],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map