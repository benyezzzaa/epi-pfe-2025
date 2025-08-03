export declare class ModificationDto {
    champ: string;
    ancienneValeur: string;
    nouvelleValeur: string;
    date: Date;
}
export declare class NotificationCommandeDto {
    commandeId: number;
    numeroCommande: string;
    date: Date;
    modifications: ModificationDto[];
}
