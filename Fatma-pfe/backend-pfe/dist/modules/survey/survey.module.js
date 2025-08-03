"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SurveyModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const survey_entity_1 = require("./survey.entity");
const survey_question_entity_1 = require("./survey-question.entity");
const survey_affectation_entity_1 = require("./survey-affectation.entity");
const survey_service_1 = require("./survey.service");
const survey_controller_1 = require("./survey.controller");
const users_entity_1 = require("../users/users.entity");
const client_entity_1 = require("../client/client.entity");
let SurveyModule = class SurveyModule {
};
exports.SurveyModule = SurveyModule;
exports.SurveyModule = SurveyModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([survey_entity_1.Survey, survey_question_entity_1.SurveyQuestion, survey_affectation_entity_1.SurveyAffectation, users_entity_1.User, client_entity_1.Client])],
        providers: [survey_service_1.SurveyService],
        controllers: [survey_controller_1.SurveyController],
    })
], SurveyModule);
//# sourceMappingURL=survey.module.js.map