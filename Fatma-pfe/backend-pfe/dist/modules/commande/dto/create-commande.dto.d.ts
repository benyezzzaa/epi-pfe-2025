declare class LigneCommandeDto {
    produitId: number;
    quantite: number;
}
export declare class CreateCommandeDto {
    numeroCommande?: string;
    clientId: number;
    lignesCommande: LigneCommandeDto[];
    promotionId?: number;
}
export {};
