const handleAPIResponse = async (response, errorMessage) => {
    const responseClone = response.clone();
    if (!response.ok) {
        try {
            const error = await response.json();
            throw new Error(error.error || errorMessage);
        } catch {
            const bodyText = await responseClone.text();
            console.error("Errore non JSON ricevuto:", bodyText);
            throw new Error("Errore sconosciuto nella risposta API");
        }
    }
    return response.json();
};

export default handleAPIResponse;