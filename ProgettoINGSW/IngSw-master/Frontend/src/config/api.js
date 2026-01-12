const getApiBaseUrl = () => {
  // Variabile d'ambiente impostata da Render
  if (import.meta.env.VITE_API_URL) {
    return import.meta.env.VITE_API_URL;
  }
  
  // Fallback per sviluppo locale
  if (import.meta.env.DEV) {
    return 'http://localhost:5000';
  }
  
  // Produzione - usa il backend Render (cambia con il tuo URL quando deployato)
  return 'https://backend-zdqg.onrender.com';
};

export const API_BASE_URL = getApiBaseUrl();

console.log('🔗 API Base URL:', API_BASE_URL);
