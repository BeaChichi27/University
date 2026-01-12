from sqlalchemy.orm import Session
from sqlalchemy.sql import text
from typing import List

class LaboratorioDAO:
    def __init__(self, db: Session):
        self.db = db

    def inserisci_laboratorio(self, nome: str, resp_sci: str, topic: str):
        query = text("CALL inseriscilaboratorio(:nome, :resp_sci, :topic)")
        params = {"nome": nome, "resp_sci": resp_sci, "topic": topic}
        try:
            self.db.execute(query, params)
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            raise RuntimeError(f"Errore nell'inserimento del laboratorio: {e}")

    def rimuovi_laboratorio(self, nome: str):
        query = text("CALL rimuovi_laboratorio(:nome)")
        try:
            self.db.execute(query, {"nome": nome})
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            raise RuntimeError(f"Errore nella rimozione del laboratorio: {e}")

    def aggiungi_afferente(self, nome_lab: str, cf: str):
        query = text("CALL inserisciutilizza(:nome_lab, :cf)")
        params = {"nome_lab": nome_lab, "cf": cf}
        try:
            self.db.execute(query, params)
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            raise RuntimeError(f"Errore nell'aggiunta di un afferente: {e}")

    def afferenze_lab(self, nome_lab: str):
        query = text("SELECT cf FROM utilizza WHERE nomelab = :nome_lab")
        try:
            result = self.db.execute(query, {"nome_lab": nome_lab})
            return [dict(row) for row in result.mappings()]
        except Exception as e:
            raise RuntimeError(f"Errore nel recupero delle afferenze: {e}")


    def get_resp_sci(self, nome_lab: str):
        query = text("""
            SELECT i.cf, i.nome, i.cognome
            FROM laboratorio AS l
            JOIN impiegato AS i ON l.respscie = i.cf
            WHERE l.nome = :nome_lab
        """)
        try:
            result = self.db.execute(query, {"nome_lab": nome_lab})
            resp = [{"cf": row["cf"], "nome": row["nome"], "cognome": row["cognome"]} for row in result.mappings()]
            return resp
        except Exception as e:
            raise RuntimeError(f"Errore nel recupero del responsabile scientifico: {e}")