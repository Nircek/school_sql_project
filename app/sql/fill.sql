INSERT INTO nauczyciel (imie, nazwisko)
VALUES ('Jan', 'Matematyk'),
       ('Anna', 'Polonistka'),
       ('Piotr', 'Fizyk'),
       ('Katarzyna', 'Chemiczka'),
       ('Marek', 'Biolog'),
       ('Agnieszka', 'Geografka'),
       ('Michał', 'Historyk');


INSERT INTO klasa (nazwa, wychowawca)
VALUES ('1A', 2),
       ('1B', 4),
       ('2A', 3),
       ('2B', 7),
       ('3A', 1),
       ('3B', 5),
       ('3C', 6);

INSERT INTO uczen (imie, nazwisko, klasa_id)
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

INSERT INTO sala (nazwa)
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

INSERT INTO semestr (data_poczatku, data_konca)
VALUES ('2024-09-01', '2025-01-19'),
       ('2025-02-03', '2025-06-27');

INSERT INTO zajecia (sala_id, klasa_id, nauczyciel_id, nazwa, semestr_id, dzien, czas_rozp, czas_konc)
VALUES (1, 1, 5, 'Biologia', 1, 'pn', '08:00', '09:30'),
       (2, 7, 3, 'Fizyka', 1, 'pn', '09:45', '11:15'),
       (3, 5, 5, 'Biologia', 1, 'pn', '11:30', '13:00'),
       (4, 4, 4, 'Chemia', 1, 'pn', '13:15', '14:45'),
       (5, 1, 6, 'Geografia', 1, 'pn', '15:00', '16:30'),
       (6, 4, 1, 'Matematka', 1, 'pn', '16:45', '18:15'),
       (7, 2, 6, 'Geografia', 1, 'pn', '18:30', '20:00'),
       (8, 7, 6, 'Geografia', 1, 'wt', '08:00', '09:30'),
       (9, 7, 6, 'Geografia', 1, 'wt', '09:45', '11:15'),
       (10, 5, 7, 'Historia', 1, 'wt', '11:30', '13:00'),
       (1, 2, 7, 'Historia', 1, 'wt', '13:15', '14:45'),
       (2, 5, 6, 'Geografia', 1, 'wt', '15:00', '16:30'),
       (3, 2, 3, 'Fizyka', 1, 'wt', '16:45', '18:15'),
       (4, 7, 6, 'Geografia', 1, 'wt', '18:30', '20:00'),
       (5, 2, 4, 'Chemia', 1, 'śr', '08:00', '09:30'),
       (6, 1, 5, 'Biologia', 1, 'śr', '09:45', '11:15'),
       (7, 7, 5, 'Biologia', 1, 'śr', '11:30', '13:00'),
       (8, 2, 7, 'Historia', 1, 'śr', '13:15', '14:45'),
       (9, 6, 6, 'Geografia', 1, 'śr', '15:00', '16:30'),
       (10, 4, 2, 'Polski', 1, 'śr', '16:45', '18:15'),
       (1, 4, 1, 'Matematka', 1, 'śr', '18:30', '20:00'),
       (2, 2, 6, 'Geografia', 1, 'cz', '08:00', '09:30'),
       (3, 4, 4, 'Chemia', 1, 'cz', '09:45', '11:15'),
       (4, 3, 7, 'Historia', 1, 'cz', '11:30', '13:00'),
       (5, 4, 5, 'Biologia', 1, 'cz', '13:15', '14:45'),
       (6, 1, 4, 'Chemia', 1, 'cz', '15:00', '16:30'),
       (7, 2, 2, 'Polski', 1, 'cz', '16:45', '18:15'),
       (8, 7, 2, 'Polski', 1, 'cz', '18:30', '20:00'),
       (9, 1, 4, 'Chemia', 1, 'pt', '08:00', '09:30'),
       (10, 3, 3, 'Fizyka', 1, 'pt', '09:45', '11:15'),
       (1, 2, 4, 'Chemia', 1, 'pt', '11:30', '13:00'),
       (2, 7, 6, 'Geografia', 1, 'pt', '13:15', '14:45'),
       (3, 6, 3, 'Fizyka', 1, 'pt', '15:00', '16:30'),
       (4, 4, 3, 'Fizyka', 1, 'pt', '16:45', '18:15'),
       (5, 1, 1, 'Matematka', 1, 'pt', '18:30', '20:00'),
       (6, 6, 1, 'Matematka', 2, 'pn', '08:00', '09:30'),
       (7, 6, 3, 'Fizyka', 2, 'pn', '09:45', '11:15'),
       (8, 2, 7, 'Historia', 2, 'pn', '11:30', '13:00'),
       (9, 1, 7, 'Historia', 2, 'pn', '13:15', '14:45'),
       (10, 1, 1, 'Matematka', 2, 'pn', '15:00', '16:30'),
       (1, 2, 6, 'Geografia', 2, 'pn', '16:45', '18:15'),
       (2, 3, 2, 'Polski', 2, 'pn', '18:30', '20:00'),
       (3, 2, 4, 'Chemia', 2, 'wt', '08:00', '09:30'),
       (4, 1, 3, 'Fizyka', 2, 'wt', '09:45', '11:15'),
       (5, 3, 4, 'Chemia', 2, 'wt', '11:30', '13:00'),
       (6, 5, 4, 'Chemia', 2, 'wt', '13:15', '14:45'),
       (7, 1, 3, 'Fizyka', 2, 'wt', '15:00', '16:30'),
       (8, 7, 2, 'Polski', 2, 'wt', '16:45', '18:15'),
       (9, 3, 7, 'Historia', 2, 'wt', '18:30', '20:00'),
       (10, 4, 1, 'Matematka', 2, 'śr', '08:00', '09:30'),
       (1, 2, 1, 'Matematka', 2, 'śr', '09:45', '11:15'),
       (2, 5, 7, 'Historia', 2, 'śr', '11:30', '13:00'),
       (3, 2, 7, 'Historia', 2, 'śr', '13:15', '14:45'),
       (4, 6, 4, 'Chemia', 2, 'śr', '15:00', '16:30'),
       (5, 4, 4, 'Chemia', 2, 'śr', '16:45', '18:15'),
       (6, 3, 2, 'Polski', 2, 'śr', '18:30', '20:00'),
       (7, 5, 5, 'Biologia', 2, 'cz', '08:00', '09:30'),
       (8, 4, 2, 'Polski', 2, 'cz', '09:45', '11:15'),
       (9, 4, 6, 'Geografia', 2, 'cz', '11:30', '13:00'),
       (10, 5, 7, 'Historia', 2, 'cz', '13:15', '14:45'),
       (1, 7, 7, 'Historia', 2, 'cz', '15:00', '16:30'),
       (2, 3, 5, 'Biologia', 2, 'cz', '16:45', '18:15'),
       (3, 2, 5, 'Biologia', 2, 'cz', '18:30', '20:00'),
       (4, 6, 2, 'Polski', 2, 'pt', '08:00', '09:30'),
       (5, 2, 6, 'Geografia', 2, 'pt', '09:45', '11:15'),
       (6, 3, 2, 'Polski', 2, 'pt', '11:30', '13:00'),
       (7, 7, 5, 'Biologia', 2, 'pt', '13:15', '14:45'),
       (8, 5, 7, 'Historia', 2, 'pt', '15:00', '16:30'),
       (9, 3, 6, 'Geografia', 2, 'pt', '16:45', '18:15'),
       (10, 1, 1, 'Matematka', 2, 'pt', '18:30', '20:00');

