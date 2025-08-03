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
exports.CommandeService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const commande_entity_1 = require("./commande.entity");
const lignecommande_entity_1 = require("../lignecommande/lignecommande.entity");
const produit_entity_1 = require("../produit/produit.entity");
const PDFDocument = require("pdfkit");
const promotion_entity_1 = require("../Promotion/promotion.entity");
const historique_commande_entity_1 = require("./historique-commande.entity");
const client_entity_1 = require("../client/client.entity");
let CommandeService = class CommandeService {
    commandeRepository;
    ligneCommandeRepository;
    produitRepository;
    promotionRepository;
    clientRepository;
    historiqueCommandeRepository;
    findCommandeById(id) {
        throw new Error('Method not implemented.');
    }
    constructor(commandeRepository, ligneCommandeRepository, produitRepository, promotionRepository, clientRepository, historiqueCommandeRepository) {
        this.commandeRepository = commandeRepository;
        this.ligneCommandeRepository = ligneCommandeRepository;
        this.produitRepository = produitRepository;
        this.promotionRepository = promotionRepository;
        this.clientRepository = clientRepository;
        this.historiqueCommandeRepository = historiqueCommandeRepository;
    }
    async generateUniqueNumeroCommande() {
        const currentYear = new Date().getFullYear();
        let attempts = 0;
        const maxAttempts = 10;
        while (attempts < maxAttempts) {
            const lastCommande = await this.commandeRepository
                .createQueryBuilder('commande')
                .where('commande.numero_commande LIKE :pattern', {
                pattern: `CMD-${currentYear}-%`
            })
                .orderBy('commande.numero_commande', 'DESC')
                .getOne();
            let sequenceNumber = 1;
            if (lastCommande) {
                const match = lastCommande.numero_commande.match(new RegExp(`CMD-${currentYear}-(\\d+)`));
                if (match) {
                    sequenceNumber = parseInt(match[1]) + 1;
                }
            }
            const timestamp = Date.now();
            const offset = (timestamp % 1000) + attempts;
            sequenceNumber += offset;
            const formattedSequence = sequenceNumber.toString().padStart(5, '0');
            const numeroCommande = `CMD-${currentYear}-${formattedSequence}`;
            const existingCommande = await this.commandeRepository.findOne({
                where: { numero_commande: numeroCommande }
            });
            if (!existingCommande) {
                return numeroCommande;
            }
            attempts++;
        }
        const timestamp = Date.now();
        return `CMD-${currentYear}-${timestamp}`;
    }
    async cleanOldCommandeNumbers() {
        const commandesWithBadNumbers = await this.commandeRepository
            .createQueryBuilder('commande')
            .where('commande.numero_commande LIKE :pattern1', { pattern1: '%[%' })
            .orWhere('commande.numero_commande LIKE :pattern2', { pattern2: '%m%' })
            .orWhere('commande.numero_commande NOT LIKE :pattern3', { pattern3: 'CMD-%' })
            .getMany();
        let updatedCount = 0;
        for (const commande of commandesWithBadNumbers) {
            const newNumero = await this.generateUniqueNumeroCommande();
            commande.numero_commande = newNumero;
            await this.commandeRepository.save(commande);
            updatedCount++;
        }
        return { updated: updatedCount };
    }
    async fixDuplicateCommandeNumbers() {
        const duplicates = await this.commandeRepository
            .createQueryBuilder('commande')
            .select('commande.numero_commande')
            .addSelect('COUNT(*)', 'count')
            .groupBy('commande.numero_commande')
            .having('COUNT(*) > 1')
            .getRawMany();
        let fixedCount = 0;
        for (const duplicate of duplicates) {
            const commandesWithSameNumber = await this.commandeRepository.find({
                where: { numero_commande: duplicate.numero_commande },
                order: { dateCreation: 'ASC' }
            });
            for (let i = 1; i < commandesWithSameNumber.length; i++) {
                const commande = commandesWithSameNumber[i];
                const newNumero = await this.generateUniqueNumeroCommande();
                commande.numero_commande = newNumero;
                await this.commandeRepository.save(commande);
                fixedCount++;
            }
        }
        return {
            fixed: fixedCount,
            duplicates: duplicates.map(d => ({ numero: d.numero_commande, count: parseInt(d.count) }))
        };
    }
    async generatePdf(id) {
        const commande = await this.commandeRepository.findOne({
            where: { id },
            relations: ['lignesCommande', 'lignesCommande.produit', 'client'],
        });
        if (!commande) {
            throw new Error('Commande introuvable.');
        }
        if (!commande.lignesCommande || commande.lignesCommande.length === 0) {
            throw new Error('La commande ne contient aucune ligne.');
        }
        const doc = new PDFDocument();
        const chunks = [];
        return new Promise((resolve, reject) => {
            doc.on('data', (chunk) => chunks.push(chunk));
            doc.on('end', () => resolve(Buffer.concat(chunks)));
            doc.on('error', reject);
            doc.fontSize(18).text(`Commande #${commande.numero_commande}`, { underline: true });
            doc.moveDown();
            doc.fontSize(12).text(`Client : ${commande.client.nom}`);
            doc.text(`Date : ${commande.dateCreation}`);
            doc.text(`Statut : ${commande.statut}`);
            doc.text(`Total TTC : ${commande.prix_total_ttc} DT`);
            doc.moveDown();
            doc.fontSize(14).text('Produits commandés :');
            commande.lignesCommande.forEach((ligne) => {
                doc.fontSize(12).text(`- ${ligne.produit.nom} x${ligne.quantite} = ${ligne.total} DT`);
            });
            doc.end();
        });
    }
    async getDetailsCommandeModifiee(commandeId) {
        return this.historiqueCommandeRepository.find({
            where: { commande: { id: commandeId } },
            relations: ['commande', 'modifiePar'],
            order: { dateModification: 'DESC' },
        });
    }
    async marquerNotificationCommeVue(id) {
        const historique = await this.historiqueCommandeRepository.findOne({
            where: { id },
            relations: ['commande', 'commande.commercial'],
        });
        if (!historique) {
            throw new common_1.NotFoundException('Notification non trouvée.');
        }
        historique.vuParCommercial = true;
        await this.historiqueCommandeRepository.save(historique);
        return { message: `Notification marquée comme vue.` };
    }
    async getNombreNotificationsNonVues(commercialId) {
        return this.historiqueCommandeRepository.count({
            where: {
                vuParCommercial: false,
                commande: {
                    commercial: { id: commercialId },
                },
            },
            relations: ['commande', 'commande.commercial'],
        });
    }
    async createCommande(dto, commercial) {
        if (commercial.role !== 'commercial') {
            throw new common_1.ForbiddenException('Seuls les commerciaux peuvent créer des commandes.');
        }
        const numeroCommande = await this.generateUniqueNumeroCommande();
        const commande = this.commandeRepository.create({
            numero_commande: numeroCommande,
            commercial: commercial,
            client: { id: dto.clientId },
            statut: 'en_attente',
            estModifieParAdmin: false,
            prix_total_ttc: 0,
            prix_hors_taxe: 0,
            tva: 0,
            promotion: dto.promotionId ? { id: dto.promotionId } : undefined,
        });
        let savedCommande = null;
        let attempts = 0;
        const maxAttempts = 3;
        while (attempts < maxAttempts) {
            try {
                savedCommande = await this.commandeRepository.save(commande);
                break;
            }
            catch (error) {
                attempts++;
                if (error.code === '23505' && error.constraint === 'UQ_a7f83d06c017678ec4cb3628ffb') {
                    if (attempts >= maxAttempts) {
                        throw new common_1.BadRequestException('Impossible de générer un numéro de commande unique. Veuillez réessayer.');
                    }
                    commande.numero_commande = await this.generateUniqueNumeroCommande();
                    continue;
                }
                throw error;
            }
        }
        if (!savedCommande) {
            throw new common_1.BadRequestException('Erreur lors de la sauvegarde de la commande.');
        }
        let totalHT = 0;
        let totalTVA = 0;
        let totalTTC = 0;
        for (const ligne of dto.lignesCommande) {
            const produit = await this.produitRepository.findOneBy({ id: ligne.produitId });
            if (!produit) {
                throw new common_1.NotFoundException(`Produit ${ligne.produitId} introuvable.`);
            }
            const totalLigneHT = produit.prix_unitaire * ligne.quantite;
            const tvaLigne = produit.tva;
            const totalLigneTVA = totalLigneHT * (tvaLigne / 100);
            const totalLigneTTC = totalLigneHT + totalLigneTVA;
            totalHT += totalLigneHT;
            totalTVA += totalLigneTVA;
            totalTTC += totalLigneTTC;
            const ligneCommande = this.ligneCommandeRepository.create({
                quantite: ligne.quantite,
                prixUnitaire: produit.prix_unitaire,
                prixUnitaireTTC: produit.prix_unitaire_ttc,
                tva: produit.tva,
                totalHT: totalLigneHT,
                total: totalLigneTTC,
                produit: produit,
                commande: savedCommande,
            });
            await this.ligneCommandeRepository.save(ligneCommande);
        }
        const tvaMoyennePonderee = totalHT > 0 ? (totalTVA / totalHT) * 100 : 0;
        savedCommande.prix_hors_taxe = parseFloat(totalHT.toFixed(2));
        savedCommande.prix_total_ttc = parseFloat(totalTTC.toFixed(2));
        savedCommande.tva = parseFloat(tvaMoyennePonderee.toFixed(2));
        return await this.commandeRepository.save(savedCommande);
    }
    async findAllByCommercial(userId, filters) {
        return this.commandeRepository.find({
            where: { commercial: { id: userId } },
            relations: ['client', 'lignesCommande'],
            order: { dateCreation: 'DESC' },
        });
    }
    async getCommandesByCommercial(userId) {
        return this.commandeRepository.find({
            where: { commercial: { id: userId } },
            relations: ['client', 'lignesCommande', 'lignesCommande.produit'],
        });
    }
    async getAllCommandes() {
        return this.commandeRepository.find({
            relations: [
                'client',
                'lignesCommande',
                'lignesCommande.produit',
                'commercial',
                'promotion',
            ],
            order: { id: 'DESC' },
        });
    }
    async getBandeDeCommande(id) {
        const commande = await this.commandeRepository.findOne({
            where: { id },
            relations: ['lignesCommande', 'lignesCommande.produit', 'commercial', 'client', 'promotion'],
        });
        if (!commande) {
            throw new common_1.NotFoundException(`Commande avec ID ${id} introuvable`);
        }
        const totalAvantRemise = commande.prix_total_ttc;
        let prixAvantReduction = totalAvantRemise;
        if (commande.promotion) {
            const reduction = commande.promotion.tauxReduction || 0;
            prixAvantReduction = +(totalAvantRemise / (1 - reduction / 100)).toFixed(2);
        }
        return {
            numeroCommande: commande.numero_commande,
            date: commande.dateCreation,
            commercial: {
                nom: commande.commercial?.nom,
                prenom: commande.commercial?.prenom,
                email: commande.commercial?.email,
            },
            client: {
                nom: commande.client?.nom,
                prenom: commande.client?.prenom,
                code_fiscal: commande.client?.codeFiscale,
            },
            produits: commande.lignesCommande.map((ligne) => ({
                id: ligne.id,
                nomProduit: ligne.produit?.nom,
                quantite: ligne.quantite,
                prixUnitaire: ligne.prixUnitaire,
                tva: ligne.tva,
                prixTTC: ligne.prixUnitaireTTC,
                totalHT: ligne.totalHT,
                total: ligne.total,
            })),
            prixTotalTTC: Number(commande.prix_total_ttc),
            prixHorsTaxe: Number(commande.prix_hors_taxe),
            prixAvantReduction,
            promotion: commande.promotion
                ? {
                    nom: commande.promotion.titre,
                    reductionPourcentage: commande.promotion.tauxReduction ?? 0,
                }
                : null,
        };
    }
    async getCommandesModifieesParAdmin(commercialId) {
        return this.commandeRepository.find({
            where: {
                commercial: { id: commercialId },
                estModifieParAdmin: true,
            },
            relations: ['client', 'lignesCommande', 'promotion'],
            order: { dateCreation: 'DESC' },
        });
    }
    async marquerCommandeCommeModifiee(commandeId, modifiePar, champ, ancienneValeur, nouvelleValeur) {
        const commande = await this.commandeRepository.findOne({
            where: { id: commandeId },
            relations: ['commercial'],
        });
        if (!commande)
            throw new common_1.NotFoundException('Commande introuvable');
        commande.estModifieParAdmin = true;
        await this.commandeRepository.save(commande);
        const historique = this.historiqueCommandeRepository.create({
            commande,
            champModifie: champ,
            ancienneValeur,
            nouvelleValeur,
            modifiePar,
            vuParCommercial: false,
        });
        await this.historiqueCommandeRepository.save(historique);
    }
    async updateCommande(id, updateDto) {
        const commande = await this.commandeRepository.findOne({
            where: { id },
            relations: ['lignesCommande', 'lignesCommande.produit', 'commercial'],
        });
        if (!commande) {
            throw new common_1.NotFoundException(`Commande introuvable`);
        }
        let modificationEffectuee = false;
        let totalHT = 0;
        let totalTVA = 0;
        let totalTTC = 0;
        if (updateDto.lignesCommande?.length) {
            for (const ligneUpdate of updateDto.lignesCommande) {
                const ligne = await this.ligneCommandeRepository.findOne({
                    where: { id: ligneUpdate.id },
                    relations: ['produit'],
                });
                if (!ligne)
                    continue;
                const ancienneQuantite = ligne.quantite;
                const nouvelleQuantite = ligneUpdate.quantite;
                if (nouvelleQuantite <= 0) {
                    throw new common_1.BadRequestException(`La quantité du produit ${ligne.produit.nom} doit être supérieure à 0`);
                }
                if (nouvelleQuantite !== ancienneQuantite) {
                    ligne.quantite = nouvelleQuantite;
                    ligne.totalHT = parseFloat((ligne.prixUnitaire * ligne.quantite).toFixed(2));
                    ligne.total = parseFloat((ligne.totalHT * (1 + ligne.tva / 100)).toFixed(2));
                    await this.ligneCommandeRepository.save(ligne);
                    await this.marquerCommandeCommeModifiee(commande.id, { id: updateDto.modifiePar }, `Quantité - ${ligne.produit.nom}`, ancienneQuantite.toString(), nouvelleQuantite.toString());
                    modificationEffectuee = true;
                }
            }
        }
        if (modificationEffectuee) {
            const lignesMajorees = await this.ligneCommandeRepository.find({
                where: { commande: { id } },
            });
            for (const ligne of lignesMajorees) {
                const ligneHT = Number(ligne.totalHT);
                const ligneTTC = Number(ligne.total);
                if (isNaN(ligneHT) || isNaN(ligneTTC)) {
                    throw new common_1.BadRequestException(`Ligne ${ligne.id} a un total invalide`);
                }
                totalHT += ligneHT;
                totalTTC += ligneTTC;
                totalTVA += ligneTTC - ligneHT;
            }
            const tvaMoyenne = totalHT > 0 ? (totalTVA / totalHT) * 100 : 0;
            commande.prix_hors_taxe = parseFloat(totalHT.toFixed(2));
            commande.prix_total_ttc = parseFloat(totalTTC.toFixed(2));
            commande.tva = parseFloat(tvaMoyenne.toFixed(2));
            commande.estModifieParAdmin = true;
            await this.commandeRepository.save(commande);
        }
        return commande;
    }
    async getCommandesModifieesPourCommercial(commercialId) {
        const commandes = await this.commandeRepository.find({
            where: {
                commercial: { id: commercialId },
                estModifieParAdmin: true,
            },
            relations: ['client', 'lignesCommande', 'lignesCommande.produit', 'promotion'],
            order: { dateCreation: 'DESC' },
        });
        const commandesAvecNotifications = await Promise.all(commandes.map(async (commande) => {
            const notificationsNonVues = await this.historiqueCommandeRepository.count({
                where: {
                    commande: { id: commande.id },
                    vuParCommercial: false,
                },
            });
            return {
                ...commande,
                notificationsNonVues,
                vu: notificationsNonVues === 0,
            };
        }));
        return commandesAvecNotifications;
    }
    async marquerModificationsCommeVues(commercialId) {
        const historiques = await this.historiqueCommandeRepository.find({
            where: { vuParCommercial: false },
            relations: ['commande', 'commande.commercial'],
        });
        const àMarquer = historiques.filter(h => h.commande.commercial.id === commercialId);
        for (const h of àMarquer) {
            h.vuParCommercial = true;
            await this.historiqueCommandeRepository.save(h);
        }
        return { message: `${àMarquer.length} notifications marquées comme vues.` };
    }
    async getCommandesValidees() {
        return this.commandeRepository.find({
            where: { statut: 'validee' },
            relations: ['lignesCommande', 'lignesCommande.produit', 'commercial'],
            order: { id: 'DESC' },
        });
    }
    async validerCommande(id) {
        const commande = await this.commandeRepository.findOne({ where: { id } });
        if (!commande) {
            throw new common_1.NotFoundException('Commande introuvable');
        }
        commande.statut = 'validee';
        commande.date_validation = new Date();
        return this.commandeRepository.save(commande);
    }
    async rejeterCommande(id, motifRejet) {
        const commande = await this.commandeRepository.findOne({ where: { id } });
        if (!commande) {
            throw new common_1.NotFoundException('Commande introuvable');
        }
        commande.statut = 'rejetee';
        commande.motif_rejet = motifRejet;
        return this.commandeRepository.save(commande);
    }
    async deleteCommande(id) {
        const commande = await this.commandeRepository.findOneBy({ id });
        if (!commande) {
            throw new common_1.NotFoundException('Commande introuvable');
        }
        commande.statut = 'rejetee';
        commande.motif_rejet = 'Commande supprimée par l\'administrateur';
        await this.marquerCommandeCommeModifiee(commande.id, { id: 1 }, 'Statut', commande.statut, 'rejetee');
        return this.commandeRepository.save(commande);
    }
    async deleteCommandeDefinitivement(id) {
        const commande = await this.commandeRepository.findOneBy({ id });
        if (!commande) {
            throw new common_1.NotFoundException('Commande introuvable');
        }
        return this.commandeRepository.remove(commande);
    }
    async recalculerTotauxCommande(commandeId) {
        const commande = await this.commandeRepository.findOne({
            where: { id: commandeId },
            relations: ['lignesCommande'],
        });
        if (!commande) {
            throw new common_1.NotFoundException(`Commande ${commandeId} non trouvée`);
        }
        let totalHT = 0;
        for (const ligne of commande.lignesCommande) {
            const total = Number(ligne.total);
            if (isNaN(total)) {
                throw new common_1.BadRequestException(`Total invalide pour la ligne ${ligne.id}`);
            }
            totalHT += total;
        }
        const prixTotalTTC = parseFloat((totalHT * 1.19).toFixed(2));
        commande.prix_hors_taxe = parseFloat(totalHT.toFixed(2));
        commande.prix_total_ttc = prixTotalTTC;
        await this.commandeRepository.save(commande);
    }
    async getCommandesRejeteesPourCommercial(commercialId) {
        return this.commandeRepository.find({
            where: {
                commercial: { id: commercialId },
                statut: 'rejetee',
            },
            relations: ['client', 'lignesCommande', 'lignesCommande.produit', 'promotion'],
            order: { dateCreation: 'DESC' },
        });
    }
};
exports.CommandeService = CommandeService;
exports.CommandeService = CommandeService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(commande_entity_1.Commande)),
    __param(1, (0, typeorm_1.InjectRepository)(lignecommande_entity_1.LigneCommande)),
    __param(2, (0, typeorm_1.InjectRepository)(produit_entity_1.Produit)),
    __param(3, (0, typeorm_1.InjectRepository)(promotion_entity_1.Promotion)),
    __param(4, (0, typeorm_1.InjectRepository)(client_entity_1.Client)),
    __param(5, (0, typeorm_1.InjectRepository)(historique_commande_entity_1.HistoriqueCommande)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], CommandeService);
//# sourceMappingURL=commande.service.js.map