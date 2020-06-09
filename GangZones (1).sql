-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Erstellungszeit: 09. Jun 2020 um 20:43
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
-- Tabellenstruktur für Tabelle `GangZones`
--

CREATE TABLE `GangZones` (
  `zoneid` int(11) NOT NULL,
  `ZoneArt` int(11) NOT NULL,
  `minx` float NOT NULL,
  `miny` float NOT NULL,
  `maxx` float NOT NULL,
  `maxy` float NOT NULL,
  `DominatedBy` int(11) NOT NULL,
  `ZoneName` varchar(40) NOT NULL,
  `ZoneActive` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `GangZones`
--

INSERT INTO `GangZones` (`zoneid`, `ZoneArt`, `minx`, `miny`, `maxx`, `maxy`, `DominatedBy`, `ZoneName`, `ZoneActive`) VALUES
(1, 1, 36.0001, -1546.5, 72.0001, -1519.5, 0, 'Bridge', 0),
(2, 1, 72.0001, -1570.5, 88.0001, -1537.5, 1, 'LS1', 0),
(3, 1, 85.0001, -1596.5, 101, -1568.5, 1, 'LS2', 0),
(4, 1, 106, -1568.5, 121, -1540.5, 1, 'LS3', 0),
(5, 1, 117, -1596.5, 133, -1568.5, 1, 'LS4', 0),
(6, 1, 107, -1610.5, 139, -1596.5, 1, 'LS5', 0),
(7, 1, 85.0001, -1624.5, 107, -1596.5, 1, 'LS6', 0),
(8, 1, 85.0001, -1669.5, 108, -1645.5, 1, 'LS7', 0),
(9, 1, 139, -1668.5, 171, -1646.5, 1, 'LS8', 0),
(10, 1, 107, -1668.5, 139, -1646.5, 1, 'LS9', 0),
(11, 1, 139, -1690.5, 171, -1668.5, 1, 'LS10', 0),
(12, 1, 107, -1690.5, 139, -1668.5, 1, 'LS11', 0),
(13, 1, 91.0001, -1690.5, 107, -1668.5, 1, 'LS12', 0),
(14, 1, 91.0001, -1712.5, 114, -1690.5, 1, 'LS13', 0),
(15, 1, 107, -1712.5, 130, -1690.5, 1, 'LS14', 0),
(16, 1, 130, -1712.5, 173, -1690.5, 1, 'LS15', 0),
(17, 1, 31.4001, -1556.8, 98.4001, -1513.8, 1, 'LS16', 1),
(18, 1, 97.4001, -1555.8, 164.4, -1512.8, 1, 'LS17', 1),
(19, 1, 77.4001, -1598.8, 144.4, -1555.8, 1, 'LS18', 1),
(20, 1, 144.4, -1546.5, 211.4, -1555.8, 1, 'LS19', 1),
(21, 1, 144.4, -1641.8, 211.4, -1598.8, 1, 'LS20', 1),
(22, 1, 78.4001, -1641.8, 145.4, -1598.8, 1, 'LS21', 1),
(23, 1, 77.4001, -1683.8, 144.4, -1640.8, 1, 'LS22', 1),
(24, 1, 144.4, -1683.8, 211.4, -1640.8, 1, 'LS23', 1),
(25, 1, 144.4, -1725.8, 211.4, -1682.8, 1, 'LS24', 1),
(26, 1, 78.4001, -1725.8, 145.4, -1682.8, 1, 'LS25', 1),
(27, 1, 210.4, -1641.8, 277.4, -1598.8, 1, 'LS26', 1),
(28, 1, 210.4, -1683.8, 277.4, -1640.8, 1, 'LS27', 1),
(29, 1, 210.4, -1725.8, 277.4, -1682.8, 1, 'LS28', 1),
(30, 1, 276.4, -1725.8, 359.4, -1683.8, 1, 'LS29', 1),
(31, 1, 276.4, -1684.8, 361.4, -1640.8, 1, 'LS30', 1),
(32, 1, 78.4001, -1767.8, 145.4, -1724.8, 1, 'LS31', 1),
(33, 1, 144.4, -1767.8, 211.4, -1724.8, 1, 'LS32', 1),
(34, 1, 210.4, -1767.8, 277.4, -1724.8, 1, 'LS33', 1),
(35, 1, 276.4, -1769.8, 362.4, -1724.8, 1, 'LS34', 1),
(36, 1, 277.4, -1808.8, 362.4, -1766.8, 1, 'LS35', 1),
(37, 1, 210.4, -1809.8, 277.4, -1766.8, 1, 'LS36', 1),
(38, 1, 145.4, -1809.8, 212.4, -1766.8, 1, 'LS36', 1),
(39, 1, 143.4, -1893.8, 210.4, -1850.8, 1, 'LS37', 1),
(40, 1, 210.4, -1851.8, 277.4, -1808.8, 1, 'LS38', 1),
(41, 1, 276.4, -1851.8, 72.0001, -1809.8, 1, 'LS39', 1),
(42, 1, 143.4, -1851.8, 210.4, -1808.8, 1, 'LS40', 1),
(43, 1, 210.4, -1893.8, 277.4, -1850.8, 1, 'LS41', 1),
(44, 1, 277.4, -1892.8, 360.4, -1850.8, 1, 'LS42', 1),
(45, 1, 359, -1850.8, 442, -1808.8, 1, 'LS Rest', 1),
(46, 1, 359.4, -1892.8, 442.4, -1850.8, 1, 'LS 43', 1),
(47, 1, 359, -1809.8, 442, -1767.8, 1, 'LS 44', 1),
(48, 1, 98.4001, -1976.8, 214.4, -1892.8, 1, 'LS 45', 1),
(49, 1, 0, -1859.5, 363, -1807.5, 1, 'LS 46', 1);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `GangZones`
--
ALTER TABLE `GangZones`
  ADD PRIMARY KEY (`zoneid`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `GangZones`
--
ALTER TABLE `GangZones`
  MODIFY `zoneid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