INSERT INTO ocena (zajecia_id, uczen_id, ocena, data, komentarz)
VALUES (1, 1, 5, '2024-09-02', 'zadanie 1'),
       (1, 1, 1, '2024-09-02', 'zadanie domowe 1'),
       (1, 2, 4, '2024-09-02', 'zadanie 1'),
       (1, 3, 3, '2024-09-02', 'zadanie 1'),
       (1, 4, 2, '2024-09-02', 'zadanie 1'),
       (1, 5, 5, '2024-09-02', 'zadanie 1'),
       (1, 6, 4, '2024-09-02', 'zadanie 1'),
       (1, 7, 3, '2024-09-02', 'zadanie 1'),
       (2, 43, 2, '2024-09-02', 'zadanie 1'),
       (2, 44, 5, '2024-09-02', 'zadanie 1'),
       (2, 45, 4, '2024-09-02', 'zadanie 1'),
       (2, 46, 2, '2024-09-02', 'zadanie 1'),
       (2, 47, 2, '2024-09-02', 'zadanie 1'),
       (2, 48, 2, '2024-09-02', 'zadanie 1'),
       (2, 49, 1, '2024-09-02', 'zadanie 1'),
       (3, 29, 5, '2024-09-02', 'zadanie 1'),
       (3, 30, 5, '2024-09-02', 'zadanie 1'),
       (3, 31, 5, '2024-09-02', 'zadanie 1'),
       (3, 32, 4, '2024-09-02', 'zadanie 1'),
       (3, 33, 4, '2024-09-02', 'zadanie 1'),
       (3, 34, 4, '2024-09-02', 'zadanie 1'),
       (3, 35, 4, '2024-09-02', 'zadanie 1'),
       (4, 22, 2, '2024-09-02', 'zadanie 1'),
       (4, 23, 2, '2024-09-02', 'zadanie 1'),
       (4, 24, 3, '2024-09-02', 'zadanie 1'),
       (4, 25, 3, '2024-09-02', 'zadanie 1'),
       (4, 26, 3, '2024-09-02', 'zadanie 1'),
       (4, 27, 4, '2024-09-02', 'zadanie 1'),
       (4, 28, 4, '2024-09-02', 'zadanie 1'),
       (5, 1, 4, '2024-09-02', 'zadanie 1'),
       (5, 2, 2, '2024-09-02', 'zadanie 1'),
       (5, 3, 5, '2024-09-02', 'zadanie 1'),
       (5, 4, 5, '2024-09-02', 'zadanie 1'),
       (5, 5, 5, '2024-09-02', 'zadanie 1'),
       (5, 6, 5, '2024-09-02', 'zadanie 1'),
       (5, 7, 2, '2024-09-02', 'zadanie 1'),
       (6, 22, 5, '2024-09-02', 'zadanie 1'),
       (6, 23, 3, '2024-09-02', 'zadanie 1'),
       (6, 24, 3, '2024-09-02', 'zadanie 1'),
       (6, 25, 3, '2024-09-02', 'zadanie 1'),
       (6, 26, 3, '2024-09-02', 'zadanie 1'),
       (6, 27, 5, '2024-09-02', 'zadanie 1'),
       (6, 28, 5, '2024-09-02', 'zadanie 1'),
       (7, 8, 3, '2024-09-02', 'zadanie 1'),
       (7, 9, 3, '2024-09-02', 'zadanie 1'),
       (7, 10, 3, '2024-09-02', 'zadanie 1'),
       (7, 11, 3, '2024-09-02', 'zadanie 1'),
       (7, 12, 2, '2024-09-02', 'zadanie 1'),
       (7, 13, 5, '2024-09-02', 'zadanie 1'),
       (7, 14, 3, '2024-09-02', 'zadanie 1'),
       (8, 43, 3, '2024-09-03', 'zadanie 1'),
       (8, 44, 4, '2024-09-03', 'zadanie 1'),
       (8, 45, 3, '2024-09-03', 'zadanie 1'),
       (8, 46, 3, '2024-09-03', 'zadanie 1'),
       (8, 47, 4, '2024-09-03', 'zadanie 1'),
       (8, 48, 4, '2024-09-03', 'zadanie 1'),
       (8, 49, 1, '2024-09-03', 'zadanie 1');

