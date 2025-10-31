import handleAPIResponse from "../Services/handleAPIresponse.jsx";
import { API_BASE_URL } from '../config/api.js';

const API_URL = `${API_BASE_URL}/api/impiegati`;

export const getImpiegati = async () => {
    try {
        const response = await fetch(`${API_BASE_URL}/api/gestionale/impiegati`);
        return handleAPIResponse(response, "Errore nel prelievo degli impiegati");
    } catch (error) {
        console.error("Errore nella chiamata API:", error);
        throw error;
    }
};

export const addImpiegato = async (impiegato) => {
    try {
        const response = await fetch(`${API_URL}/`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(impiegato),
        });
        return handleAPIResponse(response, "Errore nell'aggiunta dell'impiegato");
    } catch (error) {
        console.error("Errore nella chiamata API:", error);
        throw error;
    }
};

export const promuoviImpiegato = async (cf, merito) => {
    try {
        const response = await fetch(`${API_URL}/${cf}/promuovi/${merito}`, {
            method: "PATCH",
        });
        return handleAPIResponse(response, "Errore nella promozione dell'impiegato");
    } catch (error) {
        console.error("Errore nella chiamata API:", error);
        throw error;
    }
};

export const getPromozioni = async (cf) => {
    try {
      const response = await fetch(`${API_URL}/${cf}/promozioni`);
      const data = await handleAPIResponse(response, "Errore nel prelievo delle promozioni");
      if (!data || data.length === 0) {
        console.warn("Nessuna promozione trovata, impostando default.");
        return [
          {
            categoria: "Junior",
            datapassaggio: new Date().toISOString().split("T")[0],
          },
        ];
      }
      return data;
    } catch (error) {
      console.error("Errore nella chiamata API per le promozioni:", error);
      throw error;
    }
};
  

export const rimuoviImpiegato = async (cf) => {
    try {
        const response = await fetch(`${API_URL}/${cf}`, {
            method: "DELETE",
        });
        return handleAPIResponse(response, "Errore nella rimozione dell'impiegato");
    } catch (error) {
        console.error("Errore nella chiamata API:", error);
        throw error;
    }
};

export const caricaAfferenze = async (cf) => {
    try {
      const response = await fetch(`${API_URL}/${cf}/laboratori`);
      const data = await handleAPIResponse(response, "Errore nel recupero delle afferenze dell'impiegato");
      console.log("Risposta afferenze:", data);
      return data || {};
    } catch (error) {
      console.error("Errore nella chiamata API caricaAfferenze:", error);
      throw error;
    }
};  

export const caricaProgetti = async (cf) => {
    try {
      const response = await fetch(`${API_URL}/${cf}/progetti`);
      const data = await handleAPIResponse(response, "Errore nel recupero dei progetti dell'impiegato");
      console.log("Risposta progetti:", data);
      return data || {};
    } catch (error) {
      console.error("Errore nella chiamata API caricaProgetti:", error);
      throw error;
    }
};  