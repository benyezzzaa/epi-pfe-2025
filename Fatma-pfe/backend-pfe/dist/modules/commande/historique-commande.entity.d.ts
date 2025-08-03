import { Commande } from './commande.entity';
import { User } from '../users/users.entity';
export declare class HistoriqueCommande {
    id: number;
    commande: Commande;
    champModifie: string;
    ancienneValeur: string;
    nouvelleValeur: string;
    modifiePar: User;
    dateModification: Date;
    vuParCommercial: boolean;
}
