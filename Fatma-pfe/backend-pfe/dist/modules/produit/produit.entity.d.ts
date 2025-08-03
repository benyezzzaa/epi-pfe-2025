import { CategorieProduit } from '../categorie-produit/categorie-produit.entity';
import { Unite } from '../unite/unite.entity';
import { LigneCommande } from '../lignecommande/lignecommande.entity';
export declare class Produit {
    id: number;
    nom: string;
    description: string;
    tva: number;
    colisage: number;
    images: string[];
    prix_unitaire: number;
    categorieId: number;
    prix_unitaire_ttc: number;
    categorie: CategorieProduit;
    uniteId: number;
    unite: Unite;
    lignesCommande: LigneCommande[];
    isActive: boolean;
}
