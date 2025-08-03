import { Commande } from '../commande/commande.entity';
import { Produit } from '../produit/produit.entity';
import { User } from '../users/users.entity';
import { Repository } from 'typeorm';
export declare class DashboardService {
    private commandeRepository;
    private produitRepository;
    private userRepository;
    constructor(commandeRepository: Repository<Commande>, produitRepository: Repository<Produit>, userRepository: Repository<User>);
    getStats(): Promise<{
        totalCommandes: number;
        totalProduits: number;
        totalUtilisateurs: number;
    }>;
    getVentesParCommercial(): Promise<{
        commercial: any;
        total: number;
    }[]>;
    getVentesParCategorie(): Promise<{
        categorie: any;
        quantite: number;
    }[]>;
    getVentesParMois(): Promise<{
        mois: string;
        montant: number;
    }[]>;
}
