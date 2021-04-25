
USE firma;

SELECT * FROM ksiegowosc.premie;
SELECT * FROM ksiegowosc.pracownicy;
SELECT * FROM ksiegowosc.pensje;
SELECT * FROM ksiegowosc.godziny;
SELECT * FROM ksiegowosc.wynagrodzenie;


--a)

SELECT pracownicy.imi�, pracownicy.nazwisko, CONCAT_WS('','(+48)', pracownicy.telefon) AS 'telefon' FROM ksiegowosc.pracownicy;

--b)

ALTER TABLE ksiegowosc.pracownicy
ALTER COLUMN telefon varchar(12);

UPDATE ksiegowosc.pracownicy
SET pracownicy.telefon = FORMAT(cast(pracownicy.telefon AS int), '###-###-###');

--c) 

SELECT TOP 1 UPPER(pracownicy.nazwisko) AS 'nazwisko', UPPER(pracownicy.imi�) AS 'imi�', UPPER(pracownicy.adres) AS 'adres'
FROM ksiegowosc.pracownicy ORDER BY LEN(pracownicy.nazwisko) DESC;

--d) 

SELECT HASHBYTES ('MD5',pracownicy.imi�) AS 'imie', HASHBYTES('MD5',pracownicy.nazwisko) AS 'nazwisko', HASHBYTES('MD5',CAST( pensje.kwota_brutto AS varchar)) AS 'pensja' 
FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.wynagrodzenie INNER JOIN ksiegowosc.pensje ON pensje.id_pensji = wynagrodzenie.id_pensji)
ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika;

--e)

SELECT pracownicy.id_pracownika, pracownicy.imi�, pracownicy.nazwisko, pensje.kwota_brutto AS 'pensja', premie.kwota AS 'premia'
FROM ksiegowosc.pracownicy LEFT JOIN (ksiegowosc.pensje LEFT JOIN ( ksiegowosc.wynagrodzenie LEFT JOIN ksiegowosc.premie  ON wynagrodzenie.id_premii = premie.id_premii) ON pensje.id_pensji = wynagrodzenie.id_pensji ) ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika

--f)

SELECT CONCAT('Pracownik ', pracownicy.imi�,' ', pracownicy.nazwisko,', w dniu ', godziny.dzie�, ' otrzyma� pensj� ca�kowit� na kwot� ', (pensje.kwota_brutto + premie.kwota) ,', gdzie wynagrodzenie zasadnicze wynosi�o: ', pensje.kwota_brutto, ' z�, premia: ', premie.kwota, ' z�') AS 'raport'
FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.pensje INNER JOIN ( ksiegowosc.premie INNER JOIN (ksiegowosc.godziny INNER JOIN ksiegowosc.wynagrodzenie ON godziny.id_godziny = wynagrodzenie.id_godziny) ON premie.id_premii = wynagrodzenie.id_premii) ON pensje.id_pensji = wynagrodzenie.id_pensji ) ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika

