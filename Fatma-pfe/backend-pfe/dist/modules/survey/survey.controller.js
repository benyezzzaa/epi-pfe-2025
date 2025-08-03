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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SurveyController = void 0;
const common_1 = require("@nestjs/common");
const survey_service_1 = require("./survey.service");
const create_survey_dto_1 = require("./dto/create-survey.dto");
const create_question_dto_1 = require("./dto/create-question.dto");
const create_affectation_dto_1 = require("./dto/create-affectation.dto");
let SurveyController = class SurveyController {
    surveyService;
    constructor(surveyService) {
        this.surveyService = surveyService;
    }
    createSurvey(dto) {
        return this.surveyService.createSurvey(dto);
    }
    addQuestion(id, dto) {
        return this.surveyService.addQuestion(Number(id), dto);
    }
    addAffectation(id, dto) {
        return this.surveyService.addAffectation(Number(id), dto);
    }
    updateSurvey(id, dto) {
        return this.surveyService.updateSurvey(Number(id), dto);
    }
    getSurveys() {
        return this.surveyService.getSurveys();
    }
    getSurveyQuestions(id) {
        return this.surveyService.getSurveyQuestions(Number(id));
    }
    getSurveyAffectations(id) {
        return this.surveyService.getSurveyAffectations(Number(id));
    }
    getAffectees(commercialId) {
        return this.surveyService.getEnquetesAffecteesCommercial(commercialId);
    }
    async getSurveyPdf(id, res) {
        return this.surveyService.generateSurveyPdf(+id, res);
    }
};
exports.SurveyController = SurveyController;
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_survey_dto_1.CreateSurveyDto]),
    __metadata("design:returntype", void 0)
], SurveyController.prototype, "createSurvey", null);
__decorate([
    (0, common_1.Post)(':id/questions'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, create_question_dto_1.CreateQuestionDto]),
    __metadata("design:returntype", void 0)
], SurveyController.prototype, "addQuestion", null);
__decorate([
    (0, common_1.Post)(':id/affectation'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, create_affectation_dto_1.CreateAffectationDto]),
    __metadata("design:returntype", void 0)
], SurveyController.prototype, "addAffectation", null);
__decorate([
    (0, common_1.Put)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", void 0)
], SurveyController.prototype, "updateSurvey", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], SurveyController.prototype, "getSurveys", null);
__decorate([
    (0, common_1.Get)(':id/questions'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], SurveyController.prototype, "getSurveyQuestions", null);
__decorate([
    (0, common_1.Get)(':id/affectations'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], SurveyController.prototype, "getSurveyAffectations", null);
__decorate([
    (0, common_1.Get)('affectees'),
    __param(0, (0, common_1.Query)('commercialId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], SurveyController.prototype, "getAffectees", null);
__decorate([
    (0, common_1.Get)(':id/pdf'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Object]),
    __metadata("design:returntype", Promise)
], SurveyController.prototype, "getSurveyPdf", null);
exports.SurveyController = SurveyController = __decorate([
    (0, common_1.Controller)('enquetes'),
    __metadata("design:paramtypes", [survey_service_1.SurveyService])
], SurveyController);
//# sourceMappingURL=survey.controller.js.map