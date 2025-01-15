DROP SCHEMA IF EXISTS projekt CASCADE;

CREATE SCHEMA projekt;

SET
    search_path TO projekt;

CREATE TYPE dzien_tygodnia AS enum ('pn', 'wt', 'śr', 'cz', 'pt', 'sb', 'nd');

CREATE TYPE obecnosc AS enum ('ob', 'nb', 'u', 'zw');

CREATE TABLE
    "nauczyciel"
(
    "nauczyciel_id" serial PRIMARY KEY,
    "imie"          varchar NOT NULL,
    "nazwisko"      varchar NOT NULL
);

CREATE TABLE
    "klasa"
(
    "klasa_id"   serial PRIMARY KEY,
    "nazwa"      varchar NOT NULL,
    "wychowawca" serial REFERENCES "nauczyciel"
);

CREATE TABLE
    "uczen"
(
    "uczen_id" serial PRIMARY KEY,
    "imie"     varchar NOT NULL,
    "nazwisko" varchar NOT NULL,
    "klasa_id" serial REFERENCES "klasa"
);

CREATE TABLE
    "sala"
(
    "sala_id" serial PRIMARY KEY,
    "nazwa"   varchar NOT NULL
);

CREATE TABLE
    "semestr"
(
    "semestr_id"    serial PRIMARY KEY,
    "data_poczatku" date NOT NULL,
    "data_konca"    date NOT NULL
);

CREATE TABLE
    "zajecia"
(
    "zajecia_id"    serial PRIMARY KEY,
    "sala_id"       serial REFERENCES "sala",
    "klasa_id"      serial REFERENCES "klasa",
    "nauczyciel_id" serial REFERENCES "nauczyciel",
    "semestr_id"    serial REFERENCES "semestr",
    "dzien"         dzien_tygodnia         NOT NULL,
    "czas_rozp"     time without time zone NOT NULL,
    "czas_konc"     time without time zone NOT NULL
);

CREATE TABLE
    "frekwencja"
(
    "zajecia_id" serial REFERENCES "zajecia",
    "data"       date     NOT NULL,
    "uczen_id"   serial REFERENCES "uczen",
    "obecnosc"   obecnosc NOT NULL,
    PRIMARY KEY ("zajecia_id", "data", "uczen_id")
);

CREATE TABLE
    "platnosc"
(
    "platnosc_id" serial PRIMARY KEY,
    "klasa_id"    serial REFERENCES "klasa",
    "tytul"       varchar NOT NULL,
    "opis"        varchar NOT NULL,
    "kwota"       int     NOT NULL,
    "termin"      date    NOT NULL,
    "kategoria"   varchar NOT NULL
);

CREATE TABLE
    "zaplata"
(
    "platnosc_id" serial REFERENCES "platnosc",
    "uczen_id"    serial REFERENCES "uczen",
    "kwota"       int NOT NULL,
    PRIMARY KEY ("platnosc_id", "uczen_id")
);

-- CHANGELOG:
-- - dodana "frekwencja"."data"
