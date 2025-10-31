import React, { useState, useEffect } from "react";
import {
  getLaboratori,
  aggiungiLaboratori,
  rimuoviLaboratorio,
  caricaAfferenze,
  caricaResponsabile,
} from "../Services/LaboratorioService.jsx";
import { useNavigate } from "react-router-dom";
import "../styles/table.css";

const LaboratoriList = () => {
  const navigate = useNavigate();
  const [laboratori, setLaboratori] = useState([]);
  const [selectedLab, setSelectedLab] = useState(null);
  const [afferenti, setAfferenti] = useState([]);
  const [responsabile, setResponsabile] = useState("");
  const [showAddForm, setShowAddForm] = useState(false);
  const [newLaboratorio, setNewLaboratorio] = useState({
    nome: "",
    responsabile_sci: "",
    topic: "",
    numero_afferenti: 0,
  });

  useEffect(() => {
    getLaboratori()
      .then((data) => {
        console.log("Dati ricevuti:", data);
        const uniqueLaboratori = Array.from(new Map(data.map((lab) => [lab.nome, lab])).values());
        setLaboratori(uniqueLaboratori);
      })
      .catch((error) => {
        if (error.message.includes("404")) {
          navigate("/not-found", { state: { message: "Nessun laboratorio trovato." } });
        } else {
          console.error("Errore:", error.message);
        }
      });
  }, [navigate]);
  
  const handleSelectLab = async (nome) => {
    setSelectedLab(nome);
    try {
      const afferenze = await caricaAfferenze(nome);
      setAfferenti(Array.isArray(afferenze.cf) ? afferenze.cf.map(item => item.cf) : []);
  
      const responsabileData = await caricaResponsabile(nome);
      const responsabile = responsabileData?.Responsabile?.[0];
      setResponsabile(
        responsabile
          ? `${responsabile.nome} ${responsabile.cognome} (CF: ${responsabile.cf})`
          : "Informazione non disponibile"
      );
    } catch (error) {
      console.error("Errore nel caricamento dei dettagli del laboratorio:", error.message);
      setAfferenti([]);
      setResponsabile("Informazione non disponibile");
    }

    setSelectedLab(nome);
  };
  

  const handleRimuoviLaboratorio = async () => {
    if (!selectedLab) return alert("Seleziona un laboratorio per rimuoverlo!");
    try {
      await rimuoviLaboratorio(selectedLab);
      setLaboratori((prevLaboratori) => prevLaboratori.filter((lab) => lab.nome !== selectedLab));
      setSelectedLab(null);
      setAfferenti([]);
      setResponsabile("");
    } catch (error) {
      if (error.message.includes("404")) {
        navigate("/not-found", { state: { message: `Il laboratorio ${selectedLab} non è stato trovato.` } });
      } else {
        alert(`Errore nella rimozione del laboratorio: ${error.message}`);
      }
    }
  };  

  const handleAggiungiLaboratorio = async (e) => {
    e.preventDefault();
    try {
      const laboratorio = {
        nome: newLaboratorio.nome,
        resp_sci: newLaboratorio.responsabile_sci,
        topic: newLaboratorio.topic,
        numero_afferenti: newLaboratorio.numero_afferenti
      };
      console.log("Laboratorio inviato:", laboratorio);
      await aggiungiLaboratori(laboratorio);
      alert("Laboratorio aggiunto con successo!");
      setNewLaboratorio({
        nome: "",
        responsabile_sci: "",
        topic: "",
        numero_afferenti: 0
      });
      setShowAddForm(false);
      setLaboratori((prevLaboratori) => prevLaboratori.filter((lab) => lab.nome !== selectedLab));
      setSelectedLab(null);
      setAfferenti([]);
      setResponsabile("");
    } catch (error) {
      console.error("Errore nell'aggiunta del laboratorio:", error);
    }
  };
  
  return (
    <div className="scrollable-table">
      <div className="left-panel">
        <h1>Lista Laboratori</h1>
        <table className="table" border="1">
          <thead>
            <tr>
              <th>Nome</th>
              <th>Topic</th>
              <th>Numero Afferenti</th>
            </tr>
          </thead>
          <tbody>
            {laboratori.map((lab) => (
              <tr key={lab.nome}>
                <td>{lab.nome}</td>
                <td>{lab.topic}</td>
                <td>{lab.numero_afferenti}</td>
                <td>
                  <button onClick={() => handleSelectLab(lab.nome)}>Mostra Dettagli</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {showAddForm && (
        <form onSubmit={handleAggiungiLaboratorio} style={{ marginTop: "20px" }}>
          <h2>Aggiungi Laboratorio</h2>
          <input
            name="nome"
            placeholder="Nome Laboratorio"
            value={newLaboratorio.nome}
            onChange={(e) => setNewLaboratorio({ ...newLaboratorio, nome: e.target.value })}
            required
          />
          <input
            name="responsabile_sci"
            placeholder="Responsabile Scientifico"
            value={newLaboratorio.responsabile_sci}
            onChange={(e) => setNewLaboratorio({ ...newLaboratorio, responsabile_sci: e.target.value })}
            required
          />
          <input
            name="topic"
            placeholder="Topic"
            value={newLaboratorio.topic}
            onChange={(e) => setNewLaboratorio({ ...newLaboratorio, topic: e.target.value })}
            required
          />
          <input
            name="numero_afferenti"
            type="number"
            placeholder="Numero Afferenti"
            value={newLaboratorio.numero_afferenti}
            onChange={(e) => setNewLaboratorio({ ...newLaboratorio, numero_afferenti: Number(e.target.value) })}
            required
          />
          <button type="submit">Aggiungi Laboratorio</button>
        </form>
      )}

      {selectedLab && (
        <div className="right-panel">
          <h2>Dettagli per {selectedLab}</h2>
          <h3>Afferenze</h3>
          <ul>
            {afferenti.length > 0 ? (
              afferenti.map((cf, index) => <li key={index}>{cf}</li>)
            ) : (
              <li>Nessuna afferenza trovata.</li>
            )}
          </ul>
          <h3>Responsabile</h3>
          <p>{responsabile || "Informazione non disponibile"}</p>
        </div>
      )}

      <div className="buttons-container">
        <button onClick={handleRimuoviLaboratorio}>Rimuovi Laboratorio</button>
        <button onClick={() => setShowAddForm((prev) => !prev)}>
          {showAddForm ? "Annulla Aggiunta" : "Aggiungi Laboratorio"}
        </button>
      </div>
    </div>
  );
};

export default LaboratoriList;