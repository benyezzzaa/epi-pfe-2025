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
exports.PromotionService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const promotion_entity_1 = require("./promotion.entity");
const typeorm_3 = require("typeorm");
let PromotionService = class PromotionService {
    promoRepo;
    constructor(promoRepo) {
        this.promoRepo = promoRepo;
    }
    async create(dto) {
        const promo = this.promoRepo.create({
            ...dto,
            isActive: true,
        });
        return await this.promoRepo.save(promo);
    }
    async findActive() {
        const today = new Date();
        return this.promoRepo.find({
            where: {
                isActive: true,
                dateDebut: (0, typeorm_3.LessThanOrEqual)(today),
                dateFin: (0, typeorm_3.MoreThanOrEqual)(today),
            },
        });
    }
    async findActives() {
        return this.promoRepo.find({
            where: { isActive: true },
            order: { dateDebut: 'DESC' },
        });
    }
    async findAll() {
        console.log('⏳ Appel à findAll()');
        const promos = await this.promoRepo.find();
        console.log('✅ Promotions trouvées :', promos);
        return promos;
    }
    async update(id, dto) {
        const promo = await this.promoRepo.findOneBy({ id });
        if (!promo) {
            throw new common_1.NotFoundException('Promotion introuvable');
        }
        Object.assign(promo, dto);
        return await this.promoRepo.save(promo);
    }
    async getPromotionsActives() {
        const now = new Date();
        return this.promoRepo.find({
            where: {
                isActive: true,
                dateDebut: (0, typeorm_3.LessThanOrEqual)(now),
                dateFin: (0, typeorm_3.MoreThanOrEqual)(now),
            },
            order: { dateDebut: 'DESC' },
        });
    }
    async toggleStatus(id) {
        const promo = await this.promoRepo.findOneBy({ id });
        if (!promo) {
            throw new common_1.NotFoundException('Promotion introuvable');
        }
        promo.isActive = !promo.isActive;
        return await this.promoRepo.save(promo);
    }
};
exports.PromotionService = PromotionService;
exports.PromotionService = PromotionService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(promotion_entity_1.Promotion)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], PromotionService);
//# sourceMappingURL=Promotion.Service.js.map