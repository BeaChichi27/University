import React from "react";
import { Link } from "react-router-dom";

const NotFoundPage = () => {
  return (
    <div style={{ textAlign: "center", marginTop: "50px" }}>
      <h1>404</h1>
      <h2>Pagina non trovata</h2>
      <p>Ops! La pagina che stai cercando non esiste o è stata rimossa.</p>
      <Link to="/" style={{ textDecoration: "none", color: "blue", fontWeight: "bold" }}>
        Torna alla Home
      </Link>
    </div>
  );
};

export default NotFoundPage;