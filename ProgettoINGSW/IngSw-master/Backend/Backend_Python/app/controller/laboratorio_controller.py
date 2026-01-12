from app.dao.LaboratorioDAO import LaboratorioDAO
from typing import List

class LaboratorioController:
    def __init__(self, db):
        if not db:
            raise ValueError("La connessione al database non può essere nulla!")
        self.dao = LaboratorioDAO(db)

    def aggiungi_laboratorio(self, nome: str, resp_sci: str, topic: str):
        self.dao.inserisci_laboratorio(nome, resp_sci, topic)

    def rimuovi_laboratorio(self, nome: str):
        self.dao.rimuovi_laboratorio(nome)

    def aggiungi_afferente(self, nome_lab: str, cf: str):
        self.dao.aggiungi_afferente(nome_lab, cf)

    def carica_afferenze(self, nome_lab: str) -> List[dict]:
        return self.dao.afferenze_lab(nome_lab)

    def carica_resp_sci(self, nome_lab: str) -> List[str]:
        return self.dao.get_resp_sci(nome_lab)