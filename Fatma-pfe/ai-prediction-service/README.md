# AI Prediction Service

This service provides AI-powered predictions for e-commerce data using statistical analysis and trend detection.

## Features

- **Top Products Prediction**: Predicts the best-selling products for the next month
- **Top Categories Prediction**: Predicts the most popular product categories
- **Expected Orders Prediction**: Forecasts the total number of orders expected

## Technology Stack

- **FastAPI**: Modern Python web framework
- **Pandas**: Data manipulation and analysis
- **PostgreSQL**: Database for storing sales data
- **NumPy**: Numerical computations

## Installation

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

2. Make sure your PostgreSQL database is running and accessible

3. Update database connection settings in `database.py` if needed

## Usage

### Start the Service

```bash
python main.py
```

The service will start on `http://localhost:8000`

### API Endpoints

- `GET /health` - Health check and system status
- `GET /test` - Test database connection and data fetching
- `GET /predict?top_n=10` - Get predictions (top_n is optional, default=10)
- `POST /retrain` - Retrain models with latest data

### Example Response

```json
{
  "success": true,
  "data": {
    "top_products": [...],
    "top_categories": [...],
    "expected_commandes": {...},
    "analysis_summary": {...}
  },
  "message": "Predictions generated successfully"
}
```

## How It Works

### Prediction Algorithm

The service uses the following approach for predictions:

- **Historical Analysis**: Analyzes past sales data by month
- **Trend Detection**: Calculates average monthly quantities and orders
- **Growth Projection**: Applies a 10% growth factor for next month predictions
- **Fallback Strategy**: Uses deterministic defaults for products/categories with no historical data

### Features Used

- **Monthly aggregation**: Groups sales data by month
- **Average calculations**: Computes mean quantities and orders per month
- **Growth factors**: Applies business growth assumptions
- **Deterministic defaults**: Uses product/category IDs for consistent fallback values

### Deterministic Results

All predictions are fixed and reproducible:
- Fixed random seed (42)
- Fixed prediction date (2024-12-15 10:30:00)
- No random factors in calculations

## File Structure

```
ai-prediction-service/
├── main.py              # Main FastAPI application
├── database.py          # Database connection and queries
├── requirements.txt     # Python dependencies
└── README.md           # This file
```

## Integration

This service is designed to work with:
- **NestJS Backend**: Handles API routing and integration
- **React Frontend**: Displays predictions in a dashboard
- **PostgreSQL Database**: Stores sales and order data

## Model Performance

The statistical approach provides:
- ✅ **Reliable predictions** based on historical data
- ✅ **Trend detection** in sales patterns
- ✅ **Fast computation** without complex ML dependencies
- ✅ **Robust fallbacks** when data is insufficient
- ✅ **Fixed predictions** that don't change on refresh 