INSERT INTO frekwencja (zajecia_id, data, uczen_id, obecnosc)
VALUES (1, '2024-09-02', 1, 'nb'),
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
       (3, '2024-09-02', 29, 'ob'),
       (3, '2024-09-02', 30, 'ob'),
       (3, '2024-09-02', 31, 'ob'),
       (3, '2024-09-02', 32, 'ob'),
       (3, '2024-09-02', 33, 'ob'),
       (3, '2024-09-02', 34, 'ob'),
       (3, '2024-09-02', 35, 'ob'),
       (4, '2024-09-02', 22, 'ob'),
       (4, '2024-09-02', 23, 'ob'),
       (4, '2024-09-02', 24, 'ob'),
       (4, '2024-09-02', 25, 'ob'),
       (4, '2024-09-02', 26, 'ob'),
       (4, '2024-09-02', 27, 'ob'),
       (4, '2024-09-02', 28, 'ob'),
       (5, '2024-09-02', 1, 'ob'),
       (5, '2024-09-02', 2, 'ob'),
       (5, '2024-09-02', 3, 'ob'),
       (5, '2024-09-02', 4, 'ob'),
       (5, '2024-09-02', 5, 'ob'),
       (5, '2024-09-02', 6, 'ob'),
       (5, '2024-09-02', 7, 'ob'),
       (6, '2024-09-02', 22, 'ob'),
       (6, '2024-09-02', 23, 'ob'),
       (6, '2024-09-02', 24, 'ob'),
       (6, '2024-09-02', 25, 'ob'),
       (6, '2024-09-02', 26, 'ob'),
       (6, '2024-09-02', 27, 'ob'),
       (6, '2024-09-02', 28, 'ob'),
       (7, '2024-09-02', 8, 'ob'),
       (7, '2024-09-02', 9, 'ob'),
       (7, '2024-09-02', 10, 'ob'),
       (7, '2024-09-02', 11, 'ob'),
       (7, '2024-09-02', 12, 'ob'),
       (7, '2024-09-02', 13, 'ob'),
       (7, '2024-09-02', 14, 'ob'),
       (8, '2024-09-03', 43, 'ob'),
       (8, '2024-09-03', 44, 'ob'),
       (8, '2024-09-03', 45, 'ob'),
       (8, '2024-09-03', 46, 'ob'),
       (8, '2024-09-03', 47, 'ob'),
       (8, '2024-09-03', 48, 'ob'),
       (8, '2024-09-03', 49, 'ob'),
       (9, '2024-09-03', 43, 'ob');

