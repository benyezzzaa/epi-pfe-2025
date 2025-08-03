import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Commande } from '../commande/commande.entity';
import { LigneCommande } from '../lignecommande/lignecommande.entity';
import { Produit } from '../produit/produit.entity';
import { CategorieProduit } from '../categorie-produit/categorie-produit.entity';
import { Client } from '../client/client.entity';
import axios from 'axios';

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

@Injectable()
export class AiPredictionService {
  private readonly aiServiceUrl = process.env.AI_SERVICE_URL || 'http://localhost:8000';

  constructor(
    @InjectRepository(Commande)
    private commandeRepository: Repository<Commande>,
    @InjectRepository(LigneCommande)
    private ligneCommandeRepository: Repository<LigneCommande>,
    @InjectRepository(Produit)
    private produitRepository: Repository<Produit>,
    @InjectRepository(CategorieProduit)
    private categorieRepository: Repository<CategorieProduit>,
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}

  async getPredictions(request: PredictionRequest = {}): Promise<PredictionResponse> {
    try {
      const response = await axios.get(`${this.aiServiceUrl}/predict`, {
        params: {
          top_n: request.top_n || 10,
        },
      });

      return response.data;
    } catch (error) {
      console.error('Error calling AI service:', error);
      throw new HttpException(
        'Failed to get predictions from AI service',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async retrainModels(): Promise<{ message: string }> {
    try {
      const response = await axios.post(`${this.aiServiceUrl}/retrain`);
      return response.data;
    } catch (error) {
      console.error('Error retraining models:', error);
      throw new HttpException(
        'Failed to retrain AI models',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async getHealthStatus(): Promise<{ status: string; models_loaded: boolean; timestamp: string }> {
    try {
      const response = await axios.get(`${this.aiServiceUrl}/health`);
      return response.data;
    } catch (error) {
      console.error('Error checking AI service health:', error);
      return {
        status: 'unhealthy',
        models_loaded: false,
        timestamp: new Date().toISOString(),
      };
    }
  }

  async getSalesAnalytics(): Promise<any> {
    try {
      // Get sales data for analytics
      const commandes = await this.commandeRepository.find({
        relations: ['lignesCommande', 'lignesCommande.produit', 'lignesCommande.produit.categorie'],
      });

      const salesData = commandes.map(commande => ({
        id: commande.id,
        date_creation: commande.dateCreation,
        client_id: commande.client?.id,
        prix_total_ttc: commande.prix_total_ttc,
        statut: commande.statut,
        lignes: commande.lignesCommande.map(ligne => ({
          id: ligne.id,
          commande_id: ligne.commande.id,
          produit_id: ligne.produit.id,
          quantite: ligne.quantite,
          total: ligne.total,
        })),
      }));

      return {
        total_orders: commandes.length,
        total_revenue: commandes.reduce((sum, cmd) => sum + cmd.prix_total_ttc, 0),
        sales_data: salesData,
      };
    } catch (error) {
      console.error('Error getting sales analytics:', error);
      throw new HttpException(
        'Failed to get sales analytics',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async getTopProductsByPeriod(period: 'week' | 'month' | 'quarter' = 'month'): Promise<any[]> {
    try {
      const dateFilter = this.getDateFilter(period);
      
      const topProducts = await this.ligneCommandeRepository
        .createQueryBuilder('ligne')
        .leftJoinAndSelect('ligne.produit', 'produit')
        .leftJoinAndSelect('ligne.commande', 'commande')
        .where('commande.dateCreation >= :dateFilter', { dateFilter })
        .select([
          'produit.id as product_id',
          'produit.nom as product_name',
          'SUM(ligne.quantite) as total_quantity',
          'SUM(ligne.total) as total_revenue',
        ])
        .groupBy('produit.id, produit.nom')
        .orderBy('total_quantity', 'DESC')
        .limit(10)
        .getRawMany();

      return topProducts;
    } catch (error) {
      console.error('Error getting top products:', error);
      throw new HttpException(
        'Failed to get top products',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async getTopCategoriesByPeriod(period: 'week' | 'month' | 'quarter' = 'month'): Promise<any[]> {
    try {
      const dateFilter = this.getDateFilter(period);
      
      const topCategories = await this.ligneCommandeRepository
        .createQueryBuilder('ligne')
        .leftJoinAndSelect('ligne.produit', 'produit')
        .leftJoinAndSelect('produit.categorie', 'categorie')
        .leftJoinAndSelect('ligne.commande', 'commande')
        .where('commande.dateCreation >= :dateFilter', { dateFilter })
        .select([
          'categorie.id as category_id',
          'categorie.nom as category_name',
          'SUM(ligne.quantite) as total_quantity',
          'SUM(ligne.total) as total_revenue',
        ])
        .groupBy('categorie.id, categorie.nom')
        .orderBy('total_quantity', 'DESC')
        .limit(10)
        .getRawMany();

      return topCategories;
    } catch (error) {
      console.error('Error getting top categories:', error);
      throw new HttpException(
        'Failed to get top categories',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  private getDateFilter(period: 'week' | 'month' | 'quarter'): Date {
    const now = new Date();
    switch (period) {
      case 'week':
        return new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
      case 'month':
        return new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
      case 'quarter':
        return new Date(now.getTime() - 90 * 24 * 60 * 60 * 1000);
      default:
        return new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
    }
  }
} 