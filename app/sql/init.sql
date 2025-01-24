DROP SCHEMA IF EXISTS projekt CASCADE;

CREATE SCHEMA projekt;

SET
    search_path TO projekt;

CREATE TYPE dzien_tygodnia AS enum ('pn', 'wt', 'śr', 'cz', 'pt', 'sb', 'nd');

CREATE TYPE obecnosc AS enum ('ob', 'nb', 'u', 'zw');

CREATE TABLE
    nauczyciel
(
    nauczyciel_id serial PRIMARY KEY,
    imie          varchar NOT NULL CHECK (LENGTH(imie) > 0),
    nazwisko      varchar NOT NULL CHECK (LENGTH(nazwisko) > 0)
);

CREATE TABLE
    klasa
(
    klasa_id   serial PRIMARY KEY,
    nazwa      varchar NOT NULL CHECK (LENGTH(nazwa) > 0),
    wychowawca serial REFERENCES nauczyciel
);

CREATE TABLE
    uczen
(
    uczen_id serial PRIMARY KEY,
    imie     varchar NOT NULL CHECK (LENGTH(imie) > 0),
    nazwisko varchar NOT NULL CHECK (LENGTH(nazwisko) > 0),
    klasa_id serial REFERENCES klasa
);

CREATE TABLE
    sala
(
    sala_id serial PRIMARY KEY,
    nazwa   varchar NOT NULL CHECK (LENGTH(nazwa) > 0)
);

CREATE TABLE
    semestr
(
    semestr_id    serial PRIMARY KEY,
    data_poczatku date NOT NULL,
    data_konca    date NOT NULL CHECK (data_konca >= data_poczatku)
);

CREATE TABLE
    zajecia
(
    zajecia_id    serial PRIMARY KEY,
    sala_id       serial REFERENCES sala,
    klasa_id      serial REFERENCES klasa,
    nauczyciel_id serial REFERENCES nauczyciel,
    nazwa         varchar NOT NULL CHECK (LENGTH(nazwa) > 0),
    semestr_id    serial REFERENCES semestr,
    dzien         dzien_tygodnia         NOT NULL,
    czas_rozp     time without time zone NOT NULL,
    czas_konc     time without time zone NOT NULL CHECK (czas_konc > czas_rozp)
);

CREATE TABLE
    frekwencja
(
    zajecia_id serial REFERENCES zajecia,
    data       date     NOT NULL,
    uczen_id   serial REFERENCES uczen,
    obecnosc   obecnosc NOT NULL,
    PRIMARY KEY (zajecia_id, data, uczen_id)
);

CREATE TABLE ocena
(
    ocena_id   serial PRIMARY KEY,
    zajecia_id serial REFERENCES zajecia,
    uczen_id   serial REFERENCES uczen,
    ocena      int     NOT NULL CHECK (ocena >= 1 AND ocena <= 6),
    data       date    NOT NULL,
    komentarz  varchar NOT NULL
);

CREATE TABLE
    platnosc
(
    platnosc_id serial PRIMARY KEY,
    klasa_id    serial REFERENCES klasa,
    tytul       varchar NOT NULL CHECK (LENGTH(tytul) > 0),
    opis        varchar NOT NULL,
    kwota       int     NOT NULL CHECK (kwota > 0),
    termin      date    NOT NULL,
    kategoria   varchar NOT NULL
);

CREATE TABLE
    zaplata
(
    platnosc_id serial REFERENCES platnosc,
    uczen_id    serial REFERENCES uczen,
    kwota       int NOT NULL,
    PRIMARY KEY (platnosc_id, uczen_id)
);

