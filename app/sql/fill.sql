
INSERT INTO "nauczyciel" ("imie", "nazwisko")
VALUES ('Jan', 'Matematyk'),
       ('Anna', 'Polonistka'),
       ('Piotr', 'Fizyk'),
       ('Katarzyna', 'Chemiczka'),
       ('Marek', 'Biolog'),
       ('Agnieszka', 'Geografka'),
       ('Michał', 'Historyk');

INSERT INTO "klasa" ("nazwa", "wychowawca")
VALUES ('1A', 2),
       ('1B', 4),
       ('2A', 3),
       ('2B', 7),
       ('3A', 1),
       ('3B', 5),
       ('3C', 6);

INSERT INTO "uczen" ("imie", "nazwisko", "klasa_id")
VALUES ('Jan', 'Kowalski', 1),
       ('Anna', 'Nowak', 1),
       ('Piotr', 'Wiśniewski', 1),
       ('Katarzyna', 'Wójcik', 1),
       ('Marek', 'Kowalczyk', 1),
       ('Agnieszka', 'Kamińska', 1),
       ('Michał', 'Lewandowski', 1),
       ('Jan', 'Zieliński', 2),
       ('Anna', 'Szymańska', 2),
       ('Piotr', 'Woźniak', 2),
       ('Katarzyna', 'Dąbrowska', 2),
       ('Marek', 'Kozłowski', 2),
       ('Agnieszka', 'Jankowska', 2),
       ('Michał', 'Mazur', 2),
       ('Jan', 'Wojciechowski', 3),
       ('Anna', 'Kwiatkowska', 3),
       ('Piotr', 'Krawczyk', 3),
       ('Katarzyna', 'Majewska', 3),
       ('Marek', 'Kamiński', 3),
       ('Agnieszka', 'Zając', 3),
       ('Michał', 'Król', 3),
       ('Jan', 'Jabłoński', 4),
       ('Anna', 'Wieczorek', 4),
       ('Piotr', 'Sikora', 4),
       ('Katarzyna', 'Olejnik', 4),
       ('Marek', 'Szymczak', 4),
       ('Agnieszka', 'Kaźmierczak', 4),
       ('Michał', 'Czarnecki', 4),
       ('Jan', 'Kaczmarek', 5),
       ('Anna', 'Zalewska', 5),
       ('Piotr', 'Wysocka', 5),
       ('Katarzyna', 'Piątkowska', 5),
       ('Marek', 'Sawicki', 5),
       ('Agnieszka', 'Kowal', 5),
       ('Michał', 'Urbaniak', 5),
       ('Jan', 'Piotrowski', 6),
       ('Anna', 'Sobczak', 6),
       ('Piotr', 'Szczepańska', 6),
       ('Katarzyna', 'Marciniak', 6),
       ('Marek', 'Wróbel', 6),
       ('Agnieszka', 'Duda', 6),
       ('Michał', 'Sikorski', 6),
       ('Jan', 'Kozak', 7),
       ('Anna', 'Kubiak', 7),
       ('Piotr', 'Kot', 7),
       ('Katarzyna', 'Leszczyńska', 7),
       ('Marek', 'Łukasik', 7),
       ('Agnieszka', 'Krupa', 7),
       ('Michał', 'Kaczor', 7);

INSERT INTO "sala" ("nazwa")
VALUES ('101'),
       ('102'),
       ('103'),
       ('104'),
       ('105'),
       ('106'),
       ('107'),
       ('108'),
       ('109'),
       ('110');

INSERT INTO "semestr" ("data_poczatku", "data_konca")
VALUES ('2024-09-01', '2025-01-19'),
       ('2025-02-03', '2021-06-27');

