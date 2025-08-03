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
exports.UniteService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const unite_entity_1 = require("./unite.entity");
let UniteService = class UniteService {
    uniteRepository;
    constructor(uniteRepository) {
        this.uniteRepository = uniteRepository;
    }
    async create(dto) {
        const exist = await this.uniteRepository
            .createQueryBuilder('u')
            .where('LOWER(u.nom) = LOWER(:nom)', { nom: dto.nom.trim() })
            .getOne();
        if (exist) {
            throw new common_1.NotFoundException("Cette unité existe déjà (insensible à la casse)");
        }
        const unite = this.uniteRepository.create({
            ...dto,
            isActive: true,
        });
        return await this.uniteRepository.save(unite);
    }
    async findAll(options) {
        let query = this.uniteRepository.createQueryBuilder('u');
        if (options?.search) {
            query = query.where('LOWER(u.nom) LIKE :search', { search: `%${options.search.toLowerCase()}%` });
        }
        const page = options?.page && options.page > 0 ? options.page : 1;
        const limit = options?.limit && options.limit > 0 ? options.limit : 10;
        query = query.skip((page - 1) * limit).take(limit);
        const [data, total] = await query.getManyAndCount();
        return { data, total, page, limit };
    }
    async findOne(id) {
        const unite = await this.uniteRepository.findOne({ where: { id } });
        if (!unite) {
            throw new common_1.NotFoundException(`Unité avec l'ID ${id} non trouvée`);
        }
        return unite;
    }
    async update(id, dto) {
        const unite = await this.findOne(id);
        const existing = await this.uniteRepository
            .createQueryBuilder('u')
            .where('LOWER(u.nom) = LOWER(:nom)', { nom: dto.nom.trim() })
            .andWhere('u.id != :id', { id })
            .getOne();
        if (existing) {
            throw new common_1.BadRequestException(`Une autre unité avec le nom "${dto.nom}" existe déjà.`);
        }
        Object.assign(unite, dto);
        try {
            return await this.uniteRepository.save(unite);
        }
        catch (error) {
            throw new Error("Erreur lors de la mise à jour de l'unité");
        }
    }
    async toggleStatus(id, isActive) {
        const unite = await this.findOne(id);
        unite.isActive = isActive;
        return this.uniteRepository.save(unite);
    }
    async delete(id) {
        const unite = await this.findOne(id);
        await this.uniteRepository.remove(unite);
    }
};
exports.UniteService = UniteService;
exports.UniteService = UniteService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(unite_entity_1.Unite)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], UniteService);
//# sourceMappingURL=unite.service.js.map