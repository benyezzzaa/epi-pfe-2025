"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SurveyAffectation = void 0;
const typeorm_1 = require("typeorm");
const survey_entity_1 = require("./survey.entity");
const users_entity_1 = require("../users/users.entity");
const client_entity_1 = require("../client/client.entity");
let SurveyAffectation = class SurveyAffectation {
    id;
    survey;
    commercial;
    client;
};
exports.SurveyAffectation = SurveyAffectation;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], SurveyAffectation.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => survey_entity_1.Survey, { onDelete: 'CASCADE' }),
    __metadata("design:type", survey_entity_1.Survey)
], SurveyAffectation.prototype, "survey", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => users_entity_1.User, { onDelete: 'CASCADE' }),
    __metadata("design:type", users_entity_1.User)
], SurveyAffectation.prototype, "commercial", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => client_entity_1.Client, { onDelete: 'CASCADE' }),
    __metadata("design:type", client_entity_1.Client)
], SurveyAffectation.prototype, "client", void 0);
exports.SurveyAffectation = SurveyAffectation = __decorate([
    (0, typeorm_1.Entity)()
], SurveyAffectation);
//# sourceMappingURL=survey-affectation.entity.js.map