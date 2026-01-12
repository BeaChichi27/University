--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';

--
-- Name: impiegato; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.impiegato (
    cf character varying(16) NOT NULL,
    nome character varying(20) NOT NULL,
    cognome character varying(20) NOT NULL,
    datanascita date NOT NULL,
    merito boolean,
    codicecon character varying(10) NOT NULL,
    dataassunzione date NOT NULL,
    eta integer,
    categoria character varying(20) NOT NULL,
    salario numeric NOT NULL
);


ALTER TABLE public.impiegato OWNER TO postgres;

--
-- Name: laboratorio; Type: TABLE; Schema: public; Owner: postgres
--

-- Tabella laboratorio senza constraint issenior
CREATE TABLE public.laboratorio (
    nome character varying(20) NOT NULL,
    respscie character varying(16) NOT NULL,
    topic character varying(50) NOT NULL,
    n_afferenti integer
);

ALTER TABLE public.laboratorio OWNER TO postgres;

-- Tabella progetto senza constraint issenior e isdirector
CREATE TABLE public.progetto (
    cup character varying(15) NOT NULL,
    refscie character varying(16) NOT NULL,
    respscie character varying(16) NOT NULL,
    nome character varying(20) NOT NULL,
    budget numeric
);

ALTER TABLE public.progetto OWNER TO postgres;

--
-- Name: lavora; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lavora (
    lab1 character varying(20),
    lab2 character varying(20),
    lab3 character varying(20),
    cup character varying(15)
);


ALTER TABLE public.lavora OWNER TO postgres;

--
-- Name: promozione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promozione (
    cf character varying(16) NOT NULL,
    codicecon character varying(20),
    datapassaggio date NOT NULL,
    vecchiacategoria character varying(20),
    nuovacategoria character varying(20) NOT NULL
);


ALTER TABLE public.promozione OWNER TO postgres;

--
-- Name: promozioni; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promozioni (
    cf character varying(16) NOT NULL,
    categoria1 character varying(20),
    datapassaggio1 date,
    categoria2 character varying(20),
    datapassaggio2 date,
    categoria3 character varying(20),
    datapassaggio3 date,
    categoria4 character varying(20),
    datapassaggio4 date
);


ALTER TABLE public.promozioni OWNER TO postgres;

--
-- Name: calcola_dati_impiegato(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calcola_dati_impiegato() RETURNS TABLE(codicefiscale character varying, categoria1 character varying, datapassaggio1 date, categoria2 character varying, datapassaggio2 date, categoria3 character varying, datapassaggio3 date, categoria4 character varying, datapassaggio4 date)
    LANGUAGE plpgsql
    AS $$

DECLARE

    impiegato_record impiegato%ROWTYPE;

BEGIN

    FOR impiegato_record IN SELECT * FROM impiegato LOOP

        IF impiegato_record.merito = true THEN

            IF EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM impiegato_record.dataassunzione) > 7 THEN

                RETURN QUERY (

                    SELECT

                        impiegato_record.cf::varchar AS codicefiscale,

                        'Junior'::varchar AS categoria1,

                        impiegato_record.dataassunzione AS datapassaggio1,

                        'Middle'::varchar AS categoria2,

                        CAST(impiegato_record.dataassunzione + INTERVAL '3 years' AS date) AS datapassaggio2,

                        'Senior'::varchar AS categoria3,

                        CAST(impiegato_record.dataassunzione + INTERVAL '7 years' AS date) AS datapassaggio3,

                        'Dirigente'::varchar AS categoria4,

                        CAST(impiegato_record.dataassunzione + INTERVAL '8 years' AS date) AS datapassaggio4

                );

            ELSIF EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM impiegato_record.dataassunzione) <= 7

                  AND EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM impiegato_record.dataassunzione) >= 3 THEN

                RETURN QUERY (

                    SELECT

                        impiegato_record.cf::varchar AS codicefiscale,

                        'Junior'::varchar AS categoria1,

                        impiegato_record.dataassunzione AS datapassaggio1,

                        'Middle'::varchar AS categoria2,

                        CAST(impiegato_record.dataassunzione + INTERVAL '3 years' AS date) AS datapassaggio2,

                        NULL::varchar AS categoria3,

                        NULL::date AS datapassaggio3,

                        'Dirigente'::varchar AS categoria4,

                        CAST(impiegato_record.dataassunzione + INTERVAL '4 years' AS date) AS datapassaggio4

                );

            ELSIF EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM impiegato_record.dataassunzione) < 3 THEN

                RETURN QUERY (

                    SELECT

                        impiegato_record.cf::varchar AS codicefiscale,

                        'Junior'::varchar AS categoria1,

                        impiegato_record.dataassunzione AS datapassaggio1,

                        NULL::varchar AS categoria2,

                        NULL::date AS datapassaggio2,

                        NULL::varchar AS categoria3,

                        NULL::date AS datapassaggio3,

                        'Dirigente'::varchar AS categoria4,

                        CAST(impiegato_record.dataassunzione + INTERVAL '4 years' AS date) AS datapassaggio4

                );

            END IF;

        ELSIF impiegato_record.merito = false THEN

            IF EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM impiegato_record.dataassunzione) > 7 THEN

                RETURN QUERY (

                    SELECT

                        impiegato_record.cf::varchar AS codicefiscale,

                        'Junior'::varchar AS categoria1,

                        impiegato_record.dataassunzione AS datapassaggio1,

                        'Middle'::varchar AS categoria2,

                        CAST(impiegato_record.dataassunzione + INTERVAL '3 years' AS date) AS datapassaggio2,

                        'Senior'::varchar AS categoria3,

                        CAST(impiegato_record.dataassunzione + INTERVAL '7 years' AS date) AS datapassaggio3,

                        NULL::varchar AS categoria4,

                        NULL::date AS datapassaggio4

                );

            ELSIF EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM impiegato_record.dataassunzione) <= 7

                  AND EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM impiegato_record.dataassunzione) >= 3 THEN

                RETURN QUERY (

                    SELECT

                        impiegato_record.cf::varchar AS codicefiscale,

                        'Junior'::varchar AS categoria1,

                        impiegato_record.dataassunzione AS datapassaggio1,

                        'Middle'::varchar AS categoria2,

                        CAST(impiegato_record.dataassunzione + INTERVAL '3 years' AS date) AS datapassaggio2,

                        NULL::varchar AS categoria3,

                        NULL::date AS datapassaggio3,

                        NULL::varchar AS categoria4,

                        NULL::date AS datapassaggio4

                );

            ELSIF EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM impiegato_record.dataassunzione) < 3 THEN

                RETURN QUERY (

                    SELECT

                        impiegato_record.cf::varchar AS codicefiscale,

                        'Junior'::varchar AS categoria1,

                        impiegato_record.dataassunzione AS datapassaggio1,

                        NULL::varchar AS categoria2,

                        NULL::date AS datapassaggio2,

                        NULL::varchar AS categoria3,

                        NULL::date AS datapassaggio3,

                        NULL::varchar AS categoria4,

                        NULL::date AS datapassaggio4

                );

            END IF;

        END IF;

    END LOOP;

    RETURN;

END;

$$;


ALTER FUNCTION public.calcola_dati_impiegato() OWNER TO postgres;

--
-- Name: preleva_dati; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.preleva_dati AS
 SELECT codicefiscale,
    categoria1,
    datapassaggio1,
    categoria2,
    datapassaggio2,
    categoria3,
    datapassaggio3,
    categoria4,
    datapassaggio4
   FROM public.calcola_dati_impiegato() calcola_dati_impiegato(codicefiscale, categoria1, datapassaggio1, categoria2, datapassaggio2, categoria3, datapassaggio3, categoria4, datapassaggio4);


ALTER VIEW public.preleva_dati OWNER TO postgres;

--
-- Name: presenza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.presenza (
    cup character varying(20),
    nome character varying(20),
    cognome character varying(20),
    cf character varying(20),
    categoria character varying(20)
);


ALTER TABLE public.presenza OWNER TO postgres;

--
-- Name: progetti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.progetti (
    cup character varying NOT NULL,
    refscie character varying NOT NULL,
    respscie character varying NOT NULL,
    nome character varying NOT NULL,
    budget numeric
);


ALTER TABLE public.progetti OWNER TO postgres;

--
-- Name: progetto; Type: TABLE; Schema: public; Owner: postgres
--

--
-- Name: utilizza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilizza (
    cf character varying(16) NOT NULL,
    nomelab character varying(20) NOT NULL
);


ALTER TABLE public.utilizza OWNER TO postgres;

