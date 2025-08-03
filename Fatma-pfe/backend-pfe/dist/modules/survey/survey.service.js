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
exports.SurveyService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const survey_entity_1 = require("./survey.entity");
const survey_question_entity_1 = require("./survey-question.entity");
const survey_affectation_entity_1 = require("./survey-affectation.entity");
const users_entity_1 = require("../users/users.entity");
const client_entity_1 = require("../client/client.entity");
const PDFDocument = require("pdfkit");
let SurveyService = class SurveyService {
    surveyRepo;
    questionRepo;
    affectationRepo;
    userRepo;
    clientRepo;
    constructor(surveyRepo, questionRepo, affectationRepo, userRepo, clientRepo) {
        this.surveyRepo = surveyRepo;
        this.questionRepo = questionRepo;
        this.affectationRepo = affectationRepo;
        this.userRepo = userRepo;
        this.clientRepo = clientRepo;
    }
    async createSurvey(dto) {
        const survey = this.surveyRepo.create(dto);
        return this.surveyRepo.save(survey);
    }
    async updateSurvey(id, dto) {
        const survey = await this.surveyRepo.findOne({ where: { id } });
        if (!survey)
            throw new Error('Enquête non trouvée');
        if (dto.nom !== undefined)
            survey.nom = dto.nom;
        if (dto.dateDebut !== undefined)
            survey.dateDebut = dto.dateDebut;
        if (dto.dateFin !== undefined)
            survey.dateFin = dto.dateFin;
        return this.surveyRepo.save(survey);
    }
    async addQuestion(surveyId, dto) {
        const survey = await this.surveyRepo.findOne({ where: { id: surveyId } });
        if (!survey)
            throw new common_1.NotFoundException('Enquête non trouvée');
        const question = this.questionRepo.create({ ...dto, survey });
        return this.questionRepo.save(question);
    }
    async addAffectation(surveyId, dto) {
        const survey = await this.surveyRepo.findOne({ where: { id: surveyId } });
        if (!survey)
            throw new common_1.NotFoundException('Enquête non trouvée');
        const commercial = await this.userRepo.findOne({ where: { id: dto.commercialId } });
        if (!commercial)
            throw new common_1.NotFoundException('Commercial non trouvé');
        const clients = await this.clientRepo.findByIds(dto.clientIds);
        const affectations = clients.map(client => this.affectationRepo.create({ survey, commercial, client }));
        return this.affectationRepo.save(affectations);
    }
    async getSurveys() {
        return this.surveyRepo.find();
    }
    async getSurveyQuestions(surveyId) {
        return this.questionRepo.find({ where: { survey: { id: surveyId } } });
    }
    async getSurveyAffectations(surveyId) {
        return this.affectationRepo.find({ where: { survey: { id: surveyId } }, relations: ['commercial', 'client'] });
    }
    async getEnquetesAffecteesCommercial(commercialId) {
        const affectations = await this.affectationRepo.find({
            where: { commercial: { id: commercialId } },
            relations: ['survey', 'survey.questions', 'client'],
        });
        const surveyMap = new Map();
        for (const aff of affectations) {
            const surveyId = aff.survey.id;
            if (!surveyMap.has(surveyId)) {
                surveyMap.set(surveyId, {
                    ...aff.survey,
                    clients: [],
                });
            }
            surveyMap.get(surveyId).clients.push(aff.client);
        }
        return Array.from(surveyMap.values());
    }
    async generateSurveyPdf(surveyId, res) {
        const survey = await this.surveyRepo.findOne({
            where: { id: surveyId },
            relations: ['questions'],
        });
        if (!survey)
            throw new common_1.NotFoundException('Enquête non trouvée');
        const doc = new PDFDocument({ margin: 40, size: 'A4' });
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename=enquete_${surveyId}_${survey.nom.replace(/\s+/g, '_')}.pdf`);
        doc.pipe(res);
        doc.rect(40, 40, 515, 80).stroke('#3F51B5');
        doc.fillColor('#3F51B5').fill();
        doc.rect(40, 40, 515, 80).stroke('#3F51B5');
        doc.fillColor('white')
            .fontSize(24)
            .font('Helvetica-Bold')
            .text('DIGITAL PROCESS', 50, 55, { align: 'center', width: 495 });
        doc.fontSize(14)
            .font('Helvetica')
            .text('Force de Vente - Enquête de Satisfaction', 50, 85, { align: 'center', width: 495 });
        doc.fontSize(10)
            .text('📧 contact@digitalprocess.com | 📞 +216 XX XXX XXX | 🌐 www.digitalprocess.com', 50, 105, { align: 'center', width: 495 });
        doc.moveDown(3);
        doc.fillColor('#2E3440')
            .fontSize(20)
            .font('Helvetica-Bold')
            .text(survey.nom, { align: 'center', underline: true });
        doc.moveDown(0.5);
        doc.fillColor('#5E81AC')
            .fontSize(14)
            .font('Helvetica-Bold')
            .text('📅 Période de l\'enquête :', 50, doc.y);
        doc.fillColor('#4C566A')
            .fontSize(12)
            .font('Helvetica')
            .text(`Du ${new Date(survey.dateDebut).toLocaleDateString('fr-FR')} au ${new Date(survey.dateFin).toLocaleDateString('fr-FR')}`, 50, doc.y + 5);
        doc.moveDown(1);
        doc.fillColor('#5E81AC')
            .fontSize(14)
            .font('Helvetica-Bold')
            .text('📋 Informations générales :', 50, doc.y);
        doc.fillColor('#4C566A')
            .fontSize(11)
            .font('Helvetica')
            .text(`• Enquête créée le : ${new Date(survey.createdAt).toLocaleDateString('fr-FR')}`, 60, doc.y + 5);
        doc.text(`• Nombre de questions : ${survey.questions?.length || 0}`, 60, doc.y + 3);
        doc.text(`• Statut : En cours`, 60, doc.y + 3);
        doc.moveDown(1);
        doc.moveTo(50, doc.y)
            .lineTo(545, doc.y)
            .stroke('#3F51B5');
        doc.moveDown(1);
        doc.fillColor('#2E3440')
            .fontSize(18)
            .font('Helvetica-Bold')
            .text('📝 Questions de l\'enquête', { underline: true });
        doc.moveDown(0.5);
        if (survey.questions && survey.questions.length > 0) {
            survey.questions.forEach((q, i) => {
                let typeLabel = '';
                let color = '#5E81AC';
                let icon = '❓';
                switch (q.type) {
                    case 'text':
                        typeLabel = 'Réponse libre';
                        color = '#88C0D0';
                        icon = '✏️';
                        break;
                    case 'image':
                        typeLabel = 'Réponse avec image';
                        color = '#A3BE8C';
                        icon = '🖼️';
                        break;
                    case 'select':
                        typeLabel = 'Oui / Non';
                        color = '#EBCB8B';
                        icon = '✅';
                        break;
                    default:
                        typeLabel = q.type;
                        icon = '❓';
                }
                doc.fillColor('#2E3440')
                    .fontSize(14)
                    .font('Helvetica-Bold')
                    .text(`Question ${i + 1}`, 50, doc.y);
                doc.fillColor('#4C566A')
                    .fontSize(12)
                    .font('Helvetica')
                    .text(q.text, 50, doc.y + 5, { width: 495, align: 'justify' });
                doc.moveDown(0.3);
                doc.fillColor(color)
                    .fontSize(10)
                    .font('Helvetica-Bold')
                    .text(`${icon} Type de réponse : ${typeLabel}`, 60, doc.y);
                doc.moveDown(0.5);
                doc.rect(60, doc.y, 435, 30).stroke('#D8DEE9');
                doc.fillColor('#ECEFF4')
                    .fontSize(10)
                    .font('Helvetica')
                    .text('Espace pour votre réponse...', 65, doc.y + 10);
                if (q.type === 'text') {
                    doc.fillColor('#D8DEE9')
                        .moveTo(65, doc.y + 15)
                        .lineTo(485, doc.y + 15)
                        .stroke();
                    doc.fillColor('#D8DEE9')
                        .moveTo(65, doc.y + 20)
                        .lineTo(485, doc.y + 20)
                        .stroke();
                }
                else if (q.type === 'select') {
                    doc.fillColor('#4C566A')
                        .fontSize(10)
                        .font('Helvetica')
                        .text('☐ Oui    ☐ Non', 65, doc.y + 10);
                }
                else if (q.type === 'image') {
                    doc.fillColor('#4C566A')
                        .fontSize(10)
                        .font('Helvetica')
                        .text('[Espace pour coller ou dessiner une image]', 65, doc.y + 10);
                }
                doc.moveDown(1.5);
            });
        }
        else {
            doc.fillColor('#BF616A')
                .fontSize(12)
                .font('Helvetica-Bold')
                .text('⚠️ Aucune question définie pour cette enquête.', { align: 'center' });
        }
        doc.moveDown(2);
        doc.moveTo(50, doc.y)
            .lineTo(545, doc.y)
            .stroke('#3F51B5');
        doc.moveDown(0.5);
        doc.fillColor('#5E81AC')
            .fontSize(12)
            .font('Helvetica-Bold')
            .text('📤 Retour de l\'enquête :', 50, doc.y);
        doc.fillColor('#4C566A')
            .fontSize(10)
            .font('Helvetica')
            .text('• Par email : contact@digitalprocess.com', 60, doc.y + 5);
        doc.text('• Par téléphone : +216 XX XXX XXX', 60, doc.y + 3);
        doc.text('• Date limite de retour : ' + new Date(survey.dateFin).toLocaleDateString('fr-FR'), 60, doc.y + 3);
        doc.moveDown(1);
        doc.fillColor('#8FBCBB')
            .fontSize(9)
            .font('Helvetica')
            .text('🔒 Vos réponses sont confidentielles et seront utilisées uniquement pour améliorer nos services.', 50, doc.y, { width: 495, align: 'center' });
        doc.moveDown(0.5);
        doc.fillColor('#4C566A')
            .fontSize(10)
            .font('Helvetica')
            .text('Signature du client : _________________________', 50, doc.y);
        doc.text('Date : _________________________', 300, doc.y);
        doc.moveDown(1);
        doc.fillColor('#3F51B5')
            .fontSize(8)
            .font('Helvetica-Bold')
            .text('DIGITAL PROCESS - Force de Vente | Généré le ' + new Date().toLocaleDateString('fr-FR'), { align: 'center' });
        doc.fillColor('#6B7280')
            .fontSize(7)
            .font('Helvetica')
            .text('📧 contact@digitalprocess.com | 🌐 www.digitalprocess.com | 📞 +216 XX XXX XXX', { align: 'center' });
        doc.end();
    }
};
exports.SurveyService = SurveyService;
exports.SurveyService = SurveyService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(survey_entity_1.Survey)),
    __param(1, (0, typeorm_1.InjectRepository)(survey_question_entity_1.SurveyQuestion)),
    __param(2, (0, typeorm_1.InjectRepository)(survey_affectation_entity_1.SurveyAffectation)),
    __param(3, (0, typeorm_1.InjectRepository)(users_entity_1.User)),
    __param(4, (0, typeorm_1.InjectRepository)(client_entity_1.Client)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], SurveyService);
//# sourceMappingURL=survey.service.js.map