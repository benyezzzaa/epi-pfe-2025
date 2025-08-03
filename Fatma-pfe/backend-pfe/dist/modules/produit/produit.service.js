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
exports.ProduitService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const produit_entity_1 = require("./produit.entity");
const categorie_produit_entity_1 = require("../categorie-produit/categorie-produit.entity");
const unite_entity_1 = require("../unite/unite.entity");
let ProduitService = class ProduitService {
    produitRepository;
    categorieProduitRepository;
    uniteRepository;
    constructor(produitRepository, categorieProduitRepository, uniteRepository) {
        this.produitRepository = produitRepository;
        this.categorieProduitRepository = categorieProduitRepository;
        this.uniteRepository = uniteRepository;
    }
    async createProduit(dto, imageFilenames) {
        if (!dto.uniteId || !dto.categorieId) {
            throw new common_1.BadRequestException('Les champs uniteId et categorieId sont requis.');
        }
        const unite = await this.uniteRepository
            .createQueryBuilder('unite')
            .where(' id  =  :id ', { id: dto.uniteId })
            .getOne();
        if (!unite) {
            throw new common_1.NotFoundException(`Unité "${dto.uniteId}" non trouvée.`);
        }
        const categorie = await this.categorieProduitRepository.findOneBy({
            nom: dto.categorieId,
        });
        if (!categorie) {
            throw new common_1.NotFoundException(`Catégorie "${dto.categorieId}" non trouvée.`);
        }
        const produit = this.produitRepository.create({
            nom: dto.nom,
            description: dto.description,
            prix_unitaire: dto.prix_unitaire,
            prix_unitaire_ttc: Number((dto.prix_unitaire * (1 + dto.tva / 100)).toFixed(2)),
            tva: dto.tva,
            colisage: dto.colisage,
            images: imageFilenames ?? [],
            uniteId: unite.id,
            categorieId: categorie.id,
        });
        return this.produitRepository.save(produit);
    }
    async getAllProduits() {
        return this.produitRepository.find({
            relations: ['categorie', 'unite'],
        });
    }
    async updateProduit(id, dto, imageFilenames) {
        const produit = await this.produitRepository.findOneBy({ id });
        if (!produit) {
            throw new common_1.NotFoundException('Produit introuvable');
        }
        produit.nom = dto.nom ?? produit.nom;
        produit.description = dto.description ?? produit.description;
        produit.prix_unitaire = dto.prix_unitaire ?? produit.prix_unitaire;
        produit.tva = dto.tva ?? produit.tva;
        produit.colisage = dto.colisage ?? produit.colisage;
        produit.prix_unitaire_ttc = Number(((produit.prix_unitaire) * (1 + produit.tva / 100)).toFixed(2));
        if (dto.categorieId) {
            produit.categorie = { id: Number(dto.categorieId) };
        }
        produit.unite = { id: dto.uniteId };
        if (imageFilenames && imageFilenames.length > 0) {
            produit.images = imageFilenames;
        }
        return this.produitRepository.save(produit);
    }
    async updateStatut(id, isActive) {
        const produit = await this.produitRepository.findOneBy({ id });
        if (!produit) {
            throw new common_1.NotFoundException('Produit introuvable');
        }
        await this.produitRepository
            .createQueryBuilder()
            .update(produit_entity_1.Produit)
            .set({ isActive })
            .where('id = :id', { id })
            .execute();
        return {
            message: `Produit ${isActive ? 'activé' : 'désactivé'} ✅`,
        };
    }
    async createTestProducts() {
        const testProducts = [
            {
                nom: 'Lait Bio 1L',
                description: 'Lait bio frais de vache',
                prix_unitaire: 1.20,
                tva: 5.5,
                colisage: 12,
                uniteId: 66,
                categorieId: 'Bio'
            },
        ];
        const createdProducts = [];
        for (const product of testProducts) {
            try {
                const created = await this.createProduit(product);
                createdProducts.push(created);
            }
            catch (error) {
                console.log(`Erreur lors de la création du produit ${product.nom}:`, error.message);
            }
        }
        return createdProducts;
    }
};
exports.ProduitService = ProduitService;
exports.ProduitService = ProduitService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(produit_entity_1.Produit)),
    __param(1, (0, typeorm_1.InjectRepository)(categorie_produit_entity_1.CategorieProduit)),
    __param(2, (0, typeorm_1.InjectRepository)(unite_entity_1.Unite)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], ProduitService);
//# sourceMappingURL=produit.service.js.map