--
-- Name: aggiornan_afferenti(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aggiornan_afferenti() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN



    UPDATE Laboratorio

    SET N_Afferenti = N_Afferenti + 1

    WHERE Nome = NEW.NomeLab;



    RETURN NEW;

END;

$$;


ALTER FUNCTION public.aggiornan_afferenti() OWNER TO postgres;

--
-- Name: aggiornapromozioni(character varying, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.aggiornapromozioni(IN cf_n character varying, IN meri_n boolean)
    LANGUAGE plpgsql
    AS $$

DECLARE

    datapassaggio_1 date;

BEGIN



    SELECT impiegato.dataassunzione INTO datapassaggio_1

    FROM impiegato

    WHERE cf = cf_n;



    IF meri_n THEN



        UPDATE promozioni

        SET categoria4 = 'Dirigente'

        WHERE cf = cf_n;



        UPDATE promozioni

        SET datapassaggio4 = datapassaggio_1

        WHERE cf = cf_n;



    end if;



    IF NOT meri_n THEN



        UPDATE promozioni

        SET categoria1 = 'Junior'

        WHERE cf = cf_n;



        UPDATE promozioni

        SET datapassaggio1 = datapassaggio_1

        WHERE cf = cf_n;

    end if;

END;

$$;


ALTER PROCEDURE public.aggiornapromozioni(IN cf_n character varying, IN meri_n boolean) OWNER TO postgres;

--
-- Name: dirigente(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dirigente(cod_fisc character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN

    IF EXISTS(

        SELECT 1

        FROM Impiegato

        WHERE CF = cod_fisc AND Categoria <> 'Dirigente'

    ) THEN

		UPDATE Progetto

		SET RespScie = (SELECT CF FROM Impiegato WHERE Categoria = 'Dirigente')

		WHERE RespScie IS NULL;

		RETURN TRUE;

	END IF;

END;

$$;


ALTER FUNCTION public.dirigente(cod_fisc character varying) OWNER TO postgres;

--
-- Name: inserisci_impiegato(character varying, character varying, character varying, date, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.inserisci_impiegato(cf character varying, nome character varying, cognome character varying, datanascita date, codicecon character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    eta INT;
BEGIN
    -- Calcola l'etÔÇª
    SELECT DATE_PART('year', AGE(datanascita)) INTO eta;

    -- Controlla che l'impiegato abbia almeno 18 anni
    IF eta < 18 THEN
        RAISE EXCEPTION 'L''impiegato deve avere almeno 18 anni. EtÔÇª attuale: %', eta;
    END IF;

    -- Inserisce un nuovo impiegato
    INSERT INTO impiegato (cf, nome, cognome, datanascita, dataassunzione, categoria, salario, merito, codicecon, eta)
    VALUES (
        cf,
        nome,
        cognome,
        datanascita,
        CURRENT_DATE, -- Data di assunzione ┼á sempre quella corrente
        'Junior',     -- Categoria iniziale
        1500.00,      -- Salario iniziale
        FALSE,        -- Merito iniziale
        codicecon,
        eta           -- EtÔÇª calcolata
    );

    -- Aggiorna la vista preleva_dati tramite calcola_dati_impiegato
    PERFORM calcola_dati_impiegato();
END;
$$;


ALTER FUNCTION public.inserisci_impiegato(cf character varying, nome character varying, cognome character varying, datanascita date, codicecon character varying) OWNER TO postgres;

--
-- Name: inseriscilaboratorio(character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inseriscilaboratorio(IN nome_n character varying, IN respscie_n character varying, IN topic_n character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN



    INSERT INTO utilizza (cf, nomelab) VALUES (respscie_n, nome_n);





    INSERT INTO Laboratorio (Nome, RespScie, Topic, N_Afferenti)

    VALUES (Nome_n, RespScie_n, Topic_n, 1);

END;

$$;


ALTER PROCEDURE public.inseriscilaboratorio(IN nome_n character varying, IN respscie_n character varying, IN topic_n character varying) OWNER TO postgres;

--
-- Name: inseriscilavora(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inseriscilavora(IN cup_progetto character varying, IN nome_lab character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se il laboratorio ┼á giÔÇª associato a un altro progetto
    IF EXISTS (
        SELECT 1
        FROM lavora
        WHERE lab1 = nome_lab OR lab2 = nome_lab OR lab3 = nome_lab
    ) THEN
        RAISE EXCEPTION 'Il laboratorio % ┼á giÔÇª associato a un altro progetto', nome_lab;
    END IF;

    -- Determina quale colonna ┼á disponibile per il laboratorio
    IF NOT EXISTS (
        SELECT 1
        FROM lavora
        WHERE cup = cup_progetto AND lab1 IS NULL
    ) THEN
        UPDATE lavora
        SET lab1 = nome_lab
        WHERE cup = cup_progetto;
    ELSIF NOT EXISTS (
        SELECT 1
        FROM lavora
        WHERE cup = cup_progetto AND lab2 IS NULL
    ) THEN
        UPDATE lavora
        SET lab2 = nome_lab
        WHERE cup = cup_progetto;
    ELSIF NOT EXISTS (
        SELECT 1
        FROM lavora
        WHERE cup = cup_progetto AND lab3 IS NULL
    ) THEN
        UPDATE lavora
        SET lab3 = nome_lab
        WHERE cup = cup_progetto;
    ELSE
        RAISE EXCEPTION 'Il progetto % ha giÔÇª il massimo numero di laboratori associati', cup_progetto;
    END IF;

END;
$$;


ALTER PROCEDURE public.inseriscilavora(IN cup_progetto character varying, IN nome_lab character varying) OWNER TO postgres;

--
-- Name: inseriscipresenza(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inseriscipresenza(IN cup_ins character varying)
    LANGUAGE plpgsql
    AS $$

DECLARE

    nome_ins varchar;

    cognome_ins varchar;

    cf_ins varchar;

BEGIN

    BEGIN

        SELECT i.nome, i.cognome, i.cf INTO nome_ins, cognome_ins, cf_ins

        FROM impiegato AS i JOIN progetto AS p ON i.cf = p.respscie

        WHERE p.cup = cup_ins;



        UPDATE progetto

        SET respscie = cf_ins

        WHERE cup = cup_ins;



        INSERT INTO presenza(cup, nome, cognome, cf) VALUES (cup_ins, nome_ins, cognome_ins, cf_ins);

    EXCEPTION

        WHEN NO_DATA_FOUND THEN

            RAISE EXCEPTION 'Dati non trovati per cup %', cup_ins;

        WHEN OTHERS THEN

            RAISE EXCEPTION 'Errore durante l''inserimento della presenza per cup %: %', cup_ins, SQLERRM;

    END;



    BEGIN

        SELECT i.nome, i.cognome, i.cf INTO nome_ins, cognome_ins, cf_ins

        FROM impiegato AS i JOIN progetto AS p ON i.cf = p.refscie

        WHERE p.cup = cup_ins;



        UPDATE progetto

        SET refscie = cf_ins

        WHERE cup = cup_ins;



        INSERT INTO presenza(cup, nome, cognome, cf) VALUES (cup_ins, nome_ins, cognome_ins, cf_ins);

    EXCEPTION

        WHEN NO_DATA_FOUND THEN

            RAISE EXCEPTION 'Dati non trovati per cup %', cup_ins;

        WHEN OTHERS THEN

            RAISE EXCEPTION 'Errore durante l''inserimento della presenza per cup %: %', cup_ins, SQLERRM;

    END;

END;

$$;


ALTER PROCEDURE public.inseriscipresenza(IN cup_ins character varying) OWNER TO postgres;

--
-- Name: inserisciprogetto(character varying, character varying, character varying, character varying, numeric); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inserisciprogetto(IN cup character varying, IN ref_sci character varying, IN resp character varying, IN nome character varying, IN budget numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Progetto (cup, refscie, respscie, nome, budget)
    VALUES (cup, ref_sci, resp, nome, budget);
END;
$$;


ALTER PROCEDURE public.inserisciprogetto(IN cup character varying, IN ref_sci character varying, IN resp character varying, IN nome character varying, IN budget numeric) OWNER TO postgres;

--
-- Name: inseriscipromozioni(character varying, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inseriscipromozioni(IN cf_ins character varying, IN meri boolean)
    LANGUAGE plpgsql
    AS $$

DECLARE

    categoria_1 varchar;

    categoria_2 varchar;

    categoria_3 varchar;

    categoria_4 varchar;

    datapassaggio_1 date;

    datapassaggio_2 date;

    datapassaggio_3 date;

    datapassaggio_4 date;

    salar numeric;

BEGIN



    categoria_1:= NULL;

    categoria_2:= NULL;

    categoria_3:= NULL;

    categoria_4:= NULL;

    datapassaggio_2 := NULL;

    datapassaggio_3 := NULL;

    datapassaggio_4 := NULL;



    SELECT impiegato.dataassunzione INTO datapassaggio_1

    FROM impiegato

    WHERE cf = cf_ins;



    IF meri = true THEN



        salar := 3000.00;

        IF EXTRACT(YEAR FROM CURRENT_DATE) -

           EXTRACT(YEAR FROM datapassaggio_1) > 7 THEN

            categoria_1 := 'Junior';

            categoria_2 := 'Middle';

            datapassaggio_2 := datapassaggio_1 + INTERVAL '3 years';

            categoria_3 := 'Senior';

            datapassaggio_3 := datapassaggio_1 + INTERVAL '7 years';

            categoria_4 := 'Dirigente';

            datapassaggio_4 := datapassaggio_1 + INTERVAL '8 years';

        ELSIF EXTRACT(YEAR FROM CURRENT_DATE) -

           EXTRACT(YEAR FROM datapassaggio_1) < 3 THEN

            categoria_1 := 'Junior';

            categoria_4 := 'Dirigente';

            datapassaggio_4 := datapassaggio_1 + INTERVAL '1 year';

        ELSEIF EXTRACT(YEAR FROM CURRENT_DATE) -

           EXTRACT(YEAR FROM datapassaggio_1) >= 3 AND

               EXTRACT(YEAR FROM CURRENT_DATE) -

           EXTRACT(YEAR FROM datapassaggio_1) <= 7 THEN

            categoria_1 := 'Junior';

            categoria_2 := 'Middle';

            datapassaggio_2 := datapassaggio_1 + INTERVAL '3 years';

            categoria_4 := 'Dirigente';

            datapassaggio_4 := datapassaggio_1 + INTERVAL '4 years';

        END IF;

        UPDATE impiegato

        SET categoria = categoria_4

        WHERE cf = cf_ins;

    end if;



    IF meri = false THEN

        IF EXTRACT(YEAR FROM CURRENT_DATE) -

           EXTRACT(YEAR FROM datapassaggio_1) > 7 THEN

            categoria_1 := 'Junior';

            categoria_2 := 'Middle';

            datapassaggio_2 := datapassaggio_1 + INTERVAL '3 years';

            categoria_3 := 'Senior';

            datapassaggio_3 := datapassaggio_1 + INTERVAL '7 years';

            salar := 2500.00;

            UPDATE impiegato

            SET categoria = categoria_3

            WHERE cf = cf_ins;

        ELSIF EXTRACT(YEAR FROM CURRENT_DATE) -

           EXTRACT(YEAR FROM datapassaggio_1) < 3 THEN

            categoria_1 := 'Junior';

            UPDATE impiegato

            SET categoria = categoria_1

            WHERE cf = cf_ins;

            salar := 1500.00;

        ELSEIF EXTRACT(YEAR FROM CURRENT_DATE) -

           EXTRACT(YEAR FROM datapassaggio_1) >= 3 AND

               EXTRACT(YEAR FROM CURRENT_DATE) -

           EXTRACT(YEAR FROM datapassaggio_1) <= 7 THEN

            categoria_1 := 'Junior';

            categoria_2 := 'Middle';

            UPDATE impiegato

            SET categoria = categoria_2

            WHERE cf = cf_ins;

            datapassaggio_2 := datapassaggio_1 + INTERVAL '3 years';

            salar := 2000.00;

        END IF;

    end if;



    UPDATE impiegato

    SET salario = salar

    WHERE cf = cf_ins;



    DELETE FROM promozioni WHERE cf = cf_ins;



    INSERT INTO promozioni(cf, categoria1, datapassaggio1, categoria2, datapassaggio2, categoria3, datapassaggio3, categoria4, datapassaggio4)

    VALUES (cf_ins, categoria_1, datapassaggio_1, categoria_2, datapassaggio_2, categoria_3, datapassaggio_3, categoria_4, datapassaggio_4);

END;

$$;


ALTER PROCEDURE public.inseriscipromozioni(IN cf_ins character varying, IN meri boolean) OWNER TO postgres;

--
-- Name: inserisciutilizza(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inserisciutilizza(IN cf_ins character varying, IN nomelab_ins character varying)
    LANGUAGE plpgsql
    AS $$

    DECLARE

        n_aff integer;

BEGIN

    IF NOT EXISTS(

        SELECT *

        FROM impiegato

        WHERE cf = cf_ins

        LIMIT 1

    ) THEN

        RAISE EXCEPTION 'Non esiste il cf inserito!';

    end if;



    IF NOT EXISTS(

        SELECT *

        FROM laboratorio

        WHERE nome = nomelab_ins

        LIMIT 1

    ) THEN

        RAISE EXCEPTION 'Non esiste il laboratorio inserito!';

    end if;



    IF EXISTS(

        SELECT *

        FROM utilizza

        WHERE cf = cf_ins AND nomelab = nomelab_ins

        LIMIT 1

    ) THEN

        RAISE EXCEPTION 'Esiste questa coppia in utilizza!';

    end if;



    SELECT laboratorio.n_afferenti INTO n_aff

    FROM laboratorio

    WHERE nome = nomelab_ins;



    INSERT INTO utilizza(cf, nomelab) VALUES

    (cf_ins, nomelab_ins);



    UPDATE laboratorio

    SET n_afferenti = n_afferenti + 1

    WHERE nome = nomelab_ins;



END

$$;


ALTER PROCEDURE public.inserisciutilizza(IN cf_ins character varying, IN nomelab_ins character varying) OWNER TO postgres;

--
-- Name: lavora_view(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lavora_view(cf_ins character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$

DECLARE

    cup_result VARCHAR;

BEGIN

    SELECT lavora.cup INTO cup_result

    FROM lavora

    JOIN utilizza ON lavora.lab1 = utilizza.nomelab

                    OR lavora.lab2 = utilizza.nomelab

                    OR lavora.lab3 = utilizza.nomelab

    WHERE utilizza.cf = cf_ins;



    RETURN cup_result;

END;

$$;


ALTER FUNCTION public.lavora_view(cf_ins character varying) OWNER TO postgres;

--
-- Name: limite_laboratori(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.limite_laboratori() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    -- Conta il numero attuale di laboratori associati al progetto

    IF (SELECT COUNT(*) FROM Lavora WHERE CUP = OLD.CUP) > 3 THEN

        RAISE EXCEPTION 'Un progetto pu├▓ avere al massimo 3 laboratori';

    END IF;



    RETURN OLD;

END;

$$;


ALTER FUNCTION public.limite_laboratori() OWNER TO postgres;

--
-- Name: passaggio_ruolo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.passaggio_ruolo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

    Merito boolean;

    Eta            int ;

    data_assunzione date ;

    codice_con varchar(20);

BEGIN



    NEW.VecchiaCategoria := OLD.NuovaCategoria;



    SELECT dataassunzione INTO data_assunzione

    FROM impiegato

    WHERE cf = OLD.cf AND codicecon = OLD.codicecon;



    SELECT impiegato.merito INTO Merito

    FROM impiegato

    WHERE cf = OLD.cf AND codicecon = OLD.codicecon;







    Eta := EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_assunzione);



    IF Merito THEN

        NEW.NuovaCategoria := 'Dirigente';

        SELECT CONCAT(impiegato.codicecon, '.4') INTO codice_con

            FROM impiegato

            WHERE cf = OLD.cf;

            UPDATE promozione

            SET codicecon = codice_con;

    ELSE

        IF Eta < 3 THEN

            NEW.NuovaCategoria := 'Dipendente junior';

            SELECT CONCAT(impiegato.codicecon, '.1') INTO codice_con

            FROM impiegato

            WHERE cf = OLD.cf;

            UPDATE promozione

            SET codicecon = codice_con;



        ELSIF Eta >= 3 AND Eta < 7 THEN

            NEW.NuovaCategoria := 'Dipendente middle';

            SELECT CONCAT(impiegato.codicecon, '.2') INTO codice_con

            FROM impiegato

            WHERE cf = OLD.cf;

            UPDATE promozione

            SET codicecon = codice_con;

        ELSE

            NEW.NuovaCategoria := 'Dipendente senior';

            SELECT CONCAT(impiegato.codicecon, '.3') INTO codice_con

            FROM impiegato

            WHERE cf = OLD.cf;

            UPDATE promozione

            SET codicecon = codice_con;

        END IF;

    END IF;



    UPDATE impiegato

    SET categoria = NEW.NuovaCategoria

    WHERE cf = OLD.cf AND codicecon = OLD.codicecon;



    RETURN NEW;

END;

$$;


ALTER FUNCTION public.passaggio_ruolo() OWNER TO postgres;

--
-- Name: prevent_loop(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.prevent_loop() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        -- Verifica per evitare loop
        RAISE NOTICE 'Eliminazione in loop interrotta.';
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;

ALTER FUNCTION public.prevent_loop() OWNER TO postgres;

--
-- Name: promuovi_impiegato(character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.promuovi_impiegato(cf_ins character varying, meri boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    vecchia_cat VARCHAR;
    nuova_cat VARCHAR;
    codice VARCHAR;
    data_pass DATE;
    salar NUMERIC;
BEGIN
    -- Recupera il codice contratto e la data di assunzione
    SELECT codicecon, dataassunzione INTO codice, data_pass
    FROM impiegato
    WHERE cf = cf_ins;

    -- Controlla se codicecon ┼á nullo
    IF codice IS NULL THEN
        RAISE NOTICE 'codicecon ┼á nullo per l''impiegato %, promozione non completata', cf_ins;
    END IF;

    -- Calcola la nuova categoria e il salario
    IF meri = TRUE THEN
        nuova_cat := 'Dirigente';
        salar := 3000.00;
    ELSE
        IF EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_pass) > 7 THEN
            nuova_cat := 'Senior';
            salar := 2500.00;
        ELSIF EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_pass) BETWEEN 3 AND 7 THEN
            nuova_cat := 'Middle';
            salar := 2000.00;
        ELSE
            nuova_cat := 'Junior';
            salar := 1500.00;
        END IF;
    END IF;

    -- Recupera la vecchia categoria
    SELECT categoria INTO vecchia_cat
    FROM impiegato
    WHERE cf = cf_ins;

    -- Inserisce il record di promozione
    INSERT INTO promozione (cf, codicecon, datapassaggio, vecchiacategoria, nuovacategoria)
    VALUES (cf_ins, codice, CURRENT_DATE, vecchia_cat, nuova_cat);

    -- Aggiorna la categoria e il salario dell'impiegato
    UPDATE impiegato
    SET categoria = nuova_cat, salario = salar
    WHERE cf = cf_ins;

    -- Aggiorna i dati correlati tramite calcola_dati_impiegato
    PERFORM calcola_dati_impiegato();
END;
$$;


ALTER FUNCTION public.promuovi_impiegato(cf_ins character varying, meri boolean) OWNER TO postgres;


CREATE PROCEDURE public.rimuovi_impiegato(IN cf_impiegato character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Gestire i laboratori dove l'impiegato ┼á responsabile
    IF EXISTS (SELECT 1 FROM Laboratorio WHERE RespScie = cf_impiegato) THEN
        UPDATE Laboratorio
        SET RespScie = (
            SELECT CF
            FROM impiegato
            WHERE Categoria = 'Senior' AND CF <> cf_impiegato AND resposenior(CF)
            LIMIT 1
        )
        WHERE RespScie = cf_impiegato;
    END IF;

    -- Gestire i progetti dove l'impiegato ┼á responsabile scientifico
    IF EXISTS (SELECT 1 FROM Progetto WHERE RespScie = cf_impiegato) THEN
        UPDATE Progetto
        SET RespScie = (
            SELECT CF
            FROM impiegato
            WHERE Categoria = 'Dirigente' AND CF <> cf_impiegato AND refdir(CF)
            LIMIT 1
        )
        WHERE RespScie = cf_impiegato;
    END IF;

    -- Gestire i progetti dove l'impiegato ┼á referente scientifico
    IF EXISTS (SELECT 1 FROM Progetto WHERE RefScie = cf_impiegato) THEN
        UPDATE Progetto
        SET RefScie = (
            SELECT CF
            FROM impiegato
            WHERE Categoria = 'Senior' AND CF <> cf_impiegato AND resposenior(CF)
            LIMIT 1
        )
        WHERE RefScie = cf_impiegato;
    END IF;

    -- Eliminare l'impiegato
    DELETE FROM Impiegato WHERE CF = cf_impiegato;
END;
$$;


ALTER PROCEDURE public.rimuovi_impiegato(IN cf_impiegato character varying) OWNER TO postgres;

--
-- Name: rimuovi_laboratorio(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.rimuovi_laboratorio(IN nuovo_lab character varying)
    LANGUAGE plpgsql
    AS $$

DECLARE

    Lab_el VARCHAR(20);

BEGIN

	-- Trova il nome del laboratorio che sta per essere rimosso

    SELECT NomeLab INTO Lab_el FROM Utilizza WHERE NomeLab = nuovo_Lab LIMIT 1;



    -- Verifica se il laboratorio da rimuovere ├¿ l'ultimo rimanente in un progetto

    IF (SELECT COUNT(*) FROM Lavora WHERE Lab1 = Lab_el OR Lab2 = Lab_el OR Lab3 = Lab_el) > 1 THEN

        -- Trova un laboratorio non impegnato in nessun progetto come rimpiazzo

        SELECT Nome INTO nuovo_Lab FROM Laboratorio

        WHERE Nome NOT IN (SELECT Lab1 FROM Lavora UNION SELECT Lab2 FROM Lavora UNION SELECT Lab3 FROM Lavora)

        LIMIT 1;



        -- Aggiorna il laboratorio che sta per essere rimosso con il rimpiazzo

        IF (SELECT Lab1 FROM Lavora WHERE Lab1 = Lab_el) IS NOT NULL THEN

            UPDATE Lavora SET Lab1 = nuovo_Lab WHERE Lab1 = Lab_el;

        END IF;



        IF (SELECT Lab2 FROM Lavora WHERE Lab2 = Lab_el) IS NOT NULL THEN

            UPDATE Lavora SET Lab2 = nuovo_Lab WHERE Lab2 = Lab_el;

        END IF;



        IF (SELECT Lab3 FROM Lavora WHERE Lab3 = Lab_el) IS NOT NULL THEN

            UPDATE Lavora SET Lab3 = nuovo_Lab WHERE Lab3 = Lab_el;

        END IF;

    END IF;



    DELETE FROM Laboratorio WHERE Nome = nuovo_Lab;

END;

$$;


ALTER PROCEDURE public.rimuovi_laboratorio(IN nuovo_lab character varying) OWNER TO postgres;

--
-- Name: rimuovi_lavora(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.rimuovi_lavora(IN cup_r character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

    DELETE FROM Lavora WHERE CUP = cup_r;

END;

$$;


ALTER PROCEDURE public.rimuovi_lavora(IN cup_r character varying) OWNER TO postgres;

--
-- Name: rimuovi_progetto(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.rimuovi_progetto(IN cup_r character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Elimina le associazioni dalla tabella lavora
  DELETE FROM lavora WHERE cup = cup_r;

  -- Elimina il progetto dalla tabella progetto
  DELETE FROM progetto WHERE cup = cup_r;

  RAISE NOTICE 'Progetto % e le sue associazioni sono stati rimossi.', cup_r;
END;
$$;


ALTER PROCEDURE public.rimuovi_progetto(IN cup_r character varying) OWNER TO postgres;

--
-- Name: rimuovi_utilizza(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.rimuovi_utilizza(IN cf_impiegato character varying, IN nome_lab character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

    DELETE FROM Utilizza

    WHERE CF = cf_impiegato AND NomeLab = nome_lab;



    UPDATE Laboratorio

    SET N_Afferenti = N_Afferenti - 1

    WHERE Nome = nome_lab;

END;

$$;


ALTER PROCEDURE public.rimuovi_utilizza(IN cf_impiegato character varying, IN nome_lab character varying) OWNER TO postgres;

--
-- Name: senior(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.senior(codice_fiscale character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN

    IF EXISTS (

        SELECT 1

        FROM impiegato

        WHERE CF = codice_fiscale AND Categoria <> 'Senior'

    ) THEN

		UPDATE Progetto

        SET RefScie = (SELECT CF FROM Impiegato WHERE Categoria = 'Senior' AND CF NOT IN (SELECT RefScie FROM Progetto) LIMIT 1)

        WHERE RefScie IS NULL;



        UPDATE Laboratorio

        SET RespScie = (SELECT CF FROM Impiegato WHERE Categoria = 'Senior' AND CF NOT IN (SELECT RespScie FROM Laboratorio) LIMIT 1)

        WHERE RespScie IS NULL;

		RETURN TRUE;

	END IF;

END;

$$;


ALTER FUNCTION public.senior(codice_fiscale character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Data for Name: impiegato; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.impiegato (cf, nome, cognome, datanascita, merito, codicecon, dataassunzione, eta, categoria, salario) FROM stdin;
CF4	Nome4	Cognome4	1982-04-17	t	Codice4	2016-09-01	42	Dirigente	3000.00
CF10	Nome10	Cognome10	1987-08-25	t	Codice10	2014-03-15	37	Dirigente	3000.00
CF11	Nome11	Cognome11	1996-01-05	f	Codice11	2024-01-08	28	Junior	1500.00
CF12	Nome12	Cognome12	1984-10-12	t	Codice12	2019-10-12	40	Dirigente	3000.00
CF13	Nome13	Cognome13	1997-04-30	f	Codice13	2023-06-30	27	Junior	1500.00
CF14	Nome14	Cognome14	1983-11-08	t	Codice14	2015-02-12	41	Dirigente	3000.00
CF17	Nome17	Cognome17	1994-03-02	f	Codice17	2021-08-15	30	Junior	1500.00
CF18	Nome18	Cognome18	1981-07-24	f	Codice18	2016-04-20	43	Senior	2500.00
CF19	Nome19	Cognome19	1988-12-06	f	Codice19	2020-05-28	36	Middle	2000.00
CF20	Nome20	Cognome20	1999-08-14	f	Codice20	2021-09-14	25	Junior	1500.00
CF22	Nome22	Cognome22	1993-10-09	f	Codice22	2023-11-20	31	Junior	1500.00
CF23	Nome23	Cognome23	1982-01-15	f	Codice23	2015-07-31	42	Senior	2500.00
CF25	Nome25	Cognome25	1989-05-07	f	Codice25	2016-11-19	35	Senior	2500.00
CF26	Nome26	Cognome26	1996-11-19	f	Codice26	2021-02-22	28	Junior	1500.00
CF27	Nome27	Cognome27	1987-02-22	f	Codice27	2016-08-03	37	Senior	2500.00
CF28	Nome28	Cognome28	1994-08-03	t	Codice28	2018-03-11	30	Dirigente	3000.00
CF29	Nome29	Cognome29	1984-03-11	f	Codice29	2017-09-28	40	Middle	2000.00
CF30	Nome30	Cognome30	1991-09-28	f	Codice30	2016-01-16	33	Senior	2500.00
CF31	Nome31	Cognome31	1983-06-04	f	Codice31	2019-10-27	41	Middle	2000.00
CF35	Nome35	Cognome35	1986-12-13	f	Codice35	2014-04-02	38	Senior	2500.00
CF36	Nome36	Cognome36	1995-07-23	f	Codice36	2022-11-14	29	Junior	1500.00
CF37	Nome37	Cognome37	1981-04-02	f	Codice37	2015-02-20	43	Senior	2500.00
CF38	Nome38	Cognome38	1992-11-14	f	Codice38	2021-09-07	32	Junior	1500.00
CF39	Nome39	Cognome39	1988-02-20	f	Codice39	2019-05-29	36	Middle	2000.00
CF40	Nome40	Cognome40	1993-09-07	f	Codice40	2023-12-09	31	Junior	1500.00
CF41	Nome41	Cognome41	1984-05-29	f	Codice41	2018-07-16	40	Middle	2000.00
CF43	Nome43	Cognome43	1989-07-16	f	Codice43	2015-09-12	35	Senior	2500.00
CF44	Nome44	Cognome44	1996-02-26	t	Codice44	2014-04-21	28	Dirigente	3000.00
CF46	Nome46	Cognome46	1980-04-21	f	Codice46	2015-01-18	44	Senior	2500.00
CF47	Nome47	Cognome47	1997-10-03	f	Codice47	2022-06-30	27	Junior	1500.00
CF49	Nome49	Cognome49	1994-06-30	f	Codice49	2022-07-22	30	Junior	1500.00
CF50	Nome50	Cognome50	1983-02-08	f	Codice50	2014-03-05	41	Senior	2500.00
CF51	Nome51	Cognome51	1990-08-20	f	Codice51	2023-10-16	34	Middle	2000.00
CF52	Nome52	Cognome52	1987-03-02	f	Codice52	2017-05-27	37	Senior	2500.00
CF53	Nome53	Cognome53	1998-09-14	f	Codice53	2021-12-08	26	Junior	1500.00
CF54	Nome54	Cognome54	1981-04-27	f	Codice54	2016-11-19	43	Senior	2500.00
CF55	Nome55	Cognome55	1992-11-08	f	Codice55	2019-06-02	32	Middle	2000.00
CF56	Nome56	Cognome56	1989-06-17	f	Codice56	2014-01-14	35	Senior	2500.00
CF57	Nome57	Cognome57	1995-01-28	f	Codice57	2022-08-26	29	Junior	1500.00
CF58	Nome58	Cognome58	1984-07-10	t	Codice58	2016-04-08	40	Dirigente	3000.00
CF59	Nome59	Cognome59	1993-02-19	f	Codice59	2022-11-19	31	Junior	1500.00
CF60	Nome60	Cognome60	1991-12-14	f	Codice60	2024-01-11	33	Junior	1500.00
CF61	Nome61	Cognome61	1991-04-15	f	Codice61	2023-03-20	33	Junior	1500.00
CF62	Nome62	Cognome62	1988-11-26	f	Codice62	2016-07-10	36	Senior	2500.00
CF63	Nome63	Cognome63	1996-06-07	f	Codice63	2018-11-05	28	Middle	2000.00
CF66	Nome66	Cognome66	1990-03-12	f	Codice66	2014-08-10	34	Senior	2500.00
CF67	Nome67	Cognome67	1987-10-24	f	Codice67	2019-05-01	37	Middle	2000.00
CF68	Nome68	Cognome68	1994-05-04	f	Codice68	2022-09-12	30	Junior	1500.00
CF69	Nome69	Cognome69	1985-12-16	f	Codice69	2016-03-05	39	Senior	2500.00
CF70	Nome70	Cognome70	1997-07-27	f	Codice70	2022-12-18	27	Junior	1500.00
CF71	Nome71	Cognome71	1981-03-06	f	Codice71	2014-08-30	43	Senior	2500.00
CF72	Nome72	Cognome72	1998-10-18	f	Codice72	2022-04-14	26	Junior	1500.00
CF73	Nome73	Cognome73	1989-05-30	f	Codice73	2019-01-26	35	Middle	2000.00
CF74	Nome74	Cognome74	1992-01-10	t	Codice74	2018-06-08	32	Dirigente	3000.00
CF75	Nome75	Cognome75	1986-06-22	f	Codice75	2017-12-19	38	Middle	2000.00
CF76	Nome76	Cognome76	1995-12-03	f	Codice76	2021-05-30	29	Junior	1500.00
CF77	Nome77	Cognome77	1983-07-14	f	Codice77	2015-11-10	41	Senior	2500.00
CF78	Nome78	Cognome78	1980-02-25	f	Codice78	2016-07-01	44	Senior	2500.00
CF79	Nome79	Cognome79	1991-09-06	f	Codice79	2021-10-05	33	Junior	1500.00
CF80	Nome80	Cognome80	1988-04-17	f	Codice80	2019-02-18	36	Middle	2000.00
CF81	Nome81	Cognome81	1993-11-28	f	Codice81	2022-07-09	31	Junior	1500.00
CF82	Nome82	Cognome82	1982-07-09	f	Codice82	2014-05-20	42	Senior	2500.00
CF83	Nome83	Cognome83	1990-12-21	f	Codice83	2017-10-31	34	Middle	2000.00
CF84	Nome84	Cognome84	1987-05-01	f	Codice84	2015-04-14	37	Senior	2500.00
CF85	Nome85	Cognome85	1996-02-11	f	Codice85	2023-09-25	28	Junior	1500.00
CF86	Nome86	Cognome86	1985-09-25	f	Codice86	2018-11-07	39	Middle	2000.00
CF87	Nome87	Cognome87	1981-04-07	f	Codice87	2015-08-14	43	Senior	2500.00
CF88	Nome88	Cognome88	1998-11-19	f	Codice88	2022-04-26	26	Junior	1500.00
CF89	Nome89	Cognome89	1989-06-02	f	Codice89	2017-11-30	35	Middle	2000.00
CF90	Nome90	Cognome90	1994-01-14	t	Codice90	2018-08-09	30	Dirigente	3000.00
CF91	Nome91	Cognome91	1983-08-26	f	Codice91	2014-03-03	41	Senior	2500.00
CF6	Nome6	Cognome6	1989-12-20	t	Codice6	2019-02-20	35	Dirigente	3000.00
CF45	Nome45	Cognome45	1982-09-12	f	Codice45	2015-10-03	42	Dirigente	3000.00
CF15	Nome15	Cognome15	1992-06-18	f	Codice15	2022-01-10	32	Dirigente	3000.00
CF34	Nome34	Cognome34	1997-05-05	f	Codice34	2022-07-23	27	Dirigente	3000.00
CF64	Nome64	Cognome64	1982-01-23	f	Codice64	2014-09-15	42	Dirigente	3000.00
CF24	Nome24	Cognome24	1990-07-31	f	Codice24	2020-05-07	34	Dirigente	3000.00
CF21	Nome21	Cognome21	1985-04-26	f	Codice21	2017-04-05	39	Dirigente	3000.00
CF42	Nome42	Cognome42	1991-12-09	f	Codice42	2015-02-26	33	Dirigente	3000.00
CF8	Nome8	Cognome8	1980-06-10	t	Codice8	2018-04-05	44	Dirigente	3000.00
CF9	Nome9	Cognome9	1991-03-14	f	Codice9	2018-10-28	33	Dirigente	3000.00
CF16	Nome16	Cognome16	1986-09-21	f	Codice16	2014-06-22	38	Dirigente	3000.00
CF92	Nome92	Cognome92	1980-04-08	f	Codice92	2016-01-15	44	Senior	2500.00
CF93	Nome93	Cognome93	1991-11-19	f	Codice93	2022-07-18	33	Junior	1500.00
CF94	Nome94	Cognome94	1987-06-30	f	Codice94	2015-08-06	37	Senior	2500.00
CF95	Nome95	Cognome95	1992-02-10	f	Codice95	2022-10-25	32	Junior	1500.00
CF97	Nome97	Cognome97	1995-03-05	f	Codice97	2022-07-15	29	Junior	1500.00
CF98	Nome98	Cognome98	1981-10-16	f	Codice98	2014-04-07	43	Senior	2500.00
CF99	Nome99	Cognome99	1990-05-27	f	Codice99	2018-02-18	34	Middle	2000.00
CF100	Nome100	Cognome100	1988-01-08	f	Codice100	2017-09-30	36	Middle	2000.00
CF96	Nome96	Cognome96	1986-07-22	t	Codice96	2016-02-28	38	Dirigente	3000.00
CF7	Nome7	Cognome7	1995-02-28	f	Codice7	2023-07-15	29	Junior	1500.00
CF48	Nome48	Cognome48	1985-01-18	t	Codice48	2017-02-10	39	Dirigente	3000.00
CF104	Nome104	Cognome104	2000-12-18	f	Codice104	2024-12-09	23	Dirigente	3000.00
CF65	Nome65	Cognome65	1983-08-31	f	Codice65	2017-06-22	41	Dirigente	3000.00
\.


--
-- Data for Name: laboratorio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laboratorio (nome, respscie, topic, n_afferenti) FROM stdin;
Laboratorio B	CF82	Big Data	16
Laboratorio E	CF98	Informatica delle cose	36
Laboratorio C	CF16	Apprendimento Automatico	17
Laboratorio G	CF18	Software Testing	1
Laboratorio F	CF25	Salumeria	1
Laboratorio H	CF27	Giornalismo	1
Laboratorio J	CF16	Reinforcement Learning	1
\.


--
-- Data for Name: lavora; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lavora (lab1, lab2, lab3, cup) FROM stdin;
Laboratorio B	Laboratorio G	Laboratorio E	CUP2
Laboratorio C	Laboratorio F	\N	CUP5
Laboratorio H	Laboratorio I	Laboratorio J	CUP4
\N		Laboratorio L	CUP6
\.


--
-- Data for Name: presenza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.presenza (cup, nome, cognome, cf, categoria) FROM stdin;
CUP1	Nome14	Cognome14	CF14	Dirigente
CUP4	Nome14	Cognome14	CF14	Dirigente
CUP1	Nome18	Cognome18	CF18	Senior
CUP2	Nome25	Cognome25	CF25	Senior
CUP5	Nome58	Cognome58	CF58	Dirigente
CUP5	Nome62	Cognome62	CF62	Senior
CUP4	Nome77	Cognome77	CF77	Senior
CUP6	Nome84	Cognome84	CF84	Senior
CUP3	Nome91	Cognome91	CF91	Senior
CUP6	Nome8	Cognome8	CF8	Dirigente
CUP3	Nome96	Cognome96	CF96	Dirigente
CUP2	Nome2	Cognome2	CF2	Dirigente
\.


--
-- Data for Name: progetti; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progetti (cup, refscie, respscie, nome, budget) FROM stdin;
\.


--
-- Data for Name: progetto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progetto (cup, refscie, respscie, nome, budget) FROM stdin;
CUP4	CF77	CF14	Progetto D	80000
CUP5	CF62	CF58	Progetto E	200000
CUP6	CF84	CF8	Progetto F	180000
CUP2	CF25	CF4	Progetto B	150000
CUP1	CF18	CF14	Progetto A	15000
CUP3	CF87	CF34	Progetto Z	1000
CUP8	CF37	CF24	Progetto X	2000
\.


--
-- Data for Name: promozione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promozione (cf, codicecon, datapassaggio, vecchiacategoria, nuovacategoria) FROM stdin;
CF48	Codice48	2020-02-10	Middle	Middle
CF24	Codice24	2024-05-07	Middle	Dirigente
CF48	Codice48	2024-12-09	Dirigente	Dirigente
CF42	Codice42	2024-12-09	Dirigente	Dirigente
CF9	Codice9	2024-12-09	Middle	Dirigente
CF4	Codice4.1	2016-09-01	\N	Junior
CF4	Codice4.2	2019-09-01	Junior	Middle
CF4	Codice4.3	2023-09-01	Middle	Senior
CF4	Codice4.4	2024-09-01	Senior	Dirigente
CF6	Codice6.1	2019-02-20	\N	Junior
CF6	Codice6.2	2022-02-20	Junior	Middle
CF6	Codice6.4	2023-02-20	Middle	Dirigente
CF7	Codice7.1	2023-07-15	\N	Junior
CF8	Codice8.1	2018-04-05	\N	Junior
CF8	Codice8.2	2021-04-05	Junior	Middle
CF8	Codice8.4	2022-04-05	Middle	Dirigente
CF9	Codice9.1	2018-10-28	\N	Junior
CF9	Codice9.2	2021-10-28	Junior	Middle
CF10	Codice10.1	2014-03-15	\N	Junior
CF10	Codice10.2	2017-03-15	Junior	Middle
CF10	Codice10.3	2021-03-15	Middle	Senior
CF10	Codice10.4	2022-03-15	Senior	Dirigente
CF11	Codice11.1	2024-01-08	\N	Junior
CF12	Codice12.1	2019-10-12	\N	Junior
CF12	Codice12.2	2022-10-12	Junior	Middle
CF12	Codice12.4	2023-10-12	Middle	Dirigente
CF13	Codice13.1	2023-06-30	\N	Junior
CF14	Codice14.1	2015-02-12	\N	Junior
CF14	Codice14.2	2018-02-12	Junior	Middle
CF14	Codice14.3	2022-02-12	Middle	Senior
CF14	Codice14.4	2023-02-12	Senior	Dirigente
CF15	Codice15.1	2022-01-10	\N	Junior
CF16	Codice16.1	2014-06-22	\N	Junior
CF16	Codice16.2	2017-06-22	Junior	Middle
CF16	Codice16.3	2021-06-22	Middle	Senior
CF17	Codice17.1	2021-08-15	\N	Junior
CF17	Codice17.2	2024-08-15	Junior	Middle
CF18	Codice18.1	2016-04-20	\N	Junior
CF18	Codice18.2	2019-04-20	Junior	Middle
CF18	Codice18.3	2023-04-20	Middle	Senior
CF19	Codice19.1	2020-05-28	\N	Junior
CF19	Codice19.2	2023-05-28	Junior	Middle
CF20	Codice20.1	2021-09-14	\N	Junior
CF20	Codice20.2	2024-09-14	Junior	Middle
CF21	Codice21.1	2017-04-05	\N	Junior
CF21	Codice21.2	2020-04-05	Junior	Middle
CF22	Codice22.1	2023-11-20	\N	Junior
CF23	Codice23.1	2015-07-31	\N	Junior
CF23	Codice23.2	2018-07-31	Junior	Middle
CF23	Codice23.3	2022-07-31	Middle	Senior
CF24	Codice24.1	2020-05-07	\N	Junior
CF24	Codice24.2	2023-05-07	Junior	Middle
CF25	Codice25.1	2016-11-19	\N	Junior
CF25	Codice25.2	2019-11-19	Junior	Middle
CF25	Codice25.3	2023-11-19	Middle	Senior
CF26	Codice26.1	2021-02-22	\N	Junior
CF26	Codice26.2	2024-02-22	Junior	Middle
CF27	Codice27.1	2016-08-03	\N	Junior
CF27	Codice27.2	2019-08-03	Junior	Middle
CF27	Codice27.3	2023-08-03	Middle	Senior
CF28	Codice28.1	2018-03-11	\N	Junior
CF28	Codice28.2	2021-03-11	Junior	Middle
CF28	Codice28.4	2022-03-11	Middle	Dirigente
CF29	Codice29.1	2017-09-28	\N	Junior
CF29	Codice29.2	2020-09-28	Junior	Middle
CF30	Codice30.1	2016-01-16	\N	Junior
CF30	Codice30.2	2019-01-16	Junior	Middle
CF30	Codice30.3	2023-01-16	Middle	Senior
CF31	Codice31.1	2019-10-27	\N	Junior
CF31	Codice31.2	2022-10-27	Junior	Middle
CF34	Codice34.1	2022-07-23	\N	Junior
CF35	Codice35.1	2014-04-02	\N	Junior
CF35	Codice35.2	2017-04-02	Junior	Middle
CF35	Codice35.3	2021-04-02	Middle	Senior
CF36	Codice36.1	2022-11-14	\N	Junior
CF37	Codice37.1	2015-02-20	\N	Junior
CF37	Codice37.2	2018-02-20	Junior	Middle
CF37	Codice37.3	2022-02-20	Middle	Senior
CF38	Codice38.1	2021-09-07	\N	Junior
CF38	Codice38.2	2024-09-07	Junior	Middle
CF39	Codice39.1	2019-05-29	\N	Junior
CF39	Codice39.2	2022-05-29	Junior	Middle
CF40	Codice40.1	2023-12-09	\N	Junior
CF41	Codice41.1	2018-07-16	\N	Junior
CF41	Codice41.2	2021-07-16	Junior	Middle
CF42	Codice42.1	2015-02-26	\N	Junior
CF42	Codice42.2	2018-02-26	Junior	Middle
CF42	Codice42.3	2022-02-26	Middle	Senior
CF43	Codice43.1	2015-09-12	\N	Junior
CF43	Codice43.2	2018-09-12	Junior	Middle
CF43	Codice43.3	2022-09-12	Middle	Senior
CF44	Codice44.1	2014-04-21	\N	Junior
CF44	Codice44.2	2017-04-21	Junior	Middle
CF44	Codice44.3	2021-04-21	Middle	Senior
CF44	Codice44.4	2022-04-21	Senior	Dirigente
CF45	Codice45.1	2015-10-03	\N	Junior
CF45	Codice45.2	2018-10-03	Junior	Middle
CF45	Codice45.3	2022-10-03	Middle	Senior
CF46	Codice46.1	2015-01-18	\N	Junior
CF46	Codice46.2	2018-01-18	Junior	Middle
CF46	Codice46.3	2022-01-18	Middle	Senior
CF47	Codice47.1	2022-06-30	\N	Junior
CF49	Codice48.1	2022-07-22	\N	Junior
CF50	Codice49.1	2014-03-05	\N	Junior
CF50	Codice49.2	2017-03-05	Junior	Middle
CF50	Codice49.3	2021-03-05	Middle	Senior
CF51	Codice50.1	2023-10-16	\N	Junior
CF52	Codice51.1	2017-05-27	\N	Junior
CF52	Codice51.2	2020-05-27	Junior	Middle
CF53	Codice52.1	2021-12-08	\N	Junior
CF53	Codice52.2	2024-12-08	Junior	Middle
CF54	Codice53.1	2016-11-19	\N	Junior
CF54	Codice53.2	2019-11-19	Junior	Middle
CF54	Codice53.3	2023-11-19	Middle	Senior
CF55	Codice54.1	2019-06-02	\N	Junior
CF55	Codice54.2	2022-06-02	Junior	Middle
CF56	Codice55.1	2014-01-14	\N	Junior
CF56	Codice55.2	2017-01-14	Junior	Middle
CF56	Codice55.3	2021-01-14	Middle	Senior
CF16	Codice16	2024-12-10	Dirigente	Dirigente
CF57	Codice56.1	2022-08-26	\N	Junior
CF58	Codice57.1	2016-04-08	\N	Junior
CF58	Codice57.2	2019-04-08	Junior	Middle
CF58	Codice57.3	2023-04-08	Middle	Senior
CF58	Codice58.4	2024-04-08	Senior	Dirigente
CF59	Codice58.1	2022-11-19	\N	Junior
CF60	Codice59.1	2024-01-11	\N	Junior
CF61	Codice60.1	2023-03-20	\N	Junior
CF62	Codice61.1	2016-07-10	\N	Junior
CF62	Codice61.2	2019-07-10	Junior	Middle
CF62	Codice61.3	2023-07-10	Middle	Senior
CF63	Codice62.1	2018-11-05	\N	Junior
CF63	Codice62.2	2021-11-05	Junior	Middle
CF64	Codice63.1	2014-09-15	\N	Junior
CF64	Codice63.2	2017-09-15	Junior	Middle
CF64	Codice63.3	2021-09-15	Middle	Senior
CF66	Codice64.1	2014-08-10	\N	Junior
CF66	Codice64.2	2017-08-10	Junior	Middle
CF66	Codice64.3	2021-08-10	Middle	Senior
CF67	Codice65.1	2019-05-01	\N	Junior
CF67	Codice65.2	2022-05-01	Junior	Middle
CF68	Codice66.1	2022-09-12	\N	Junior
CF69	Codice67.1	2016-03-05	\N	Junior
CF69	Codice67.2	2019-03-05	Junior	Middle
CF69	Codice67.3	2023-03-05	Middle	Senior
CF70	Codice68.1	2022-12-18	\N	Junior
CF71	Codice69.1	2014-08-30	\N	Junior
CF71	Codice69.2	2017-08-30	Junior	Middle
CF71	Codice69.3	2021-08-30	Middle	Senior
CF72	Codice70.1	2022-04-14	\N	Junior
CF73	Codice71.1	2019-01-26	\N	Junior
CF73	Codice71.2	2022-01-26	Junior	Middle
CF74	Codice72.1	2018-06-08	\N	Junior
CF74	Codice72.2	2021-06-08	Junior	Middle
CF74	Codice74.4	2022-06-08	Middle	Dirigente
CF75	Codice73.1	2017-12-19	\N	Junior
CF75	Codice73.2	2020-12-19	Junior	Middle
CF76	Codice74.1	2021-05-30	\N	Junior
CF76	Codice74.2	2024-05-30	Junior	Middle
CF77	Codice75.1	2015-11-10	\N	Junior
CF77	Codice75.2	2018-11-10	Junior	Middle
CF77	Codice75.3	2022-11-10	Middle	Senior
CF78	Codice76.1	2016-07-01	\N	Junior
CF78	Codice76.2	2019-07-01	Junior	Middle
CF78	Codice76.3	2023-07-01	Middle	Senior
CF79	Codice77.1	2021-10-05	\N	Junior
CF79	Codice77.2	2024-10-05	Junior	Middle
CF80	Codice78.1	2019-02-18	\N	Junior
CF80	Codice78.2	2022-02-18	Junior	Middle
CF81	Codice79.1	2022-07-09	\N	Junior
CF82	Codice80.1	2014-05-20	\N	Junior
CF82	Codice80.2	2017-05-20	Junior	Middle
CF82	Codice80.3	2021-05-20	Middle	Senior
CF83	Codice81.1	2017-10-31	\N	Junior
CF83	Codice81.2	2020-10-31	Junior	Middle
CF84	Codice82.1	2015-04-14	\N	Junior
CF84	Codice82.2	2018-04-14	Junior	Middle
CF84	Codice82.3	2022-04-14	Middle	Senior
CF85	Codice83.1	2023-09-25	\N	Junior
CF86	Codice84.1	2018-11-07	\N	Junior
CF86	Codice84.2	2021-11-07	Junior	Middle
CF87	Codice85.1	2015-08-14	\N	Junior
CF87	Codice85.2	2018-08-14	Junior	Middle
CF87	Codice85.3	2022-08-14	Middle	Senior
CF88	Codice86.1	2022-04-26	\N	Junior
CF89	Codice87.1	2017-11-30	\N	Junior
CF89	Codice87.2	2020-11-30	Junior	Middle
CF90	Codice88.1	2018-08-09	\N	Junior
CF90	Codice88.2	2021-08-09	Junior	Middle
CF90	Codice90.4	2022-08-09	Middle	Dirigente
CF91	Codice89.1	2014-03-03	\N	Junior
CF91	Codice89.2	2017-03-03	Junior	Middle
CF91	Codice89.3	2021-03-03	Middle	Senior
CF92	Codice90.1	2016-01-15	\N	Junior
CF92	Codice90.2	2019-01-15	Junior	Middle
CF92	Codice90.3	2023-01-15	Middle	Senior
CF93	Codice91.1	2022-07-18	\N	Junior
CF94	Codice92.1	2015-08-06	\N	Junior
CF94	Codice92.2	2018-08-06	Junior	Middle
CF94	Codice92.3	2022-08-06	Middle	Senior
CF95	Codice93.1	2022-10-25	\N	Junior
CF97	Codice94.1	2022-07-15	\N	Junior
CF98	Codice95.1	2014-04-07	\N	Junior
CF98	Codice95.2	2017-04-07	Junior	Middle
CF98	Codice95.3	2021-04-07	Middle	Senior
CF99	Codice96.1	2018-02-18	\N	Junior
CF99	Codice96.2	2021-02-18	Junior	Middle
CF100	Codice97.1	2017-09-30	\N	Junior
CF100	Codice97.2	2020-09-30	Junior	Middle
CF65	Codice98.1	2017-06-22	\N	Junior
CF65	Codice98.2	2020-06-22	Junior	Middle
CF96	Codice99.1	2016-02-28	\N	Junior
CF96	Codice99.2	2019-02-28	Junior	Middle
CF96	Codice99.3	2023-02-28	Middle	Senior
CF96	Codice96.4	2024-02-28	Senior	Dirigente
CF48	Codice100.1	2017-02-10	\N	Junior
CF48	Codice100.2	2020-02-10	Junior	Middle
CF7	Codice7	2023-07-15	Dirigente	Junior
CF45	Codice45	2023-10-03	Senior	Dirigente
CF34	Codice34	2023-07-23	Junior	Dirigente
CF48	Codice48	2024-12-09	Middle	Dirigente
CF65	Codice65	2024-12-09	Middle	Dirigente
CF104	Codice104	2024-12-09	Junior	Dirigente
CF8	Codice8	2024-12-09	Dirigente	Dirigente
CF16	Codice16	2024-12-09	Senior	Dirigente
CF4	Codice2.1	2016-09-01	\N	Junior
CF4	Codice2.2	2019-09-01	Junior	Middle
CF4	Codice2.3	2023-09-01	Middle	Senior
CF4	Codice2.4	2024-09-01	Senior	Dirigente
CF7	Codice4.1	2023-07-15	\N	Junior
CF8	Codice5.1	2018-04-05	\N	Junior
CF8	Codice5.2	2021-04-05	Junior	Middle
CF8	Codice5.4	2022-04-05	Middle	Dirigente
CF9	Codice6.1	2018-10-28	\N	Junior
CF9	Codice6.2	2021-10-28	Junior	Middle
CF10	Codice7.1	2014-03-15	\N	Junior
CF10	Codice7.2	2017-03-15	Junior	Middle
CF10	Codice7.3	2021-03-15	Middle	Senior
CF10	Codice7.4	2022-03-15	Senior	Dirigente
CF11	Codice8.1	2024-01-08	\N	Junior
CF12	Codice9.1	2019-10-12	\N	Junior
CF12	Codice9.2	2022-10-12	Junior	Middle
CF12	Codice9.4	2023-10-12	Middle	Dirigente
CF13	Codice10.1	2023-06-30	\N	Junior
CF14	Codice11.1	2015-02-12	\N	Junior
CF14	Codice11.2	2018-02-12	Junior	Middle
CF14	Codice11.3	2022-02-12	Middle	Senior
CF14	Codice11.4	2023-02-12	Senior	Dirigente
CF15	Codice12.1	2022-01-10	\N	Junior
CF16	Codice13.1	2014-06-22	\N	Junior
CF16	Codice13.2	2017-06-22	Junior	Middle
CF16	Codice13.3	2021-06-22	Middle	Senior
CF17	Codice14.1	2021-08-15	\N	Junior
CF17	Codice14.2	2024-08-15	Junior	Middle
CF18	Codice15.1	2016-04-20	\N	Junior
CF18	Codice15.2	2019-04-20	Junior	Middle
CF18	Codice15.3	2023-04-20	Middle	Senior
CF19	Codice16.1	2020-05-28	\N	Junior
CF19	Codice16.2	2023-05-28	Junior	Middle
CF20	Codice17.1	2021-09-14	\N	Junior
CF20	Codice17.2	2024-09-14	Junior	Middle
CF21	Codice18.1	2017-04-05	\N	Junior
CF21	Codice18.2	2020-04-05	Junior	Middle
CF22	Codice19.1	2023-11-20	\N	Junior
CF23	Codice20.1	2015-07-31	\N	Junior
CF23	Codice20.2	2018-07-31	Junior	Middle
CF23	Codice20.3	2022-07-31	Middle	Senior
CF24	Codice21.1	2020-05-07	\N	Junior
CF24	Codice21.2	2023-05-07	Junior	Middle
CF25	Codice22.1	2016-11-19	\N	Junior
CF25	Codice22.2	2019-11-19	Junior	Middle
CF25	Codice22.3	2023-11-19	Middle	Senior
CF26	Codice23.1	2021-02-22	\N	Junior
CF26	Codice23.2	2024-02-22	Junior	Middle
CF27	Codice24.1	2016-08-03	\N	Junior
CF27	Codice24.2	2019-08-03	Junior	Middle
CF27	Codice24.3	2023-08-03	Middle	Senior
CF28	Codice25.1	2018-03-11	\N	Junior
CF28	Codice25.2	2021-03-11	Junior	Middle
CF28	Codice25.4	2022-03-11	Middle	Dirigente
CF29	Codice26.1	2017-09-28	\N	Junior
CF29	Codice26.2	2020-09-28	Junior	Middle
CF30	Codice27.1	2016-01-16	\N	Junior
CF30	Codice27.2	2019-01-16	Junior	Middle
CF30	Codice27.3	2023-01-16	Middle	Senior
CF31	Codice28.1	2019-10-27	\N	Junior
CF31	Codice28.2	2022-10-27	Junior	Middle
CF34	Codice31.1	2022-07-23	\N	Junior
CF35	Codice32.1	2014-04-02	\N	Junior
CF35	Codice32.2	2017-04-02	Junior	Middle
CF35	Codice32.3	2021-04-02	Middle	Senior
CF36	Codice33.1	2022-11-14	\N	Junior
CF37	Codice34.1	2015-02-20	\N	Junior
CF37	Codice34.2	2018-02-20	Junior	Middle
CF37	Codice34.3	2022-02-20	Middle	Senior
CF38	Codice35.1	2021-09-07	\N	Junior
CF38	Codice35.2	2024-09-07	Junior	Middle
CF39	Codice36.1	2019-05-29	\N	Junior
CF39	Codice36.2	2022-05-29	Junior	Middle
CF40	Codice37.1	2023-12-09	\N	Junior
CF41	Codice38.1	2018-07-16	\N	Junior
CF41	Codice38.2	2021-07-16	Junior	Middle
CF42	Codice39.1	2015-02-26	\N	Junior
CF42	Codice39.2	2018-02-26	Junior	Middle
CF42	Codice39.3	2022-02-26	Middle	Senior
CF43	Codice40.1	2015-09-12	\N	Junior
CF43	Codice40.2	2018-09-12	Junior	Middle
CF43	Codice40.3	2022-09-12	Middle	Senior
CF44	Codice41.1	2014-04-21	\N	Junior
CF44	Codice41.2	2017-04-21	Junior	Middle
CF44	Codice41.3	2021-04-21	Middle	Senior
CF44	Codice41.4	2022-04-21	Senior	Dirigente
CF45	Codice42.1	2015-10-03	\N	Junior
CF45	Codice42.2	2018-10-03	Junior	Middle
CF45	Codice42.3	2022-10-03	Middle	Senior
CF46	Codice43.1	2015-01-18	\N	Junior
CF46	Codice43.2	2018-01-18	Junior	Middle
CF46	Codice43.3	2022-01-18	Middle	Senior
CF47	Codice44.1	2022-06-30	\N	Junior
CF49	Codice45.1	2022-07-22	\N	Junior
CF50	Codice46.1	2014-03-05	\N	Junior
CF50	Codice46.2	2017-03-05	Junior	Middle
CF50	Codice46.3	2021-03-05	Middle	Senior
CF51	Codice47.1	2023-10-16	\N	Junior
CF52	Codice48.1	2017-05-27	\N	Junior
CF52	Codice48.2	2020-05-27	Junior	Middle
CF53	Codice49.1	2021-12-08	\N	Junior
CF53	Codice49.2	2024-12-08	Junior	Middle
CF54	Codice50.1	2016-11-19	\N	Junior
CF54	Codice50.2	2019-11-19	Junior	Middle
CF54	Codice50.3	2023-11-19	Middle	Senior
CF55	Codice51.1	2019-06-02	\N	Junior
CF55	Codice51.2	2022-06-02	Junior	Middle
CF56	Codice52.1	2014-01-14	\N	Junior
CF56	Codice52.2	2017-01-14	Junior	Middle
CF56	Codice52.3	2021-01-14	Middle	Senior
CF57	Codice53.1	2022-08-26	\N	Junior
CF58	Codice54.1	2016-04-08	\N	Junior
CF58	Codice54.2	2019-04-08	Junior	Middle
CF58	Codice54.3	2023-04-08	Middle	Senior
CF58	Codice54.4	2024-04-08	Senior	Dirigente
CF59	Codice55.1	2022-11-19	\N	Junior
CF60	Codice56.1	2024-01-11	\N	Junior
CF61	Codice57.1	2023-03-20	\N	Junior
CF62	Codice58.1	2016-07-10	\N	Junior
CF62	Codice58.2	2019-07-10	Junior	Middle
CF62	Codice58.3	2023-07-10	Middle	Senior
CF63	Codice59.1	2018-11-05	\N	Junior
CF63	Codice59.2	2021-11-05	Junior	Middle
CF64	Codice60.1	2014-09-15	\N	Junior
CF64	Codice60.2	2017-09-15	Junior	Middle
CF64	Codice60.3	2021-09-15	Middle	Senior
CF66	Codice61.1	2014-08-10	\N	Junior
CF66	Codice61.2	2017-08-10	Junior	Middle
CF66	Codice61.3	2021-08-10	Middle	Senior
CF67	Codice62.1	2019-05-01	\N	Junior
CF67	Codice62.2	2022-05-01	Junior	Middle
CF68	Codice63.1	2022-09-12	\N	Junior
CF69	Codice64.1	2016-03-05	\N	Junior
CF69	Codice64.2	2019-03-05	Junior	Middle
CF69	Codice64.3	2023-03-05	Middle	Senior
CF70	Codice65.1	2022-12-18	\N	Junior
CF71	Codice66.1	2014-08-30	\N	Junior
CF71	Codice66.2	2017-08-30	Junior	Middle
CF71	Codice66.3	2021-08-30	Middle	Senior
CF72	Codice67.1	2022-04-14	\N	Junior
CF73	Codice68.1	2019-01-26	\N	Junior
CF73	Codice68.2	2022-01-26	Junior	Middle
CF74	Codice69.1	2018-06-08	\N	Junior
CF74	Codice69.2	2021-06-08	Junior	Middle
CF74	Codice69.4	2022-06-08	Middle	Dirigente
CF75	Codice70.1	2017-12-19	\N	Junior
CF75	Codice70.2	2020-12-19	Junior	Middle
CF76	Codice71.1	2021-05-30	\N	Junior
CF76	Codice71.2	2024-05-30	Junior	Middle
CF77	Codice72.1	2015-11-10	\N	Junior
CF77	Codice72.2	2018-11-10	Junior	Middle
CF77	Codice72.3	2022-11-10	Middle	Senior
CF78	Codice73.1	2016-07-01	\N	Junior
CF78	Codice73.2	2019-07-01	Junior	Middle
CF78	Codice73.3	2023-07-01	Middle	Senior
CF79	Codice74.1	2021-10-05	\N	Junior
CF79	Codice74.2	2024-10-05	Junior	Middle
CF80	Codice75.1	2019-02-18	\N	Junior
CF80	Codice75.2	2022-02-18	Junior	Middle
CF81	Codice76.1	2022-07-09	\N	Junior
CF82	Codice77.1	2014-05-20	\N	Junior
CF82	Codice77.2	2017-05-20	Junior	Middle
CF82	Codice77.3	2021-05-20	Middle	Senior
CF83	Codice78.1	2017-10-31	\N	Junior
CF83	Codice78.2	2020-10-31	Junior	Middle
CF84	Codice79.1	2015-04-14	\N	Junior
CF84	Codice79.2	2018-04-14	Junior	Middle
CF84	Codice79.3	2022-04-14	Middle	Senior
CF85	Codice80.1	2023-09-25	\N	Junior
CF86	Codice81.1	2018-11-07	\N	Junior
CF86	Codice81.2	2021-11-07	Junior	Middle
CF87	Codice82.1	2015-08-14	\N	Junior
CF87	Codice82.2	2018-08-14	Junior	Middle
CF87	Codice82.3	2022-08-14	Middle	Senior
CF88	Codice83.1	2022-04-26	\N	Junior
CF89	Codice84.1	2017-11-30	\N	Junior
CF89	Codice84.2	2020-11-30	Junior	Middle
CF90	Codice85.1	2018-08-09	\N	Junior
CF90	Codice85.2	2021-08-09	Junior	Middle
CF90	Codice85.4	2022-08-09	Middle	Dirigente
CF91	Codice86.1	2014-03-03	\N	Junior
CF91	Codice86.2	2017-03-03	Junior	Middle
CF91	Codice86.3	2021-03-03	Middle	Senior
CF6	Codice87.1	2019-02-20	\N	Junior
CF6	Codice87.2	2022-02-20	Junior	Middle
CF6	Codice87.4	2023-02-20	Middle	Dirigente
CF92	Codice88.1	2016-01-15	\N	Junior
CF92	Codice88.2	2019-01-15	Junior	Middle
CF92	Codice88.3	2023-01-15	Middle	Senior
CF93	Codice89.1	2022-07-18	\N	Junior
CF94	Codice90.1	2015-08-06	\N	Junior
CF94	Codice90.2	2018-08-06	Junior	Middle
CF94	Codice90.3	2022-08-06	Middle	Senior
CF95	Codice91.1	2022-10-25	\N	Junior
CF97	Codice92.1	2022-07-15	\N	Junior
CF98	Codice93.1	2014-04-07	\N	Junior
CF98	Codice93.2	2017-04-07	Junior	Middle
CF98	Codice93.3	2021-04-07	Middle	Senior
CF99	Codice94.1	2018-02-18	\N	Junior
CF99	Codice94.2	2021-02-18	Junior	Middle
CF100	Codice95.1	2017-09-30	\N	Junior
CF100	Codice95.2	2020-09-30	Junior	Middle
CF65	Codice96.1	2017-06-22	\N	Junior
CF65	Codice96.2	2020-06-22	Junior	Middle
CF96	Codice97.1	2016-02-28	\N	Junior
CF96	Codice97.2	2019-02-28	Junior	Middle
CF96	Codice97.3	2023-02-28	Middle	Senior
CF96	Codice97.4	2024-02-28	Senior	Dirigente
CF48	Codice98.1	2017-02-10	\N	Junior
CF48	Codice98.2	2020-02-10	Junior	Middle
CF64	Codice64	2022-09-15	Senior	Dirigente
CF21	Codice21	2024-12-09	Middle	Dirigente
CF42	Codice42	2024-12-09	Senior	Dirigente
CF65	Codice65	2024-12-09	Dirigente	Dirigente
CF9	Codice9	2024-12-09	Dirigente	Dirigente
\.


--
-- Data for Name: promozioni; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promozioni (cf, categoria1, datapassaggio1, categoria2, datapassaggio2, categoria3, datapassaggio3, categoria4, datapassaggio4) FROM stdin;
CF2	Junior	2018-05-10	Middle	2021-05-10	\N	\N	Dirigente	2022-05-10
CF4	Junior	2016-09-01	Middle	2019-09-01	Senior	2023-09-01	Dirigente	2024-09-01
CF5	Junior	2023-12-18	\N	\N	\N	\N	\N	\N
CF8	Junior	2018-04-05	Middle	2021-04-05	\N	\N	Dirigente	2022-04-05
CF9	Junior	2018-10-28	Middle	2021-10-28	\N	\N	\N	\N
CF10	Junior	2014-03-15	Middle	2017-03-15	Senior	2021-03-15	Dirigente	2022-03-15
CF11	Junior	2024-01-08	\N	\N	\N	\N	\N	\N
CF12	Junior	2019-10-12	Middle	2022-10-12	\N	\N	Dirigente	2023-10-12
CF13	Junior	2023-06-30	\N	\N	\N	\N	\N	\N
CF14	Junior	2015-02-12	Middle	2018-02-12	Senior	2022-02-12	Dirigente	2023-02-12
CF16	Junior	2014-06-22	Middle	2017-06-22	Senior	2021-06-22	\N	\N
CF17	Junior	2021-08-15	Middle	2024-08-15	\N	\N	\N	\N
CF18	Junior	2016-04-20	Middle	2019-04-20	Senior	2023-04-20	\N	\N
CF19	Junior	2020-05-28	Middle	2023-05-28	\N	\N	\N	\N
CF20	Junior	2021-09-14	Middle	2024-09-14	\N	\N	\N	\N
CF21	Junior	2017-04-05	Middle	2020-04-05	\N	\N	\N	\N
CF22	Junior	2023-11-20	\N	\N	\N	\N	\N	\N
CF23	Junior	2015-07-31	Middle	2018-07-31	Senior	2022-07-31	\N	\N
CF24	Junior	2020-05-07	Middle	2023-05-07	\N	\N	\N	\N
CF25	Junior	2016-11-19	Middle	2019-11-19	Senior	2023-11-19	\N	\N
CF26	Junior	2021-02-22	Middle	2024-02-22	\N	\N	\N	\N
CF27	Junior	2016-08-03	Middle	2019-08-03	Senior	2023-08-03	\N	\N
CF28	Junior	2018-03-11	Middle	2021-03-11	\N	\N	Dirigente	2022-03-11
CF29	Junior	2017-09-28	Middle	2020-09-28	\N	\N	\N	\N
CF30	Junior	2016-01-16	Middle	2019-01-16	Senior	2023-01-16	\N	\N
CF31	Junior	2019-10-27	Middle	2022-10-27	\N	\N	\N	\N
CF32	Junior	2021-05-05	Middle	2024-05-05	\N	\N	\N	\N
CF33	Junior	2016-12-13	Middle	2019-12-13	Senior	2023-12-13	\N	\N
CF34	Junior	2022-07-23	\N	\N	\N	\N	\N	\N
CF35	Junior	2014-04-02	Middle	2017-04-02	Senior	2021-04-02	\N	\N
CF36	Junior	2022-11-14	\N	\N	\N	\N	\N	\N
CF37	Junior	2015-02-20	Middle	2018-02-20	Senior	2022-02-20	\N	\N
CF38	Junior	2021-09-07	Middle	2024-09-07	\N	\N	\N	\N
CF39	Junior	2019-05-29	Middle	2022-05-29	\N	\N	\N	\N
CF40	Junior	2023-12-09	\N	\N	\N	\N	\N	\N
CF41	Junior	2018-07-16	Middle	2021-07-16	\N	\N	\N	\N
CF42	Junior	2015-02-26	Middle	2018-02-26	Senior	2022-02-26	\N	\N
CF43	Junior	2015-09-12	Middle	2018-09-12	Senior	2022-09-12	\N	\N
CF44	Junior	2014-04-21	Middle	2017-04-21	Senior	2021-04-21	Dirigente	2022-04-21
CF45	Junior	2015-10-03	Middle	2018-10-03	Senior	2022-10-03	\N	\N
CF46	Junior	2015-01-18	Middle	2018-01-18	Senior	2022-01-18	\N	\N
CF47	Junior	2022-06-30	\N	\N	\N	\N	\N	\N
CF49	Junior	2022-07-22	\N	\N	\N	\N	\N	\N
CF50	Junior	2014-03-05	Middle	2017-03-05	Senior	2021-03-05	\N	\N
CF51	Junior	2023-10-16	\N	\N	\N	\N	\N	\N
CF52	Junior	2017-05-27	Middle	2020-05-27	\N	\N	\N	\N
CF53	Junior	2021-12-08	Middle	2024-12-08	\N	\N	\N	\N
CF54	Junior	2016-11-19	Middle	2019-11-19	Senior	2023-11-19	\N	\N
CF55	Junior	2019-06-02	Middle	2022-06-02	\N	\N	\N	\N
CF56	Junior	2014-01-14	Middle	2017-01-14	Senior	2021-01-14	\N	\N
CF57	Junior	2022-08-26	\N	\N	\N	\N	\N	\N
CF58	Junior	2016-04-08	Middle	2019-04-08	Senior	2023-04-08	Dirigente	2024-04-08
CF59	Junior	2022-11-19	\N	\N	\N	\N	\N	\N
CF60	Junior	2024-01-11	\N	\N	\N	\N	\N	\N
CF61	Junior	2023-03-20	\N	\N	\N	\N	\N	\N
CF62	Junior	2016-07-10	Middle	2019-07-10	Senior	2023-07-10	\N	\N
CF63	Junior	2018-11-05	Middle	2021-11-05	\N	\N	\N	\N
CF64	Junior	2014-09-15	Middle	2017-09-15	Senior	2021-09-15	\N	\N
CF66	Junior	2014-08-10	Middle	2017-08-10	Senior	2021-08-10	\N	\N
CF67	Junior	2019-05-01	Middle	2022-05-01	\N	\N	\N	\N
CF68	Junior	2022-09-12	\N	\N	\N	\N	\N	\N
CF69	Junior	2016-03-05	Middle	2019-03-05	Senior	2023-03-05	\N	\N
CF70	Junior	2022-12-18	\N	\N	\N	\N	\N	\N
CF71	Junior	2014-08-30	Middle	2017-08-30	Senior	2021-08-30	\N	\N
CF72	Junior	2022-04-14	\N	\N	\N	\N	\N	\N
CF73	Junior	2019-01-26	Middle	2022-01-26	\N	\N	\N	\N
CF74	Junior	2018-06-08	Middle	2021-06-08	\N	\N	Dirigente	2022-06-08
CF75	Junior	2017-12-19	Middle	2020-12-19	\N	\N	\N	\N
CF76	Junior	2021-05-30	Middle	2024-05-30	\N	\N	\N	\N
CF77	Junior	2015-11-10	Middle	2018-11-10	Senior	2022-11-10	\N	\N
CF78	Junior	2016-07-01	Middle	2019-07-01	Senior	2023-07-01	\N	\N
CF79	Junior	2021-10-05	Middle	2024-10-05	\N	\N	\N	\N
CF80	Junior	2019-02-18	Middle	2022-02-18	\N	\N	\N	\N
CF81	Junior	2022-07-09	\N	\N	\N	\N	\N	\N
CF82	Junior	2014-05-20	Middle	2017-05-20	Senior	2021-05-20	\N	\N
CF83	Junior	2017-10-31	Middle	2020-10-31	\N	\N	\N	\N
CF84	Junior	2015-04-14	Middle	2018-04-14	Senior	2022-04-14	\N	\N
CF85	Junior	2023-09-25	\N	\N	\N	\N	\N	\N
CF86	Junior	2018-11-07	Middle	2021-11-07	\N	\N	\N	\N
CF87	Junior	2015-08-14	Middle	2018-08-14	Senior	2022-08-14	\N	\N
CF88	Junior	2022-04-26	\N	\N	\N	\N	\N	\N
CF89	Junior	2017-11-30	Middle	2020-11-30	\N	\N	\N	\N
CF90	Junior	2018-08-09	Middle	2021-08-09	\N	\N	Dirigente	2022-08-09
CF91	Junior	2014-03-03	Middle	2017-03-03	Senior	2021-03-03	\N	\N
CF6	Junior	2019-02-20	Middle	2022-02-20	\N	\N	Dirigente	2023-02-20
CF92	Junior	2016-01-15	Middle	2019-01-15	Senior	2023-01-15	\N	\N
CF93	Junior	2022-07-18	\N	\N	\N	\N	\N	\N
CF94	Junior	2015-08-06	Middle	2018-08-06	Senior	2022-08-06	\N	\N
CF95	Junior	2022-10-25	\N	\N	\N	\N	\N	\N
CF97	Junior	2022-07-15	\N	\N	\N	\N	\N	\N
CF98	Junior	2014-04-07	Middle	2017-04-07	Senior	2021-04-07	\N	\N
CF99	Junior	2018-02-18	Middle	2021-02-18	\N	\N	\N	\N
CF100	Junior	2017-09-30	Middle	2020-09-30	\N	\N	\N	\N
CF65	Junior	2017-06-22	Middle	2020-06-22	\N	\N	\N	\N
CF96	Junior	2016-02-28	Middle	2019-02-28	Senior	2023-02-28	Dirigente	2024-02-28
CF48	Junior	2017-02-10	Middle	2020-02-10	\N	\N	\N	\N
CF3	Junior	2023-11-07	\N	\N	\N	\N	\N	\N
CF7	Junior	2023-07-15	\N	\N	\N	\N	Dirigente	2024-07-15
CF15	Junior	2022-01-10	\N	\N	\N	\N	Dirigente	2023-01-10
CF12345	\N	2024-12-09	\N	\N	\N	\N	\N	\N
CF1	\N	\N	\N	\N	\N	\N	\N	\N
CF102	\N	\N	\N	\N	\N	\N	Dirigente	2024-03-15
CF101	Junior	2024-03-15	\N	\N	\N	\N	\N	\N
CF103	\N	2024-12-04	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: utilizza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utilizza (cf, nomelab) FROM stdin;
CF1	Laboratorio A
CF2	Laboratorio A
CF3	Laboratorio B
CF4	Laboratorio C
CF5	Laboratorio C
CF6	Laboratorio D
CF7	Laboratorio D
CF8	Laboratorio E
CF9	Laboratorio E
CF10	Laboratorio A
CF11	Laboratorio B
CF12	Laboratorio B
CF13	Laboratorio D
CF14	Laboratorio D
CF15	Laboratorio E
CF16	Laboratorio E
CF17	Laboratorio C
CF18	Laboratorio C
CF19	Laboratorio E
CF20	Laboratorio E
CF21	Laboratorio B
CF22	Laboratorio A
CF23	Laboratorio C
CF24	Laboratorio E
CF25	Laboratorio E
CF26	Laboratorio E
CF27	Laboratorio E
CF28	Laboratorio C
CF29	Laboratorio C
CF30	Laboratorio D
CF31	Laboratorio E
CF32	Laboratorio B
CF33	Laboratorio B
CF34	Laboratorio B
CF35	Laboratorio A
CF36	Laboratorio E
CF37	Laboratorio E
CF38	Laboratorio E
CF39	Laboratorio E
CF40	Laboratorio D
CF41	Laboratorio D
CF42	Laboratorio D
CF43	Laboratorio E
CF44	Laboratorio E
CF45	Laboratorio C
CF46	Laboratorio C
CF47	Laboratorio B
CF48	Laboratorio A
CF49	Laboratorio E
CF50	Laboratorio E
CF51	Laboratorio C
CF52	Laboratorio C
CF53	Laboratorio C
CF54	Laboratorio E
CF55	Laboratorio D
CF56	Laboratorio A
CF57	Laboratorio A
CF58	Laboratorio A
CF59	Laboratorio A
CF60	Laboratorio E
CF61	Laboratorio E
CF62	Laboratorio C
CF63	Laboratorio B
CF64	Laboratorio B
CF65	Laboratorio B
CF66	Laboratorio A
CF67	Laboratorio A
CF68	Laboratorio E
CF69	Laboratorio E
CF70	Laboratorio E
CF71	Laboratorio D
CF72	Laboratorio D
CF73	Laboratorio E
CF74	Laboratorio C
CF75	Laboratorio A
CF76	Laboratorio B
CF77	Laboratorio B
CF78	Laboratorio B
CF79	Laboratorio E
CF80	Laboratorio E
CF81	Laboratorio A
CF82	Laboratorio D
CF83	Laboratorio E
CF84	Laboratorio E
CF85	Laboratorio E
CF86	Laboratorio D
CF87	Laboratorio D
CF88	Laboratorio B
CF89	Laboratorio E
CF90	Laboratorio B
CF91	Laboratorio C
CF92	Laboratorio C
CF93	Laboratorio A
CF94	Laboratorio A
CF95	Laboratorio E
CF96	Laboratorio E
CF97	Laboratorio A
CF98	Laboratorio A
CF99	Laboratorio E
CF100	Laboratorio E
	
CF28	Laboratorio C
CF28	Laboratorio C
CF27	Laboratorio C
CF24	Laboratorio C
CF99	Laboratorio C
CF1	Laboratorio G
CF23	Laboratorio D
CF25	Laboratorio F
CF27	Laboratorio H
CF30	Laboratorio I
CF33	Laboratorio J
CF35	Laboratorio K
CF37	Laboratorio L
CF101	Laboratorio K
CF66	Laboratorio L
CF66	Laboratorio L
CF35	Laboratorio M
\.


--
-- Name: impiegato impiegato_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.impiegato
    ADD CONSTRAINT impiegato_pkey PRIMARY KEY (cf);


--
-- Name: laboratorio laboratorio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratorio
    ADD CONSTRAINT laboratorio_pkey PRIMARY KEY (nome);


--
-- Name: lavora lavora_lab1_cup_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lavora
    ADD CONSTRAINT lavora_lab1_cup_key UNIQUE (lab1, cup);


--
-- Name: progetti progetti_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progetti
    ADD CONSTRAINT progetti_pkey PRIMARY KEY (cup);


--
-- Name: progetto progetto_cup_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progetto
    ADD CONSTRAINT progetto_cup_nome_key UNIQUE (cup, nome);


--
-- Name: progetto progetto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progetto
    ADD CONSTRAINT progetto_pkey PRIMARY KEY (cup);


--
-- Name: laboratorio laboratorio_respscie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratorio
    ADD CONSTRAINT laboratorio_respscie_fkey FOREIGN KEY (respscie) REFERENCES public.impiegato(cf) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: laboratorio laboratorio_respscie_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratorio
    ADD CONSTRAINT laboratorio_respscie_fkey1 FOREIGN KEY (respscie) REFERENCES public.impiegato(cf);


--
-- Name: lavora lavora_cup_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lavora
    ADD CONSTRAINT lavora_cup_fkey FOREIGN KEY (cup) REFERENCES public.progetto(cup);


--
-- Name: lavora lavora_cup_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lavora
    ADD CONSTRAINT lavora_cup_fkey1 FOREIGN KEY (cup) REFERENCES public.progetto(cup) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lavora lavora_lab1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lavora
    ADD CONSTRAINT lavora_lab1_fkey FOREIGN KEY (lab1) REFERENCES public.laboratorio(nome) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: progetti progetti_refscie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progetti
    ADD CONSTRAINT progetti_refscie_fkey FOREIGN KEY (refscie) REFERENCES public.impiegato(cf);


--
-- Name: progetti progetti_respscie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progetti
    ADD CONSTRAINT progetti_respscie_fkey FOREIGN KEY (respscie) REFERENCES public.impiegato(cf);


--
-- Name: progetto progetto_refscie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progetto
    ADD CONSTRAINT progetto_refscie_fkey FOREIGN KEY (refscie) REFERENCES public.impiegato(cf) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: progetto progetto_respscie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progetto
    ADD CONSTRAINT progetto_respscie_fkey FOREIGN KEY (respscie) REFERENCES public.impiegato(cf) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promozione promozione_cf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promozione
    ADD CONSTRAINT promozione_cf_fkey FOREIGN KEY (cf) REFERENCES public.impiegato(cf) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

