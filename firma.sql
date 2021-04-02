--1. TWORZENIE BAZY DANYCH
CREATE DATABASE firma;
USE firma;

--2. TWORZENIE SCHEMATU

CREATE SCHEMA rozliczenia;

--3. TWORZENIE TABEL

CREATE TABLE rozliczenia.pracownicy (
	id_pracownika int PRIMARY KEY NOT NULL,
	imiê varchar(30),
	nazwisko varchar(45) NOT NULL,
	adres varchar(100),
	telefon int
);

CREATE TABLE rozliczenia.godziny (
	id_godziny int PRIMARY KEY NOT NULL,
	dzieñ date NOT NULL,
	liczba_godzin int,
	id_pracownika int NOT NULL,
	CONSTRAINT fk_id_pracownika FOREIGN KEY (id_pracownika) REFERENCES rozliczenia.pracownicy (id_pracownika)
);


CREATE TABLE rozliczenia.pensje (
	id_pensji int PRIMARY KEY NOT NULL,
	stanowisko varchar(40) NOT NULL,
	kwota decimal(8,2),
	id_premii int NOT NULL
);

CREATE TABLE rozliczenia.premie (
	id_premii int PRIMARY KEY NOT NULL,
	rodzaj varchar(30),
	kwota decimal(8,2)
);

--4. DODAWANIE KLUCZA OBCEGO DO TABELI "PENSJE"

ALTER TABLE rozliczenia.pensje 
ADD CONSTRAINT fk_id_premii
FOREIGN KEY (id_premii) REFERENCES rozliczenia.premie (id_premii);


--5. DODAWANIE REKORDÓW

INSERT INTO rozliczenia.pracownicy
VALUES(1, 'Jan', 'Kowalski', '11-go listopada 3, Kraków', 987324080);

INSERT INTO rozliczenia.pracownicy
VALUES(2, 'Monika', 'Górka', 'Micha³owicza 12, Warszawa', 123321000);

INSERT INTO rozliczenia.pracownicy
VALUES(3, 'Joanna', 'Maj', 'Dêbowiec 7/29, Kraków', 609870320);

INSERT INTO rozliczenia.pracownicy
VALUES(4, 'Andrzej', 'K³os', 'Storczyków 1, Gdañsk', 111991711);

INSERT INTO rozliczenia.pracownicy
VALUES(5, 'Miros³aw', 'Dendzik', 'Bajkowa, Warszawa', 438906304);

INSERT INTO rozliczenia.pracownicy
VALUES(6, 'Alicja', 'Drabek', 'Rzeczna 1/6, Gdañsk', 755300290);

INSERT INTO rozliczenia.pracownicy
VALUES(7, 'Helena', 'Piotrkowska', 'Kasztanowa 7, Warszawa', 198759759);

INSERT INTO rozliczenia.pracownicy
VALUES(8, 'Stefan', 'Sowa', 'Prosta 115, Kraków', 939546000);

INSERT INTO rozliczenia.pracownicy
VALUES(9, 'Tomasz', 'Sokó³', 'Towarowa 8, Katowice', 500811299);

INSERT INTO rozliczenia.pracownicy
VALUES(10, 'Nina', 'Nowak', 'M³yñska 43, Katowice', 198261529);

SELECT * FROM rozliczenia.pracownicy ORDER BY id_pracownika;


INSERT INTO rozliczenia.godziny
VALUES(1, '2020-08-06', 6, 3);

INSERT INTO rozliczenia.godziny
VALUES(2, '2020-08-11', 4, 7);

INSERT INTO rozliczenia.godziny
VALUES(3, '2020-08-15', 2, 5);

INSERT INTO rozliczenia.godziny
VALUES(4, '2020-08-12', 12, 9);

INSERT INTO rozliczenia.godziny
VALUES(5, '2020-08-01', 11, 2);

INSERT INTO rozliczenia.godziny
VALUES(6, '2020-08-18', 6, 4);

INSERT INTO rozliczenia.godziny
VALUES(7, '2020-08-23', 9, 8);

INSERT INTO rozliczenia.godziny
VALUES(8, '2020-08-12', 3, 1);

INSERT INTO rozliczenia.godziny
VALUES(9, '2020-08-07', 17, 10);

INSERT INTO rozliczenia.godziny
VALUES(10, '2020-08-05', 14, 6);

SELECT * FROM rozliczenia.godziny;


INSERT INTO rozliczenia.premie
VALUES(1, 'œwi¹teczna', 1000);

INSERT INTO rozliczenia.premie
VALUES(2, 'motywacyjna', 500);

INSERT INTO rozliczenia.premie
VALUES(3, 'jubileuszowa', 1500);

INSERT INTO rozliczenia.premie
VALUES(4, 'kwartalna', 800);

SELECT * FROM rozliczenia.premie;


INSERT INTO rozliczenia.pensje
VALUES(1, 'sprzedawca', 4000, 1);

INSERT INTO rozliczenia.pensje
VALUES(2, 'kierownik sprzeda¿y', 5600, 2);

INSERT INTO rozliczenia.pensje
VALUES(3, 'radca prawny', 8700, 3);

INSERT INTO rozliczenia.pensje
VALUES(4, 'kierowca', 4600, 4);

INSERT INTO rozliczenia.pensje
VALUES(5, 'specjalista ds. reklamy', 6000, 4);

INSERT INTO rozliczenia.pensje
VALUES(6, 'g³owny ksiêgowy', 8900, 3);

INSERT INTO rozliczenia.pensje
VALUES(7, 'm³odszy ksiêgowy', 5000, 4);

INSERT INTO rozliczenia.pensje
VALUES(8, 'informatyk', 8500, 2);

INSERT INTO rozliczenia.pensje
VALUES(9, 'dyrektor ds. marketingu', 7300, 2);

INSERT INTO rozliczenia.pensje
VALUES(10, 'dyrektor generalny', 10200, 1);

SELECT * FROM rozliczenia.pensje;

--6. KONWERSJA DATY 
SELECT 
DATEPART(DW, dzieñ) AS Dzieñ_tygodnia,
DATEPART(MM, dzieñ) AS Miesi¹c
FROM rozliczenia.godziny;


--7. ZMIANA NAZWY KOLUMNY Z KWOTA NA KWOTA_BRUTTO I DODANIE KOLUMNY KWOTA_NETTO
EXEC sp_rename 'rozliczenia.pensje.kwota', 'kwota_brutto', 'COLUMN';  

ALTER TABLE rozliczenia.pensje
ADD kwota_netto AS (0.81 * kwota_brutto);

SELECT * FROM rozliczenia.pensje;
