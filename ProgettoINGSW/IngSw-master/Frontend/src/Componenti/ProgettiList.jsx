import React, { useState, useEffect } from 'react';
import {
  getProgetti,
  aggiungiProgetto,
  rimuoviProgetto,
  caricaImpiegati,
  caricaLaboratori,
} from "../Services/ProgettoService.jsx";
import { useNavigate } from "react-router-dom";
import '../styles/table.css';

const ProgettiList = () => {
  const navigate = useNavigate();
  const [progetti, setProgetti] = useState([]);
  const [selectedProg, setSelectedProg] = useState(null);
  const [impiegati, setImpiegati] = useState([]);
  const [laboratori, setLaboratori] = useState([]);
  const [showAddForm, setShowAddForm] = useState(false);
  const [newProgetto, setNewProgetto] = useState({
    cup: "",
    ref_sci: "",
    resp: "",
    nome: "",
    budget: "",
  });

  useEffect(() => {
    getProgetti()
      .then((data) => {
        const uniqueProgetti = Array.from(new Map(data.map(progetto => [progetto.cup, progetto])).values());
        setProgetti(uniqueProgetti);
      })
      .catch((error) => {
        console.error("Errore nel caricamento dei progetti:", error.message);
        navigate("/not-found", { state: { message: "Nessun progetto trovato." } });
      });
  }, [navigate]);
  
  
  const handleSelectProg = async (cup) => {
    setSelectedProg(cup);
    try {
      const impiegatiData = await caricaImpiegati(cup);
      console.log("Impiegati caricati:", impiegatiData);
      setImpiegati(impiegatiData);
  
      const laboratoriData = await caricaLaboratori(cup);
      console.log("Laboratori caricati:", laboratoriData);
      setLaboratori(laboratoriData);
    } catch (error) {
      console.error("Errore:", error.message);
      navigate("/not-found", { state: { message: `Il progetto ${cup} non è stato trovato.` } });
    }
  };  
  
  const handleRimuoviProgetto = async () => {
    if (!selectedProg) return alert("Seleziona un progetto per rimuoverlo!");
    try {
      await rimuoviProgetto(selectedProg);
      setSelectedProg(null);
  
      const updatedProgetti = await getProgetti();
      const uniqueProgetti = Array.from(new Map(updatedProgetti.map(progetto => [progetto.cup, progetto])).values());
      setProgetti(uniqueProgetti);
  
      setImpiegati([]);
      setLaboratori([]);
    } catch (error) {
      if (error.message.includes("404")) {
        navigate("/not-found", { state: { message: `Il progetto ${selectedProg} non è stato trovato.` } });
      } else {
        alert(`Errore nella rimozione del progetto: ${error.message}`);
      }
    }
  };  

  const handleAggiungiProgetto = async (e) => {
    e.preventDefault();

    const progettoDaAggiungere = {
        cup: newProgetto.cup,
        ref_sci: newProgetto.ref_sci,
        resp: newProgetto.resp,
        nome: newProgetto.nome,
        budget: Number(newProgetto.budget),
    };

    try {
        const addedProject = await aggiungiProgetto(progettoDaAggiungere);
        alert("Progetto aggiunto con successo!");
        console.log("Progetto aggiunto:", addedProject);

        setProgetti((prevProgetti) => [...prevProgetti, addedProject]);

        setNewProgetto({
            cup: "",
            ref_sci: "",
            resp: "",
            nome: "",
            budget: "",
        });
        setShowAddForm(false);
    } catch (error) {
        console.error("Errore nell'aggiunta del progetto:", error.message);
        alert(`Errore nell'aggiunta del progetto: ${error.message}`);
    }
};

  return (
    <div className="scrollable-table">
      <div className="left-panel">
        <h1>Lista Progetti</h1>
        <table className="table" border="1">
          <thead>
            <tr>
              <th>CUP</th>
              <th>Nome</th>
              <th>Budget</th>
            </tr>
          </thead>
          <tbody>
          {progetti.map((prog, index) => (
            <tr key={prog.cup ? prog.cup : `progetto-${index}`}> 
              <td>{prog.cup}</td>
              <td>{prog.nome}</td>
              <td>{prog.budget}</td>
              <td>
                <button onClick={() => handleSelectProg(prog.cup)}>Mostra Dettagli</button>
              </td>
            </tr>
          ))}
          </tbody>
        </table>
      </div>
  
      {showAddForm && (
        <form onSubmit={handleAggiungiProgetto} style={{ marginTop: "20px" }}>
          <h2>Aggiungi Progetto</h2>
          <input
            name="cup"
            placeholder="Cup Progetto"
            value={newProgetto.cup}
            onChange={(e) => setNewProgetto({ ...newProgetto, cup: e.target.value })}
            required
          />
          <input
            name="ref_sci"
            placeholder="Referente Scientifico"
            value={newProgetto.ref_sci}
            onChange={(e) => setNewProgetto({ ...newProgetto, ref_sci: e.target.value })}
            required
          />
          <input
            name="resp"
            placeholder="Responsabile"
            value={newProgetto.resp}
            onChange={(e) => setNewProgetto({ ...newProgetto, resp: e.target.value })}
            required
          />
          <input
            name="nome"
            placeholder="Nome Progetto"
            value={newProgetto.nome}
            onChange={(e) => setNewProgetto({ ...newProgetto, nome: e.target.value })}
            required
          />
          <input
            name="budget"
            type="number"
            placeholder="Budget"
            value={newProgetto.budget}
            onChange={(e) => setNewProgetto({ ...newProgetto, budget: Number(e.target.value) })}
            required
          />
          <button type="submit">Aggiungi Progetto</button>
        </form>
      )}
  
      {selectedProg && (
        <div className="right-panel">
          <h2>Dettagli per {selectedProg}</h2>

          <div className="details">
            <h3>Referente Scientifico</h3>
            <p>
              {impiegati?.referente ? `${impiegati.referente.cf}
               ${impiegati.referente.nome} ${impiegati.referente.cognome}` : "Non disponibile"}
            </p>
          </div>
          <div className="details">
            <h3>Responsabile</h3>
            <p>
              {impiegati?.responsabile ? ` ${impiegati.responsabile.cf}
              ${impiegati.responsabile.nome} ${impiegati.responsabile.cognome}` : "Non disponibile"}
            </p>
          </div>

          <div className="details">
            <h3>Laboratori</h3>
            <ul>
            {laboratori.map((nome, index) => (
              <li key={nome.lab ? nome.lab : `laboratorio-${index}`}>{nome.lab || "Non specificato"}</li>
            ))}
            </ul>
          </div>
        </div>
      )}
  
      <div className="buttons-container">
        <button onClick={() => setShowAddForm((prev) => !prev)}>
          {showAddForm ? "Annulla Aggiunta" : "Aggiungi Nuovo Progetto"}
        </button>
        <button onClick={handleRimuoviProgetto}>Rimuovi Progetto</button>
      </div>
    </div>
  );
}  

export default ProgettiList;