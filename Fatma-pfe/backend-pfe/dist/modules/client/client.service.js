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
exports.ClientService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const client_entity_1 = require("./client.entity");
const visite_entity_1 = require("../Visite/visite.entity");
const categorie_client_entity_1 = require("./categorie-client.entity");
let ClientService = class ClientService {
    clientRepository;
    visiteRepository;
    categorieClientRepository;
    constructor(clientRepository, visiteRepository, categorieClientRepository) {
        this.clientRepository = clientRepository;
        this.visiteRepository = visiteRepository;
        this.categorieClientRepository = categorieClientRepository;
    }
    validateSIRET(siret) {
        if (!siret || siret.length !== 14)
            return false;
        let sum = 0;
        for (let i = 0; i < 13; i++) {
            let digit = parseInt(siret[i]);
            if (i % 2 === 1) {
                digit *= 2;
                if (digit > 9)
                    digit -= 9;
            }
            sum += digit;
        }
        const checkDigit = (10 - (sum % 10)) % 10;
        return checkDigit === parseInt(siret[13]);
    }
    async createClient(dto, user) {
        if (user.role !== 'commercial') {
            throw new common_1.ForbiddenException('Seuls les commerciaux peuvent ajouter des clients.');
        }
        if (dto.codeFiscale && !/^\d{14}$/.test(dto.codeFiscale)) {
            throw new common_1.BadRequestException('Le SIRET doit contenir exactement 14 chiffres.');
        }
        let categorie = null;
        if (dto.categorieId) {
            categorie = await this.categorieClientRepository.findOneBy({ id: dto.categorieId });
            if (!categorie)
                throw new common_1.NotFoundException('Catégorie non trouvée');
        }
        const cleanTelephone = dto.telephone ? dto.telephone.replace(/\s+/g, '') : dto.telephone;
        const client = this.clientRepository.create({
            ...dto,
            telephone: cleanTelephone,
            commercial: user,
            ...(categorie ? { categorie } : {}),
        });
        const savedClient = await this.clientRepository.save(client);
        const clientWithRelations = await this.clientRepository.findOne({
            where: { id: savedClient.id },
            relations: ['categorie', 'commercial'],
        });
        if (!clientWithRelations)
            throw new common_1.NotFoundException('Client non trouvé après création');
        return clientWithRelations;
    }
    async getAllClients() {
        return this.clientRepository.find({
            relations: ['categorie', 'commercial'],
        });
    }
    async getClientById(id) {
        if (typeof id !== 'number' || isNaN(id)) {
            throw new common_1.BadRequestException('ID invalide');
        }
        const client = await this.clientRepository.findOne({
            where: { id },
            relations: ['categorie', 'commercial'],
        });
        if (!client) {
            throw new common_1.NotFoundException(`Client avec l'id ${id} non trouvé.`);
        }
        return client;
    }
    async updateClient(id, dto, user) {
        const client = await this.getClientById(id);
        if (user.role === 'commercial' && client.commercial?.id !== user.id) {
            throw new common_1.ForbiddenException('Vous ne pouvez modifier que vos propres clients.');
        }
        if (dto.codeFiscale && !/^\d{14}$/.test(dto.codeFiscale)) {
            throw new common_1.BadRequestException('Le SIRET doit contenir exactement 14 chiffres.');
        }
        if (dto.codeFiscale && dto.codeFiscale !== client.codeFiscale) {
            const existingClient = await this.clientRepository.findOneBy({
                codeFiscale: dto.codeFiscale
            });
            if (existingClient) {
                throw new common_1.ConflictException('Un client avec ce numéro SIRET existe déjà.');
            }
        }
        if (dto.telephone) {
            dto.telephone = dto.telephone.replace(/\s+/g, '');
        }
        if (dto.categorieId) {
            const categorie = await this.categorieClientRepository.findOneBy({ id: dto.categorieId });
            if (!categorie) {
                throw new common_1.NotFoundException('Catégorie non trouvée');
            }
            client.categorie = categorie;
        }
        Object.assign(client, {
            nom: dto.nom,
            prenom: dto.prenom,
            email: dto.email,
            telephone: dto.telephone,
            adresse: dto.adresse,
            codeFiscale: dto.codeFiscale,
            estFidele: dto.estFidele,
            latitude: dto.latitude,
            longitude: dto.longitude,
            responsable: dto.responsable,
        });
        const savedClient = await this.clientRepository.save(client);
        const clientFinal = await this.clientRepository.findOne({
            where: { id: savedClient.id },
            relations: ['categorie', 'commercial'],
        });
        if (!clientFinal) {
            throw new common_1.NotFoundException('Client non trouvé après mise à jour');
        }
        return clientFinal;
    }
    async deleteClient(id, user) {
        const client = await this.clientRepository.findOne({ where: { id } });
        if (!client)
            throw new common_1.NotFoundException('Client non trouvé.');
        if (user.role === 'commercial' && client.commercial?.id !== user.id) {
            throw new common_1.ForbiddenException('Vous ne pouvez supprimer que vos propres clients.');
        }
        await this.clientRepository.remove(client);
        return { message: 'Client supprimé avec succès.' };
    }
    async updateClientStatus(id, isActive, user) {
        const client = await this.getClientById(id);
        if (user.role === 'commercial' && client.commercial?.id !== user.id) {
            throw new common_1.ForbiddenException('Vous ne pouvez modifier que vos propres clients.');
        }
        client.isActive = isActive;
        const updated = await this.clientRepository.save(client);
        return {
            message: `Client ${isActive ? 'activé' : 'désactivé'} avec succès.`,
            client: updated,
        };
    }
    async getCategoriesDuCommercial(user) {
        if (user.role !== 'commercial') {
            throw new common_1.ForbiddenException('Seuls les commerciaux peuvent accéder à leurs catégories');
        }
        const categories = await this.categorieClientRepository
            .createQueryBuilder('categorie')
            .leftJoin('categorie.clients', 'client')
            .where('client.commercial_id = :id', { id: user.id })
            .groupBy('categorie.id')
            .addGroupBy('categorie.nom')
            .getMany();
        return categories;
    }
    async getClientsDuCommercial(user) {
        if (!user || !user.id) {
            throw new common_1.BadRequestException('Utilisateur non authentifié');
        }
        return this.clientRepository.find({
            where: { commercial: { id: user.id } },
            relations: ['categorie', 'commercial'],
        });
    }
    async getClientsByCommercialId(commercialId) {
        return this.clientRepository.find({
            where: { commercial: { id: commercialId } },
            relations: ['categorie', 'commercial'],
        });
    }
    async getOptimizedPlanning(user, currentLat, currentLon) {
        if (!user || !user.id) {
            throw new common_1.BadRequestException('Utilisateur non authentifié.');
        }
        const clients = await this.clientRepository.find({
            where: { commercial: { id: user.id }, isActive: true },
            relations: ['commercial'],
        });
        if (!clients.length) {
            return [];
        }
        const visites = await this.visiteRepository
            .createQueryBuilder('visite')
            .leftJoinAndSelect('visite.client', 'client')
            .where('client.commercial_id = :commercialId', { commercialId: user.id })
            .getMany();
        const now = new Date();
        const scoredClients = clients.map(client => {
            const lastVisit = visites
                .filter(v => v.client.id === client.id)
                .sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime())[0];
            const daysSinceLastVisit = lastVisit
                ? Math.ceil((now.getTime() - new Date(lastVisit.date).getTime()) /
                    (1000 * 60 * 60 * 24))
                : 999;
            const distance = client.latitude != null && client.longitude != null
                ? haversine(currentLat, currentLon, client.latitude, client.longitude)
                : 999;
            const score = 5 * client.importance + 0.1 * daysSinceLastVisit - 2 * distance;
            return {
                id: client.id,
                nom: client.nom,
                prenom: client.prenom,
                adresse: client.adresse,
                importance: client.importance,
                distance: Number(distance.toFixed(2)),
                daysSinceLastVisit,
                score: Number(score.toFixed(2)),
            };
        });
        return scoredClients.sort((a, b) => b.score - a.score);
    }
};
exports.ClientService = ClientService;
exports.ClientService = ClientService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(client_entity_1.Client)),
    __param(1, (0, typeorm_1.InjectRepository)(visite_entity_1.Visite)),
    __param(2, (0, typeorm_1.InjectRepository)(categorie_client_entity_1.CategorieClient)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], ClientService);
function haversine(lat1, lon1, lat2, lon2) {
    const R = 6371;
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1 * Math.PI / 180) *
            Math.cos(lat2 * Math.PI / 180) *
            Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
}
//# sourceMappingURL=client.service.js.map