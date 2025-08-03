import { DashboardService } from '../dashboard/dashboard.service';
export declare class DashboardController {
    private readonly dashboardService;
    constructor(dashboardService: DashboardService);
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
