import { Repository } from 'typeorm';
import { Commande } from './commande.entity';
import { LigneCommande } from '../lignecommande/lignecommande.entity';
import { CreateCommandeDto } from './dto/create-commande.dto';
import { User } from '../users/users.entity';
import { Produit } from '../produit/produit.entity';
import { UpdateCommandeDto } from './dto/update-commande.dto';
import { Promotion } from '../Promotion/promotion.entity';
import { HistoriqueCommande } from './historique-commande.entity';
import { Client } from '../client/client.entity';
export declare class CommandeService {
    private commandeRepository;
    private ligneCommandeRepository;
    private produitRepository;
    private promotionRepository;
    private clientRepository;
    private historiqueCommandeRepository;
    findCommandeById(id: number): void;
    constructor(commandeRepository: Repository<Commande>, ligneCommandeRepository: Repository<LigneCommande>, produitRepository: Repository<Produit>, promotionRepository: Repository<Promotion>, clientRepository: Repository<Client>, historiqueCommandeRepository: Repository<HistoriqueCommande>);
    private generateUniqueNumeroCommande;
    cleanOldCommandeNumbers(): Promise<{
        updated: number;
    }>;
    fixDuplicateCommandeNumbers(): Promise<{
        fixed: number;
        duplicates: any[];
    }>;
    generatePdf(id: number): Promise<Buffer>;
    getDetailsCommandeModifiee(commandeId: number): Promise<HistoriqueCommande[]>;
    marquerNotificationCommeVue(id: number): Promise<{
        message: string;
    }>;
    getNombreNotificationsNonVues(commercialId: number): Promise<number>;
    createCommande(dto: CreateCommandeDto, commercial: User): Promise<Commande>;
    findAllByCommercial(userId: number, filters?: any): Promise<Commande[]>;
    getCommandesByCommercial(userId: number): Promise<Commande[]>;
    getAllCommandes(): Promise<Commande[]>;
    getBandeDeCommande(id: number): Promise<{
        numeroCommande: string;
        date: Date;
        commercial: {
            nom: string;
            prenom: string;
            email: string;
        };
        client: {
            nom: string;
            prenom: string;
            code_fiscal: string | undefined;
        };
        produits: {
            id: number;
            nomProduit: string;
            quantite: number;
            prixUnitaire: number;
            tva: number;
            prixTTC: number;
            totalHT: number;
            total: number;
        }[];
        prixTotalTTC: number;
        prixHorsTaxe: number;
        prixAvantReduction: number;
        promotion: {
            nom: string;
            reductionPourcentage: number;
        } | null;
    }>;
    getCommandesModifieesParAdmin(commercialId: number): Promise<Commande[]>;
    marquerCommandeCommeModifiee(commandeId: number, modifiePar: User, champ: string, ancienneValeur: string, nouvelleValeur: string): Promise<void>;
    updateCommande(id: number, updateDto: UpdateCommandeDto): Promise<Commande>;
    getCommandesModifieesPourCommercial(commercialId: number): Promise<any[]>;
    marquerModificationsCommeVues(commercialId: number): Promise<{
        message: string;
    }>;
    getCommandesValidees(): Promise<Commande[]>;
    validerCommande(id: number): Promise<Commande>;
    rejeterCommande(id: number, motifRejet: string): Promise<Commande>;
    deleteCommande(id: number): Promise<Commande>;
    deleteCommandeDefinitivement(id: number): Promise<Commande>;
    recalculerTotauxCommande(commandeId: number): Promise<void>;
    getCommandesRejeteesPourCommercial(commercialId: number): Promise<Commande[]>;
}
