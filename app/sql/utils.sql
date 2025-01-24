--- check schema
SELECT
    schema_name
FROM
    information_schema.schemata
WHERE
    schema_name = 'projekt';

--- drop schema
DROP SCHEMA "projekt" CASCADE;

--- select schema
SET
    search_path TO projekt;

--- select wplaty-uczniow
WITH params AS (SELECT *
                FROM platnosc
                WHERE platnosc_id = %s)
SELECT u.uczen_id, u.imie, u.nazwisko, COALESCE(kwota, 0) AS _wplacone
FROM uczen u
         LEFT JOIN zaplata z ON u.uczen_id = z.uczen_id AND platnosc_id = (SELECT platnosc_id FROM params)
WHERE klasa_id = (SELECT klasa_id
                  FROM params)
ORDER BY nazwisko, imie;

--- action wplaty-uczniow dopłata_
SELECT dodaj_zaplate(%s, %s, %s);

--- select plandla_nauczyciel
SELECT zajecia_id, sala_id, klasa_id, nauczyciel_id, nazwa, dzien, czas_rozp, czas_konc
FROM zajecia
WHERE semestr_id = %s
  AND nauczyciel_id = %s ORDER BY dzien, czas_rozp;

--- select plandla_klasa
SELECT zajecia_id, sala_id, klasa_id, nauczyciel_id, nazwa, dzien, czas_rozp, czas_konc
FROM zajecia
WHERE semestr_id = %s
  AND klasa_id = %s ORDER BY dzien, czas_rozp;

--- select plandla_sala
SELECT zajecia_id, sala_id, klasa_id, nauczyciel_id, nazwa, dzien, czas_rozp, czas_konc
FROM zajecia
WHERE semestr_id = %s
  AND sala_id = %s ORDER BY dzien, czas_rozp;

--- delete plandla
DELETE FROM zajecia
WHERE semestr_id = %s AND LENGTH(%s::TEXT) > 0 AND zajecia_id = %s;

--- update plandla
UPDATE zajecia
SET {} = %s
WHERE zajecia_id = %s;

--- get all dates for zajecia
SELECT date
FROM (SELECT GENERATE_SERIES(data_poczatku, data_konca, '1 day')::date AS date, dzien
      FROM zajecia
               JOIN semestr s USING (semestr_id)
      WHERE zajecia_id = %s
) t
WHERE EXTRACT(DOW FROM t.date) = (SELECT CASE
                                             WHEN dzien = 'pn' THEN 1
                                             WHEN dzien = 'wt' THEN 2
                                             WHEN dzien = 'śr' THEN 3
                                             WHEN dzien = 'cz' THEN 4
                                             WHEN dzien = 'pt' THEN 5
                                             WHEN dzien = 'sb' THEN 6
                                             WHEN dzien = 'nd' THEN 7
                                             END);

--- select frekwencja-zajecia-data
WITH params AS (SELECT * FROM zajecia WHERE zajecia_id = %s)
   , uczniowie AS (SELECT * FROM uczen u WHERE u.klasa_id = (SELECT klasa_id FROM params))
SELECT u.uczen_id,
       u.imie,
       u.nazwisko,
       COALESCE(f.obecnosc, 'nb') AS obecnosc
FROM uczniowie u
         LEFT JOIN frekwencja f
                   ON u.uczen_id = f.uczen_id AND zajecia_id = (SELECT zajecia_id FROM params) AND data = %s
ORDER BY nazwisko, imie;

--- action frekwencja-zajecia-data obecnosc
SELECT dodaj_frekwencje(%s, %s, %s, %s::obecnosc);

--- select uczniowie-srednie
SELECT u.uczen_id, u.imie, u.nazwisko, AVG(so.srednia) AS _srednia
FROM uczen u
         FULL JOIN srednia_ocena_na_swiadectwie so ON u.uczen_id = so.uczen_id
WHERE semestr_id = %s AND so.klasa_id = %s
GROUP BY u.uczen_id
ORDER BY AVG(so.srednia) DESC NULLS LAST, u.klasa_id, u.nazwisko;

--- select oceny-ucznia
SELECT nazwa AS _nazwa, srednia AS _srednia
FROM srednia_ocena_na_swiadectwie so JOIN uczen u ON so.uczen_id = u.uczen_id
WHERE semestr_id = %s AND so.uczen_id = %s;

--- select mniej_niz_trzy_oceny
WITH cte AS (SELECT z.zajecia_id, COUNT(o.ocena) AS ilosc_ocen
             FROM ocena o
                      FULL JOIN zajecia z ON o.zajecia_id = z.zajecia_id
             WHERE z.semestr_id = %s
             GROUP BY z.zajecia_id, z.nauczyciel_id, o.uczen_id
             HAVING COUNT(o.ocena) < 3)
SELECT z.zajecia_id, MIN(ilosc_ocen) AS min_ilosc_ocen
FROM cte c
         JOIN zajecia z ON c.zajecia_id = z.zajecia_id
GROUP BY z.zajecia_id
ORDER BY z.zajecia_id;

--- select oblani
SELECT uczen_id, COUNT(*) AS liczba_oblanych
FROM srednia_ocena_na_swiadectwie so
WHERE srednia < 2
  AND semestr_id = %s
GROUP BY klasa_id, uczen_id;

--- select wybitni
SELECT uczen_id, AVG(srednia)
FROM srednia_ocena_na_swiadectwie so
WHERE semestr_id = %s
GROUP BY uczen_id
ORDER BY AVG(srednia) DESC NULLS LAST
LIMIT 10;
