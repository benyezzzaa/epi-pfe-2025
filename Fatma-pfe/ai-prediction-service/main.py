from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import psycopg2
from psycopg2.extras import RealDictCursor
import logging
from sklearn.ensemble import RandomForestRegressor
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
import joblib
import os

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="AI Prediction Service", version="1.0.0")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic models
class ProductPrediction(BaseModel):
    product_name: str
    predicted_sales: float
    current_price_ttc: float
    historical_orders: int
    confidence_score: float

class CategoryPrediction(BaseModel):
    category_name: str
    predicted_sales: float
    historical_orders: int
    confidence_score: float

class ExpectedCommandes(BaseModel):
    expected_commandes: int
    historical_commandes: int
    avg_monthly_commandes: float
    growth_rate: float
    confidence_interval: Dict[str, float]

class PredictionResponse(BaseModel):
    success: bool
    data: Dict[str, Any]
    message: str
    timestamp: str

# Database connection
class DatabaseConnection:
    def __init__(self):
        self.connection_string = "postgresql://postgres:fatma@localhost:5432/postgres"
    
    def get_connection(self):
        return psycopg2.connect(self.connection_string)
    
    def test_connection(self):
        try:
            with self.get_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT 1")
                    return True
        except Exception as e:
            logger.error(f"Database connection failed: {e}")
            return False

