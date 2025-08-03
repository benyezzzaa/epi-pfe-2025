import { Client } from '../client/client.entity';
import { Visite } from '../Visite/visite.entity';
import { Commande } from '../commande/commande.entity';
export declare class User {
    id: number;
    nom: string;
    adresse: string;
    prenom: string;
    email: string;
    password: string;
    tel: string;
    role: string;
    latitude: number;
    longitude: number;
    isActive: boolean;
    clients: Client[];
    visites: Visite[];
    commandes: Commande[];
}
