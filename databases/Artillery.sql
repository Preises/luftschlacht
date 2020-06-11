-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Erstellungszeit: 11. Jun 2020 um 21:56
-- Server-Version: 5.5.60-0+deb8u1
-- PHP-Version: 5.6.33-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `samp6933_shorttest`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Artillery`
--

CREATE TABLE `Artillery` (
  `ListID` int(11) NOT NULL,
  `Art_PositonX` float NOT NULL,
  `Art_PositonY` float NOT NULL,
  `Art_PositonZ` float NOT NULL,
  `Art_RotationX` float NOT NULL,
  `Art_RotationY` float NOT NULL,
  `Art_RotationZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `Artillery`
--

INSERT INTO `Artillery` (`ListID`, `Art_PositonX`, `Art_PositonY`, `Art_PositonZ`, `Art_RotationX`, `Art_RotationY`, `Art_RotationZ`) VALUES
(1, 223.4, -1589.4, 32.2, 0, 0, 76),
(3, -380.2, -1477.9, 24.7, 0, 0, 264),
(4, -35.6, -1778.7, 0.6, 0, 0, 338),
(5, -131.5, -1636.6, 2.4, 0, 0, 212);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `Artillery`
--
ALTER TABLE `Artillery`
  ADD PRIMARY KEY (`ListID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `Artillery`
--
ALTER TABLE `Artillery`
  MODIFY `ListID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