INSERT INTO "zajecia" ("sala_id", "klasa_id", "nauczyciel_id", "semestr_id", "dzien", "czas_rozp", "czas_konc")
VALUES (1, 1, 5, 1, 'pn', '08:00', '09:30'),
       (2, 7, 3, 1, 'pn', '09:45', '11:15'),
       (3, 5, 5, 1, 'pn', '11:30', '13:00'),
       (4, 4, 4, 1, 'pn', '13:15', '14:45'),
       (5, 1, 6, 1, 'pn', '15:00', '16:30'),
       (6, 4, 1, 1, 'pn', '16:45', '18:15'),
       (7, 2, 6, 1, 'pn', '18:30', '20:00'),
       (8, 7, 6, 1, 'wt', '08:00', '09:30'),
       (9, 7, 6, 1, 'wt', '09:45', '11:15'),
       (10, 5, 7, 1, 'wt', '11:30', '13:00'),
       (1, 2, 7, 1, 'wt', '13:15', '14:45'),
       (2, 5, 6, 1, 'wt', '15:00', '16:30'),
       (3, 2, 3, 1, 'wt', '16:45', '18:15'),
       (4, 7, 6, 1, 'wt', '18:30', '20:00'),
       (5, 2, 4, 1, 'śr', '08:00', '09:30'),
       (6, 1, 5, 1, 'śr', '09:45', '11:15'),
       (7, 7, 5, 1, 'śr', '11:30', '13:00'),
       (8, 2, 7, 1, 'śr', '13:15', '14:45'),
       (9, 6, 6, 1, 'śr', '15:00', '16:30'),
       (10, 4, 2, 1, 'śr', '16:45', '18:15'),
       (1, 4, 1, 1, 'śr', '18:30', '20:00'),
       (2, 2, 6, 1, 'cz', '08:00', '09:30'),
       (3, 4, 4, 1, 'cz', '09:45', '11:15'),
       (4, 3, 7, 1, 'cz', '11:30', '13:00'),
       (5, 4, 5, 1, 'cz', '13:15', '14:45'),
       (6, 1, 4, 1, 'cz', '15:00', '16:30'),
       (7, 2, 2, 1, 'cz', '16:45', '18:15'),
       (8, 7, 2, 1, 'cz', '18:30', '20:00'),
       (9, 1, 4, 1, 'pt', '08:00', '09:30'),
       (10, 3, 3, 1, 'pt', '09:45', '11:15'),
       (1, 2, 4, 1, 'pt', '11:30', '13:00'),
       (2, 7, 6, 1, 'pt', '13:15', '14:45'),
       (3, 6, 3, 1, 'pt', '15:00', '16:30'),
       (4, 4, 3, 1, 'pt', '16:45', '18:15'),
       (5, 1, 1, 1, 'pt', '18:30', '20:00'),
       (6, 6, 1, 2, 'pn', '08:00', '09:30'),
       (7, 6, 3, 2, 'pn', '09:45', '11:15'),
       (8, 2, 7, 2, 'pn', '11:30', '13:00'),
       (9, 1, 7, 2, 'pn', '13:15', '14:45'),
       (10, 1, 1, 2, 'pn', '15:00', '16:30'),
       (1, 2, 6, 2, 'pn', '16:45', '18:15'),
       (2, 3, 2, 2, 'pn', '18:30', '20:00'),
       (3, 2, 4, 2, 'wt', '08:00', '09:30'),
       (4, 1, 3, 2, 'wt', '09:45', '11:15'),
       (5, 3, 4, 2, 'wt', '11:30', '13:00'),
       (6, 5, 4, 2, 'wt', '13:15', '14:45'),
       (7, 1, 3, 2, 'wt', '15:00', '16:30'),
       (8, 7, 2, 2, 'wt', '16:45', '18:15'),
       (9, 3, 7, 2, 'wt', '18:30', '20:00'),
       (10, 4, 1, 2, 'śr', '08:00', '09:30'),
       (1, 2, 1, 2, 'śr', '09:45', '11:15'),
       (2, 5, 7, 2, 'śr', '11:30', '13:00'),
       (3, 2, 7, 2, 'śr', '13:15', '14:45'),
       (4, 6, 4, 2, 'śr', '15:00', '16:30'),
       (5, 4, 4, 2, 'śr', '16:45', '18:15'),
       (6, 3, 2, 2, 'śr', '18:30', '20:00'),
       (7, 5, 5, 2, 'cz', '08:00', '09:30'),
       (8, 4, 2, 2, 'cz', '09:45', '11:15'),
       (9, 4, 6, 2, 'cz', '11:30', '13:00'),
       (10, 5, 7, 2, 'cz', '13:15', '14:45'),
       (1, 7, 7, 2, 'cz', '15:00', '16:30'),
       (2, 3, 5, 2, 'cz', '16:45', '18:15'),
       (3, 2, 5, 2, 'cz', '18:30', '20:00'),
       (4, 6, 2, 2, 'pt', '08:00', '09:30'),
       (5, 2, 6, 2, 'pt', '09:45', '11:15'),
       (6, 3, 2, 2, 'pt', '11:30', '13:00'),
       (7, 7, 5, 2, 'pt', '13:15', '14:45'),
       (8, 5, 7, 2, 'pt', '15:00', '16:30'),
       (9, 3, 6, 2, 'pt', '16:45', '18:15'),
       (10, 1, 1, 2, 'pt', '18:30', '20:00');

