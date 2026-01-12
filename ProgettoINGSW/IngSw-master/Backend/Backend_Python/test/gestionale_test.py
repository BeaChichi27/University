import unittest
from unittest.mock import MagicMock
from app.controller.impiegato_controller import ImpiegatoController
from app.controller.laboratorio_controller import LaboratorioController
from app.controller.progetto_controller import ProjectController

class TestImpiegatoController(unittest.TestCase):

    def setUp(self):
        self.mock_db = MagicMock()
        self.controller = ImpiegatoController(self.mock_db)

    def test_aggiungi_impiegato(self):
        self.controller.dao.inserisci_impiegato = MagicMock()

        impiegato = {
            "cf": "CF1234567890",
            "nome": "Mario",
            "cognome": "Rossi",
            "datanascita": "1990-01-01",
            "codicecon": "CON123",
        }

        self.controller.aggiungi_impiegato(**impiegato)

        self.controller.dao.inserisci_impiegato.assert_called_once_with(
            cf="CF1234567890",
            nome="Mario",
            cognome="Rossi",
            datanascita="1990-01-01",
            codicecon="CON123"
        )

    def test_promuovi_impiegato(self):
        self.controller.dao.promuovi_impiegato = MagicMock()

        cf = "CF1234567890"
        merito = True

        self.controller.promuovi_impiegato(cf, merito)

        self.controller.dao.promuovi_impiegato.assert_called_once_with(cf, merito)


class TestLaboratorioController(unittest.TestCase):

    def setUp(self):
        self.mock_db = MagicMock()
        self.controller = LaboratorioController(self.mock_db)

    def test_aggiungi_laboratorio(self):
        self.controller.dao.inserisci_laboratorio = MagicMock()

        laboratorio = {
            "nome": "Lab AI",
            "resp_sci": "CF9876543210",
            "topic": "Artificial Intelligence",
        }

        self.controller.aggiungi_laboratorio(**laboratorio)

        self.controller.dao.inserisci_laboratorio.assert_called_once_with(
            nome="Lab AI",
            resp_sci="CF9876543210",
            topic="Artificial Intelligence"
        )


class TestProjectController(unittest.TestCase):

    def setUp(self):
        self.mock_db = MagicMock()
        self.controller = ProjectController(self.mock_db)

    def test_inserisci_progetto(self):
        self.controller.dao.insert_project = MagicMock()

        progetto = {
            "cup": "CUP123",
            "ref_sci": "CF1234567890",
            "resp": "CF0987654321",
            "nome": "Progetto AI",
            "budget": 100000.00,
        }

        self.controller.inserisci_progetto(**progetto)

        self.controller.dao.insert_project.assert_called_once_with(
            cup="CUP123",
            ref_sci="CF1234567890",
            resp="CF0987654321",
            nome="Progetto AI",
            budget=100000.00
        )

if __name__ == "__main__":
    unittest.main()