import { Produit } from '../produit/produit.entity';
export declare class CategorieProduit {
    id: number;
    nom: string;
    produits: Produit[];
    isActive: boolean;
}
