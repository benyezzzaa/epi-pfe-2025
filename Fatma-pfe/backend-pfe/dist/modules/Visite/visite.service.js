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
exports.VisiteService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const visite_entity_1 = require("./visite.entity");
const client_entity_1 = require("../client/client.entity");
const raison_visite_entity_1 = require("../raison-visite/raison-visite.entity");
let VisiteService = class VisiteService {
    visiteRepository;
    clientRepository;
    raisonVisiteRepository;
    constructor(visiteRepository, clientRepository, raisonVisiteRepository) {
        this.visiteRepository = visiteRepository;
        this.clientRepository = clientRepository;
        this.raisonVisiteRepository = raisonVisiteRepository;
    }
    async createVisite(dto, user) {
        const client = await this.clientRepository.findOneBy({ id: dto.clientId });
        if (!client)
            throw new common_1.NotFoundException('Client non trouvé.');
        const raison = await this.raisonVisiteRepository.findOneBy({ id: dto.raisonId });
        if (!raison)
            throw new common_1.NotFoundException('Raison de visite non trouvée.');
        if (!dto.date) {
            throw new common_1.BadRequestException('Date manquante.');
        }
        const date = new Date(dto.date);
        if (isNaN(date.getTime())) {
            throw new common_1.BadRequestException('Format de date invalide.');
        }
        const onlyDate = date.toISOString().split('T')[0];
        const existingVisite = await this.visiteRepository
            .createQueryBuilder('visite')
            .where('visite.userId = :userId', { userId: user.id })
            .andWhere('visite.client_id = :clientId', { clientId: dto.clientId })
            .andWhere("DATE(visite.date) = :date", { date: onlyDate })
            .getOne();
        if (existingVisite) {
            throw new common_1.ForbiddenException("Une visite pour ce client existe déjà à cette date.");
        }
        const newVisite = this.visiteRepository.create({
            date,
            user,
            client,
            raison,
        });
        return await this.visiteRepository.save(newVisite);
    }
    async getAllVisites() {
        return this.visiteRepository.find({
            relations: ['user', 'client', 'raison'],
            order: { id: 'ASC' },
        });
    }
    async getVisitesByCommercial(commercialId) {
        return await this.visiteRepository.find({
            where: { user: { id: commercialId } },
            relations: ['user', 'client'],
        });
    }
    async deleteVisite(id, user) {
        const visite = await this.visiteRepository.findOne({
            where: { id },
            relations: ['user'],
        });
        if (!visite)
            throw new common_1.NotFoundException('Visite non trouvée.');
        if (user.role !== 'admin' && visite.user.id !== user.id) {
            throw new common_1.ForbiddenException('Vous ne pouvez supprimer que vos propres visites.');
        }
        await this.visiteRepository.remove(visite);
    }
};
exports.VisiteService = VisiteService;
exports.VisiteService = VisiteService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(visite_entity_1.Visite)),
    __param(1, (0, typeorm_1.InjectRepository)(client_entity_1.Client)),
    __param(2, (0, typeorm_1.InjectRepository)(raison_visite_entity_1.RaisonVisite)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], VisiteService);
//# sourceMappingURL=visite.service.js.map