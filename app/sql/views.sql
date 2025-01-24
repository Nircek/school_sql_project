CREATE OR REPLACE VIEW postep_platnosci AS
WITH platnosc_wplacone AS (SELECT platnosc_id, SUM(kwota) AS wszystkie_wplacone
                           FROM zaplata
                           GROUP BY platnosc_id),
     platnosc_do_zaplaty AS (SELECT platnosc_id, COUNT(uczen_id) * kwota AS wszystkie_do_zaplaty
                             FROM platnosc
                                      JOIN uczen USING (klasa_id)
                             GROUP BY platnosc_id)
SELECT p.*, COALESCE(wszystkie_wplacone, 0) AS _wplacone, wszystkie_do_zaplaty AS _do_zaplaty
FROM platnosc_wplacone
         FULL JOIN platnosc_do_zaplaty USING (platnosc_id)
         FULL JOIN platnosc p USING (platnosc_id)
ORDER BY platnosc_id;

CREATE OR REPLACE VIEW srednia_ocena_na_swiadectwie AS
SELECT z.semestr_id, u.klasa_id, u.uczen_id, z.zajecia_id, z.nazwa, AVG(o.ocena) AS srednia
FROM uczen u
         FULL JOIN zajecia z ON u.klasa_id = z.klasa_id
         FULL JOIN ocena o ON u.uczen_id = o.uczen_id AND z.zajecia_id = o.zajecia_id
GROUP BY u.uczen_id, z.zajecia_id
ORDER BY z.semestr_id, uczen_id, z.zajecia_id;
