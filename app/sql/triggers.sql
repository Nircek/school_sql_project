-- validate data

CREATE FUNCTION czy_semestr_nachodzi()
    RETURNS trigger AS
$$
BEGIN
    IF EXISTS (SELECT 1
               FROM semestr
               WHERE new.semestr_id <> semestr_id
                 AND new.data_poczatku < data_konca
                 AND new.data_konca > data_poczatku) THEN
        RAISE EXCEPTION 'Dodawany semestr nachodzi na już istniejący. -- (pocz %, konc %)',
            new.data_poczatku, new.data_konca;
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER czy_semestr_nachodzi
    BEFORE INSERT OR UPDATE
    ON semestr
    FOR EACH ROW
EXECUTE FUNCTION czy_semestr_nachodzi();

CREATE FUNCTION czy_zajecia_nachodzi()
    RETURNS trigger AS
$$
BEGIN
    IF EXISTS (SELECT 1
               FROM zajecia
               WHERE new.dzien = dzien
                 AND new.czas_rozp < czas_konc
                 AND new.czas_konc > czas_rozp
                 AND new.sala_id = sala_id
                 AND new.semestr_id = semestr_id) THEN
        RAISE EXCEPTION 'Dodawane zajęcią nachodzą na już istniejące. Sala jest już zajęta. -- (dzien %, rozp %, konc %, klasa %, sala %, nauczyciel %)',
            new.dzien, new.czas_rozp, new.czas_konc, new.klasa_id, new.sala_id, new.nauczyciel_id;
    END IF;

    IF EXISTS (SELECT 1
               FROM zajecia
               WHERE new.dzien = dzien
                 AND new.czas_rozp < czas_konc
                 AND new.czas_konc > czas_rozp
                 AND new.klasa_id = klasa_id
                 AND new.semestr_id = semestr_id) THEN
        RAISE EXCEPTION 'Dodawane zajęcią nachodzą na już istniejące. Klasa ma już zajęcia. -- (dzien %, rozp %, konc %, klasa %, sala %, nauczyciel %)',
            new.dzien, new.czas_rozp, new.czas_konc, new.klasa_id, new.sala_id, new.nauczyciel_id;
    END IF;

    IF EXISTS (SELECT 1
               FROM zajecia
               WHERE new.dzien = dzien
                 AND new.czas_rozp < czas_konc
                 AND new.czas_konc > czas_rozp
                 AND new.nauczyciel_id = nauczyciel_id
                 AND new.semestr_id = semestr_id) THEN
        RAISE EXCEPTION 'Dodawane zajęcią nachodzą na już istniejące. Nauczyciel jest już zajęty, -- (dzien %, rozp %, konc %, klasa %, sala %, nauczyciel %)',
            new.dzien, new.czas_rozp, new.czas_konc, new.klasa_id, new.sala_id, new.nauczyciel_id;
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER czy_zajecia_nachodzi
    BEFORE INSERT OR UPDATE
    ON zajecia
    FOR EACH ROW
EXECUTE FUNCTION czy_zajecia_nachodzi();

CREATE FUNCTION czy_frekwencja()
    RETURNS trigger AS
$$
DECLARE
    dzien_zajec  integer;
    klasa_zajec  integer;
    klasa_ucznia integer;
BEGIN
    IF NOT EXISTS (SELECT 1
                   FROM semestr
                   WHERE new.data BETWEEN data_poczatku AND data_konca) THEN
        RAISE EXCEPTION 'Data dodawanej frekwencji nie znajduje się w semestrze -- (zajecia %, data %, uczen %, semestr %)',
            new.zajecia_id, new.data, new.uczen_id, new.semestr_id;
    END IF;

    SELECT CASE
               WHEN dzien = 'pn' THEN 1
               WHEN dzien = 'wt' THEN 2
               WHEN dzien = 'śr' THEN 3
               WHEN dzien = 'cz' THEN 4
               WHEN dzien = 'pt' THEN 5
               WHEN dzien = 'sb' THEN 6
               WHEN dzien = 'nd' THEN 7
               END
    INTO dzien_zajec
    FROM zajecia
    WHERE new.zajecia_id = zajecia_id;

    IF dzien_zajec <> EXTRACT(DOW FROM new.data)
    THEN
        RAISE EXCEPTION 'Data dodawanej frekwencji nie jest w dniu tygodnia zajęć (% <> %) -- (zajecia %, data %, uczen %, obecnosc %)',
            EXTRACT(DOW FROM new.data), dzien_zajec, new.zajecia_id, new.data, new.uczen_id, new.obecnosc;
    END IF;

    SELECT klasa_id
    INTO klasa_zajec
    FROM zajecia
    WHERE new.zajecia_id = zajecia_id;

    SELECT klasa_id
    INTO klasa_ucznia
    FROM uczen
    WHERE new.uczen_id = uczen_id;

    IF klasa_ucznia <> klasa_zajec THEN
        RAISE EXCEPTION 'Uczeń nie należy do klasy, dla której są prowadzone zajęcia. (uczen % (klasa %), zajecia % (klasa %))',
            new.uczen_id, klasa_ucznia, new.zajecia_id, klasa_zajec;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER czy_frekwencja
    BEFORE INSERT OR UPDATE
    ON frekwencja
    FOR EACH ROW
