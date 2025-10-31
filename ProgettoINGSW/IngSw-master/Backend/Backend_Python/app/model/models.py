from sqlalchemy import Column, String, Integer, Boolean, Date, Numeric, ForeignKey
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class Impiegato(Base):
    __tablename__ = "impiegato"
    
    cf = Column(String(16),primary_key = True)
    nome = Column(String(20), nullable=False)
    cognome = Column(String(20), nullable=False)
    data_nascita = Column(Date, nullable=False)
    merito = Column(Boolean, default=False)
    codice_contratto = Column(String(10), nullable=False, unique=True)
    data_assunzione = Column(Date, nullable=False)
    eta = Column(Integer)
    categoria = Column(String(20), nullable=False)
    salario = Column(Numeric, nullable=False)
    
    def __init__(self, cf, nome, cognome, data_nascita, data_assunzione, codice_contratto, merito, salario, categoria, eta):
        self.cf = cf
        self.nome = nome
        self.cognome = cognome
        self.data_nascita = data_nascita
        self.data_assunzione = data_assunzione
        self.codice_contratto = codice_contratto
        self.merito = merito
        self.salario = salario
        self.categoria = categoria
        self.eta = eta

    def to_dict(self):
        return {
            "cf": self.cf,
            "nome": self.nome,
            "cognome": self.cognome,
            "data_nascita": self.data_nascita.isoformat() if self.data_nascita else None,
            "data_assunzione": self.data_assunzione.isoformat() if self.data_assunzione else None,
            "codice_contratto": self.codice_contratto,
            "merito": self.merito,
            "salario": self.salario,
            "categoria": self.categoria,
            "eta": self.eta
        }
    
class Promozione(Base):
    __tablename__ = "promozione"

    cf = Column(String(16), ForeignKey("impiegato.cf"), primary_key=True)
    contratto = Column(String(10), primary_key=True)
    data_passaggio = Column(Date, nullable=False)
    vecchia_categoria = Column(String(20), nullable = True)
    nuova_categoria = Column(String(20), nullable=True)

    def __init__(self, cf, contratto, data_passaggio, vecchia_categoria, nuova_categoria):
        self.cf = cf
        self.contratto = contratto
        self.data_passaggio = data_passaggio
        self.vecchia_categoria = vecchia_categoria
        self.nuova_categoria = nuova_categoria
        
    def to_dict(self):
        return {
            "cf": self.cf,
            "contratto": self.contratto,
            "data_passaggio": self.data_passaggio.isoformat() if self.data_passaggio else None,
            "vecchia_categoria": self.vecchia_categoria,
            "nuova_categoria": self.nuova_categoria
        }


class Laboratorio(Base):
    __tablename__ = "laboratorio"

    nome = Column(String(20), primary_key=True)
    responsabile_scientifico = Column(String(16), ForeignKey("impiegato.cf"), nullable=False)
    topic = Column(String(50), nullable=False)
    numero_afferenti = Column(Integer, nullable=True)

    def __init__(self, nome, responsabile_scientifico, topic, numero_afferenti):
        self.nome = nome
        self.responsabile_scientifico = responsabile_scientifico
        self.topic = topic
        self.numero_afferenti = numero_afferenti

    def to_dict(self):
        return {
            "nome": self.nome,
            "responsabile_scientifico": self.responsabile_scientifico,
            "topic": self.topic,
            "numero_afferenti": self.numero_afferenti
        }

class Progetto(Base):
    __tablename__ = "progetto"

    cup = Column(String(15), primary_key=True)
    referente_scientifico = Column(String(16), ForeignKey("impiegato.cf"), nullable=False)
    responsabile = Column(String(16), ForeignKey("impiegato.cf"), nullable=False)
    nome = Column(String(20), unique=True, nullable=False)
    budget = Column(Numeric, nullable=True)

    def __init__(self, cup, referente_scientifico, responsabile, nome, budget):
        self.cup = cup
        self.referente_scientifico = referente_scientifico
        self.responsabile = responsabile
        self.nome = nome
        self.budget = budget

    def to_dict(self):
        return {
            "cup": self.cup,
            "referente_scientifico": self.referente_scientifico,
            "responsabile": self.responsabile,
            "nome": self.nome,
            "budget": self.budget
        }