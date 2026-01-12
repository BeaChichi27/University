import React, { useState, useEffect } from "react";
import {
  getPromozioni,
  caricaAfferenze,
  getImpiegati,
  caricaProgetti,
  rimuoviImpiegato,
  promuoviImpiegato,
  addImpiegato,
} from "../Services/ImpiegatoService.jsx";
import { useNavigate } from "react-router-dom";
import '../styles/table.css';

const ImpiegatiList = () => {
  const [impiegati, setImpiegati] = useState([]);
  const [selectedCF, setSelectedCF] = useState(null);
  const [promozioni, setPromozioni] = useState([]);
  const [afferenze, setAfferenze] = useState({});
  const [progetto, setProgetto] = useState({});
  const [showAddForm, setShowAddForm] = useState(false);
  const [newImpiegato, setNewImpiegato] = useState({
    cf: "",
    nome: "",
    cognome: "",
    datanascita: "",
    codicecon: "",
    data_assunzione: new Date().toISOString().split("T")[0],
  });

  const navigate = useNavigate();

  useEffect(() => {
    getImpiegati()
      .then((data) => {
        const uniqueImpiegati = Array.from(new Map(data.map((imp) => [imp.cf, imp])).values());
        setImpiegati(uniqueImpiegati);
        console.log("Impiegati caricati:", uniqueImpiegati);
      })
      .catch((error) => {
        if (error.message.includes("404")) {
          navigate("/not-found", { state: { message: "Nessun impiegato trovato." } });
        } else {
          console.error("Errore:", error.message);
        }
      });
  }, [navigate]);

  const handleSelectCF = async (cf) => {
    setSelectedCF(cf);

    try {
      const promozioniData = await getPromozioni(cf);
      console.log("Promozioni ricevute:", promozioniData);
  
      let promozioniArray = [];
      if (Array.isArray(promozioniData)) {
        promozioniArray = promozioniData.map((promo) => ({
          categoria: promo.categoria,
          datapassaggio: new Date(promo.datapassaggio).toLocaleDateString("it-IT"),
        }));
      } else if (typeof promozioniData === "object") {
        promozioniArray = Object.entries(promozioniData).map(([categoria, datapassaggio]) => ({
          categoria,
          datapassaggio: new Date(datapassaggio).toLocaleDateString("it-IT"),
        }));
      }
      setPromozioni(promozioniArray);

    } catch (error) {
      console.error("Errore nel caricamento delle promozioni:", error.message);
      setPromozioni([]);
    }

    try {
      const afferenzeData = await caricaAfferenze(cf);
      setAfferenze(Array.isArray(afferenzeData) && afferenzeData.length > 0 ? { nomelab: afferenzeData[0] } : {});
      console.log("Afferenze ricevute:", afferenzeData);
    } catch (error) {
      console.warn("Nessuna afferenza trovata per l'impiegato", cf);
      setAfferenze({});
    }

    try {
      const progettoData = await caricaProgetti(cf);
      setProgetto(progettoData?.progetto ? { cup: progettoData.progetto } : {});
      console.log("Progetti ricevuti:", progettoData);
    } catch (error) {
      if (error.message.includes("Nessun progetto associato")) {
        console.warn(`Nessun progetto trovato per l'impiegato ${cf}`);
        setProgetto({ cup: "Nessun progetto associato" });
      } else {
        console.error("Errore nel caricamento dei progetti:", error.message);
        setProgetto({});
      }
    }    
  };

  const handleRimuoviImpiegato = async () => {
    if (!selectedCF) return alert("Seleziona un impiegato per rimuoverlo!");
    try {
      await rimuoviImpiegato(selectedCF);

      const updatedImpiegati = impiegati.filter((impiegato) => impiegato.cf !== selectedCF);
      setImpiegati(updatedImpiegati);

      setSelectedCF(null);
      setPromozioni([]);
      setAfferenze([]);
    } catch (error) {
      if (error.message.includes("404")) {
        navigate("/not-found", { state: { message: "L'impiegato non è stato trovato." } });
      } else {
        alert(`Errore nella rimozione dell'impiegato: ${error.message}`);
      }
    }
  };

  const handleAggiungiImpiegato = async (e) => {
    e.preventDefault();

    const impiegatoDaAggiungere = {
        cf: newImpiegato.cf,
        nome: newImpiegato.nome,
        cognome: newImpiegato.cognome,
        datanascita: newImpiegato.datanascita,
        dataassunzione: new Date().toISOString().split("T")[0],
        categoria: "Junior",
        salario: "1500.00",
        merito: false,
        codicecon: newImpiegato.codicecon,
    };

    try {
        const response = await addImpiegato(impiegatoDaAggiungere);
        alert("Impiegato aggiunto con successo!");

        setImpiegati((prev) => [...prev, response]);

        setNewImpiegato({
            cf: "",
            nome: "",
            cognome: "",
            datanascita: "",
            codicecon: "",
            data_assunzione: new Date().toISOString().split("T")[0],
        });
        setShowAddForm(false);
    } catch (error) {
        if (error.message.includes("404")) {
            navigate("/not-found", { state: { message: "Errore durante l'aggiunta: impiegato non trovato." } });
        } else {
            alert(`Errore nell'aggiunta dell'impiegato: ${error.message}`);
        }
    }
  };

  
  const handlePromuoviImpiegato = async () => {
    if (!selectedCF) return alert("Seleziona un impiegato per promuoverlo!");
    try {
      await promuoviImpiegato(selectedCF, true);

      const updatedPromozioni = await getPromozioni(selectedCF);
      setPromozioni(updatedPromozioni);

      const updatedImpiegati = impiegati.map((impiegato) => {
        if (impiegato.cf === selectedCF) {
          return {
            ...impiegato,
            categoria: "Dirigente",
            salario: "3000.00",
            merito: true,
          };
        }
        return impiegato;
      });

      setImpiegati(updatedImpiegati);

      alert("Impiegato promosso con successo!");
    } catch (error) {
      if (error.message.includes("già esiste")) {
        alert("Promozione già registrata per questo impiegato.");
      } else {
        alert(`Errore nella promozione dell'impiegato: ${error.message}`);
      }
    }
  };

  return (
    <div className="scrollable-table">
      <div className="left-panel">
        <h1>Lista Impiegati</h1>
        <table className="table" border="1">
          <thead>
            <tr>
              <th>CF</th>
              <th>Nome</th>
              <th>Cognome</th>
              <th>Categoria</th>
              <th>Data Assunzione</th>
              <th>Data di Nascita</th>
              <th>Età</th>
              <th>Salario</th>
              <th>Merito</th>
            </tr>
          </thead>
          <tbody>
            {impiegati.map((impiegato) => (
              <tr key={impiegato.cf || Math.random()}>
                <td>{impiegato.cf}</td>
                <td>{impiegato.nome}</td>
                <td>{impiegato.cognome}</td>
                <td>{impiegato.categoria}</td>
                <td>
                  {impiegato.data_assunzione
                    ? new Date(impiegato.data_assunzione).toLocaleDateString("it-IT")
                    : "Non disponibile"}
                </td>
                <td>
                  {impiegato.data_nascita
                    ? new Date(impiegato.data_nascita).toLocaleDateString("it-IT")
                    : "Non disponibile"}
                </td>
                <td>{impiegato.eta || "N/A"}</td>
                <td>{impiegato.salario || "N/A"}</td>
                <td>{impiegato.merito ? "Sì" : "No"}</td>
                <td>
                  <button onClick={() => handleSelectCF(impiegato.cf)}>Mostra Dettagli</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
  
      <div className="buttons-container">
        <button onClick={() => setShowAddForm((prev) => !prev)}>
          {showAddForm ? "Annulla Aggiunta" : "Aggiungi Nuovo Impiegato"}
        </button>
        <button onClick={handlePromuoviImpiegato}>Promuovi</button>
        <button onClick={handleRimuoviImpiegato}>Rimuovi</button>
      </div>
  
      {showAddForm && (
        <form onSubmit={handleAggiungiImpiegato} style={{ marginTop: "20px" }}>
          <h2>Aggiungi Impiegato</h2>
          <input
            name="cf"
            placeholder="Codice Fiscale"
            value={newImpiegato.cf}
            onChange={(e) => setNewImpiegato({ ...newImpiegato, cf: e.target.value })}
            required
          />
          <input
            name="nome"
            placeholder="Nome"
            value={newImpiegato.nome}
            onChange={(e) => setNewImpiegato({ ...newImpiegato, nome: e.target.value })}
            required
          />
          <input
            name="cognome"
            placeholder="Cognome"
            value={newImpiegato.cognome}
            onChange={(e) => setNewImpiegato({ ...newImpiegato, cognome: e.target.value })}
            required
          />
          <input
            name="datanascita"
            type="date"
            placeholder="Data di Nascita"
            value={newImpiegato.datanascita}
            onChange={(e) => setNewImpiegato({ ...newImpiegato, datanascita: e.target.value })}
            required
          />
          <input
            name="codicecon"
            placeholder="Codice Contratto"
            value={newImpiegato.codicecon}
            onChange={(e) => setNewImpiegato({ ...newImpiegato, codicecon: e.target.value })}
            required
          />
          <button type="submit">Aggiungi Impiegato</button>
        </form>
      )}
  
      <div className="right-panel">
        {selectedCF && (
          <>
            <div className="details">
              <h2>Promozioni</h2>
              <table className="promozioni-table" border="1">
                <thead>
                  <tr>
                    <th>Categoria</th>
                    <th>Data Passaggio</th>
                  </tr>
                </thead>
                <tbody>
                  {Array.isArray(promozioni) && promozioni.length > 0 ? (
                    promozioni.map((promo, index) => (
                      <tr key={index}>
                        <td>{promo.categoria}</td>
                        <td>{promo.datapassaggio}</td>
                      </tr>
                    ))
                  ) : (
                    <tr>
                      <td colSpan="2">Nessuna promozione disponibile</td>
                    </tr>
                  )}
                  </tbody>
              </table>
            </div>
  
            <div className="details">
              <h2>Progetti e Afferenze</h2>
              <table className="details-table" border="1">
                <thead>
                  <tr>
                    <th>Nome Laboratorio</th>
                    <th>CUP Progetto</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>{afferenze?.nomelab || "Nessun laboratorio associato"}</td>
                    <td>{progetto?.cup || "Nessun progetto associato"}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </>
        )}
      </div>
    </div>
  );
}  

export default ImpiegatiList;