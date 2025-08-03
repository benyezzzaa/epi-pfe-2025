import React, { useState, useEffect } from 'react';
import axios from 'axios';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement,
} from 'chart.js';
import { Bar, Doughnut } from 'react-chartjs-2';

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement
);

const AiPredictions = () => {
  const [healthStatus, setHealthStatus] = useState(null);
  const [predictions, setPredictions] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [topN, setTopN] = useState(10);

  const fetchHealthStatus = async () => {
    try {
      const response = await axios.get('http://localhost:4000/api/ai-predictions/health');
      setHealthStatus(response.data);
    } catch (error) {
      console.error('Error fetching health status:', error);
      setError('Échec de la connexion au service IA');
    }
  };

  const fetchPredictions = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`http://localhost:4000/api/ai-predictions/predict?top_n=${topN}`);
      console.log('API Response:', response.data);
      setPredictions(response.data);
      setError(null);
    } catch (error) {
      console.error('Error fetching predictions:', error);
      setError('Échec de la récupération des prédictions');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchHealthStatus();
    fetchPredictions();
  }, [topN]);

  const handleRetrain = async () => {
    try {
      await axios.post('http://localhost:4000/api/ai-predictions/retrain');
      fetchPredictions();
    } catch (error) {
      console.error('Error retraining models:', error);
    }
  };

  const getTopProductsChartData = () => {
    if (!predictions?.data?.data?.top_products || !Array.isArray(predictions.data.data.top_products) || predictions.data.data.top_products.length === 0) {
      return null;
    }

    const products = predictions.data.data.top_products;
    
    return {
      labels: products.map(p => (p.product_name || 'Produit Inconnu').substring(0, 15) + '...'),
      datasets: [
        {
          label: 'Ventes Prédites',
          data: products.map(p => p.predicted_sales || 0),
          backgroundColor: 'rgba(54, 162, 235, 0.8)',
          borderColor: 'rgba(54, 162, 235, 1)',
          borderWidth: 1,
        },
      ],
    };
  };

  const getTopCategoriesChartData = () => {
    if (!predictions?.data?.data?.top_categories || !Array.isArray(predictions.data.data.top_categories) || predictions.data.data.top_categories.length === 0) {
      return null;
    }

    const categories = predictions.data.data.top_categories;
    
    return {
      labels: categories.map(c => (c.category_name || 'Catégorie Inconnue').substring(0, 15) + '...'),
      datasets: [
        {
          label: 'Ventes Prédites',
          data: categories.map(c => c.predicted_sales || 0),
          backgroundColor: 'rgba(255, 159, 64, 0.8)',
          borderColor: 'rgba(255, 159, 64, 1)',
          borderWidth: 1,
        },
      ],
    };
  };

  const getExpectedCommandesChartData = () => {
    if (!predictions?.data?.data?.expected_commandes) {
      return null;
    }

    const expectedCommandes = predictions.data.data.expected_commandes;
    
    return {
      labels: ['Commandes Attendues', 'Commandes Historiques'],
      datasets: [
        {
          data: [expectedCommandes.expected_commandes || 0, expectedCommandes.historical_commandes || 0],
          backgroundColor: [
            'rgba(75, 192, 192, 0.8)',
            'rgba(201, 203, 207, 0.8)',
          ],
          borderColor: [
            'rgba(75, 192, 192, 1)',
            'rgba(201, 203, 207, 1)',
          ],
          borderWidth: 1,
        },
      ],
    };
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="text-xl">Chargement des prédictions...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="text-xl text-red-600">Erreur: {error}</div>
      </div>
    );
  }

  return (
    <div className="p-6">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-800 mb-4">Tableau de Bord des Prédictions IA</h1>
        <div className="flex gap-4 items-center">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Nombre de Produits Principaux:
            </label>
            <select
              value={topN}
              onChange={(e) => setTopN(Number(e.target.value))}
              className="border border-gray-300 rounded-md px-3 py-2"
            >
              <option value={5}>5</option>
              <option value={10}>10</option>
              <option value={15}>15</option>
              <option value={20}>20</option>
            </select>
          </div>
          <button
            onClick={handleRetrain}
            className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700"
          >
            Rafraîchir les données
          </button>
        </div>
      </div>


      {/* Top Products Section */}
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-4">Produits Principaux pour le Mois Prochain</h2>
                    {predictions?.data?.data?.top_products && predictions.data.data.top_products.length > 0 ? (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold mb-4">Vue Graphique</h3>
              {getTopProductsChartData() && (
                <Bar
                  data={getTopProductsChartData()}
                  options={{
                    responsive: true,
                    plugins: {
                      legend: {
                        position: 'top',
                      },
                      title: {
                        display: true,
                        text: 'Produits Principaux - Ventes Prédites',
                      },
                    },
                    scales: {
                      y: {
                        beginAtZero: true,
                      },
                    },
                  }}
                />
              )}
            </div>
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold mb-4">Vue Tableau</h3>
              <div className="overflow-x-auto">
                <table className="min-w-full">
                  <thead>
                    <tr className="bg-gray-50">
                      <th className="px-4 py-2 text-left">Produit</th>
                      <th className="px-4 py-2 text-left">Ventes Prédites</th>
                      <th className="px-4 py-2 text-left">Prix (TTC)</th>
                      <th className="px-4 py-2 text-left">Commandes Historiques</th>
                    </tr>
                  </thead>
                  <tbody>
                    {predictions.data.data.top_products.map((product, index) => (
                      <tr key={index} className="border-b">
                        <td className="px-4 py-2">{product.product_name}</td>
                        <td className="px-4 py-2 font-medium">{product.predicted_sales}</td>
                        <td className="px-4 py-2">{product.current_price_ttc} Euro</td>
                        <td className="px-4 py-2">{product.historical_orders}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        ) : (
          <div className="text-center py-8 text-gray-500">Aucune prédiction de produit disponible</div>
        )}
      </div>

      {/* Top Categories Section */}
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-4">Catégories Principales pour le Mois Prochain</h2>
                    {predictions?.data?.data?.top_categories && predictions.data.data.top_categories.length > 0 ? (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold mb-4">Vue Graphique</h3>
              {getTopCategoriesChartData() && (
                <Bar
                  data={getTopCategoriesChartData()}
                  options={{
                    responsive: true,
                    plugins: {
                      legend: {
                        position: 'top',
                      },
                      title: {
                        display: true,
                        text: 'Catégories Principales - Ventes Prédites',
                      },
                    },
                    scales: {
                      y: {
                        beginAtZero: true,
                      },
                    },
                  }}
                />
              )}
            </div>
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold mb-4">Vue Tableau</h3>
              <div className="overflow-x-auto">
                <table className="min-w-full">
                  <thead>
                    <tr className="bg-gray-50">
                      <th className="px-4 py-2 text-left">Catégorie</th>
                      <th className="px-4 py-2 text-left">Ventes Prédites</th>
                      <th className="px-4 py-2 text-left">Commandes Historiques</th>
                    </tr>
                  </thead>
                  <tbody>
                    {predictions.data.data.top_categories.map((category, index) => (
                      <tr key={index} className="border-b">
                        <td className="px-4 py-2">{category.category_name}</td>
                        <td className="px-4 py-2 font-medium">{category.predicted_sales}</td>
                        <td className="px-4 py-2">{category.historical_orders}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        ) : (
          <div className="text-center py-8 text-gray-500">Aucune prédiction de catégorie disponible</div>
        )}
      </div>

      {/* Expected Commandes Section */}
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-gray-800 mb-4">Commandes Attendues pour le Mois Prochain</h2>
        {predictions?.data?.data?.expected_commandes ? (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold mb-4">Vue Graphique</h3>
              {getExpectedCommandesChartData() && (
                <Doughnut
                  data={getExpectedCommandesChartData()}
                  options={{
                    responsive: true,
                    plugins: {
                      legend: {
                        position: 'top',
                      },
                      title: {
                        display: true,
                        text: 'Commandes Attendues vs Historiques',
                      },
                    },
                  }}
                />
              )}
            </div>
            <div className="bg-white p-6 rounded-lg shadow">
              <h3 className="text-lg font-semibold mb-4">Détails</h3>
              <div className="space-y-4">
                <div className="flex justify-between items-center p-4 bg-blue-50 rounded-lg">
                  <span className="font-medium">Commandes Attendues:</span>
                  <span className="text-2xl font-bold text-blue-600">
                    {predictions.data.data.expected_commandes.expected_commandes}
                  </span>
                </div>
                <div className="flex justify-between items-center p-4 bg-gray-50 rounded-lg">
                  <span className="font-medium">Total des Commandes Historiques:</span>
                  <span className="text-xl font-semibold text-gray-600">
                    {predictions.data.data.expected_commandes.historical_commandes}
                  </span>
                </div>
                <div className="flex justify-between items-center p-4 bg-green-50 rounded-lg">
                  <span className="font-medium">Moyenne Mensuelle des Commandes:</span>
                  <span className="text-lg font-semibold text-green-600">
                    {predictions.data.data.expected_commandes.avg_monthly_commandes}
                  </span>
                </div>
                <div className="flex justify-between items-center p-4 bg-yellow-50 rounded-lg">
                  <span className="font-medium">Taux de Croissance:</span>
                  <span className="text-lg font-semibold text-yellow-600">
                    {(predictions.data.data.expected_commandes.growth_rate * 100).toFixed(1)}%
                  </span>
                </div>
              </div>
            </div>
          </div>
        ) : (
          <div className="text-center py-8 text-gray-500">Aucune prédiction de commande disponible</div>
        )}
      </div>

      {/* Analysis Summary */}
      {predictions?.data?.data?.analysis_summary && (
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-2xl font-bold text-gray-800 mb-4">Plage de dates de l'Analyse</h2>
          <div className="mt-4 text-sm text-gray-600">
            <strong>Plage de Dates:</strong> {predictions.data.data.analysis_summary.date_range.from} à {predictions.data.data.analysis_summary.date_range.to}
          </div>
        </div>
      )}
    </div>
  );
};

export default AiPredictions; 