EXECUTE FUNCTION czy_frekwencja();


CREATE FUNCTION czy_zaplata()
    RETURNS trigger AS
$$
DECLARE
    klasa_ucznia    integer;
    klasa_platnosci integer;
BEGIN
    SELECT klasa_id
    INTO klasa_ucznia
    FROM uczen
    WHERE new.uczen_id = uczen_id;

    SELECT klasa_id
    INTO klasa_platnosci
    FROM platnosc
    WHERE new.platnosc_id = platnosc_id;

    IF klasa_ucznia <> klasa_platnosci THEN
        RAISE EXCEPTION 'Uczeń nie należy do klasy, dla której jest płatność. (uczen % (klasa %), platnosc % (klasa %))',
            new.uczen_id, klasa_ucznia, new.platnosc_id, klasa_platnosci;
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER czy_zaplata
    BEFORE INSERT OR UPDATE
    ON zaplata
    FOR EACH ROW
EXECUTE FUNCTION czy_zaplata();

CREATE FUNCTION czy_ocena()
    RETURNS trigger AS
$$
DECLARE
    klasa_ucznia integer;
    klasa_oceny  integer;
BEGIN
    SELECT klasa_id
    INTO klasa_ucznia
    FROM uczen
    WHERE new.uczen_id = uczen_id;

    SELECT klasa_id
    INTO klasa_oceny
    FROM zajecia
    WHERE new.zajecia_id = zajecia_id;

    IF klasa_ucznia <> klasa_oceny THEN
        RAISE EXCEPTION 'Uczeń nie należy do klasy, dla której jest ocena. (uczen % (klasa %), ocena % (klasa %))',
            new.uczen_id, klasa_ucznia, new.ocena_id, klasa_oceny;
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER czy_ocena
    BEFORE INSERT OR UPDATE
    ON ocena
    FOR EACH ROW
EXECUTE FUNCTION czy_ocena();

-- delete dependencies on delete

CREATE OR REPLACE FUNCTION delete_nauczyciel()
    RETURNS trigger AS
$$
BEGIN
    DELETE FROM klasa WHERE wychowawca = old.nauczyciel_id;
    DELETE FROM zajecia WHERE nauczyciel_id = old.nauczyciel_id;
    RETURN old;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_nauczyciel
    BEFORE DELETE
    ON nauczyciel
    FOR EACH ROW
EXECUTE FUNCTION delete_nauczyciel();

CREATE OR REPLACE FUNCTION delete_klasa()
    RETURNS trigger AS
$$
BEGIN
    DELETE FROM uczen WHERE klasa_id = old.klasa_id;
    DELETE FROM platnosc WHERE klasa_id = old.klasa_id;
    DELETE FROM zajecia WHERE klasa_id = old.klasa_id;
    RETURN old;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_klasa
    BEFORE DELETE
    ON klasa
    FOR EACH ROW
EXECUTE FUNCTION delete_klasa();

CREATE OR REPLACE FUNCTION delete_uczen()
    RETURNS trigger AS
$$
BEGIN
    DELETE FROM ocena WHERE uczen_id = old.uczen_id;
    DELETE FROM frekwencja WHERE uczen_id = old.uczen_id;
    DELETE FROM zaplata WHERE uczen_id = old.uczen_id;
    RETURN old;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_uczen
    BEFORE DELETE
    ON uczen
    FOR EACH ROW
EXECUTE FUNCTION delete_uczen();

CREATE OR REPLACE FUNCTION delete_sala()
    RETURNS trigger AS
