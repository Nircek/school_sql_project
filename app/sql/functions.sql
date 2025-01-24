CREATE OR REPLACE FUNCTION dodaj_zaplate(do_platnosci int, uczen int, wplacane int)
    RETURNS void AS
$$
DECLARE
    juz_wplacone       integer;
    lacznie_do_zaplaty integer;
BEGIN
    SELECT kwota
    INTO juz_wplacone
    FROM zaplata
    WHERE platnosc_id = do_platnosci
      AND uczen_id = uczen;

    SELECT kwota
    INTO lacznie_do_zaplaty
    FROM platnosc
    WHERE platnosc_id = do_platnosci;

    IF COALESCE(juz_wplacone, 0) + wplacane <= lacznie_do_zaplaty THEN
        IF juz_wplacone IS NULL THEN
            INSERT INTO zaplata (platnosc_id, uczen_id, kwota)
            VALUES (do_platnosci, uczen, wplacane);
        ELSE
            UPDATE zaplata
            SET kwota = juz_wplacone + wplacane
            WHERE platnosc_id = do_platnosci
              AND uczen_id = uczen;
        END IF;
    ELSE
        RAISE EXCEPTION 'Przekroczono kwotę do zapłaty, wpłata nie może być zrealizowana, bo % + % = % > %',
            juz_wplacone, wplacane, juz_wplacone + wplacane, lacznie_do_zaplaty;
    END IF;
END;
$$ LANGUAGE plpgsql;

