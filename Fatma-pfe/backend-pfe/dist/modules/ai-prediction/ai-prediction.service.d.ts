import { Repository } from 'typeorm';
import { Commande } from '../commande/commande.entity';
import { LigneCommande } from '../lignecommande/lignecommande.entity';
import { Produit } from '../produit/produit.entity';
import { CategorieProduit } from '../categorie-produit/categorie-produit.entity';
import { Client } from '../client/client.entity';
export interface PredictionRequest {
    days_ahead?: number;
    top_n?: number;
}
export interface PredictionResponse {
    top_products: Array<{
        product_id: number;
        product_name: string;
        category_id: number;
        predicted_sales: number;
        current_price: number;
        confidence: number;
    }>;
    top_categories: Array<{
        category_id: number;
        category_name: string;
        predicted_sales: number;
        confidence: number;
    }>;
    seasonal_trends: {
        monthly_trends: Record<string, number>;
        quarterly_trends: Record<string, number>;
        peak_months: number[];
        low_months: number[];
    };
    confidence_scores: {
        product_model: number;
        category_model: number;
        data_quality: number;
    };
}
export declare class AiPredictionService {
    private commandeRepository;
    private ligneCommandeRepository;
    private produitRepository;
    private categorieRepository;
    private clientRepository;
    private readonly aiServiceUrl;
    constructor(commandeRepository: Repository<Commande>, ligneCommandeRepository: Repository<LigneCommande>, produitRepository: Repository<Produit>, categorieRepository: Repository<CategorieProduit>, clientRepository: Repository<Client>);
    getPredictions(request?: PredictionRequest): Promise<PredictionResponse>;
    retrainModels(): Promise<{
        message: string;
    }>;
    getHealthStatus(): Promise<{
        status: string;
        models_loaded: boolean;
        timestamp: string;
    }>;
    getSalesAnalytics(): Promise<any>;
    getTopProductsByPeriod(period?: 'week' | 'month' | 'quarter'): Promise<any[]>;
    getTopCategoriesByPeriod(period?: 'week' | 'month' | 'quarter'): Promise<any[]>;
    private getDateFilter;
}
