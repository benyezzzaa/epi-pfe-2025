"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AiPredictionController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const ai_prediction_service_1 = require("./ai-prediction.service");
let AiPredictionController = class AiPredictionController {
    aiPredictionService;
    constructor(aiPredictionService) {
        this.aiPredictionService = aiPredictionService;
    }
    async getPredictions(daysAhead, topN) {
        try {
            const request = {
                days_ahead: daysAhead || 30,
                top_n: topN || 10,
            };
            const predictions = await this.aiPredictionService.getPredictions(request);
            return {
                success: true,
                data: predictions,
                timestamp: new Date().toISOString(),
            };
        }
        catch (error) {
            throw new common_1.HttpException('Failed to get predictions', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async retrainModels() {
        try {
            const result = await this.aiPredictionService.retrainModels();
            return {
                success: true,
                message: result.message,
                timestamp: new Date().toISOString(),
            };
        }
        catch (error) {
            throw new common_1.HttpException('Failed to retrain models', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getHealthStatus() {
        try {
            const health = await this.aiPredictionService.getHealthStatus();
            return {
                success: true,
                data: health,
                timestamp: new Date().toISOString(),
            };
        }
        catch (error) {
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
    async getSalesAnalytics() {
        try {
            const analytics = await this.aiPredictionService.getSalesAnalytics();
            return {
                success: true,
                data: analytics,
                timestamp: new Date().toISOString(),
            };
        }
        catch (error) {
            throw new common_1.HttpException('Failed to get sales analytics', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getTopProducts(period = 'month') {
        try {
            const topProducts = await this.aiPredictionService.getTopProductsByPeriod(period);
            return {
                success: true,
                data: topProducts,
                period,
                timestamp: new Date().toISOString(),
            };
        }
        catch (error) {
            throw new common_1.HttpException('Failed to get top products', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getTopCategories(period = 'month') {
        try {
            const topCategories = await this.aiPredictionService.getTopCategoriesByPeriod(period);
            return {
                success: true,
                data: topCategories,
                period,
                timestamp: new Date().toISOString(),
            };
        }
        catch (error) {
            throw new common_1.HttpException('Failed to get top categories', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
};
exports.AiPredictionController = AiPredictionController;
__decorate([
    (0, common_1.Get)('predict'),
    (0, swagger_1.ApiOperation)({ summary: 'Get AI predictions for top products and categories' }),
    (0, swagger_1.ApiQuery)({ name: 'days_ahead', required: false, type: Number, description: 'Number of days to predict ahead' }),
    (0, swagger_1.ApiQuery)({ name: 'top_n', required: false, type: Number, description: 'Number of top items to return' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Predictions retrieved successfully' }),
    (0, swagger_1.ApiResponse)({ status: 500, description: 'Internal server error' }),
    __param(0, (0, common_1.Query)('days_ahead')),
    __param(1, (0, common_1.Query)('top_n')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, Number]),
    __metadata("design:returntype", Promise)
], AiPredictionController.prototype, "getPredictions", null);
__decorate([
    (0, common_1.Post)('retrain'),
    (0, swagger_1.ApiOperation)({ summary: 'Retrain AI models with latest data' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Models retrained successfully' }),
    (0, swagger_1.ApiResponse)({ status: 500, description: 'Failed to retrain models' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], AiPredictionController.prototype, "retrainModels", null);
__decorate([
    (0, common_1.Get)('health'),
    (0, swagger_1.ApiOperation)({ summary: 'Check AI service health status' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Health status retrieved' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], AiPredictionController.prototype, "getHealthStatus", null);
__decorate([
    (0, common_1.Get)('analytics/sales'),
    (0, swagger_1.ApiOperation)({ summary: 'Get sales analytics data' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Sales analytics retrieved successfully' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], AiPredictionController.prototype, "getSalesAnalytics", null);
__decorate([
    (0, common_1.Get)('analytics/top-products'),
    (0, swagger_1.ApiOperation)({ summary: 'Get top products by period' }),
    (0, swagger_1.ApiQuery)({ name: 'period', required: false, enum: ['week', 'month', 'quarter'], description: 'Time period for analysis' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Top products retrieved successfully' }),
    __param(0, (0, common_1.Query)('period')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], AiPredictionController.prototype, "getTopProducts", null);
__decorate([
    (0, common_1.Get)('analytics/top-categories'),
    (0, swagger_1.ApiOperation)({ summary: 'Get top categories by period' }),
    (0, swagger_1.ApiQuery)({ name: 'period', required: false, enum: ['week', 'month', 'quarter'], description: 'Time period for analysis' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Top categories retrieved successfully' }),
    __param(0, (0, common_1.Query)('period')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], AiPredictionController.prototype, "getTopCategories", null);
exports.AiPredictionController = AiPredictionController = __decorate([
    (0, swagger_1.ApiTags)('AI Predictions'),
    (0, common_1.Controller)('api/ai-predictions'),
    __metadata("design:paramtypes", [ai_prediction_service_1.AiPredictionService])
], AiPredictionController);
//# sourceMappingURL=ai-prediction.controller.js.map