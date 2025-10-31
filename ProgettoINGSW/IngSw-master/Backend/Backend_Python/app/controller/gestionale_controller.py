from app.dao.GestionaleDAO import GestionaleDAO
from app.model import Impiegato, Promozione, Laboratorio, Progetto

class GestionaleController:
    def __init__(self, db):
        if not db:
            raise ValueError("La connessione al database non può essere nulla!")
        self.dao = GestionaleDAO(db)
        self.impiegati = []
        self.promozioni = []
        self.laboratori = []
        self.progetti = []

        self.get_impiegati_db()
        self.get_laboratori_db()
        self.get_promozioni_db()
        self.get_progetti_db()

    def get_impiegati_db(self):
        cf_list, nomi_list, cognomi_list, date_nascita_list = [], [], [], []
        date_assunzioni_list, contratti_list = [], []
        merito_list, salari_list, categorie_list, eta_list = [], [], [], []

        self.dao.get_impiegati(
            cf_list, nomi_list, cognomi_list, date_nascita_list,
            date_assunzioni_list, contratti_list, merito_list,
            salari_list, categorie_list, eta_list
        )

        for i in range(len(cf_list)):
            impiegato = Impiegato(
                cf=cf_list[i],
                nome=nomi_list[i],
                cognome=cognomi_list[i],
                data_nascita=date_nascita_list[i],
                data_assunzione=date_assunzioni_list[i],
                codice_contratto=contratti_list[i],
                merito=merito_list[i],
                salario=salari_list[i],
                categoria=categorie_list[i],
                eta=eta_list[i],
            )
            self.impiegati.append(impiegato)

        return self.impiegati

    def get_laboratori_db(self):
        nomi_list, resp_sci_list, topic_list, numero_afferenti_list = [], [], [], []
        self.dao.get_laboratori(nomi_list, resp_sci_list, topic_list, numero_afferenti_list)

        for i in range(len(nomi_list)):
            laboratorio = Laboratorio(
                nome=nomi_list[i],
                responsabile_scientifico=resp_sci_list[i],
                topic=topic_list[i],
                numero_afferenti=numero_afferenti_list[i],
            )
            self.laboratori.append(laboratorio)

        return self.laboratori

    def get_promozioni_db(self):
        cf_list, date_passaggio_list, contratti_list = [], [], []
        vecchie_categorie_list, nuove_categorie_list = [], []

        self.dao.get_promozioni(
            cf_list, date_passaggio_list, contratti_list,
            vecchie_categorie_list, nuove_categorie_list
        )

        for i in range(len(cf_list)):
            promozione = Promozione(
                cf=cf_list[i],
                data_passaggio=date_passaggio_list[i],
                contratto=contratti_list[i],
                vecchia_categoria=vecchie_categorie_list[i],
                nuova_categoria=nuove_categorie_list[i],
            )
            self.promozioni.append(promozione)

        return self.promozioni

    def get_progetti_db(self):
        cup_list, ref_sci_list, resp_list, nomi_list, budget_list = [], [], [], [], []

        self.dao.get_progetti(
            cup_list, ref_sci_list, resp_list, nomi_list, budget_list
        )

        for i in range(len(cup_list)):
            progetto = Progetto(
                cup=cup_list[i],
                referente_scientifico=ref_sci_list[i],
                responsabile=resp_list[i],
                nome=nomi_list[i],
                budget=budget_list[i],
            )
            self.progetti.append(progetto)

        return self.progetti
