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
exports.CategorieProduitService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const categorie_produit_entity_1 = require("./categorie-produit.entity");
let CategorieProduitService = class CategorieProduitService {
    categorieRepository;
    constructor(categorieRepository) {
        this.categorieRepository = categorieRepository;
    }
    async create(dto) {
        const exist = await this.categorieRepository
            .createQueryBuilder('cat')
            .where('LOWER(cat.nom) = LOWER(:nom)', { nom: dto.nom.trim() })
            .getOne();
        if (exist) {
            throw new common_1.NotFoundException('Cette catégorie existe déjà (insensible à la casse)');
        }
        const cat = this.categorieRepository.create(dto);
        return this.categorieRepository.save(cat);
    }
    async getAll() {
        return this.categorieRepository.find();
    }
    async getById(id) {
        const cat = await this.categorieRepository.findOneBy({ id });
        if (!cat)
            throw new common_1.NotFoundException('Catégorie introuvable');
        return cat;
    }
    async update(id, dto) {
        const cat = await this.getById(id);
        Object.assign(cat, dto);
        return this.categorieRepository.save(cat);
    }
    async delete(id) {
        const result = await this.categorieRepository.delete(id);
        if (result.affected === 0)
            throw new common_1.NotFoundException('Catégorie introuvable');
    }
};
exports.CategorieProduitService = CategorieProduitService;
exports.CategorieProduitService = CategorieProduitService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(categorie_produit_entity_1.CategorieProduit)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], CategorieProduitService);
//# sourceMappingURL=categorie-produit.service.js.map