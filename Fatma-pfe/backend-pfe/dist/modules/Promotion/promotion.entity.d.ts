export declare class Promotion {
    id: number;
    titre: string;
    promotion: Promotion;
    description: string;
    tauxReduction: number;
    dateDebut: Date;
    dateFin: Date;
    isActive: boolean;
}
