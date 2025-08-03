import { User } from '../users/users.entity';
import { Commande } from '../commande/commande.entity';
import { CategorieClient } from './categorie-client.entity';
export declare class Client {
    id: number;
    latitude: number;
    longitude: number;
    nom: string;
    prenom: string;
    email: string;
    telephone: string;
    codeFiscale?: string;
    adresse: string;
    importance: number;
    isActive: boolean;
    commandes: Commande[];
    commercial: User;
    categorie?: CategorieClient;
}
