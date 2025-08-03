import { User } from '../users/users.entity';
import { LigneCommande } from '../lignecommande/lignecommande.entity';
import { Facture } from '../facture/facture.entity';
import { Client } from '../client/client.entity';
import { Promotion } from '../Promotion/promotion.entity';
import { HistoriqueCommande } from './historique-commande.entity';
export declare class Commande {
    id: number;
    numero_commande: string;
    promotion?: Promotion;
    dateCreation: Date;
    prix_total_ttc: number;
    date_validation: Date;
    prix_hors_taxe: number;
    tva: number;
    lignesCommande: LigneCommande[];
    commercial: User;
    client: Client;
    factures: Facture[];
    statut: string;
    estModifieParAdmin: boolean;
    motif_rejet: string;
    historique: HistoriqueCommande[];
}
