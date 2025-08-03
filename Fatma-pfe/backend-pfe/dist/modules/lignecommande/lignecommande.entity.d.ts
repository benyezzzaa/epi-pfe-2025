import { Commande } from '../commande/commande.entity';
import { Produit } from '../produit/produit.entity';
export declare class LigneCommande {
    id: number;
    quantite: number;
    total: number;
    tva: number;
    prixUnitaireTTC: number;
    prixUnitaire: number;
    commande: Commande;
    produit: Produit;
    totalHT: number;
}
