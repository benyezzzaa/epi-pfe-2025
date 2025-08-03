import { AiPredictionService } from './ai-prediction.service';
export declare class AiPredictionController {
    private readonly aiPredictionService;
    constructor(aiPredictionService: AiPredictionService);
    getPredictions(daysAhead?: number, topN?: number): Promise<{
        success: boolean;
        data: import("./ai-prediction.service").PredictionResponse;
        timestamp: string;
    }>;
    retrainModels(): Promise<{
        success: boolean;
        message: string;
        timestamp: string;
    }>;
    getHealthStatus(): Promise<{
        success: boolean;
        data: {
            status: string;
            models_loaded: boolean;
            timestamp: string;
        };
        timestamp: string;
    }>;
    getSalesAnalytics(): Promise<{
        success: boolean;
        data: any;
        timestamp: string;
    }>;
    getTopProducts(period?: 'week' | 'month' | 'quarter'): Promise<{
        success: boolean;
        data: any[];
        period: "month" | "week" | "quarter";
        timestamp: string;
    }>;
    getTopCategories(period?: 'week' | 'month' | 'quarter'): Promise<{
        success: boolean;
        data: any[];
        period: "month" | "week" | "quarter";
        timestamp: string;
    }>;
}
