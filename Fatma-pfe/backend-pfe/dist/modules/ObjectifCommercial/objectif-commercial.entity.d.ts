import { User } from '../users/users.entity';
export declare class ObjectifCommercial {
    id: number;
    commercial: User | null;
    dateDebut: Date;
    dateFin: Date;
    totalVentes: number;
    montantCible: number;
    categorieProduit?: string;
    prime: number;
    atteint: boolean;
    mission?: string;
    ventes: number;
    bonus?: number;
    pourcentageCible?: number;
    isActive: boolean;
}
