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
exports.SatisfactionService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const satisfaction_survey_entity_1 = require("./satisfaction-survey.entity");
const satisfaction_response_entity_1 = require("./satisfaction-response.entity");
const QRCode = require("qrcode");
const PDFDocument = require("pdfkit");
let SatisfactionService = class SatisfactionService {
    surveyRepo;
    responseRepo;
    constructor(surveyRepo, responseRepo) {
        this.surveyRepo = surveyRepo;
        this.responseRepo = responseRepo;
    }
    async createSurvey(dto) {
        const survey = this.surveyRepo.create(dto);
        return this.surveyRepo.save(survey);
    }
    async getSurveys() {
        return this.surveyRepo.find({ order: { createdAt: 'DESC' } });
    }
    async getSurveyById(id) {
        const survey = await this.surveyRepo.findOne({ where: { id } });
        if (!survey)
            throw new common_1.NotFoundException('Enquête non trouvée');
        return survey;
    }
    async generateSurveyQRCode(surveyId, baseUrl) {
        const url = `${baseUrl}/satisfaction/survey/${surveyId}/pdf`;
        return QRCode.toDataURL(url);
    }
    async generateSurveyPdf(surveyId, res) {
        const survey = await this.surveyRepo.findOne({ where: { id: surveyId } });
        if (!survey)
            throw new common_1.NotFoundException('Enquête non trouvée');
        const doc = new PDFDocument();
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename=enquete_${surveyId}.pdf`);
        doc.pipe(res);
        doc.fontSize(20).text(survey.titre, { align: 'center' });
        doc.moveDown();
        doc.fontSize(14).text(survey.description || '', { align: 'left' });
        doc.moveDown();
        doc.text('Nom du client: __________________________');
        doc.moveDown();
        doc.text('Réponse:');
        doc.moveDown();
        doc.text('__________________________________________');
        doc.text('__________________________________________');
        doc.text('__________________________________________');
        doc.moveDown();
        doc.text('Merci de renvoyer ce PDF rempli à : admin@tondomaine.com', { align: 'left' });
        doc.end();
    }
    async createResponse(dto) {
        const survey = await this.surveyRepo.findOne({ where: { id: dto.surveyId } });
        if (!survey)
            throw new common_1.NotFoundException('Enquête non trouvée');
        const response = this.responseRepo.create({
            survey,
            nomClient: dto.nomClient,
            reponse: dto.reponse,
        });
        return this.responseRepo.save(response);
    }
};
exports.SatisfactionService = SatisfactionService;
exports.SatisfactionService = SatisfactionService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(satisfaction_survey_entity_1.SatisfactionSurvey)),
    __param(1, (0, typeorm_1.InjectRepository)(satisfaction_response_entity_1.SatisfactionResponse)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], SatisfactionService);
//# sourceMappingURL=satisfaction.service.js.map