# ML Models
class MLPredictionEngine:
    def __init__(self):
        self.product_model = None
        self.category_model = None
        self.commande_model = None
        self.product_scaler = StandardScaler()
        self.category_scaler = StandardScaler()
        self.commande_scaler = StandardScaler()
        self.label_encoders = {}
        self.feature_names = {}  # Store feature names for each model
        self.models_trained = False
        
    def prepare_features(self, df):
        """Prepare features for ML models"""
        features = df.copy()
        
        # Convert dates to features
        if 'date_creation' in features.columns:
            features['date_creation'] = pd.to_datetime(features['date_creation'])
            features['month'] = features['date_creation'].dt.month
            features['day_of_week'] = features['date_creation'].dt.dayofweek
            features['quarter'] = features['date_creation'].dt.quarter
            features['year'] = features['date_creation'].dt.year
        
        # Encode categorical variables
        categorical_cols = ['statut', 'product_name', 'category_name']
        for col in categorical_cols:
            if col in features.columns:
                if col not in self.label_encoders:
                    self.label_encoders[col] = LabelEncoder()
                    features[col] = self.label_encoders[col].fit_transform(features[col].astype(str))
                else:
                    # Handle unseen categories
                    features[col] = features[col].astype(str).map(
                        lambda x: x if x in self.label_encoders[col].classes_ else 'unknown'
                    )
                    features[col] = self.label_encoders[col].transform(features[col])
        
        # Create interaction features
        if 'quantite' in features.columns and 'prix_unitaire' in features.columns:
            features['total_value'] = features['quantite'] * features['prix_unitaire']
        
        if 'client_importance' in features.columns and 'quantite' in features.columns:
            features['importance_quantity'] = features['client_importance'] * features['quantite']
        
        return features
    
    def train_product_model(self, data):
        """Train model for product sales prediction"""
        try:
            features = self.prepare_features(data)
            
            # Select features for product prediction
            feature_cols = ['month', 'day_of_week', 'quarter', 'year', 'prix_unitaire', 
                          'prix_unitaire_ttc', 'client_importance', 'statut', 'product_name']
            feature_cols = [col for col in feature_cols if col in features.columns]
            
            # Store feature names for prediction
            self.feature_names['product'] = feature_cols
            
            X = features[feature_cols].fillna(0)
            y = features['quantite'].fillna(0)
            
            # Split data
            X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
            
            # Scale features
            X_train_scaled = self.product_scaler.fit_transform(X_train)
            X_test_scaled = self.product_scaler.transform(X_test)
            
            # Train Random Forest model
            self.product_model = RandomForestRegressor(
                n_estimators=100,
                max_depth=10,
                random_state=42,
                n_jobs=-1
            )
            self.product_model.fit(X_train_scaled, y_train)
            
            # Evaluate model
            y_pred = self.product_model.predict(X_test_scaled)
            mse = mean_squared_error(y_test, y_pred)
            r2 = r2_score(y_test, y_pred)
            
            logger.info(f"Product model trained - MSE: {mse:.4f}, R²: {r2:.4f}")
            return True
            
        except Exception as e:
            logger.error(f"Error training product model: {e}")
            return False
    
    def train_category_model(self, data):
        """Train model for category sales prediction"""
        try:
            features = self.prepare_features(data)
            
            # Aggregate by category and date
            category_data = features.groupby(['category_name', 'month', 'quarter', 'year']).agg({
                'quantite': 'sum',
                'prix_unitaire': 'mean',
                'prix_unitaire_ttc': 'mean',
                'client_importance': 'mean'
            }).reset_index()
            
            feature_cols = ['month', 'quarter', 'year', 'prix_unitaire', 'prix_unitaire_ttc', 'client_importance']
            feature_cols = [col for col in feature_cols if col in category_data.columns]
            
            # Store feature names for prediction
            self.feature_names['category'] = feature_cols
            
            X = category_data[feature_cols].fillna(0)
            y = category_data['quantite'].fillna(0)
            
            # Split data
            X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
            
            # Scale features
            X_train_scaled = self.category_scaler.fit_transform(X_train)
            X_test_scaled = self.category_scaler.transform(X_test)
            
            # Train model
            self.category_model = RandomForestRegressor(
                n_estimators=100,
                max_depth=8,
                random_state=42,
                n_jobs=-1
            )
            self.category_model.fit(X_train_scaled, y_train)
            
            # Evaluate model
            y_pred = self.category_model.predict(X_test_scaled)
            mse = mean_squared_error(y_test, y_pred)
            r2 = r2_score(y_test, y_pred)
            
            logger.info(f"Category model trained - MSE: {mse:.4f}, R²: {r2:.4f}")
            return True
            
        except Exception as e:
            logger.error(f"Error training category model: {e}")
            return False
    
    def train_commande_model(self, data):
        """Train model for commande prediction"""
        try:
            features = self.prepare_features(data)
            
            # Aggregate by date
            daily_data = features.groupby(['date_creation']).agg({
                'quantite': 'sum',
                'prix_unitaire': 'mean',
                'client_importance': 'mean',
                'statut': 'count'  # Number of orders per day
            }).reset_index()
            
            daily_data['date_creation'] = pd.to_datetime(daily_data['date_creation'])
            daily_data['month'] = daily_data['date_creation'].dt.month
            daily_data['day_of_week'] = daily_data['date_creation'].dt.dayofweek
            daily_data['quarter'] = daily_data['date_creation'].dt.quarter
            daily_data['year'] = daily_data['date_creation'].dt.year
            
            feature_cols = ['month', 'day_of_week', 'quarter', 'year', 'quantite', 'prix_unitaire', 'client_importance']
            feature_cols = [col for col in feature_cols if col in daily_data.columns]
            
            # Store feature names for prediction
            self.feature_names['commande'] = feature_cols
            
            X = daily_data[feature_cols].fillna(0)
            y = daily_data['statut'].fillna(0)  # Number of orders
            
            # Split data
            X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
            
            # Scale features
            X_train_scaled = self.commande_scaler.fit_transform(X_train)
            X_test_scaled = self.commande_scaler.transform(X_test)
            
            # Train model
            self.commande_model = LinearRegression()
            self.commande_model.fit(X_train_scaled, y_train)
            
            # Evaluate model
            y_pred = self.commande_model.predict(X_test_scaled)
            mse = mean_squared_error(y_test, y_pred)
            r2 = r2_score(y_test, y_pred)
            
            logger.info(f"Commande model trained - MSE: {mse:.4f}, R²: {r2:.4f}")
            return True
            
        except Exception as e:
            logger.error(f"Error training commande model: {e}")
            return False
    
    def predict_product_sales(self, product_data, next_month=1):
        """Predict sales for products in the next month"""
        if self.product_model is None or 'product' not in self.feature_names:
            return None
        
        try:
            # Prepare features for prediction
            prediction_features = product_data.copy()
            prediction_features['month'] = next_month
            prediction_features['quarter'] = (next_month - 1) // 3 + 1
            prediction_features['year'] = datetime.now().year
            prediction_features['day_of_week'] = 1  # Monday
            
            features = self.prepare_features(prediction_features)
            
            # Use the same feature columns as during training
            feature_cols = self.feature_names['product']
            feature_cols = [col for col in feature_cols if col in features.columns]
            
            X = features[feature_cols].fillna(0)
            X_scaled = self.product_scaler.transform(X)
            
            # Make predictions
            predictions = self.product_model.predict(X_scaled)
            
            # Calculate confidence scores (using model's feature importance)
            feature_importance = self.product_model.feature_importances_
            confidence_scores = np.mean(feature_importance) * np.ones(len(predictions))
            
            return list(zip(predictions, confidence_scores))
            
        except Exception as e:
            logger.error(f"Error predicting product sales: {e}")
            return None
    
    def predict_category_sales(self, category_data, next_month=1):
        """Predict sales for categories in the next month"""
        if self.category_model is None or 'category' not in self.feature_names:
            return None
        
        try:
            # Prepare features for prediction
            prediction_features = category_data.copy()
            prediction_features['month'] = next_month
            prediction_features['quarter'] = (next_month - 1) // 3 + 1
            prediction_features['year'] = datetime.now().year
            
            features = self.prepare_features(prediction_features)
            
            # Use the same feature columns as during training
            feature_cols = self.feature_names['category']
            feature_cols = [col for col in feature_cols if col in features.columns]
            
            X = features[feature_cols].fillna(0)
            X_scaled = self.category_scaler.transform(X)
            
            # Make predictions
            predictions = self.category_model.predict(X_scaled)
            
            # Calculate confidence scores
            feature_importance = self.category_model.feature_importances_
            confidence_scores = np.mean(feature_importance) * np.ones(len(predictions))
            
            return list(zip(predictions, confidence_scores))
            
        except Exception as e:
            logger.error(f"Error predicting category sales: {e}")
            return None
    
    def predict_commandes(self, commande_data, next_month=1):
        """Predict number of commandes for the next month"""
        if self.commande_model is None or 'commande' not in self.feature_names:
            return None
        
        try:
            # Prepare features for prediction
            prediction_features = commande_data.copy()
            prediction_features['month'] = next_month
            prediction_features['quarter'] = (next_month - 1) // 3 + 1
            prediction_features['year'] = datetime.now().year
            prediction_features['day_of_week'] = 1
            
            features = self.prepare_features(prediction_features)
            
            # Use the same feature columns as during training
            feature_cols = self.feature_names['commande']
            feature_cols = [col for col in feature_cols if col in features.columns]
            
            X = features[feature_cols].fillna(0)
            X_scaled = self.commande_scaler.transform(X)
            
            # Make predictions
            predictions = self.commande_model.predict(X_scaled)
            
            return predictions
            
        except Exception as e:
            logger.error(f"Error predicting commandes: {e}")
            return None

