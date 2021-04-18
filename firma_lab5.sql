
USE firma;

CREATE SCHEMA ksiegowosc;
ALTER SCHEMA ksiegowosc
    TRANSFER rozliczenia.pracownicy;
ALTER SCHEMA ksiegowosc
	TRANSFER rozliczenia.godziny;
ALTER SCHEMA ksiegowosc
	TRANSFER rozliczenia.premie;
ALTER SCHEMA ksiegowosc
	TRANSFER rozliczenia.pensje;

SELECT * FROM ksiegowosc.pracownicy;

--wynagrodzenie( id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii) 

CREATE TABLE ksiegowosc.wynagrodzenie(
	id_wynagrodzenia int PRIMARY KEY,
	"data" date,
	id_pracownika int NOT NULL,
	CONSTRAINT fk_id_p FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy (id_pracownika),
	id_godziny int NOT NULL,
	CONSTRAINT fk_id_godziny FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny (id_godziny),
	id_pensji int NOT NULL,
	CONSTRAINT fk_id_pensji FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensje (id_pensji),
	id_premii int,
	CONSTRAINT fk_id_pr FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premie (id_premii),
);

SELECT * FROM ksiegowosc.premie;
SELECT * FROM ksiegowosc.pracownicy;
SELECT * FROM ksiegowosc.pensje;
SELECT * FROM ksiegowosc.godziny;
SELECT * FROM ksiegowosc.wynagrodzenie;

INSERT INTO ksiegowosc.wynagrodzenie
VALUES (111, '2020-08-06', 1, 8, 1, 1), (112, '2020-12-12', 6, 10, 9, 2), (113, '2020-09-30', 3, 1, 5, 4), (114, '2020-05-26', 7, 2, 4, 6), (115, '2020-11-02', 10, 9, 7, null), (116, '2020-01-09', 5, 3, 8, 10), (117, '2020-12-13', 9, 4, 3, 3), (118, '2020-04-23', 4, 6, 2, 8), (119, '2020-10-16', 2, 5, 6, 7), (120, '2020-09-05', 9, 4, 10, 9);

--A
SELECT pracownicy.id_pracownika, pracownicy.nazwisko FROM ksiegowosc.pracownicy

--B
SELECT pracownicy.id_pracownika, pracownicy.nazwisko, pensje.kwota_brutto FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.pensje INNER JOIN ksiegowosc.wynagrodzenie ON pensje.id_pensji = wynagrodzenie.id_pensji) ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
WHERE pensje.kwota_brutto > 1000;

--C
SELECT pracownicy.id_pracownika, pracownicy.nazwisko, pensje.kwota_brutto, wynagrodzenie.id_premii FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.pensje INNER JOIN ksiegowosc.wynagrodzenie ON pensje.id_pensji = wynagrodzenie.id_pensji) ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
WHERE wynagrodzenie.id_premii IS NULL AND pensje.kwota_brutto > 2000;

--D
SELECT * FROM ksiegowosc.pracownicy
WHERE pracownicy.imiê LIKE 'J%';

--E
SELECT * FROM ksiegowosc.pracownicy
WHERE pracownicy.nazwisko LIKE '%n%' AND pracownicy.imiê LIKE '%a';

--F
SELECT pracownicy.imiê, pracownicy.nazwisko, godziny.liczba_godzin FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.godziny INNER JOIN ksiegowosc.wynagrodzenie ON godziny.id_godziny = wynagrodzenie.id_godziny) ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
WHERE godziny.liczba_godzin > 160;

--G
SELECT pracownicy.imiê, pracownicy.nazwisko, pensje.kwota_brutto FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.wynagrodzenie INNER JOIN ksiegowosc.pensje ON pensje.id_pensji = wynagrodzenie.id_pensji) ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
WHERE pensje.kwota_brutto >= 1500 AND pensje.kwota_brutto <= 3000 ;

--H
SELECT pracownicy.imiê, pracownicy.nazwisko, godziny.liczba_godzin FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.godziny INNER JOIN ksiegowosc.wynagrodzenie ON godziny.id_godziny = wynagrodzenie.id_godziny) ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
WHERE godziny.liczba_godzin > 160 AND wynagrodzenie.id_premii IS NULL;

--I
SELECT pracownicy.imiê, pracownicy.nazwisko, pensje.kwota_brutto FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.wynagrodzenie INNER JOIN ksiegowosc.pensje ON pensje.id_pensji = wynagrodzenie.id_pensji) ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
ORDER BY pensje.kwota_brutto;

--J
SELECT pracownicy.imiê, pracownicy.nazwisko, pensje.kwota_brutto, premie.kwota FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.pensje INNER JOIN ( ksiegowosc.premie INNER JOIN ksiegowosc.wynagrodzenie  ON premie.id_premii = wynagrodzenie.id_premii) ON pensje.id_pensji = wynagrodzenie.id_pensji ) ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
ORDER BY pensje.kwota_brutto DESC, premie.kwota DESC;

--K
SELECT COUNT(pensje.stanowisko) AS 'count', pensje.stanowisko
FROM ksiegowosc.pensje
GROUP BY pensje.stanowisko;

--L
SELECT AVG(pensje.kwota_brutto) AS 'œrednia', MIN(pensje.kwota_brutto) AS 'min', MAX(pensje.kwota_brutto) AS 'max'
FROM ksiegowosc.pensje
WHERE pensje.stanowisko LIKE 'kierownik sprzeda¿y';

--M
SELECT SUM(pensje.kwota_brutto) AS 'suma wszystkich wynagrodzeñ'
FROM ksiegowosc.pensje;

--N
SELECT SUM(pensje.kwota_brutto) AS 'suma wynagrodzenia dla danego stanowiska', pensje.stanowisko
FROM ksiegowosc.pensje 
GROUP BY pensje.stanowisko;

--O
SELECT COUNT(wynagrodzenie.id_premii) AS 'liczba premii', pensje.stanowisko
FROM ksiegowosc.pensje INNER JOIN ksiegowosc.wynagrodzenie  ON pensje.id_pensji = wynagrodzenie.id_pensji 
GROUP BY pensje.stanowisko;

--P
DELETE FROM ksiegowosc.wynagrodzenie
WHERE wynagrodzenie.id_pracownika = (SELECT wynagrodzenie.id_pracownika FROM  (ksiegowosc.pensje INNER JOIN ksiegowosc.wynagrodzenie ON pensje.id_pensji = wynagrodzenie.id_pensji)
WHERE pensje.kwota_brutto <= 1200);

DELETE FROM ksiegowosc.godziny
WHERE godziny.id_pracownika = 2;

DELETE FROM ksiegowosc.pracownicy
WHERE pracownicy.id_pracownika = 2;

