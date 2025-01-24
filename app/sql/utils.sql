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

--- select wplaty_uczniow
WITH params AS (SELECT *
                FROM platnosc
                WHERE platnosc_id = %s)
SELECT u.uczen_id, u.imie, u.nazwisko, COALESCE(kwota, 0) AS _wplacone
FROM uczen u
         LEFT JOIN zaplata z ON u.uczen_id = z.uczen_id AND platnosc_id = (SELECT platnosc_id FROM params)
WHERE klasa_id = (SELECT klasa_id
                  FROM params)
ORDER BY nazwisko, imie;

--- action wplaty_uczniow dopłata_
SELECT dodaj_zaplate(%s, %s, %s);