# Initialize components
db = DatabaseConnection()
ml_engine = MLPredictionEngine()

def get_sales_data():
    """Fetch sales data from database"""
    try:
        with db.get_connection() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                query = """
                SELECT 
                    c.date_creation,
                    c.statut,
                    c.id as commande_id,
                    c."clientId",
                    c."commercialId",
                    lc.quantite,
                    lc."prixUnitaire",
                    lc."prixUnitaireTTC",
                    lc."totalHT",
                    p.nom as product_name,
                    p.prix_unitaire,
                    p.prix_unitaire_ttc,
                    p."categorieId",
                    cp.nom as category_name,
                    cl.importance as client_importance
                FROM commande c
                JOIN ligne_commande lc ON c.id = lc.commande_id
                JOIN produit p ON lc.produit_id = p.id
                JOIN categorie_produit cp ON p."categorieId" = cp.id
                JOIN client cl ON c."clientId" = cl.id
                WHERE c.date_creation IS NOT NULL
                ORDER BY c.date_creation
                """
                cur.execute(query)
                data = cur.fetchall()
                return pd.DataFrame(data)
    except Exception as e:
        logger.error(f"Error fetching sales data: {e}")
        return pd.DataFrame()

def get_total_commandes():
    """Get total number of commandes from database"""
    try:
        with db.get_connection() as conn:
            with conn.cursor() as cur:
                query = "SELECT COUNT(*) as total FROM commande"
                cur.execute(query)
                result = cur.fetchone()
                return result[0] if result else 0
    except Exception as e:
        logger.error(f"Error fetching total commandes: {e}")
        return 0

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    db_status = db.test_connection()
    data_points = 0
    
    if db_status:
        try:
            df = get_sales_data()
            data_points = len(df)
        except:
            pass
    
    return {
        "status": "healthy" if db_status else "unhealthy",
        "database_status": "connected" if db_status else "disconnected",
        "data_points": data_points,
        "models_trained": ml_engine.models_trained,
        "timestamp": datetime.now().isoformat()
    }

