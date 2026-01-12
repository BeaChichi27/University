from sqlalchemy.orm import Session
from sqlalchemy.sql import text
from typing import List

class ProjectDAO:
    def __init__(self, db: Session):
        self.db = db

    def insert_project(self, cup: str, ref_sci: str, resp: str, nome: str, budget: float):
        query = text("""
            CALL inserisciprogetto(:cup, :ref_sci, :resp, :nome, :budget)
        """)
        try:
            self.db.execute(query, {
                "cup": cup,
                "ref_sci": ref_sci,
                "resp": resp,
                "nome": nome,
                "budget": budget
            })
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            raise RuntimeError(f"Errore nell'inserimento del progetto: {e}")

    def remove_project(self, cup: str):
        query = text("CALL rimuovi_progetto(:cup);")
        try:
            self.db.execute(query, {"cup": cup})
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            raise RuntimeError(f"Errore nella rimozione del progetto: {e}")

    def get_project_employees(self, cup: str) -> dict:
        query = text("""
            SELECT 
                nome, cognome, cf, categoria 
            FROM presenza 
            WHERE cup = :cup;
        """)
        try:
            result = self.db.execute(query, {"cup": cup}).mappings()
            employees = [dict(row) for row in result]
            
            referente = next((emp for emp in employees if emp["categoria"] == "Senior"), None)
            responsabile = next((emp for emp in employees if emp["categoria"] == "Dirigente"), None)
            
            return {
                "referente": referente,
                "responsabile": responsabile,
            }
        except Exception as e:
            raise RuntimeError(f"Errore durante il recupero dei dipendenti per il progetto {cup}: {e}")



    def get_project_labs(self, cup: str) -> List[dict]:
        query = text("SELECT lab1, lab2, lab3 FROM lavora WHERE cup = :cup;")
        try:
            result = self.db.execute(query, {"cup": cup}).fetchall()
            labs = []
            
            for row in result:
                labs.extend(
                    [{"lab": lab} for lab in row if lab and lab.strip()]
                )
            
            return labs
        except Exception as e:
            raise RuntimeError(f"Errore durante il recupero dei laboratori per il progetto {cup}: {e}")