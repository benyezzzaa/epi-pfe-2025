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
exports.ReclamationService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const reclamation_entity_1 = require("./reclamation.entity");
const client_entity_1 = require("../client/client.entity");
let ReclamationService = class ReclamationService {
    repo;
    clientRepo;
    constructor(repo, clientRepo) {
        this.repo = repo;
        this.clientRepo = clientRepo;
    }
    async create(dto, user) {
        const client = await this.clientRepo.findOneBy({ id: dto.clientId });
        if (!client)
            throw new common_1.NotFoundException('Client non trouvé');
        const rec = this.repo.create({
            ...dto,
            user,
            client,
            status: 'ouverte',
        });
        return this.repo.save(rec);
    }
    findAll() {
        return this.repo.find({
            relations: ['user', 'client'],
            order: { date: 'DESC' }
        });
    }
    findByUser(userId) {
        return this.repo.find({
            where: { user: { id: userId } },
            order: { date: 'DESC' },
        });
    }
    async findOpenReclamations() {
        return this.repo.find({
            where: { status: 'ouverte' },
            relations: ['user', 'client'],
            order: { date: 'DESC' },
        });
    }
    findOpen() {
        return this.repo.find({
            where: { status: 'ouverte' },
            relations: ['client', 'user'],
            order: { date: 'DESC' },
        });
    }
    async updateStatus(id, status) {
        const rec = await this.repo.findOne({
            where: { id },
            relations: ['user', 'client']
        });
        if (!rec)
            throw new common_1.NotFoundException('Réclamation introuvable');
        rec.status = status;
        return this.repo.save(rec);
    }
};
exports.ReclamationService = ReclamationService;
exports.ReclamationService = ReclamationService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(reclamation_entity_1.Reclamation)),
    __param(1, (0, typeorm_1.InjectRepository)(client_entity_1.Client)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], ReclamationService);
//# sourceMappingURL=reclamation.service.js.map