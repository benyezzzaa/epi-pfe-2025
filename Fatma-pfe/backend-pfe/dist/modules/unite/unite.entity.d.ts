import { Produit } from '../produit/produit.entity';
export declare class Unite {
    id: number;
    nom: string;
    isActive: boolean;
    produits: Produit[];
}
