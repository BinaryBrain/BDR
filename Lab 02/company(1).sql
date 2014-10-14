-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Mar 14 Octobre 2014 à 11:57
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `company`
--

-- --------------------------------------------------------

--
-- Structure de la table `department`
--

CREATE TABLE IF NOT EXISTS `department` (
  `Dname` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Dnumber` int(11) NOT NULL,
  `Mgr_ssn` varchar(9) COLLATE utf8_unicode_ci NOT NULL,
  `Mgr_Start_Date` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`Dnumber`),
  KEY `Mgr_ssn` (`Mgr_ssn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `department`
--

INSERT INTO `department` (`Dname`, `Dnumber`, `Mgr_ssn`, `Mgr_Start_Date`) VALUES
('Headquarters', 1, '888665555', '1981-06-19'),
('Administration', 4, '987654321', '1995-01-01'),
('Research', 5, '333445555', '1988-05-22');

-- --------------------------------------------------------

--
-- Structure de la table `dependent`
--

CREATE TABLE IF NOT EXISTS `dependent` (
  `Essn` char(9) COLLATE utf8_unicode_ci NOT NULL,
  `dependent_name` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `sex` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BDate` date DEFAULT NULL,
  `Relationship` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`Essn`,`dependent_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `dependent`
--

INSERT INTO `dependent` (`Essn`, `dependent_name`, `sex`, `BDate`, `Relationship`) VALUES
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('333445555', 'Alice', 'F', '1986-04-04', 'Daughter'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse');

-- --------------------------------------------------------

--
-- Structure de la table `dept_locations`
--

CREATE TABLE IF NOT EXISTS `dept_locations` (
  `Dnumber` int(11) NOT NULL,
  `Dlocation` int(11) NOT NULL,
  PRIMARY KEY (`Dnumber`,`Dlocation`),
  KEY `Dlocation` (`Dlocation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `dept_locations`
--

INSERT INTO `dept_locations` (`Dnumber`, `Dlocation`) VALUES
(1, 1),
(5, 1),
(4, 2),
(5, 3),
(5, 4);

-- --------------------------------------------------------

--
-- Structure de la table `employee`
--

CREATE TABLE IF NOT EXISTS `employee` (
  `Fname` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `Minit` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Lname` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `Ssn` varchar(9) COLLATE utf8_unicode_ci NOT NULL,
  `BDate` date DEFAULT NULL,
  `Address` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Sex` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Salary` decimal(10,2) DEFAULT NULL,
  `Dno` int(11) NOT NULL DEFAULT '1',
  `Super_Ssn` char(9) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`Ssn`),
  KEY `SuperSsn` (`Super_Ssn`),
  KEY `Dno` (`Dno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `employee`
--

INSERT INTO `employee` (`Fname`, `Minit`, `Lname`, `Ssn`, `BDate`, `Address`, `Sex`, `Salary`, `Dno`, `Super_Ssn`) VALUES
('John', 'B', 'Smith', '123456789', '1965-01-09', '731 Fondren, Houston, TX', 'M', '30000.00', 5, '333445555'),
('Franklin', 'T', 'Wong', '333445555', '1965-12-08', '638 Voss, Houston, TX', 'M', '40000.00', 5, '888665555'),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631 Rice, Houston, TX', 'F', '25000.00', 5, '333445555'),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble, TX', 'M', '38000.00', 5, '333445555'),
('James', 'E', 'Borg', '888665555', '1937-11-10', '450 Stone, Houston TX', 'M', '55000.00', 1, ''),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire, TX', 'F', '43000.00', 4, '888665555'),
('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980 Dallas, Houston TX', 'M', '25000.00', 4, '987654321'),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321 Castle, Spring, TX', 'F', '25000.00', 4, '987654321');

-- --------------------------------------------------------

--
-- Structure de la table `location`
--

CREATE TABLE IF NOT EXISTS `location` (
  `Lnumber` int(11) NOT NULL,
  `Lname` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`Lnumber`,`Lname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `location`
--

INSERT INTO `location` (`Lnumber`, `Lname`) VALUES
(1, 'Houston'),
(2, 'Stafford'),
(3, 'Bellaire'),
(4, 'Sugarland');

-- --------------------------------------------------------

--
-- Structure de la table `project`
--

CREATE TABLE IF NOT EXISTS `project` (
  `Pname` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Pnumber` int(11) NOT NULL,
  `Plocation` int(11) DEFAULT NULL,
  `Dnum` int(11) NOT NULL,
  PRIMARY KEY (`Pnumber`),
  KEY `Plocation` (`Plocation`),
  KEY `Dnum` (`Dnum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `project`
--

INSERT INTO `project` (`Pname`, `Pnumber`, `Plocation`, `Dnum`) VALUES
('ProductX', 1, 3, 5),
('ProductY', 2, 4, 5),
('ProductZ', 3, 1, 5),
('Computerization', 10, 2, 4),
('Reorganization', 20, 1, 1),
('Newbenefits', 30, 2, 4);

-- --------------------------------------------------------

--
-- Structure de la table `works_on`
--

CREATE TABLE IF NOT EXISTS `works_on` (
  `Essn` char(9) COLLATE utf8_unicode_ci NOT NULL,
  `Pno` int(11) NOT NULL,
  `Hours` decimal(3,1) NOT NULL,
  PRIMARY KEY (`Essn`,`Pno`),
  KEY `Pno` (`Pno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `works_on`
--

INSERT INTO `works_on` (`Essn`, `Pno`, `Hours`) VALUES
('123456789', 1, '32.5'),
('123456789', 2, '7.5'),
('333445555', 2, '10.0'),
('333445555', 3, '10.0'),
('333445555', 10, '10.0'),
('333445555', 20, '10.0'),
('453453453', 1, '20.0'),
('453453453', 2, '20.0'),
('666884444', 3, '40.0'),
('888665555', 20, '0.0'),
('987654321', 20, '15.0'),
('987654321', 30, '20.0'),
('987987987', 10, '35.0'),
('987987987', 30, '5.0'),
('999887777', 10, '10.0'),
('999887777', 30, '30.0');

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `department`
--
ALTER TABLE `department`
  ADD CONSTRAINT `department_ibfk_1` FOREIGN KEY (`Mgr_ssn`) REFERENCES `employee` (`Ssn`);

--
-- Contraintes pour la table `dependent`
--
ALTER TABLE `dependent`
  ADD CONSTRAINT `dependent_ibfk_1` FOREIGN KEY (`Essn`) REFERENCES `employee` (`Ssn`);

--
-- Contraintes pour la table `dept_locations`
--
ALTER TABLE `dept_locations`
  ADD CONSTRAINT `dept_locations_ibfk_2` FOREIGN KEY (`Dlocation`) REFERENCES `location` (`Lnumber`),
  ADD CONSTRAINT `dept_locations_ibfk_1` FOREIGN KEY (`Dnumber`) REFERENCES `department` (`Dnumber`);

--
-- Contraintes pour la table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_2` FOREIGN KEY (`Super_Ssn`) REFERENCES `employee` (`Ssn`),
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`Dno`) REFERENCES `department` (`Dnumber`);

--
-- Contraintes pour la table `project`
--
ALTER TABLE `project`
  ADD CONSTRAINT `project_ibfk_2` FOREIGN KEY (`Dnum`) REFERENCES `department` (`Dnumber`),
  ADD CONSTRAINT `project_ibfk_1` FOREIGN KEY (`Plocation`) REFERENCES `location` (`Lnumber`);

--
-- Contraintes pour la table `works_on`
--
ALTER TABLE `works_on`
  ADD CONSTRAINT `works_on_ibfk_2` FOREIGN KEY (`Pno`) REFERENCES `project` (`Pnumber`),
  ADD CONSTRAINT `works_on_ibfk_1` FOREIGN KEY (`Essn`) REFERENCES `employee` (`Ssn`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
