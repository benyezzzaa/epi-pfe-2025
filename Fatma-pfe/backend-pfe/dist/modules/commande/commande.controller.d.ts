import { CommandeService } from './commande.service';
import { CreateCommandeDto } from './dto/create-commande.dto';
import { UpdateCommandeDto } from './dto/update-commande.dto';
import { Response } from 'express';
export declare class CommandeController {
    private readonly commandeService;
    constructor(commandeService: CommandeService);
    createCommande(dto: CreateCommandeDto, req: any): Promise<import("./commande.entity").Commande>;
    getAllCommandes(): Promise<import("./commande.entity").Commande[]>;
    getMyCommandes(req: any): Promise<import("./commande.entity").Commande[]>;
    updateCommande(id: number, dto: UpdateCommandeDto): Promise<import("./commande.entity").Commande>;
    validerCommande(id: number): Promise<import("./commande.entity").Commande>;
    rejeterCommande(id: number, body: {
        motif_rejet: string;
    }): Promise<import("./commande.entity").Commande>;
    deleteCommande(id: number): Promise<import("./commande.entity").Commande>;
    cleanOldCommandeNumbers(): Promise<{
        updated: number;
    }>;
    fixDuplicateCommandeNumbers(): Promise<{
        fixed: number;
        duplicates: any[];
    }>;
    rejeterCommandeViaDelete(id: number, body: {
        motif_rejet?: string;
    }): Promise<import("./commande.entity").Commande>;
    deleteCommandeDefinitivement(id: number): Promise<import("./commande.entity").Commande>;
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
    getCommandesValidees(): Promise<import("./commande.entity").Commande[]>;
    getCommandesRejetees(req: any): Promise<import("./commande.entity").Commande[]>;
    downloadPdf(id: number, res: Response): Promise<void>;
    getCommandesModifiees(req: any): Promise<any[]>;
    getDetailsCommandeModifiee(id: number): Promise<import("./historique-commande.entity").HistoriqueCommande[]>;
    marquerNotificationCommeVue(id: number): Promise<number>;
    getNombreNotificationsNonVues(req: any): Promise<number>;
}
