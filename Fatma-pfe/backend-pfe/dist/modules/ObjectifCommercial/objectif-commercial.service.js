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
exports.ObjectifCommercialService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const objectif_commercial_entity_1 = require("./objectif-commercial.entity");
const users_entity_1 = require("../users/users.entity");
const commande_entity_1 = require("../commande/commande.entity");
let ObjectifCommercialService = class ObjectifCommercialService {
    objectifRepo;
    userRepo;
    commandeRepo;
    constructor(objectifRepo, userRepo, commandeRepo) {
        this.objectifRepo = objectifRepo;
        this.userRepo = userRepo;
        this.commandeRepo = commandeRepo;
    }
    async create(dto) {
        if (!dto.commercialId) {
            throw new common_1.BadRequestException('commercialId est requis pour un objectif individuel');
        }
        const user = await this.userRepo.findOneByOrFail({ id: dto.commercialId });
        const objectif = this.objectifRepo.create({
            commercial: user,
            montantCible: dto.montantCible,
            prime: dto.prime,
            mission: dto.mission || `Vendre pour ${dto.montantCible} €`,
            dateDebut: dto.dateDebut,
            dateFin: dto.dateFin,
            totalVentes: 0,
            isActive: true,
        });
        return this.objectifRepo.save(objectif);
    }
    async createGlobal(createDto) {
        const objectif = this.objectifRepo.create({
            commercial: null,
            dateDebut: new Date(createDto.dateDebut),
            dateFin: new Date(createDto.dateFin),
            montantCible: createDto.montantCible,
            prime: createDto.prime,
            mission: createDto.mission || `Objectif global: ${createDto.montantCible} €`,
            totalVentes: 0,
            isActive: true,
        });
        return this.objectifRepo.save(objectif);
    }
    async findAll() {
        console.log('🔍 findAll() appelé - Récupération de tous les objectifs');
        const objectifs = await this.objectifRepo.find({
            relations: ['commercial'],
            order: { id: 'DESC' },
        });
        console.log(`📊 ${objectifs.length} objectifs trouvés`);
        const result = await Promise.all(objectifs.map(async (obj) => {
            let montantRealise = 0;
            if (obj.commercial) {
                console.log(`💰 Calcul des ventes pour ${obj.commercial.nom} ${obj.commercial.prenom} - Objectif: ${obj.mission}`);
                console.log(`📅 Période: ${obj.dateDebut} à ${obj.dateFin}`);
                let ventesResult = await this.commandeRepo
                    .createQueryBuilder('commande')
                    .where('commande.commercialId = :userId', { userId: obj.commercial.id })
                    .andWhere('commande.statut = :statut', { statut: 'validee' })
                    .andWhere('commande.date_validation BETWEEN :dateDebut AND :dateFin', {
                    dateDebut: obj.dateDebut,
                    dateFin: obj.dateFin
                })
                    .select('SUM(commande.prix_total_ttc)', 'total')
                    .getRawOne();
                if (!ventesResult || parseFloat(ventesResult.total || '0') === 0) {
                    console.log(`⚠️ Pas de ventes avec date_validation, essai avec date_creation`);
                    ventesResult = await this.commandeRepo
                        .createQueryBuilder('commande')
                        .where('commande.commercialId = :userId', { userId: obj.commercial.id })
                        .andWhere('commande.statut = :statut', { statut: 'validee' })
                        .andWhere('commande.dateCreation BETWEEN :dateDebut AND :dateFin', {
                        dateDebut: obj.dateDebut,
                        dateFin: obj.dateFin
                    })
                        .select('SUM(commande.prix_total_ttc)', 'total')
                        .getRawOne();
                }
                montantRealise = parseFloat(ventesResult?.total || '0');
                const allCommandes = await this.commandeRepo
                    .createQueryBuilder('commande')
                    .where('commande.commercialId = :userId', { userId: obj.commercial.id })
                    .select(['commande.statut', 'commande.prix_total_ttc', 'commande.dateCreation', 'commande.date_validation'])
                    .getMany();
                console.log(`📦 Total commandes du commercial: ${allCommandes.length}`);
                console.log(`📊 Statuts des commandes:`, allCommandes.map(cmd => `${cmd.statut}: ${cmd.prix_total_ttc}€`));
                console.log(`💶 Ventes calculées: ${montantRealise}€ / Objectif: ${obj.montantCible}€`);
                console.log(`✅ Atteint: ${montantRealise >= obj.montantCible}`);
            }
            const resultObj = {
                ...obj,
                montantRealise,
                isAtteint: obj.montantCible ? montantRealise >= obj.montantCible : false,
            };
            console.log(`📋 Objectif final: ${resultObj.mission} - Réalisé: ${resultObj.montantRealise}€ - Atteint: ${resultObj.isAtteint}`);
            return resultObj;
        }));
        console.log(`✅ findAll() terminé - ${result.length} objectifs avec ventes calculées`);
        return result;
    }
    async toggleStatus(id) {
        const obj = await this.objectifRepo.findOneBy({ id });
        if (!obj)
            throw new common_1.NotFoundException('Objectif introuvable');
        obj.isActive = !obj.isActive;
        return this.objectifRepo.save(obj);
    }
    async getGlobalMontantProgress() {
        const commerciaux = await this.userRepo.find({
            where: { role: 'commercial', isActive: true },
        });
        const result = [];
        for (const commercial of commerciaux) {
            const objectifs = await this.objectifRepo.find({
                where: { commercial: { id: commercial.id }, isActive: true },
            });
            const totalVente = await this.commandeRepo
                .createQueryBuilder('commande')
                .where('commande.commercialId = :id', { id: commercial.id })
                .select('SUM(commande.prix_total_ttc)', 'total')
                .getRawOne();
            const total = parseFloat(totalVente?.total || '0');
            for (const obj of objectifs) {
                const atteint = obj.montantCible ? total >= obj.montantCible : false;
                result.push({
                    commercial: {
                        id: commercial.id,
                        nom: commercial.nom,
                        prenom: commercial.prenom,
                    },
                    objectifId: obj.id,
                    mission: obj.mission,
                    montantCible: obj.montantCible,
                    ventes: total,
                    prime: obj.prime,
                    atteint,
                });
            }
        }
        return result;
    }
    async getByCommercialGroupedByYear(userId) {
        const objectifs = await this.objectifRepo.find({
            where: { commercial: { id: userId } },
            relations: ['commercial'],
        });
        const grouped = objectifs.reduce((acc, obj) => {
            const year = new Date(obj.dateDebut).getFullYear();
            if (!acc[year])
                acc[year] = [];
            acc[year].push(obj);
            return acc;
        }, {});
        return grouped;
    }
    async getSalesByCategory(userId) {
        return this.commandeRepo
            .createQueryBuilder('commande')
            .leftJoin('commande.lignesCommande', 'ligne')
            .leftJoin('ligne.produit', 'produit')
            .leftJoin('produit.categorie', 'categorie')
            .select('categorie.nom', 'categorie')
            .addSelect('SUM(ligne.quantite)', 'totalQuantite')
            .where('commande.commercialId = :userId', { userId })
            .groupBy('categorie.nom')
            .getRawMany();
    }
    async getProgressForAdmin() {
        const objectifs = await this.objectifRepo.find({
            relations: ['commercial'],
        });
        const results = [];
        for (const obj of objectifs) {
            if (!obj.commercial)
                continue;
            const ventes = await this.commandeRepo
                .createQueryBuilder('commande')
                .leftJoin('commande.lignesCommande', 'ligne')
                .leftJoin('ligne.produit', 'produit')
                .leftJoin('produit.categorie', 'categorie')
                .select('SUM(ligne.quantite)', 'total')
                .where('commande.commercialId = :id', { id: obj.commercial.id })
                .andWhere('categorie.nom = :cat', { cat: obj.categorieProduit })
                .getRawOne();
            const totalCat = parseFloat(ventes?.total || '0');
            const allVentes = await this.commandeRepo
                .createQueryBuilder('commande')
                .leftJoin('commande.lignesCommande', 'ligne')
                .where('commande.commercialId = :id', { id: obj.commercial.id })
                .select('SUM(ligne.quantite)', 'total')
                .getRawOne();
            const totalVentes = parseFloat(allVentes?.total || '0');
            const pourcentage = totalVentes === 0 ? 0 : (totalCat / totalVentes) * 100;
            results.push({
                id: obj.id,
                commercial: obj.commercial,
                categorie: obj.categorieProduit ?? null,
                objectif: obj.pourcentageCible ?? null,
                realise: Number(pourcentage.toFixed(1)),
                atteint: obj.pourcentageCible ? pourcentage >= obj.pourcentageCible : false,
            });
        }
        return results;
    }
    async getObjectifsProgress(userId) {
        console.log(`🔍 getObjectifsProgress appelé pour userId: ${userId}`);
        const today = new Date();
        const objectifsCommercial = await this.objectifRepo.find({
            where: {
                commercial: { id: userId },
                isActive: true,
                dateFin: (0, typeorm_2.MoreThan)(today),
            },
            relations: ['commercial'],
        });
        console.log(`📊 Objectifs spécifiques au commercial ${userId} (non expirés): ${objectifsCommercial.length}`);
        objectifsCommercial.forEach((obj, index) => {
            console.log(`  ${index + 1}. Commercial: ${obj.commercial?.nom} ${obj.commercial?.prenom} - Mission: ${obj.mission}`);
        });
        const result = await Promise.all(objectifsCommercial.map(async (obj) => {
            const ventesResult = await this.commandeRepo
                .createQueryBuilder('commande')
                .where('commande.commercialId = :userId', { userId })
                .andWhere('commande.statut = :statut', { statut: 'validee' })
                .andWhere('commande.date_validation BETWEEN :dateDebut AND :dateFin', { dateDebut: obj.dateDebut, dateFin: obj.dateFin })
                .select('SUM(commande.prix_total_ttc)', 'total')
                .getRawOne();
            const ventes = parseFloat(ventesResult?.total || '0');
            return {
                id: obj.id,
                mission: obj.mission,
                dateDebut: obj.dateDebut,
                dateFin: obj.dateFin,
                prime: obj.prime,
                ventes,
                montantCible: obj.montantCible,
                atteint: obj.montantCible ? ventes >= obj.montantCible : false,
                isGlobal: false,
            };
        }));
        console.log(`✅ Retourne ${result.length} objectifs PERSONNELS pour le commercial ${userId}`);
        result.forEach((obj, index) => {
            console.log(`  ${index + 1}. [PERSONNEL] ${obj.mission} - Cible: ${obj.montantCible}€ - Réalisé: ${obj.ventes}€`);
        });
        return result;
    }
    async update(id, updateData) {
        const objectif = await this.objectifRepo.findOneBy({ id });
        if (!objectif)
            throw new common_1.NotFoundException('Objectif introuvable');
        Object.assign(objectif, updateData);
        return this.objectifRepo.save(objectif);
    }
    async remove(id) {
        const objectif = await this.objectifRepo.findOneBy({ id });
        if (!objectif)
            throw new common_1.NotFoundException('Objectif introuvable');
        return this.objectifRepo.remove(objectif);
    }
};
exports.ObjectifCommercialService = ObjectifCommercialService;
exports.ObjectifCommercialService = ObjectifCommercialService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(objectif_commercial_entity_1.ObjectifCommercial)),
    __param(1, (0, typeorm_1.InjectRepository)(users_entity_1.User)),
    __param(2, (0, typeorm_1.InjectRepository)(commande_entity_1.Commande)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], ObjectifCommercialService);
//# sourceMappingURL=objectif-commercial.service.js.map