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
exports.ReglementService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const reglement_entity_1 = require("./reglement.entity");
const typeReglement_entity_1 = require("../type-reglement/typeReglement.entity");
let ReglementService = class ReglementService {
    reglementRepository;
    typeReglementRepository;
    constructor(reglementRepository, typeReglementRepository) {
        this.reglementRepository = reglementRepository;
        this.typeReglementRepository = typeReglementRepository;
    }
    async create(dto) {
        const reglement = new reglement_entity_1.Reglement();
        reglement.mode_paiement = dto.mode_paiement;
        reglement.montant = dto.montant;
        reglement.montantPaye = dto.montantPaye;
        reglement.datePaiement = new Date(dto.datePaiement);
        reglement.statut = dto.statut;
        if (dto.typeReglementId) {
            const typeReglement = await this.typeReglementRepository.findOne({
                where: { id: dto.typeReglementId },
            });
            if (!typeReglement) {
                throw new common_1.NotFoundException('Type de règlement non trouvé');
            }
            reglement.typeReglement = typeReglement;
        }
        return await this.reglementRepository.save(reglement);
    }
    async findAll() {
        return this.reglementRepository.find({
            relations: ['typeReglement', 'reglementsFactures'],
        });
    }
};
exports.ReglementService = ReglementService;
exports.ReglementService = ReglementService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(reglement_entity_1.Reglement)),
    __param(1, (0, typeorm_1.InjectRepository)(typeReglement_entity_1.TypeReglement)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], ReglementService);
//# sourceMappingURL=reglement.service.js.map