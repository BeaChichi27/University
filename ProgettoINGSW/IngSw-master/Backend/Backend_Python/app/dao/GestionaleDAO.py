from sqlalchemy.orm import Session
from sqlalchemy.sql import text
from typing import List
from datetime import date

class GestionaleDAO:
    def __init__(self, db: Session):
        self.db = db

    def get_impiegati(
        self,
        cf_list: List[str],
        nomi_list: List[str],
        cognomi_list: List[str],
        date_nascita_list: List[date],
        date_assunzioni_list: List[date],
        contratti_list: List[str],
        merito_list: List[bool],
        salari_list: List[float],
        categorie_list: List[str],
        eta_list: List[int],
    ):
        query = "SELECT * FROM impiegato"
        try:
            result = self.db.execute(text(query))
            for row in result.mappings():
                cf_list.append(row["cf"])
                nomi_list.append(row["nome"])
                cognomi_list.append(row["cognome"])
                date_nascita_list.append(row["datanascita"])
                date_assunzioni_list.append(row["dataassunzione"])
                contratti_list.append(row["codicecon"])
                merito_list.append(row["merito"])
                salari_list.append(row["salario"])
                categorie_list.append(row["categoria"])
                eta_list.append(row["eta"])
        except Exception as e:
            raise RuntimeError(f"Errore nel recupero degli impiegati: {e}")

    def get_promozioni(
        self,
        cf_list: List[str],
        date_passaggio_list: List[date],
        contratti_list: List[str],
        vecchie_categorie_list: List[str],
        nuove_categorie_list: List[str],
    ):
        query = "SELECT * FROM promozione"
        try:
            result = self.db.execute(text(query))
            for row in result.mappings():
                cf_list.append(row["cf"])
                date_passaggio_list.append(row["datapassaggio"])
                contratti_list.append(row["codicecon"])
                vecchie_categorie_list.append(row["vecchiacategoria"])
                nuove_categorie_list.append(row["nuovacategoria"])
        except Exception as e:
            raise RuntimeError(f"Errore nel recupero delle promozioni: {e}")

    def get_laboratori(
        self,
        nomi_list: List[str],
        resp_sci_list: List[str],
        topic_list: List[str],
        numero_afferenti_list: List[int],
    ):
        query = "SELECT * FROM laboratorio"
        try:
            result = self.db.execute(text(query))
            for row in result.mappings():
                nomi_list.append(row["nome"])
                resp_sci_list.append(row["respscie"])
                topic_list.append(row["topic"])
                numero_afferenti_list.append(row["n_afferenti"])
        except Exception as e:
            raise RuntimeError(f"Errore nel recupero dei laboratori: {e}")

    def get_progetti(
        self,
        cup_list: List[str],
        ref_sci_list: List[str],
        resp_list: List[str],
        nomi_list: List[str],
        budget_list: List[float],
    ):
        query = "SELECT * FROM progetto"
        try:
            result = self.db.execute(text(query))
            for row in result.mappings():
                cup_list.append(row["cup"])
                ref_sci_list.append(row["refscie"])
                resp_list.append(row["respscie"])
                nomi_list.append(row["nome"])
                budget_list.append(row["budget"])
        except Exception as e:
            raise RuntimeError(f"Errore nel recupero dei progetti: {e}")

    def get_afferenti(self, nome_lab: str, cf_list: List[str]):
        query = "SELECT * FROM utilizza WHERE nomelab = :nomeLab"
        try:
            result = self.db.execute(text(query), {"nomeLab": nome_lab})
            for row in result.mappings():
                cf_list.append(row["cf"])
        except Exception as e:
            raise RuntimeError(f"Errore nel recupero degli afferenti: {e}")