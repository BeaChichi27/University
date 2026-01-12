import React from "react";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import ImpiegatiList from "./Componenti/ImpiegatiList.jsx";
import LaboratoriList from "./Componenti/LaboratoriList.jsx";
import ProgettiList from "./Componenti/ProgettiList.jsx";
import NotFoundPage from "./Pagine/NotFoundPage.jsx";
import ErrorBoundary from "../ErrorBoundary.jsx";

console.log("App renderizzata");
const App = () => {
  return (
    <Router>
      <div>
        <h1>Benvenuto nel Gestionale</h1>
        <nav style={{ padding: "10px" }}>
          <Link to="/impiegati" style={{ margin: "10px" }}>Impiegati</Link>
          <Link to="/laboratori" style={{ margin: "10px" }}>Laboratori</Link>
          <Link to="/progetti" style={{ margin: "10px" }}>Progetti</Link>
          <Link to="/" style={{ margin: "10px" }}>Home</Link>
        </nav>
      </div>

      <ErrorBoundary>
        <Routes>
          <Route path="/" element={<h2>Homepage</h2>} />
          <Route path="/impiegati" element={<ImpiegatiList />} />
          <Route path="/laboratori" element={<LaboratoriList />} />
          <Route path="/progetti" element={<ProgettiList />} />
          <Route path="*" element={<NotFoundPage />} />
        </Routes>
      </ErrorBoundary>
    </Router>
  );
};

export default App;