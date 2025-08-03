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
exports.Survey = void 0;
const typeorm_1 = require("typeorm");
const survey_question_entity_1 = require("./survey-question.entity");
let Survey = class Survey {
    id;
    nom;
    dateDebut;
    dateFin;
    questions;
    createdAt;
};
exports.Survey = Survey;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Survey.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Survey.prototype, "nom", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'date' }),
    __metadata("design:type", String)
], Survey.prototype, "dateDebut", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'date' }),
    __metadata("design:type", String)
], Survey.prototype, "dateFin", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => survey_question_entity_1.SurveyQuestion, question => question.survey),
    __metadata("design:type", Array)
], Survey.prototype, "questions", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)(),
    __metadata("design:type", Date)
], Survey.prototype, "createdAt", void 0);
exports.Survey = Survey = __decorate([
    (0, typeorm_1.Entity)()
], Survey);
//# sourceMappingURL=survey.entity.js.map