$$
BEGIN
    DELETE FROM zajecia WHERE sala_id = old.sala_id;
    RETURN old;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_sala
    BEFORE DELETE
    ON sala
    FOR EACH ROW
EXECUTE FUNCTION delete_sala();

CREATE OR REPLACE FUNCTION delete_semestr()
    RETURNS trigger AS
$$
BEGIN
    DELETE FROM zajecia WHERE semestr_id = old.semestr_id;
    RETURN old;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_semestr
    BEFORE DELETE
    ON semestr
    FOR EACH ROW
EXECUTE FUNCTION delete_semestr();

CREATE OR REPLACE FUNCTION delete_zajecia()
    RETURNS trigger AS
$$
BEGIN
    DELETE FROM ocena WHERE zajecia_id = old.zajecia_id;
    DELETE FROM frekwencja WHERE zajecia_id = old.zajecia_id;
    RETURN old;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_zajecia
    BEFORE DELETE
    ON zajecia
    FOR EACH ROW
EXECUTE FUNCTION delete_zajecia();


CREATE OR REPLACE FUNCTION delete_platnosc()
    RETURNS trigger AS
$$
BEGIN
    DELETE FROM zaplata WHERE platnosc_id = old.platnosc_id;
    RETURN old;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_platnosc
    BEFORE DELETE
    ON platnosc
    FOR EACH ROW
EXECUTE FUNCTION delete_platnosc();

-- delete dependencies on update

CREATE OR REPLACE FUNCTION zmiana_klasy_ucznia()
    RETURNS trigger AS
$$
BEGIN
    IF old.klasa_id <> new.klasa_id THEN
        DELETE FROM ocena WHERE uczen_id = old.uczen_id;
        DELETE FROM frekwencja WHERE uczen_id = old.uczen_id;
        DELETE FROM zaplata WHERE uczen_id = old.uczen_id;
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER zmiana_klasy_ucznia
    BEFORE UPDATE
    ON uczen
    FOR EACH ROW
EXECUTE FUNCTION zmiana_klasy_ucznia();

CREATE OR REPLACE FUNCTION zmiana_semestru_lub_klasy_lub_dnia_zajec()
    RETURNS trigger AS
$$
BEGIN
    IF old.semestr_id <> new.semestr_id OR old.klasa_id <> new.klasa_id THEN
        DELETE FROM ocena WHERE zajecia_id = old.zajecia_id;
        DELETE FROM frekwencja WHERE zajecia_id = old.zajecia_id;
    END IF;
    IF old.dzien <> new.dzien THEN
        DELETE FROM frekwencja WHERE zajecia_id = old.zajecia_id;
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER zmiana_semestru_lub_klasy_lub_dnia_zajec
    BEFORE UPDATE
    ON zajecia
    FOR EACH ROW
EXECUTE FUNCTION zmiana_semestru_lub_klasy_lub_dnia_zajec();

CREATE OR REPLACE FUNCTION zmiana_dat_semestru()
    RETURNS trigger AS
$$
BEGIN
    DELETE
    FROM frekwencja
    WHERE zajecia_id IN (SELECT zajecia_id
                         FROM zajecia
                         WHERE semestr_id = old.semestr_id)
      AND data NOT BETWEEN new.data_poczatku AND new.data_konca;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER zmiana_dat_semestru
    BEFORE UPDATE
    ON semestr
    FOR EACH ROW
EXECUTE FUNCTION zmiana_dat_semestru();

-- views triggers

CREATE OR REPLACE FUNCTION insert_into_postep_platnosci()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO platnosc (klasa_id, tytul, opis, kwota, termin, kategoria)
    VALUES (NEW.klasa_id, NEW.tytul, NEW.opis, NEW.kwota, NEW.termin, NEW.kategoria);
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_postep_platnosci()
RETURNS TRIGGER AS
$$
BEGIN
    UPDATE platnosc
    SET klasa_id = NEW.klasa_id,
        tytul = NEW.tytul,
        opis = NEW.opis,
        kwota = NEW.kwota,
        termin = NEW.termin,
        kategoria = NEW.kategoria
    WHERE platnosc_id = NEW.platnosc_id;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insert_into_postep_platnosci
    INSTEAD OF INSERT ON postep_platnosci
    FOR EACH ROW
    EXECUTE FUNCTION insert_into_postep_platnosci();

CREATE TRIGGER update_postep_platnosci
    INSTEAD OF UPDATE ON postep_platnosci
    FOR EACH ROW
    EXECUTE FUNCTION update_postep_platnosci();