@app.get("/predict")
async def predict(top_n: int = 10):
    """Generate predictions using ML models"""
    try:
        # Fetch data
        df = get_sales_data()
        if df.empty:
            raise HTTPException(status_code=500, detail="No data available for predictions")
        
        logger.info(f"Fetched {len(df)} data points for predictions")
        
        # Train models if not already trained
        if not ml_engine.models_trained:
            logger.info("Training ML models...")
            
            product_success = ml_engine.train_product_model(df)
            category_success = ml_engine.train_category_model(df)
            commande_success = ml_engine.train_commande_model(df)
            
            if product_success and category_success and commande_success:
                ml_engine.models_trained = True
                logger.info("All models trained successfully")
            else:
                logger.warning("Some models failed to train")
        
        # Get next month
        next_month = (datetime.now().month % 12) + 1
        
        # Predict top products
        product_predictions = ml_engine.predict_product_sales(df, next_month)
        if product_predictions and len(product_predictions) > 0:
            # Get unique products with their historical data
            product_summary = df.groupby('product_name').agg({
                'quantite': 'sum',
                'prix_unitaire_ttc': 'first'
            }).reset_index()
            
            # Add predictions (ensure we don't exceed the number of predictions)
            num_predictions = min(len(product_predictions), len(product_summary))
            product_summary['predicted_sales'] = [pred[0] for pred in product_predictions[:num_predictions]]
            product_summary['confidence_score'] = [pred[1] for pred in product_predictions[:num_predictions]]
            
            # Sort by predicted sales and get top N
            top_products = product_summary.nlargest(top_n, 'predicted_sales')
            
            top_products_data = []
            for _, row in top_products.iterrows():
                top_products_data.append({
                    "product_name": row['product_name'],
                    "predicted_sales": round(float(row['predicted_sales']), 2),
                    "current_price_ttc": round(float(row['prix_unitaire_ttc']), 2),
                    "historical_orders": int(row['quantite']),
                    "confidence_score": round(float(row['confidence_score']) * 100, 2)  # Convert to percentage
                })
        else:
            top_products_data = []
        
        # Predict top categories
        category_predictions = ml_engine.predict_category_sales(df, next_month)
        if category_predictions and len(category_predictions) > 0:
            # Get unique categories with their historical data
            category_summary = df.groupby('category_name').agg({
                'quantite': 'sum'
            }).reset_index()
            
            # Add predictions (ensure we don't exceed the number of predictions)
            num_predictions = min(len(category_predictions), len(category_summary))
            category_summary['predicted_sales'] = [pred[0] for pred in category_predictions[:num_predictions]]
            category_summary['confidence_score'] = [pred[1] for pred in category_predictions[:num_predictions]]
            
            # Sort by predicted sales and get top N
            top_categories = category_summary.nlargest(top_n, 'predicted_sales')
            
            top_categories_data = []
            for _, row in top_categories.iterrows():
                top_categories_data.append({
                    "category_name": row['category_name'],
                    "predicted_sales": round(float(row['predicted_sales']), 2),
                    "historical_orders": int(row['quantite']),
                    "confidence_score": round(float(row['confidence_score']) * 100, 2)  # Convert to percentage
                })
        else:
            top_categories_data = []
        
        # Predict commandes based on previous month only
        # Count total commands (all commandes in database)
        total_commandes = get_total_commandes()  # Total number of commandes from database
        
        # Calculate previous month commandes
        current_month = datetime.now().month
        previous_month = (current_month - 1) if current_month > 1 else 12
        previous_month_year = datetime.now().year if current_month > 1 else datetime.now().year - 1
        
        # Filter data for previous month
        previous_month_data = df[
            (df['date_creation'].dt.month == previous_month) & 
            (df['date_creation'].dt.year == previous_month_year)
        ]
        previous_month_commandes = len(previous_month_data['commande_id'].unique())  # Unique commandes in previous month
        
        # Simple prediction based on previous month with small growth
        if previous_month_commandes > 0:
            # Add 10% growth to previous month
            expected_commandes = int(previous_month_commandes * 1.1)
        else:
            # If no previous month data, use a default value
            expected_commandes = 5
        
        # Calculate growth rate based on previous month only
        growth_rate = (expected_commandes - previous_month_commandes) / max(1, previous_month_commandes)
        
        expected_commandes_data = {
            "expected_commandes": int(expected_commandes),  # Integer
            "total_commandes": int(total_commandes),  # Total command lines
            "previous_month_commandes": int(previous_month_commandes),  # Previous month commandes
            "growth_rate": round(growth_rate * 100, 2),  # Convert to percentage with 2 decimals
            "confidence_interval": {
                "lower": int(expected_commandes * 0.8),
                "upper": int(expected_commandes * 1.2)
            }
        }
        
        # Analysis summary
        analysis_summary = {
            "total_products_analyzed": len(df['product_name'].unique()),
            "total_orders_analyzed": len(df['commande_id'].unique()),  # Total orders, not unique dates
            "total_categories_analyzed": len(df['category_name'].unique()),
            "data_points_used": len(df),
            "date_range": {
                "from": df['date_creation'].min().strftime('%Y-%m-%d'),
                "to": df['date_creation'].max().strftime('%Y-%m-%d')
            }
        }
        
        # Debug logging
        logger.info(f"Expected commandes data: {expected_commandes_data}")
        logger.info(f"Previous month commandes: {previous_month_commandes}")
        logger.info(f"Total commandes: {total_commandes}")
        logger.info(f"Expected commandes: {expected_commandes}")
        
        return PredictionResponse(
            success=True,
            data={
                "top_products": top_products_data,
                "top_categories": top_categories_data,
                "expected_commandes": expected_commandes_data,
                "analysis_summary": analysis_summary
            },
            message=f"Predictions generated successfully using {len(df)} data points with ML models",
            timestamp=datetime.now().isoformat()
        )
        
    except Exception as e:
        logger.error(f"Error generating predictions: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/retrain")
async def retrain_models():
    """Retrain all ML models"""
    try:
        # Reset models
        ml_engine.models_trained = False
        ml_engine.product_model = None
        ml_engine.category_model = None
        ml_engine.commande_model = None
        ml_engine.feature_names = {}  # Reset feature names
        
        # Fetch fresh data
        df = get_sales_data()
        if df.empty:
            raise HTTPException(status_code=500, detail="No data available for training")
        
        # Train models
        product_success = ml_engine.train_product_model(df)
        category_success = ml_engine.train_category_model(df)
        commande_success = ml_engine.train_commande_model(df)
        
        if product_success and category_success and commande_success:
            ml_engine.models_trained = True
            return {
                "success": True,
                "message": "Models retrained successfully",
                "data_points_used": len(df),
                "timestamp": datetime.now().isoformat()
            }
        else:
            return {
                "success": False,
                "message": "Some models failed to train",
                "timestamp": datetime.now().isoformat()
            }
            
    except Exception as e:
        logger.error(f"Error retraining models: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 