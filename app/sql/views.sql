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
