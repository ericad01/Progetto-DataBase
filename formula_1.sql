-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Feb 22, 2023 alle 16:05
-- Versione del server: 10.4.25-MariaDB
-- Versione PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `formula 1`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `classificagp`
--

CREATE TABLE `classificagp` (
  `id_gp` int(10) NOT NULL,
  `id_pilota` int(10) NOT NULL,
  `id_team` int(10) NOT NULL,
  `posizione` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `classificagp`
--

INSERT INTO `classificagp` (`id_gp`, `id_pilota`, `id_team`, `posizione`) VALUES
(1, 1, 3, 1),
(1, 3, 4, 2),
(1, 6, 5, 3),
(1, 8, 6, 4),
(2, 1, 3, 2),
(2, 6, 5, 1),
(2, 7, 6, 3),
(2, 9, 7, 4),
(3, 2, 3, 1),
(3, 4, 5, 3),
(3, 5, 4, 2),
(3, 10, 7, 4),
(4, 2, 3, 4),
(4, 3, 4, 1),
(4, 4, 5, 3),
(4, 7, 6, 5),
(4, 9, 7, 2),
(5, 2, 3, 2),
(5, 5, 4, 4),
(5, 6, 5, 3),
(5, 8, 6, 1),
(5, 10, 7, 5),
(6, 1, 3, 1),
(6, 4, 5, 3),
(6, 5, 4, 5),
(6, 7, 6, 2),
(6, 9, 7, 4);

--
-- Trigger `classificagp`
--
DELIMITER $$
CREATE TRIGGER `T1` AFTER INSERT ON `classificagp` FOR EACH ROW IF (NEW.posizione < 5) THEN
UPDATE pilota SET punteggio = punteggio + (20-5*NEW.posizione)
WHERE NEW.id_pilota = id_pilota;
UPDATE team SET punteggio = punteggio + (20-5*NEW.posizione)
WHERE NEW.id_team = id_team;
END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `T4` AFTER INSERT ON `classificagp` FOR EACH ROW BEGIN
	IF NOT EXISTS (SELECT *
        FROM ClassificaGP CGP JOIN PartecipanteGP PGP ON 		           CGP.id_pilota = PGP.id_pilota AND CGP.id_team = 				    PGP.id_team AND CGP.id_gp = PGP.id_gp
        WHERE NEW.id_pilota = CGP.id_pilota AND
        	  NEW.id_gp = CGP.id_gp AND
        	  NEW.id_team = CGP.id_team)
     THEN DELETE FROM ClassificaGP 
     WHERE  NEW.id_pilota = id_pilota AND
        	  NEW.id_gp = id_gp AND
        	  NEW.id_team = id_team;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `granpremio`
--

CREATE TABLE `granpremio` (
  `id_gp` int(10) NOT NULL,
  `id_tracciato` int(10) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `data` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `granpremio`
--

INSERT INTO `granpremio` (`id_gp`, `id_tracciato`, `nome`, `data`) VALUES
(1, 1, 'Gran Premio d\'Italia', '2022-09-11'),
(2, 2, 'Grand Prix de Monaco', '2022-05-29'),
(3, 3, 'Belgian Grand Prix', '2022-08-28'),
(4, 5, 'United States Grand Prix', '2022-10-23'),
(5, 4, 'Dutch Grand Prix', '2022-09-04'),
(6, 6, 'Australian Grand Prix', '2022-04-10');

-- --------------------------------------------------------

--
-- Struttura della tabella `partecipantegp`
--

CREATE TABLE `partecipantegp` (
  `id_pilota` int(10) NOT NULL,
  `id_team` int(10) NOT NULL,
  `id_gp` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `partecipantegp`
--

INSERT INTO `partecipantegp` (`id_pilota`, `id_team`, `id_gp`) VALUES
(1, 3, 1),
(1, 3, 2),
(1, 3, 3),
(1, 3, 4),
(1, 3, 5),
(1, 3, 6),
(2, 3, 3),
(2, 3, 4),
(2, 3, 5),
(3, 4, 1),
(3, 4, 4),
(4, 5, 3),
(4, 5, 4),
(4, 5, 6),
(5, 4, 3),
(5, 4, 5),
(5, 4, 6),
(6, 5, 1),
(6, 5, 2),
(6, 5, 5),
(7, 6, 2),
(7, 6, 4),
(7, 6, 6),
(8, 6, 1),
(8, 6, 5),
(9, 7, 2),
(9, 7, 4),
(9, 7, 6),
(10, 7, 3),
(10, 7, 5);

--
-- Trigger `partecipantegp`
--
DELIMITER $$
CREATE TRIGGER `T3` AFTER INSERT ON `partecipantegp` FOR EACH ROW BEGIN
	IF (SELECT id_team
        FROM Pilota 
        WHERE id_pilota = NEW.id_pilota) <> NEW.id_team
    THEN DELETE FROM PartecipanteGP
    WHERE NEW.id_team = id_team AND
  		  NEW.id_pilota = id_pilota AND
          NEW.id_gp = id_gp;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `pilota`
--

CREATE TABLE `pilota` (
  `id_pilota` int(10) NOT NULL,
  `id_team` int(10) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `data_nascita` date NOT NULL,
  `punteggio` int(5) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `pilota`
--

INSERT INTO `pilota` (`id_pilota`, `id_team`, `nome`, `data_nascita`, `punteggio`) VALUES
(1, 3, 'Charles Leclerc', '1997-10-16', 40),
(2, 3, 'Carlos Sainz', '1994-09-01', 25),
(3, 4, 'Max Verstappen', '1997-09-30', 25),
(4, 5, 'Lewis Hamilton', '1985-01-07', 15),
(5, 4, 'Sergio Perez', '1990-01-26', 10),
(6, 5, 'George Russell', '1998-02-15', 25),
(7, 6, 'Lando Norris', '1999-11-13', 15),
(8, 6, 'Oscar Piastri', '2001-04-06', 15),
(9, 7, 'Valteri Bottas', '1989-08-28', 10),
(10, 7, 'Guanyu Zhou', '1999-05-30', 0);

--
-- Trigger `pilota`
--
DELIMITER $$
CREATE TRIGGER `T2` AFTER INSERT ON `pilota` FOR EACH ROW BEGIN
	IF (SELECT COUNT(*)
        FROM Pilota 
        WHERE id_team = NEW.id_team
        GROUP BY id_team) > 2
    THEN DELETE FROM Pilota
    WHERE id_pilota = NEW.id_pilota;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `team`
--

CREATE TABLE `team` (
  `id_team` int(10) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `nazionalità` varchar(50) NOT NULL,
  `punteggio` int(5) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `team`
--

INSERT INTO `team` (`id_team`, `nome`, `nazionalità`, `punteggio`) VALUES
(3, 'Ferrari', 'italiana', 65),
(4, 'Red Bull', 'austriaca', 35),
(5, 'Mercedes', 'tedesca', 40),
(6, 'McLaren', 'britannica', 30),
(7, 'Alfa Romeo Racing', 'svizzera', 10);

-- --------------------------------------------------------

--
-- Struttura della tabella `tracciato`
--

CREATE TABLE `tracciato` (
  `id_tracciato` int(10) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `lunghezza` int(5) NOT NULL,
  `luogo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `tracciato`
--

INSERT INTO `tracciato` (`id_tracciato`, `nome`, `lunghezza`, `luogo`) VALUES
(1, 'Autodromo nazionale di Monza', 5, 'Italia'),
(2, 'Circuit de Monaco', 3, 'Monaco'),
(3, 'Circuit de SPA-Francorchamps', 7, 'Belgio'),
(4, 'Circuit Zandvoort', 4, 'Paesi Bassi'),
(5, 'Circuit of the Americas', 5, 'Stati Uniti'),
(6, 'Circuit Albert Park', 4, 'Australia');

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `classificagp`
--
ALTER TABLE `classificagp`
  ADD PRIMARY KEY (`id_gp`,`id_pilota`,`id_team`),
  ADD KEY `id_pilota` (`id_pilota`),
  ADD KEY `id_team` (`id_team`);

--
-- Indici per le tabelle `granpremio`
--
ALTER TABLE `granpremio`
  ADD PRIMARY KEY (`id_gp`),
  ADD KEY `id_tracciato` (`id_tracciato`);

--
-- Indici per le tabelle `partecipantegp`
--
ALTER TABLE `partecipantegp`
  ADD PRIMARY KEY (`id_pilota`,`id_team`,`id_gp`),
  ADD KEY `id_team` (`id_team`),
  ADD KEY `id_gp` (`id_gp`);

--
-- Indici per le tabelle `pilota`
--
ALTER TABLE `pilota`
  ADD PRIMARY KEY (`id_pilota`),
  ADD KEY `id_team` (`id_team`);

--
-- Indici per le tabelle `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`id_team`);

--
-- Indici per le tabelle `tracciato`
--
ALTER TABLE `tracciato`
  ADD PRIMARY KEY (`id_tracciato`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `granpremio`
--
ALTER TABLE `granpremio`
  MODIFY `id_gp` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT per la tabella `pilota`
--
ALTER TABLE `pilota`
  MODIFY `id_pilota` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT per la tabella `team`
--
ALTER TABLE `team`
  MODIFY `id_team` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT per la tabella `tracciato`
--
ALTER TABLE `tracciato`
  MODIFY `id_tracciato` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `classificagp`
--
ALTER TABLE `classificagp`
  ADD CONSTRAINT `classificagp_ibfk_1` FOREIGN KEY (`id_pilota`) REFERENCES `pilota` (`id_pilota`),
  ADD CONSTRAINT `classificagp_ibfk_2` FOREIGN KEY (`id_team`) REFERENCES `team` (`id_team`),
  ADD CONSTRAINT `classificagp_ibfk_3` FOREIGN KEY (`id_gp`) REFERENCES `granpremio` (`id_gp`);

--
-- Limiti per la tabella `granpremio`
--
ALTER TABLE `granpremio`
  ADD CONSTRAINT `granpremio_ibfk_1` FOREIGN KEY (`id_tracciato`) REFERENCES `tracciato` (`id_tracciato`);

--
-- Limiti per la tabella `partecipantegp`
--
ALTER TABLE `partecipantegp`
  ADD CONSTRAINT `partecipantegp_ibfk_1` FOREIGN KEY (`id_pilota`) REFERENCES `pilota` (`id_pilota`),
  ADD CONSTRAINT `partecipantegp_ibfk_2` FOREIGN KEY (`id_team`) REFERENCES `team` (`id_team`),
  ADD CONSTRAINT `partecipantegp_ibfk_3` FOREIGN KEY (`id_gp`) REFERENCES `granpremio` (`id_gp`);

--
-- Limiti per la tabella `pilota`
--
ALTER TABLE `pilota`
  ADD CONSTRAINT `pilota_ibfk_1` FOREIGN KEY (`id_team`) REFERENCES `team` (`id_team`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
