# Gestione Aziendale - Sistema Informativo

Questo progetto implementa un sistema informativo per la gestione del personale di un'azienda. Il sistema è composto da un backend sviluppato in Flask, un frontend sviluppato in React e un database relazionale PostgreSQL.

Il progetto permette di gestire impiegati, laboratori e progetti, consentendo operazioni come l'aggiunta, la modifica, l'eliminazione e la visualizzazione delle informazioni.

---

## **Indice**
1. [Descrizione](#descrizione)
2. [Tecnologie Utilizzate](#tecnologie-utilizzate)
3. [Requisiti di Sistema](#requisiti-di-sistema)
4. [Installazione](#installazione)
5. [Utilizzo](#utilizzo)
6. [Struttura del Progetto](#struttura-del-progetto)
7. [Contributi](#contributi)
8. [Licenza](#licenza)

---

## **Descrizione**

Il sistema è progettato per soddisfare le esigenze di un'azienda nella gestione del personale e delle risorse. Le funzionalità principali includono:

- **Gestione Impiegati**: Creazione, aggiornamento e rimozione di impiegati, con tracciamento dei ruoli e delle promozioni.
- **Gestione Laboratori**: Assegnazione di responsabili e gestione dei laboratori.
- **Gestione Progetti**: Associazione di laboratori e responsabili ai progetti.

Gli utenti target sono amministratori aziendali che desiderano una soluzione digitale per gestire dati complessi in modo semplice e organizzato.

---

## **Tecnologie Utilizzate**

- **Backend**: Flask, SQLAlchemy, Psycopg2
- **Frontend**: React.js
- **Database**: PostgreSQL
- **Containerizzazione**: Docker, Docker Compose

---

## **Requisiti di Sistema**

- **Python**: 3.9+
- **Node.js**: 16+
- **Docker**: 20.10+
- **PostgreSQL**: 13+
- **Sistema Operativo**: Windows, macOS o Linux

---

## **Installazione**

### **1. Clonare il Repository**

```bash
git clone https://github.com/<username>/<repository>.git
cd <repository>
```

### **2. Configurare le Variabili d'Ambiente**

Creare un file `.env` per il backend con i seguenti contenuti:

```env
FLASK_APP=Backend_Python.main:app
FLASK_ENV=development
DB_URL_DOCKER=postgresql://<username>:<password>@<host>/<database>
```

Creare un file `.env.local` per il frontend:

```env
REACT_APP_API_URL=http://localhost:5000
```

### **3. Avviare i Servizi con Docker**

```bash
docker-compose up --build
```

---

## **Utilizzo**

### **Accesso ai Servizi**

- **Frontend**: `http://localhost:3000`
- **Backend**: `http://localhost:5000`

### **API Principali**

#### **Impiegati**
- GET `/api/gestionale/impiegati`: Ottiene l'elenco degli impiegati
- POST `/api/impiegati/`: Aggiunge un nuovo impiegato

#### **Laboratori**
- GET `/api/gestionale/laboratori`: Ottiene l'elenco dei laboratori
- POST `/api/laboratori/`: Aggiunge un nuovo laboratorio

#### **Progetti**
- GET `/api/gestionale/progetti`: Ottiene l'elenco dei progetti
- POST `/api/progetti/`: Aggiunge un nuovo progetto

---

## **Struttura del Progetto**

```plaintext
.
├── Backend
│   ├── Backend_Python
│   │   ├── app
│   │   │   ├── routes
│   │   │   ├── controller
│   │   │   └── dao
│   │   ├── database.py
│   │   └── requirements.txt
│   └── Backend_SQL
│       └── Dump
├── Frontend
│   ├── public
│   └── src
│       ├── components
│       └── services
├── docker-compose.yml
└── README.md
```

---

## **Contributi**

Siamo aperti ai contributi della community. Segui questi passaggi per contribuire:

1. **Fork del repository**
   ```bash
   git checkout -b feature/nome-feature
   ```
2. **Aggiungi le modifiche** e crea un commit:
   ```bash
   git commit -m "Descrizione delle modifiche"
   ```
3. **Crea una Pull Request**

---

## **Licenza**

Questo progetto è rilasciato sotto la licenza MIT. Consulta il file `LICENSE` per ulteriori dettagli.

