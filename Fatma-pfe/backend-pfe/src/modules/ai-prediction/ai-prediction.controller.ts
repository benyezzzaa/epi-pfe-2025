import { Controller, Get, Post, Query, HttpStatus, HttpException } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiQuery } from '@nestjs/swagger';
import { AiPredictionService, PredictionRequest } from './ai-prediction.service';

@ApiTags('AI Predictions')
@Controller('api/ai-predictions')
export class AiPredictionController {
  constructor(private readonly aiPredictionService: AiPredictionService) {}

  @Get('predict')
  @ApiOperation({ summary: 'Get AI predictions for top products and categories' })
  @ApiQuery({ name: 'days_ahead', required: false, type: Number, description: 'Number of days to predict ahead' })
  @ApiQuery({ name: 'top_n', required: false, type: Number, description: 'Number of top items to return' })
  @ApiResponse({ status: 200, description: 'Predictions retrieved successfully' })
  @ApiResponse({ status: 500, description: 'Internal server error' })
  async getPredictions(
    @Query('days_ahead') daysAhead?: number,
    @Query('top_n') topN?: number,
  ) {
    try {
      const request: PredictionRequest = {
        days_ahead: daysAhead || 30,
        top_n: topN || 10,
      };

      const predictions = await this.aiPredictionService.getPredictions(request);
      return {
        success: true,
        data: predictions,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      throw new HttpException(
        'Failed to get predictions',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Post('retrain')
  @ApiOperation({ summary: 'Retrain AI models with latest data' })
  @ApiResponse({ status: 200, description: 'Models retrained successfully' })
  @ApiResponse({ status: 500, description: 'Failed to retrain models' })
  async retrainModels() {
    try {
      const result = await this.aiPredictionService.retrainModels();
      return {
        success: true,
        message: result.message,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      throw new HttpException(
        'Failed to retrain models',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('health')
  @ApiOperation({ summary: 'Check AI service health status' })
  @ApiResponse({ status: 200, description: 'Health status retrieved' })
  async getHealthStatus() {
    try {
      const health = await this.aiPredictionService.getHealthStatus();
      return {
        success: true,
        data: health,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      return {
        success: false,
        data: {
          status: 'unhealthy',
          models_loaded: false,
          timestamp: new Date().toISOString(),
        },
        timestamp: new Date().toISOString(),
      };
    }
  }

  @Get('analytics/sales')
  @ApiOperation({ summary: 'Get sales analytics data' })
  @ApiResponse({ status: 200, description: 'Sales analytics retrieved successfully' })
  async getSalesAnalytics() {
    try {
      const analytics = await this.aiPredictionService.getSalesAnalytics();
      return {
        success: true,
        data: analytics,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      throw new HttpException(
        'Failed to get sales analytics',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('analytics/top-products')
  @ApiOperation({ summary: 'Get top products by period' })
  @ApiQuery({ name: 'period', required: false, enum: ['week', 'month', 'quarter'], description: 'Time period for analysis' })
  @ApiResponse({ status: 200, description: 'Top products retrieved successfully' })
  async getTopProducts(@Query('period') period: 'week' | 'month' | 'quarter' = 'month') {
    try {
      const topProducts = await this.aiPredictionService.getTopProductsByPeriod(period);
      return {
        success: true,
        data: topProducts,
        period,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      throw new HttpException(
        'Failed to get top products',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('analytics/top-categories')
  @ApiOperation({ summary: 'Get top categories by period' })
  @ApiQuery({ name: 'period', required: false, enum: ['week', 'month', 'quarter'], description: 'Time period for analysis' })
  @ApiResponse({ status: 200, description: 'Top categories retrieved successfully' })
  async getTopCategories(@Query('period') period: 'week' | 'month' | 'quarter' = 'month') {
    try {
      const topCategories = await this.aiPredictionService.getTopCategoriesByPeriod(period);
      return {
        success: true,
        data: topCategories,
        period,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      throw new HttpException(
        'Failed to get top categories',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
} 