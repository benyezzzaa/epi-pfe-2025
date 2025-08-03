from sqlalchemy import create_engine, text
import pandas as pd
from typing import List, Dict
import os

class DatabaseConnection:
    def __init__(self):
        # Database connection string - matching NestJS backend configuration
        self.connection_string = (
            "postgresql://postgres:fatma@localhost:5432/postgres"
        )
        self.engine = create_engine(self.connection_string)
        print(f"🔗 Connecting to database: {self.connection_string}")
    
    def test_connection(self) -> bool:
        """Test if we can connect to the database"""
        try:
            with self.engine.connect() as conn:
                result = conn.execute(text("SELECT 1"))
                print("✅ Database connection successful")
                return True
        except Exception as e:
            print(f"❌ Database connection failed: {e}")
            return False
    
    def get_sales_data(self) -> pd.DataFrame:
        """Fetch ALL sales data from the database based on actual entity structure"""
        query = """
        SELECT 
            c.id as commande_id,
            c.numero_commande,
            c.date_creation,
            c.prix_total_ttc,
            c.prix_hors_taxe,
            c.tva,
            c.statut,
            c.date_validation,
            lc.id as ligne_id,
            lc.quantite,
            lc.total,
            lc.tva as ligne_tva,
            lc."prixUnitaire",
            lc."prixUnitaireTTC",
            lc."totalHT",
            p.id as produit_id,
            p.nom as produit_nom,
            p.description as produit_description,
            p.prix_unitaire as produit_prix_unitaire,
            p.prix_unitaire_ttc as produit_prix_ttc,
            p.tva as produit_tva,
            p.colisage,
            p.isactive as produit_active,
            cp.id as categorie_id,
            cp.nom as categorie_nom,
            cp."isActive" as categorie_active,
            cl.id as client_id,
            cl.nom as client_nom,
            cl.prenom as client_prenom,
            cl.email as client_email,
            cl.importance as client_importance,
            u.id as commercial_id,
            u.nom as commercial_nom,
            u.prenom as commercial_prenom
        FROM commande c
        LEFT JOIN "ligne_commande" lc ON c.id = lc."commande_id"
        LEFT JOIN produit p ON lc."produit_id" = p.id
        LEFT JOIN "categorie_produit" cp ON p."categorieId" = cp.id
        LEFT JOIN client cl ON c."clientId" = cl.id
        LEFT JOIN users u ON c."commercialId" = u.id
        WHERE c.statut IN ('livrée', 'validée', 'validee', 'en_cours')
        AND p.isactive = true
        AND cp."isActive" = true
        ORDER BY c.date_creation DESC
        """
        
        try:
            print("📊 Fetching ALL historical sales data...")
            df = pd.read_sql(query, self.engine)
            print(f"✅ Found {len(df)} total sales records from all time")
            if len(df) > 0:
                print(f"   Date range: {df['date_creation'].min()} to {df['date_creation'].max()}")
                print(f"   Unique products: {len(df['produit_id'].unique())}")
                print(f"   Unique orders: {len(df['commande_id'].unique())}")
            return df
        except Exception as e:
            print(f"❌ Error fetching sales data: {e}")
            return pd.DataFrame()
    
    def get_products_data(self) -> List[Dict]:
        """Fetch ALL products data based on actual entity structure"""
        query = """
        SELECT 
            p.id,
            p.nom,
            p.description,
            p.prix_unitaire,
            p.prix_unitaire_ttc,
            p.tva,
            p.colisage,
            p.isactive,
            cp.id as categorie_id,
            cp.nom as categorie_nom,
            cp."isActive" as categorie_active,
            u.id as unite_id,
            u.nom as unite_nom
        FROM produit p
        LEFT JOIN "categorie_produit" cp ON p."categorieId" = cp.id
        LEFT JOIN unite u ON p."uniteId" = u.id
        WHERE p.isactive = true AND cp."isActive" = true
        """
        
        try:
            print("📦 Fetching ALL products data...")
            df = pd.read_sql(query, self.engine)
            print(f"✅ Found {len(df)} total products")
            return df.to_dict('records')
        except Exception as e:
            print(f"❌ Error fetching products data: {e}")
            return []
    
    def get_categories_data(self) -> List[Dict]:
        """Fetch ALL categories data based on actual entity structure"""
        query = """
        SELECT 
            id,
            nom,
            "isActive"
        FROM "categorie_produit"
        WHERE "isActive" = true
        """
        
        try:
            print("🏷️ Fetching ALL categories data...")
            df = pd.read_sql(query, self.engine)
            print(f"✅ Found {len(df)} total categories")
            return df.to_dict('records')
        except Exception as e:
            print(f"❌ Error fetching categories data: {e}")
            return []
    
    def get_monthly_sales(self) -> Dict:
        """Get ALL monthly sales aggregation based on actual entity structure"""
        query = """
        SELECT 
            EXTRACT(MONTH FROM c.date_creation) as month,
            EXTRACT(YEAR FROM c.date_creation) as year,
            COUNT(DISTINCT c.id) as total_orders,
            SUM(c.prix_total_ttc) as total_revenue,
            SUM(lc.quantite) as total_quantity,
            COUNT(DISTINCT c."clientId") as unique_clients,
            COUNT(DISTINCT lc."produit_id") as unique_products
        FROM commande c
        LEFT JOIN "ligne_commande" lc ON c.id = lc."commande_id"
        LEFT JOIN produit p ON lc."produit_id" = p.id
        LEFT JOIN "categorie_produit" cp ON p."categorieId" = cp.id
        WHERE c.statut IN ('livrée', 'validée', 'validee', 'en_cours')
        AND p.isactive = true
        AND cp."isActive" = true
        GROUP BY EXTRACT(MONTH FROM c.date_creation), EXTRACT(YEAR FROM c.date_creation)
        ORDER BY year, month
        """
        
        try:
            print("📈 Fetching ALL monthly sales data...")
            df = pd.read_sql(query, self.engine)
            print(f"✅ Found {len(df)} total monthly records")
            return df.to_dict('records')
        except Exception as e:
            print(f"❌ Error fetching monthly sales: {e}")
            return []
    
    def get_client_segments(self) -> List[Dict]:
        """Get ALL client segments for better predictions"""
        query = """
        SELECT 
            cl.id as client_id,
            cl.nom,
            cl.prenom,
            cl.importance,
            cc.nom as categorie_nom,
            COUNT(c.id) as total_orders,
            SUM(c.prix_total_ttc) as total_spent,
            AVG(c.prix_total_ttc) as avg_order_value,
            MAX(c.date_creation) as last_order_date
        FROM client cl
        LEFT JOIN commande c ON cl.id = c."clientId"
        LEFT JOIN "categorie_client" cc ON cl."categorie_id" = cc.id
        WHERE cl."isActive" = true
        GROUP BY cl.id, cl.nom, cl.prenom, cl.importance, cc.nom
        ORDER BY total_spent DESC
        """
        
        try:
            print("👥 Fetching ALL client segments...")
            df = pd.read_sql(query, self.engine)
            print(f"✅ Found {len(df)} total client segments")
            return df.to_dict('records')
        except Exception as e:
            print(f"❌ Error fetching client segments: {e}")
            return []
    
    def get_commercial_performance(self) -> List[Dict]:
        """Get ALL commercial performance data"""
        query = """
        SELECT 
            u.id as commercial_id,
            u.nom,
            u.prenom,
            COUNT(c.id) as total_orders,
            SUM(c.prix_total_ttc) as total_revenue,
            COUNT(DISTINCT c."clientId") as unique_clients,
            AVG(c.prix_total_ttc) as avg_order_value
        FROM users u
        LEFT JOIN commande c ON u.id = c."commercialId"
        WHERE u.role = 'commercial'
        GROUP BY u.id, u.nom, u.prenom
        ORDER BY total_revenue DESC
        """
        
        try:
            print("👨‍💼 Fetching ALL commercial performance...")
            df = pd.read_sql(query, self.engine)
            print(f"✅ Found {len(df)} total commercial records")
            return df.to_dict('records')
        except Exception as e:
            print(f"❌ Error fetching commercial performance: {e}")
            return [] 