INSERT INTO "frekwencja" ("zajecia_id", "data", "uczen_id", "obecnosc")
VALUES (1, '2024-09-02', 1, 'ob'),
       (1, '2024-09-02', 2, 'ob'),
       (1, '2024-09-02', 3, 'ob'),
       (1, '2024-09-02', 4, 'ob'),
       (1, '2024-09-02', 5, 'ob'),
       (1, '2024-09-02', 6, 'ob'),
       (1, '2024-09-02', 7, 'ob'),
       (2, '2024-09-02', 43, 'ob'),
       (2, '2024-09-02', 44, 'ob'),
       (2, '2024-09-02', 45, 'ob'),
       (2, '2024-09-02', 46, 'ob'),
       (2, '2024-09-02', 47, 'ob'),
       (2, '2024-09-02', 48, 'ob'),
       (2, '2024-09-02', 49, 'ob'),
       (3, '2024-09-02', 1, 'ob'),
       (3, '2024-09-02', 2, 'ob'),
       (3, '2024-09-02', 3, 'ob'),
       (3, '2024-09-02', 4, 'ob'),
       (3, '2024-09-02', 5, 'ob'),
       (3, '2024-09-02', 6, 'ob'),
       (3, '2024-09-02', 7, 'ob'),
       (4, '2024-09-02', 29, 'ob'),
       (4, '2024-09-02', 30, 'ob'),
       (4, '2024-09-02', 31, 'ob'),
       (4, '2024-09-02', 32, 'ob'),
       (4, '2024-09-02', 33, 'ob'),
       (4, '2024-09-02', 34, 'ob'),
       (4, '2024-09-02', 35, 'ob'),
       (5, '2024-09-02', 1, 'ob'),
       (5, '2024-09-02', 2, 'ob'),
       (5, '2024-09-02', 3, 'ob'),
       (5, '2024-09-02', 4, 'ob'),
       (5, '2024-09-02', 5, 'ob'),
       (5, '2024-09-02', 6, 'ob'),
       (5, '2024-09-02', 7, 'ob'),
       (6, '2024-09-02', 1, 'ob'),
       (6, '2024-09-02', 2, 'ob'),
       (6, '2024-09-02', 3, 'ob'),
       (6, '2024-09-02', 4, 'ob'),
       (6, '2024-09-02', 5, 'ob'),
       (6, '2024-09-02', 6, 'ob'),
       (6, '2024-09-02', 7, 'ob'),
       (7, '2024-09-02', 1, 'ob'),
       (7, '2024-09-02', 2, 'ob'),
       (7, '2024-09-02', 3, 'ob'),
       (7, '2024-09-02', 4, 'ob'),
       (7, '2024-09-02', 5, 'ob'),
       (7, '2024-09-02', 6, 'ob'),
       (7, '2024-09-02', 7, 'ob'),
       (8, '2024-09-02', 40, 'ob'),
       (8, '2024-09-02', 41, 'ob'),
       (8, '2024-09-02', 42, 'ob'),
       (8, '2024-09-02', 43, 'ob'),
       (8, '2024-09-02', 44, 'ob'),
       (8, '2024-09-02', 45, 'ob'),
       (8, '2024-09-02', 46, 'ob'),
       (9, '2024-09-02', 40, 'ob');

INSERT INTO "platnosc" ("klasa_id", "tytul", "opis", "kwota", "termin", "kategoria")
VALUES (1, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (2, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (3, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (4, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (5, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (6, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (7, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki');

INSERT INTO "zaplata" ("platnosc_id", "uczen_id", "kwota")
VALUES (1, 1, 100),
       (1, 2, 100),
       (1, 3, 100),
       (1, 4, 100),
       (1, 5, 100),
       (1, 6, 100),
       (1, 7, 100),
       (2, 43, 100),
       (2, 44, 100),
       (2, 45, 100),
       (2, 46, 100),
       (2, 47, 100),
       (2, 48, 100),
       (2, 49, 100),
       (3, 1, 100),
       (3, 2, 100),
       (3, 3, 100),
       (3, 4, 100),
       (3, 5, 100),
       (3, 6, 100),
       (3, 7, 100),
       (4, 29, 100),
       (4, 30, 100),
       (4, 31, 100),
       (4, 32, 100),
       (4, 33, 100),
       (4, 34, 100),
       (4, 35, 100),
       (5, 1, 100),
       (5, 2, 100),
       (5, 3, 100),
       (5, 4, 100),
       (5, 5, 100),
       (5, 6, 100),
       (5, 7, 100),
       (6, 1, 100),
       (6, 2, 100),
       (6, 3, 100),
       (6, 4, 100),
       (6, 5, 100),
       (6, 6, 100),
       (6, 7, 100),
       (7, 1, 100),
       (7, 2, 100),
       (7, 3, 100),
       (7, 4, 100),
       (7, 5, 100),
       (7, 6, 100),
       (7, 7, 100);
