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
exports.CategorieClientService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const categorie_client_entity_1 = require("./categorie-client.entity");
let CategorieClientService = class CategorieClientService {
    categorieRepo;
    constructor(categorieRepo) {
        this.categorieRepo = categorieRepo;
    }
    async create(dto) {
        const exists = await this.categorieRepo.findOneBy({ nom: dto.nom });
        if (exists) {
            throw new common_1.ConflictException('Cette catégorie existe déjà');
        }
        const newCategorie = this.categorieRepo.create({
            ...dto,
            isActive: true,
        });
        return this.categorieRepo.save(newCategorie);
    }
    async findAll() {
        return this.categorieRepo.find();
    }
    async update(id, dto) {
        const cat = await this.categorieRepo.findOneBy({ id });
        if (!cat)
            throw new Error('Catégorie non trouvée');
        cat.nom = dto.nom;
        return this.categorieRepo.save(cat);
    }
    async updateStatus(id, isActive) {
        try {
            const cat = await this.categorieRepo.findOneBy({ id });
            if (!cat)
                throw new Error('Catégorie non trouvée');
            cat.isActive = isActive;
            return this.categorieRepo.save(cat);
        }
        catch (e) {
            console.error('Erreur updateStatus:', e);
            throw e;
        }
    }
};
exports.CategorieClientService = CategorieClientService;
exports.CategorieClientService = CategorieClientService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(categorie_client_entity_1.CategorieClient)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], CategorieClientService);
//# sourceMappingURL=categorie-client.service.js.map