INSERT INTO platnosc (klasa_id, tytul, opis, kwota, termin, kategoria)
VALUES (1, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (2, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (3, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (4, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (5, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (6, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (7, 'kartki na kartkówki', '', 100, '2024-09-14', 'kartki'),
       (1, 'wywieczka do Paryża', '', 1000, '2024-12-31', 'wycieczki');

INSERT INTO zaplata (platnosc_id, uczen_id, kwota)
VALUES (1, 1, 100),
       (1, 2, 100),
       (1, 3, 50),
       (1, 5, 100),
       (1, 6, 100),
       (1, 7, 100),
       (2, 8, 100),
       (2, 9, 100),
       (2, 10, 100),
       (2, 11, 100),
       (2, 12, 100),
       (2, 13, 100),
       (2, 14, 100),
       (3, 15, 100),
       (3, 16, 100),
       (3, 17, 100),
       (3, 18, 100),
       (3, 19, 100),
       (3, 20, 100),
       (3, 21, 100),
       (4, 22, 100),
       (4, 23, 100),
       (4, 24, 100),
       (4, 25, 100),
       (4, 26, 100),
       (4, 27, 100),
       (4, 28, 100),
       (6, 36, 100),
       (6, 37, 100),
       (6, 38, 100),
       (6, 39, 100),
       (6, 40, 100),
       (6, 41, 100),
       (6, 42, 100),
       (7, 43, 100),
       (7, 44, 100),
       (7, 45, 100),
       (7, 46, 100),
       (7, 47, 100),
       (7, 48, 100),
       (7, 49, 100),
       (8, 1, 300),
       (8, 2, 1000);
