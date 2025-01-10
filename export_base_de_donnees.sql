-- phpMyAdmin SQL Dump
-- version 5.2.1deb1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : jeu. 28 nov. 2024 à 11:36
-- Version du serveur : 10.11.6-MariaDB-0+deb12u1-log
-- Version de PHP : 8.2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `e22200744_db1`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`e22200744sql`@`%` PROCEDURE `act_con` (IN `ID` INT, IN `N` TEXT)   BEGIN
 INSERT INTO T_ACTUALITE_ACT VALUES(NULL,"MODIFICATION DU CONCOURS => cf récapitulatif des concours!",ID,'A',CURDATE(),N);
END$$

CREATE DEFINER=`e22200744sql`@`%` PROCEDURE `act_nomcon` (IN `N1` TEXT, IN `N2` TEXT, IN `ID` INT)   BEGIN
 INSERT INTO T_ACTUALITE_ACT VALUES(NULL,CONCAT_WS(' ',N1,"Attention, changement du nom du concours par ",N2),ID,'A',CURDATE(),"Modification du nom d'un concours");
END$$

CREATE DEFINER=`e22200744sql`@`%` PROCEDURE `change_admin` (IN `ID` INT)   BEGIN
 UPDATE T_CONCOURS_CON SET ADM_idCompteAdmin=1 WHERE ADM_idCompteAdmin=ID;
 DELETE FROM T_ACTUALITE_ACT WHERE ADM_idCompteAdmin=ID;
END$$

CREATE DEFINER=`e22200744sql`@`%` PROCEDURE `ecrire_act` (IN `ID` INT)   BEGIN
 SET @auteur:=id_adm(ID);
 SET @nom:=(SELECT CON_nomConcours FROM T_CONCOURS_CON WHERE CON_idConcours=ID);
 SET @dd:=(SELECT CON_dateDebut FROM T_CONCOURS_CON WHERE CON_idConcours=ID);
 SET @descriptif:=(SELECT CON_description FROM T_CONCOURS_CON WHERE CON_idConcours=ID);
 INSERT INTO T_ACTUALITE_ACT VALUES( NULL,CONCAT_WS(' ',@nom,@dd,@descriptif),@auteur,'A',CURDATE(),CONCAT_WS(' ',"INFO SUR",@nom));
END$$

--
-- Fonctions
--
CREATE DEFINER=`e22200744sql`@`%` FUNCTION `ajout_categorie` (`idcon` INT, `idcat` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
     SET @date=(SELECT CON_dateDebut FROM T_CONCOURS_CON WHERE CON_idConcours=idcon );
     IF @date<CURDATE() THEN RETURN "concours commencé";
     ELSE INSERT INTO T_PARTITIONNEE_PAR VALUES(idcon,idcat);
     RETURN "";
     END IF;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `best_note` (`con` INT, `cat` INT) RETURNS INT(11)  BEGIN
	SET @n:=(SELECT MAX(note(CAN_idCandidature)) FROM T_CANDIDATURE_CAN JOIN T_EVALUE_EVA USING(CAN_idCandidature) WHERE CON_idConcours=con AND CAT_idCategorie=cat);
    RETURN @n;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `best_note2` (`con` INT, `cat` INT) RETURNS INT(11)  BEGIN
    SET @n=(SELECT MAX(note(CAN_idCandidature)) FROM T_CANDIDATURE_CAN JOIN T_EVALUE_EVA USING(CAN_idCandidature) WHERE CON_idConcours=con AND CAT_idCategorie=cat AND CAN_idCandidature NOT IN(SELECT CAN_idCandidature FROM T_CANDIDATURE_CAN JOIN T_EVALUE_EVA USING(CAN_idCandidature) WHERE note(CAN_idCandidature)=best_note(con,cat)));

	RETURN @n;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `best_note3` (`conc` INT, `cat` INT) RETURNS INT(11)  BEGIN
	SET @n:=(SELECT MAX(note(CAN_idCandidature)) FROM T_CANDIDATURE_CAN JOIN T_EVALUE_EVA USING(CAN_idCandidature) WHERE CON_idConcours=conc AND CAT_idCategorie=cat AND CAN_idCandidature NOT IN(SELECT CAN_idCandidature FROM T_CANDIDATURE_CAN JOIN T_EVALUE_EVA USING(CAN_idCandidature) WHERE note(CAN_idCandidature)=best_note(conc,cat)) AND CAN_idCandidature NOT IN(SELECT CAN_idCandidature FROM T_CANDIDATURE_CAN JOIN T_EVALUE_EVA USING(CAN_idCandidature) WHERE note(CAN_idCandidature)=best_note2(conc,cat))) ;
    RETURN @n;
 END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `dernier_compte` () RETURNS INT(11)  BEGIN
	SET @id:=(SELECT MAX(COM_idCompte) FROM T_COMPTE_COM);
    RETURN @id;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `donner_categories` (`id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
SET @cat:=(SELECT GROUP_CONCAT(DISTINCT CAT_nomCategorie SEPARATOR '</br>')
    FROM T_CONCOURS_CON 
    LEFT JOIN T_PARTITIONNEE_PAR USING(CON_idConcours)
    LEFT JOIN T_CATEGORIE_CAT USING(CAT_idCategorie)
     
     WHERE CON_idConcours=id GROUP BY CON_idConcours);
RETURN @cat;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `donner_dates` (`id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
   SET @dates:=(SELECT CONCAT_WS("</br>", ADDDATE(CON_dateDebut,CON_nbJourCandidature),ADDDATE(CON_dateDebut,CON_nbJourPreselection+CON_nbJourCandidature),ADDDATE(CON_dateDebut,CON_nbJourSelection+CON_nbJourPreselection+CON_nbJourCandidature)) FROM T_CONCOURS_CON WHERE CON_idConcours=id );
  RETURN @dates;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `donner_jury` (`id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
SET @jury:=(SELECT GROUP_CONCAT(DISTINCT UPPER(COM_nom),' ',COM_prenom SEPARATOR '</br>') 
    FROM T_CONCOURS_CON 
    LEFT JOIN T_JUGE_JUG USING(CON_idConcours)
    LEFT jOIN T_JURY_JUR USING(JUR_idCompteJury)
    LEFT JOIN T_COMPTE_COM ON T_JURY_JUR.JUR_idCompteJury=T_COMPTE_COM.COM_idCompte 
     WHERE CON_idConcours=id GROUP BY CON_idConcours);
RETURN @jury;

end$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `id_adm` (`ID` INT) RETURNS INT(11)  BEGIN 
 SET @adm=(SELECT ADM_idCompteAdmin FROM T_CONCOURS_CON WHERE CON_idConcours=ID);
 RETURN @adm;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `note` (`candidat` INT) RETURNS INT(11)  BEGIN 

   SET @note:=(SELECT SUM(EVA_note) FROM T_EVALUE_EVA WHERE CAN_idCandidature=candidat);
   RETURN @note;

END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `organisateur` (`id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
	SET @orga:=(SELECT GROUP_CONCAT(COM_nom," ",COM_prenom) FROM T_CONCOURS_CON JOIN T_ADMIN_ADM USING(ADM_idCompteAdmin) JOIN T_COMPTE_COM ON T_ADMIN_ADM.ADM_idCompteAdmin=T_COMPTE_COM.COM_idCompte WHERE CON_idConcours=id); 	RETURN @orga;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `phase_actuelle` (`ID` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
 DECLARE DATE_D DATE;
 DECLARE NB_JC INT;
 DECLARE NB_JP INT;
 DECLARE NB_JS INT;
 DECLARE PHASE TEXT;

 SELECT CON_dateDebut,CON_nbJourCandidature,CON_nbJourPreselection,CON_nbJourSelection INTO DATE_D,NB_JC,NB_JP,NB_JS FROM T_CONCOURS_CON WHERE CON_idConcours=ID;

 IF CURDATE()<=DATE_D THEN RETURN "a venir";
 ELSEIF CURDATE()<=ADDDATE(DATE_D,NB_JC) THEN RETURN "inscriptions";
 ELSEIF CURDATE()<=ADDDATE(DATE_D,NB_JC+NB_JP) THEN RETURN "présélection";
 ELSEIF CURDATE()<=ADDDATE(DATE_D,NB_JC+NB_JP+NB_JS) THEN RETURN "sélection";
 ELSE RETURN "terminé";
 END IF;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `rang` (`note` INT, `con` INT, `cat` INT) RETURNS INT(11)  BEGIN
	
	IF note=best_note(con,cat) THEN RETURN 1;
    ELSEIF note=best_note2(con,cat) THEN RETURN 2;
    ELSEIF note=best_note3(con,cat) THEN RETURN 3;
    ELSE RETURN 0;
    END IF;
END$$

CREATE DEFINER=`e22200744sql`@`%` FUNCTION `role` (`id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE ROLE TEXT;
    DECLARE NBJ INT;
    DECLARE NBA INT;
    SET NBJ=(SELECT COUNT(JUR_idCompteJury) FROM T_JURY_JUR WHERE JUR_idCompteJury = id);
    SET NBA=(SELECT COUNT(ADM_idCompteAdmin) FROM T_ADMIN_ADM WHERE ADM_idCompteAdmin = id);
    
    IF(NBJ!=0) THEN
    SET ROLE = 'J';
    
    ELSEIF(NBA!=0) THEN
     SET ROLE = 'A';
    END IF;
    
    RETURN ROLE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `T_ACTUALITE_ACT`
--

CREATE TABLE `T_ACTUALITE_ACT` (
  `ACT_idActualite` int(11) NOT NULL,
  `ACT_texteActualite` varchar(500) NOT NULL,
  `ADM_idCompteAdmin` int(11) NOT NULL,
  `ACT_etat` char(1) NOT NULL,
  `ACT_date` date NOT NULL,
  `ACT_titre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_ACTUALITE_ACT`
--

INSERT INTO `T_ACTUALITE_ACT` (`ACT_idActualite`, `ACT_texteActualite`, `ADM_idCompteAdmin`, `ACT_etat`, `ACT_date`, `ACT_titre`) VALUES
(1, 'OUVERTURE DE LA PHASE DE CANDIDATURE DU CONCOURS DE PHOTOGRAPHIE ANIMLIERE LE 24 OCTOBRE 2024', 1, 'A', '2024-09-27', 'OUVERTURE CONCOURS'),
(2, 'OUVERTURE DE LA PHASE DE CANDIDATURE DU CONCOURS DE PHOTOGRAPHIE SOUS-MARINE LE 1 OCTOBRE 2024', 2, 'A', '2024-09-27', 'OUVERTURE CONCOURS'),
(3, 'OUVERTURE DE LA PHASE DE CANDIDATURE DU CONCOURS DE PHOTOGRAPHIE ANIMLIERE LE 30 SEPTEMBRE 2024', 1, 'A', '2024-09-27', 'OUVERTURE CONCOURS'),
(9, 'sous marin Attention, changement du nom du concours par  Concours de photographie sous-marine', 2, 'A', '2024-10-23', 'Modification du nom d\'un concours'),
(11, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-10-23', 'Concours de photographie sous-marine'),
(16, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-10-25', 'Concours de photographie de paysage'),
(23, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-04', 'Concours de photographie animalière'),
(24, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-04', 'Concours de photographie sous-marine'),
(25, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-06', 'Concours de photographie sous-marine'),
(26, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-06', 'Concours de photographie animalière'),
(27, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-06', 'Concours de photographie animalière'),
(28, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-06', 'Concours de photographie animalière'),
(29, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-06', 'Concours de photographie animalière'),
(30, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-06', 'Concours de photographie animalière'),
(31, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-06', 'Concours de photographie animalière'),
(32, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-07', 'Concours de photographie animalière'),
(33, 'Concours de fleurs 2024-11-06 Concours de fleurs sauvages ou de celles de votre jardin', 2, 'A', '2024-11-07', 'INFO SUR Concours de fleurs'),
(34, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-07', 'Concours de photographie de paysage'),
(35, 'Concours de nourriture 2024-12-30 Concours de photo des bons petits plats que vous avez cuisinés', 2, 'A', '2024-11-07', 'INFO SUR Concours de nourriture'),
(36, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-07', 'Concours de fleurs'),
(37, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-09', 'Concours de photographie sous-marine'),
(38, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-09', 'Concours de photographie sous-marine'),
(39, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(40, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(41, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(42, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(43, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(44, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de fleurs'),
(45, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de fleurs'),
(46, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de fleurs'),
(47, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de fleurs'),
(48, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(49, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(50, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(51, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(52, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(53, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(54, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-19', 'Concours de nourriture'),
(55, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(56, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(57, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(58, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(59, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(60, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(61, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(62, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(63, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 1, 'A', '2024-11-19', 'Concours de photographie de paysage'),
(64, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-20', 'Concours de fleurs'),
(65, 'nom 0000-00-00 des', 2, 'A', '2024-11-26', 'INFO SUR nom'),
(66, 'nom 0000-00-00 des', 2, 'A', '2024-11-26', 'INFO SUR nom'),
(67, 'testtest 0000-00-00 test', 2, 'A', '2024-11-26', 'INFO SUR testtest'),
(68, 'truc 0000-00-00 2', 2, 'A', '2024-11-26', 'INFO SUR truc'),
(69, 'test 0000-00-00 2', 2, 'A', '2024-11-26', 'INFO SUR test'),
(70, 'autre 0000-00-00 2', 2, 'A', '2024-11-26', 'INFO SUR autre'),
(71, 'autre 0000-00-00 2', 2, 'A', '2024-11-26', 'INFO SUR autre'),
(72, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-26', 'test'),
(73, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-26', 'autre'),
(74, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-26', 'autre'),
(75, 'truc 0000-00-00 1', 2, 'A', '2024-11-26', 'INFO SUR truc'),
(76, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-26', 'truc'),
(77, 'truc 0000-00-00 1', 2, 'A', '2024-11-26', 'INFO SUR truc'),
(78, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-26', 'truc'),
(79, 'truc 0000-00-00 2', 2, 'A', '2024-11-26', 'INFO SUR truc'),
(80, 'truc 0000-00-00 2', 2, 'A', '2024-11-26', 'INFO SUR truc'),
(81, 'test 0000-00-00 2', 2, 'A', '2024-11-27', 'INFO SUR test'),
(82, 't 2024-11-24 2', 2, 'A', '2024-11-28', 'INFO SUR t'),
(83, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-28', 'test'),
(84, 'MODIFICATION DU CONCOURS => cf récapitulatif des concours!', 2, 'A', '2024-11-28', 't'),
(85, 'test 2025-01-24 description\r\n', 2, 'A', '2024-11-28', 'INFO SUR test'),
(86, 't 2024-11-30 2', 2, 'A', '2024-11-28', 'INFO SUR t');

-- --------------------------------------------------------

--
-- Structure de la table `T_ADMIN_ADM`
--

CREATE TABLE `T_ADMIN_ADM` (
  `ADM_idCompteAdmin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_ADMIN_ADM`
--

INSERT INTO `T_ADMIN_ADM` (`ADM_idCompteAdmin`) VALUES
(1),
(2);

--
-- Déclencheurs `T_ADMIN_ADM`
--
DELIMITER $$
CREATE TRIGGER `sup_admin` BEFORE DELETE ON `T_ADMIN_ADM` FOR EACH ROW BEGIN
 CALL change_admin(OLD.ADM_idCompteAdmin);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `T_CANDIDATURE_CAN`
--

CREATE TABLE `T_CANDIDATURE_CAN` (
  `CAN_idCandidature` int(11) NOT NULL,
  `CAN_codeInscription` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `CAN_codeCandidat` char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `CAN_nomCandidat` varchar(100) NOT NULL,
  `CAN_prenomCandidat` varchar(100) NOT NULL,
  `CAN_etat` char(1) NOT NULL,
  `CON_idConcours` int(11) NOT NULL,
  `CAT_idCategorie` int(11) NOT NULL,
  `CAN_statut` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_CANDIDATURE_CAN`
--

INSERT INTO `T_CANDIDATURE_CAN` (`CAN_idCandidature`, `CAN_codeInscription`, `CAN_codeCandidat`, `CAN_nomCandidat`, `CAN_prenomCandidat`, `CAN_etat`, `CON_idConcours`, `CAT_idCategorie`, `CAN_statut`) VALUES
(1, '5cIwlFf6RXNnEEVMciYE', 'Kuk3PZne', 'Messier', 'Sacha', 'A', 1, 1, 'P'),
(2, 'zjIeSrO5M9LszGgmaWHe', 'G+W_#1x^', 'Rouzet', 'William', 'A', 1, 1, 'P'),
(3, 'etoYyzTqDiYVtFw2gaFg', 'OqB_R6Bu', 'Duval', 'Antoine', 'A', 1, 1, 'P'),
(4, '34ZSlZyDIrlcvcULAVlp', 'm#d^QGlo', 'Allaire', 'Raphaël', 'A', 1, 1, 'C'),
(5, 'LlKBaqHtuEneuyvZa6oa', 'Vzb-fiY@', 'Beauvau', 'Dany', 'A', 1, 1, 'C'),
(6, 'xAUCYFy0OpHHcyKSu1J7', 'KKnoRLvo', 'Bessette', 'Lionel', 'A', 1, 2, 'C'),
(7, 'Kv7ePkfO6zIYwu1zwR4O', 'tWK0ze0M', 'Quint', 'Victor', 'A', 1, 2, 'P'),
(8, 'OCqYHzBS75np89Ft7B4q', '#-iSIpOv', 'Gagnon', 'Paulin', 'A', 1, 2, 'P'),
(9, '0xAXPd8aK4wbdn6R6rPy', 'ps!hYQ-&', 'Beauchamp', 'Sylvain', 'A', 1, 2, 'P'),
(10, 'CFvvFLsalCK8W8It2FOV', 'C!DF^5^W', 'D\'Aboville', 'Fabien', 'A', 1, 2, 'C'),
(11, 'TxNPyZcZsFU0vzgHTxci', 'Al_zKYUt', 'Boutroux', 'Zoé', 'A', 1, 3, 'C'),
(12, 'siBXarTjqOSIzgfga4jE', '@T1#1Zw=', 'Delannoy', 'Frédérique', 'A', 1, 3, 'C'),
(13, 'ZXeNupeCPTcTjFLSaoKZ', '3bbFXoh1', 'Boudet', 'Edmée', 'A', 1, 3, 'P'),
(14, 'EPPXO8tnF2DzAekxIUhr', 'Em=g40DG', 'Loupe', 'Florence', 'A', 1, 3, 'P'),
(15, 'cZcQXQN5SEpLgf5N56Vp', 'h6m=@zk-', 'Dubost', 'Fanny', 'A', 1, 3, 'P'),
(16, 'sVrdmEV4tPwRQBCRivR1', 'LSygrNil', 'Trouvé', 'Sylviane', 'A', 2, 2, 'P'),
(17, 'RavjBMt5GGoDm6uziCcW', '=*6xKYTa', 'Aliker', 'Auriane', 'A', 2, 2, 'C'),
(18, 'joXYR4Mlscbwstg10iHW', 'jL@_&o3p', 'Donnet', 'Déborah', 'A', 2, 2, 'P'),
(19, 'VX4kxHVqmGwTHif5bY9K', 'G5+ypJJS', 'Nee', 'Gwendoline', 'A', 2, 2, 'C'),
(20, 'lxJ4qIxEXoWTPoj2BGwi', 'LG+&tL_0', 'Jacquet', 'Maud', 'A', 2, 2, 'P'),
(21, 'pUOKlGxenyRl534hAtfQ', 'Jgkv1$!*', 'Mallet', 'José', 'A', 2, 3, 'C'),
(22, 'iupU6jXrDRQfDpwvjFFS', 'Vf8#POrf', 'Deschanel', 'Isaac', 'A', 2, 3, 'P'),
(23, 'PzfciR0h0pOV6XLl5x2y', '$1ELQ9*$', 'Bruguière', 'Charles', 'A', 2, 3, 'P'),
(24, 'KD26BBpMxYggdRzlW3aE', 'GJ0^nTF7', 'Brosseau', 'Armand', 'A', 2, 3, 'C'),
(25, 'PRfh4IWWvdVwOT20qPBI', 'BZliqnGw', 'Charrier', 'Cédric', 'A', 2, 3, 'P'),
(26, 'zfFwnbeQmOkGvm2bhg62', 'Vrf0O@r=', 'Morin', 'Paulin', 'A', 3, 1, 'P'),
(27, 'erJQhwYdYObGftEhbMDa', '3y8VF#nk', 'Bittencourt', 'Abélard', 'A', 3, 1, 'C'),
(28, 'GehVY8fFRZeaxoTbZmZl', 'ZOtu%HDU', 'Leloup', 'Cédric', 'A', 3, 1, 'P'),
(29, 'R63KTMlCu5Sl3FuYeTZn', 'J*-yo^In', 'Brousseau', 'Alex', 'A', 3, 1, 'P'),
(30, '55ZtAb6e119gMaUmDgbk', 'OmhJA^3i', 'Édouard', 'Maxime', 'A', 3, 1, 'C'),
(31, 'E8txY2Mkc60AJsQIORkH', 'UHJn-ncJ', 'Cordonnier', 'Godeliève', 'A', 3, 2, 'P'),
(32, 'hOHM0106fvAm8yTxauR6', '=-xMeVof', 'Bechard', 'Radegonde', 'A', 3, 2, 'P'),
(33, 'TwdtMMzPnWrFBajgks8u', '40jvJ+*9', 'Chuquet', 'Adèle', 'A', 3, 2, 'P'),
(34, 'uZKDsL2z2oB4y1w58Ax3', '_y1wAf5B', 'Pierrat', 'Manon', 'A', 3, 2, 'C'),
(35, 'RiF17hJYQ1bWbWakclae', 'C47X61Po', 'Charbonnier', 'Abelone', 'A', 3, 2, 'C'),
(36, '4N0je4prMW60O9NzuRDC', 'w3aTmdNg', 'Ponce', 'Viviane', 'A', 3, 3, 'C'),
(37, 'pmrokTUmyDmvsdeVewrZ', 'Bs0aLdpd', 'Serre', 'Roberte', 'A', 3, 3, 'P'),
(38, 'rBjsLC44yOejHXzIoJEZ', 'y9on1!A$', 'Vasseur', 'Linda', 'A', 3, 3, 'P'),
(39, 'l6BUmBclqXSefWW8S2uY', '5bNzFvNa', 'Haillet', 'Éliane', 'A', 3, 3, 'C'),
(40, '1FXRtR7esYAjDckrDpeH', 'gxKIXp11', 'Barbier', 'Christine', 'A', 3, 3, 'P'),
(41, 'loXF1f8WsFDgDsKvBKIo', 'JRRb1aEe', 'Choffard', 'Noël', 'A', 18, 3, 'C'),
(42, '6LJOHxOF4DR41oaRysAq', 'Wb6MF^vA', 'Montgomery', 'Inès', 'A', 18, 2, 'C'),
(43, 'VurKMEDkpfK8ml839iQZ', 'H+CEpym-', 'Saunier', 'Aude', 'A', 18, 2, 'C'),
(44, 'Vjkbn4Qy8dvcztdO7ZKU', 'r69b1yfq', 'Bourdon', 'Julie', 'A', 18, 2, 'C'),
(45, 'u0Uav6UrhozHkmVBP2yP', '$0a8%HMV', 'Beauchamp', 'Frank', 'A', 18, 3, 'C'),
(46, '25h0T09LkhDk6V4MW1KJ', 'RMwg6qcB', 'Coquelin', 'Armel', 'A', 18, 3, 'C');

-- --------------------------------------------------------

--
-- Structure de la table `T_CATEGORIE_CAT`
--

CREATE TABLE `T_CATEGORIE_CAT` (
  `CAT_idCategorie` int(11) NOT NULL,
  `CAT_nomCategorie` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_CATEGORIE_CAT`
--

INSERT INTO `T_CATEGORIE_CAT` (`CAT_idCategorie`, `CAT_nomCategorie`) VALUES
(1, 'enfants'),
(2, 'amateurs'),
(3, 'professionels');

-- --------------------------------------------------------

--
-- Structure de la table `T_COMPTE_COM`
--

CREATE TABLE `T_COMPTE_COM` (
  `COM_idCompte` int(11) NOT NULL,
  `COM_identifiant` varchar(150) NOT NULL,
  `COM_motdepasse` char(64) NOT NULL,
  `COM_etat` char(1) NOT NULL,
  `COM_nom` varchar(60) NOT NULL,
  `COM_prenom` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_COMPTE_COM`
--

INSERT INTO `T_COMPTE_COM` (`COM_idCompte`, `COM_identifiant`, `COM_motdepasse`, `COM_etat`, `COM_nom`, `COM_prenom`) VALUES
(1, 'organisateur@univ-brest.fr', '7e5129f2087097dd7c867b7bfa556bbef60aee6692d26cbeb999baf8f564d540', 'A', 'Marc', '  Valérie'),
(2, 'l.ven@gmail.com', '877fa3445420ae58999d73395f555ca272e67a25d50e567505fcda0034458699', 'A', 'Venot', 'Lisa'),
(3, 'a.villemin@gmail.com', '268fa46d1f9e5c2ee28029e4e41682c40f9d8db51dde3500c6828283236532d5', 'D', 'Villemin', 'Aurélien'),
(4, 'b.campistron@gmail.com', 'e0b84722c59acfe14c4e1028455d7f214db99613dd0290fcf03ceefdbfc15d8d', 'A', 'Campistron', 'Bastien'),
(5, 'm.courdesses@gmail.com', 'a45e243be3d8600131d3dc8e2141fd429e3089dd7e7c2d6e2ed4372fb5f3866f', 'A', 'Courdesses', '  Mathieu'),
(6, 'k.kaziras@gmail.com', 'eec10c44d9d51378bb5bf870b01e8f6bbde0d2bac9900316a34d22d63a6bd154', 'A', 'Kaziras', 'Kyriakas'),
(7, 'g.pol@gmail.com', 'e7b9a6bfe18a7ff5141d85bf5758a43c6469287414c2c6e631b0f50a95a86518', 'A', 'Pol', 'Grégory'),
(8, 'g.barathieu@gmail.com', '46d966ec12a6636ba76be0a9bf9514827ad3873c9c5ed606b977dbae1792d610', 'A', 'Barathieu', 'Gabriel'),
(9, 'd.doubilet@gmail.com', '58361b7432fc1991e4f89297528704b32994d106616896c94be687fca659b62c', 'A', 'Doubilet', 'David'),
(10, 'l.ballesta@gmail.com', 'cffd7e9b86303ae14f08ebabd6bf76c010a2a325dd3f1b1347936c2475bd2572', 'A', 'Ballesta', 'Laurent'),
(11, 'a.adams@gmail.com', '0fcb0553a2755f62c888c10b746cf8b3b1058c0a2575e453c30dd066e8b27a38', 'A', 'Adams', 'Ansel'),
(12, 'y.arthus-bertrand@gmail.com', '781527e8fda182a306a204c475f17480bb0ee0593c46564ec1f2ca8c5d7af6fc', 'A', 'Arthus-Bertrand', 'Yann'),
(13, 'f.fontana@gmail.com', 'c4b047df46feddeab25ce4ef4c4406351def2bd19118421868aaf394e071fd30', 'A', 'Fontana', 'Francos'),
(14, 'a.gursky@gmail.com', '382d0a5df21798352c8600b3846e76687a413bbfeab2597fd378d05800755d5a', 'A', 'Gursky', 'Andreas'),
(28, 'e.moysson@gmail.com', 'b4db18af46cc48ca2031ea477faf231aaabb0f0583ebac05a3dface0959c992f', 'A', 'moysson', 'émilie'),
(29, 'p.nadler@gmail.com', 'c58c25eb48554dbe07ead31eb6b738f1e227794e6938460b97593e31ae7d6e85', 'A', 'nadler', 'pierre'),
(30, 'j.pergolesi@gmail.com', '07d8284364b246f3e5be91d7e179f322cdebad78b066273af4636cc522d8a8ad', 'A', 'pergolesi', 'jerôme'),
(31, 'h.watt@gmail.com', '173452c695ad1a2344ced11aafa04ed8ae8ca77ef7705707d162bf6059c79fa1', 'A', 'watt', 'holly');

--
-- Déclencheurs `T_COMPTE_COM`
--
DELIMITER $$
CREATE TRIGGER `salage1` BEFORE INSERT ON `T_COMPTE_COM` FOR EACH ROW BEGIN
    	SET NEW.COM_motdepasse=SHA2(CONCAT(NEW.COM_motdepasse,"Ceci est mon sel"),256);
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `T_CONCOURS_CON`
--

CREATE TABLE `T_CONCOURS_CON` (
  `CON_idConcours` int(11) NOT NULL,
  `CON_nomConcours` varchar(200) NOT NULL,
  `CON_dateDebut` date NOT NULL,
  `CON_nbJourCandidature` int(11) NOT NULL,
  `CON_nbJourPreselection` int(11) NOT NULL,
  `CON_nbJourSelection` int(11) NOT NULL,
  `CON_edition` varchar(45) NOT NULL,
  `ADM_idCompteAdmin` int(11) DEFAULT NULL,
  `CON_image` varchar(200) DEFAULT NULL,
  `CON_description` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_CONCOURS_CON`
--

INSERT INTO `T_CONCOURS_CON` (`CON_idConcours`, `CON_nomConcours`, `CON_dateDebut`, `CON_nbJourCandidature`, `CON_nbJourPreselection`, `CON_nbJourSelection`, `CON_edition`, `ADM_idCompteAdmin`, `CON_image`, `CON_description`) VALUES
(1, 'Concours de photographie animalière', '2024-08-24', 30, 12, 10, '2024', 1, 'logo_animal.png', 'Concours de photo animalière montrant vos animaux de compagnies, des animaux sauvages pris sur le vif ou encore des animaux du zoo.'),
(2, 'Concours de photographie sous-marine', '2024-10-01', 30, 30, 10, '2024', 2, 'logo_sousmarine.png', 'Concours de photo sous marine montrant de la faune et la flore de ce milieu.'),
(3, 'Concours de photographie de paysage', '2024-10-18', 20, 10, 20, '2024', 1, 'logo_paysage.png', 'Concours de photo de paysage montrant le paysage derriere chez vous ou alors celuui de vos ddernieres vacances'),
(18, 'Concours de fleurs', '2024-11-18', 30, 1, 1, '2024', 2, 'logo_fleur.png', 'Concours de photographie de fleurs sauvages ou de celles de votre jardin'),
(19, 'Concours de nourriture', '2024-12-18', 30, 20, 20, '2025', 2, 'logo_nourriture.png', 'Concours de photo des bons petits plats que vous avez cuisinés');

--
-- Déclencheurs `T_CONCOURS_CON`
--
DELIMITER $$
CREATE TRIGGER `act_newcon` AFTER INSERT ON `T_CONCOURS_CON` FOR EACH ROW BEGIN
 CALL ecrire_act(NEW.CON_idConcours);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `modif_concours` AFTER UPDATE ON `T_CONCOURS_CON` FOR EACH ROW BEGIN
 IF NEW.CON_nomConcours!=OLD.CON_nomConcours THEN CALL act_nomcon(OLD.CON_nomConcours,NEW.CON_nomConcours,NEW.ADM_idCompteAdmin);
 ELSE CALL act_con(NEW.ADM_idCompteAdmin,OLD.CON_nomConcours);
 END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `T_DISCUSSION_DIS`
--

CREATE TABLE `T_DISCUSSION_DIS` (
  `DIS_idDiscussion` int(11) NOT NULL,
  `DIS_titreDiscussion` varchar(200) NOT NULL,
  `CON_idConcours` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_DISCUSSION_DIS`
--

INSERT INTO `T_DISCUSSION_DIS` (`DIS_idDiscussion`, `DIS_titreDiscussion`, `CON_idConcours`) VALUES
(1, 'Discussion a propos du Concours de photographie animalière', 1),
(2, 'Discussion a propos du Concours de photographie sous-marine', 2),
(3, 'Discussion a propos du Concours ade photographie paysager', 3);

-- --------------------------------------------------------

--
-- Structure de la table `T_DOCUMENT_DOC`
--

CREATE TABLE `T_DOCUMENT_DOC` (
  `DOC_idDocument` int(11) NOT NULL,
  `DOC_nomDocument` varchar(100) NOT NULL,
  `CAN_idCandidature` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_DOCUMENT_DOC`
--

INSERT INTO `T_DOCUMENT_DOC` (`DOC_idDocument`, `DOC_nomDocument`, `CAN_idCandidature`) VALUES
(1, 'FB_IMG_1613166922188.webp', 1),
(2, '1728069298892.webp', 2),
(3, '20240807_022038.webp', 3),
(4, '20211211_195720.webp', 4),
(5, '20200720_162504.webp', 5),
(6, 'KU1DURolS-Ozh60Sb7pLfw.webp', 6),
(7, 'hD6tKW0jSu2LNT20I7aLsw.webp', 7),
(8, 'FB_IMG_1649754188735.webp', 8),
(9, 'dIfuGGpQSMC--u6Jl6Oe9A.webp', 9),
(10, '20240620_175547.webp', 10),
(11, 'quJfsSR7QoK6b0adHmj28Q.webp', 11),
(12, 'IMG_20240604_002552_215.webp', 12),
(13, 'i-5vjFtoTgexjTdrLRemtg.webp', 13),
(14, 'dy1cgyqnTlezhNKDxY0qaA.webp', 14),
(15, 'YxcfffkOTMeKxhv3O7e0zg.webp', 15),
(16, 'JzDpOsUqTC-04XDv3hq4OQ.webp', 16),
(17, 'MCnpsGJhSia-0L8kmx4Qcg.webp', 17),
(18, 'J0176soUS9ytWaVu6NI6TA.webp', 18),
(19, 'VTCiHDlpRW-NxUSkj920ew.webp', 19),
(20, '73rN2jWSQ8ef4bCFdjcNCQ.webp', 20),
(21, '3haSVnSZSJmWsMkp1A04SA.webp', 21),
(22, '4-NkfWcORXCKrLYkbpI45A.webp', 22),
(23, '7Ic9YtuKSO6Rm6yaTJ2Cvw.webp', 23),
(24, '64Nz6zXnSom4L6qYVQ9-aw.webp', 24),
(25, 'gDVo8mlKTPmT7b3_7CeVkQ.webp', 25),
(26, '20200205_091326.webp', 26),
(27, '20200205_085018.webp', 27),
(28, '20230817_160302.webp', 28),
(29, '20210225_132340.webp', 29),
(30, 'Snapchat-1402642373.jpg', 30),
(31, '20221024_132350.webp', 31),
(32, '20220909_211618.webp', 32),
(33, '20220830_140254.webp', 33),
(34, '20200205_091313.webp', 34),
(35, '20190807_103911.webp', 35),
(36, 'XzS9qGa8RNiBViHYAshHWQ (1).webp', 36),
(37, '20210210_124928.webp', 37),
(38, 'kUXKpSjrQsKxH3QANlSdzA.webp', 38),
(39, '7DxBu8F4SsCES2iBZe1dvg.webp', 39),
(40, '20210124_124725.webp', 40),
(44, 'pexels-vika-glitter-392079-1619797', 1),
(45, 'pexels-tlhaguney-15571361', 2),
(46, 'pexels-olia-danilevich-5088183', 3),
(47, 'pexels-karolina-grabowska-6256320', 4),
(48, 'pexels-cottonbro-6214727', 5),
(49, 'pexels-thomas-chauke-437438-2838159', 26),
(50, 'pexels-ivan-samkov-9628368', 27),
(51, 'pexels-cottonbro-4710937', 28),
(52, 'pexels-atef-khaled-825144-1731995', 29),
(53, 'pexels-amina-filkins-5561156', 30),
(54, 'pexels-mirco-violent-blur-1271756-4033244', 6),
(55, 'pexels-moose-photos-170195-1587036', 7),
(56, 'pexels-estoymhrb-17048693', 8),
(57, 'pexels-ron-lach-10272672', 9),
(58, 'pexels-luchik-15030875', 10),
(59, 'pexels-estoymhrb-18235009', 21),
(60, 'pexels-estoymhrb-17657259', 22),
(61, 'pexels-emrecanalgul-26755950', 23),
(62, 'pexels-soldiervip-12336982', 24),
(63, 'pexels-yuraforrat-8624308', 25),
(64, 'pexels-khoa-vo-2347168-4025639', 11),
(65, 'pexels-marcel-kodama-862588-2180478', 12),
(66, 'pexels-atccommphoto-1903308', 13),
(67, 'pexels-llucams-1960183', 14),
(68, 'pexels-rachel-claire-4992775', 15),
(69, 'pexels-estoymhrb-18235009', 16),
(70, 'pexels-cottonbro-3584951', 17),
(71, 'pexels-andre-furtado-43594-1264210', 18),
(72, 'pexels-athena-2043595', 19),
(73, 'pexels-george-milton-7014927', 20),
(74, 'pexels-ionelceban-3226185', 31),
(75, 'pexels-majesticaljasmin-5870338', 32),
(76, 'pexels-george-milton-7014881', 33),
(77, 'pexels-roman-odintsov-6585350', 34),
(78, 'pexels-alipazani-2887755', 35),
(79, 'pexels-biasousa-3226441', 36),
(80, 'pexels-eliezer-miranda-318040194-14992970', 37),
(81, 'pexels-ron-lach-9909083', 38),
(82, 'pexels-ekaterina-bolovtsova-5393785', 39),
(83, 'pexels-olly-3812979', 40),
(84, 'pexels-athena-1990211', 41),
(85, 'pexels-yury-kim-181374-667803', 42),
(86, 'pexels-pnw-prod-9218699', 43),
(87, 'pexels-fotios-photos-5593847', 44),
(88, 'pexels-neverlandphotos-4995112', 45),
(89, 'pexels-casia-charlie-1270232-2451040', 46);

-- --------------------------------------------------------

--
-- Structure de la table `T_EVALUE_EVA`
--

CREATE TABLE `T_EVALUE_EVA` (
  `JUR_idCompteJury` int(11) NOT NULL,
  `CAN_idCandidature` int(11) NOT NULL,
  `EVA_note` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_EVALUE_EVA`
--

INSERT INTO `T_EVALUE_EVA` (`JUR_idCompteJury`, `CAN_idCandidature`, `EVA_note`) VALUES
(3, 1, 2),
(3, 2, 1),
(3, 3, 3),
(3, 4, 5),
(3, 5, 4),
(3, 6, 3),
(3, 7, 2),
(3, 8, 4),
(3, 9, 1),
(3, 10, 1),
(3, 11, 4),
(3, 12, 5),
(3, 13, 2),
(3, 14, 1),
(3, 15, 3),
(4, 1, 5),
(4, 2, 4),
(4, 3, 3),
(4, 4, 1),
(4, 5, 1),
(4, 6, 4),
(4, 7, 3),
(4, 8, 1),
(4, 9, 1),
(4, 10, 2),
(4, 11, 4),
(4, 12, 5),
(4, 13, 3),
(4, 14, 1),
(4, 15, 1),
(5, 1, 4),
(5, 2, 1),
(5, 3, 3),
(5, 4, 2),
(5, 5, 1),
(5, 6, 3),
(5, 7, 2),
(5, 8, 1),
(5, 9, 1),
(5, 10, 4),
(5, 11, 2),
(5, 12, 3),
(5, 13, 1),
(5, 14, 5),
(5, 15, 4),
(6, 1, 4),
(6, 2, 2),
(6, 3, 3),
(6, 4, 1),
(6, 5, 1),
(6, 6, 4),
(6, 7, 3),
(6, 8, 5),
(6, 9, 2),
(6, 10, 1),
(6, 11, 4),
(6, 12, 3),
(6, 13, 1),
(6, 14, 2),
(6, 15, 4);

-- --------------------------------------------------------

--
-- Structure de la table `T_JUGE_JUG`
--

CREATE TABLE `T_JUGE_JUG` (
  `JUR_idCompteJury` int(11) NOT NULL,
  `CON_idConcours` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_JUGE_JUG`
--

INSERT INTO `T_JUGE_JUG` (`JUR_idCompteJury`, `CON_idConcours`) VALUES
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 3),
(12, 3),
(13, 3),
(14, 3),
(28, 18),
(29, 18),
(30, 18),
(31, 18);

-- --------------------------------------------------------

--
-- Structure de la table `T_JURY_JUR`
--

CREATE TABLE `T_JURY_JUR` (
  `JUR_idCompteJury` int(11) NOT NULL,
  `JUR_disciplineExperte` varchar(100) DEFAULT NULL,
  `JUR_url` varchar(250) DEFAULT NULL,
  `JUR_biographie` varchar(1000) DEFAULT NULL,
  `JUR_image` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_JURY_JUR`
--

INSERT INTO `T_JURY_JUR` (`JUR_idCompteJury`, `JUR_disciplineExperte`, `JUR_url`, `JUR_biographie`, `JUR_image`) VALUES
(3, 'photographie animalière', 'https://aurelienvilleminphotographe.com/', 'Bonjour\r\nJe m\'appelle Aurélien Villemin, je suis un photographe animalier de 25 ans originaire des Vosges.\r\nJ\'ai découvert la photographie animalière lors du premier confinement même si j\'ai toujours été dans la nature depuis mon enfance.\r\nTout s\'est rapidement accéléré par la suite avec la rencontre de nombreuses espèces emblématiques de la région Grand Est (cerf, chouette, guêpier ..) puis à l\'étranger.\r\nDu côté des études, j\'ai un parcours bien éloigné de la Nature puisque j\'ai un Master en marketing et communication.\r\nAujourd\'hui je suis photographe à plein temps entre stages d\'observations animalières, reportages photos professionnels et mariages.\r\nJ\'apprécie énormément d\'amener le grand public à la découverte de la faune sauvage pour une immersion complète et de nombreuses rencontres animalières.\r\n', 'villemin.jpg'),
(4, 'photographie animalière', 'https://www.bastiencampistron.com/', 'Fasciné par la vie sauvage depuis bien des années, j’ai tout fait pour être le plus souvent au contact de la nature.Aujourd’hui, ma passion est devenue mon métier.Je travaille sur une presqu’île que l’on appelle l’île de Raymond.\r\nJ’en ai la garde afin de la restaurer écologiquement et de suivre ce qui s’y passe.\r\n\r\nIl est important pour moi de tout mettre en œuvre afin de sauvegarder nos écosystèmes.\r\n\r\nQuand je quitte ce bout de terre, l’observation de la nature continue avec cette fois-ci, un compagnon de voyage : mon appareil photo.\r\n\r\n\r\nLoin des hommes en solitaire, je passe des moments merveilleusement intenses dans la nature.\r\n\r\nAujourd’hui, j’ai l’envie de partager chacun des moments vécus avec le plus grand nombre.\r\n\r\nMontrer au monde à quel point la vie sauvage est partout autour de nous, qu’elle est importante pour notre bien-être et qu’il faut la protéger.\r\n\r\nJ’ai l’espoir que mes images donnent envie d’une vie harmonieuse entre humains et le monde sauvage.\r\n', 'campistron.jpg'),
(5, 'photographie animalière', 'https://mathieucourdesses.com/', 'Né le 2 mars 1994, Mathieu Courdesses est un photographe animalier français. Diplômé de l’ESCP Europe, il se spécialise dans la photographie des animaux en voie de disparition.\r\nDu Gorille des montagnes au Rwanda jusqu’à l’Orang outan de Sumatra en passant par le Lion à crinière brune du désert du Kalahari, cet expert de la nature a appris à partager ses connaissances et à sensibiliser son auditoire grâce à son travail de guide en Afrique australe.\r\n\r\n \r\nLa force de ses photos se trouve dans son travail de la lumière et dans ses connaissances aiguisées du monde animalier.\r\nSes photos sont très peu retouchées, la conception de son travail n’est pas de rendre beau mais d’être le témoin d’un évènement naturel, d’une histoire, ou juste d’une lumière.\r\n\r\n', 'courdesses.jpeg'),
(6, 'photographie animalière', 'https://www.kaziras.com/', 'Kyriakos Kaziras est un photographe professionnel franco-grec, spécialiste de la photographie animalière.\r\n\r\nNé en Grèce, ses parents déménagent ensuite à Genève, il y apprend le français. Il étudie ensuite la littérature française à la Sorbonne. À côté, il continue à pratiquer la photographie et achète un moyen-format Praktica d’occasion.\r\n\r\nAprès ses études, il travaille pour une société spécialisée dans la conception de décors pour les vitrines des magasins avant de se lancer comme photographe', 'kaziras.jpg'),
(7, 'photographie sous-marine', 'https://www.gregory-pol-photographie.com/', 'Ex navigateur et plongeur de la Marine Nationale, Grégory Pol est aussi un photographe voyageur sensible.\r\n\r\nDès 12 ans il s\'imaginait rejoindre l\'équipe du commandant Cousteau à bord de la Calypso pour sillonner le monde et ses Océans.\r\n\r\nAujourd’hui, photographe passionné par la nature, il capte la vie des animaux avec justesse et poésie afin d\'aider à leur préservation.\r\n\r\nLes images de Grégory nous ouvrent les portes des espaces préservés et rudes des territoires du bout du monde. En surface elles sont balayées par un vent de noroît qui nous fait frissonner et nous perce de ses cristaux de glace ; sous la surface elles nous entrainent dans le ballet figé d\'un monde du silence... Voyager en images avec Grégory Pol c\'est aller à la découverte des beautés fascinantes de notre planète bleue.\r\n\r\nLe spectacle commence et le rideau se lève avec ce désir de nous donner à voir et à aimer son monde, notre monde...', 'pol.jpg'),
(8, 'photographie sous-marine', 'https://www.underwater-landscape.com/', 'Né le 2 juin 1983, Gabriel Barathieu côtoie l\'océan Atlantique depuis sa plus tendre enfance dans sa maison familiale des Landes, à deux pas des plages.\r\n\r\nPourtant, c\'est en 1999 sur l\'île de la Réunion qu\'il découvre les merveilles du monde marin. Il décidera de s\'y installer en 2009, soit 10 ans après. Dès son retour, Gabriel retrouve les joies de la plongée sous marine et passe son niveau 1 et 2 dans la foulée.Très vite, il ressent le besoin indescriptible de partager en image ces trésors cachés sous l\'eau.', 'barathieu.jpg'),
(9, 'photographie sous-marine', 'https://www.instagram.com/DavidDoubilet/', 'David Doubilet est un pionnier de la photographie sous-marine. Celui dont la première photo a été publié dans le magazine National Geographic en 1972 a dédié sa vie aux océans, saisissant l\'action, le drame ou encore la poésie qui se cachent sous la surface de l\'eau. Ces clichés, il les remonte jusqu\'à la Terre ferme, pour tous ceux qui n\'auront certainement jamais la chance de voir ces merveilles de leurs propres yeux.', 'doubilet.jpg'),
(10, 'photographie sous-marine', 'https://laurentballesta.com/', 'Laurent Ballesta est photographe naturaliste, né à Montpellier en 1974.\r\n\r\nAujourd’hui auteur de 13 livres dédiés à la photographie sous-marine, il est le plus jeune photographe à recevoir le « Plongeur d’Or » au Festival International de l’Image Sous Marine » d’Antibes, et le seul à l’avoir obtenu trois fois. Il a publié des portfolios dans des magazines majeurs de la presse Française et Internationale : 4 sujets inédits dans National Geographic, certains plus de 20 pages et un rendez-vous devenu annuel dans Paris-Match, magazine dans lequel il compte désormais plus de 150 pages, un record pour la photographie sous marine dans un magazine général et populaire. Il publie aussi régulièrement dans Stern, GQ, Le Figaro Magazine, VSD, Science, ÇA m’intéresse, Daily Mail, View, Corriere Magazine, Terres Sauvages, Sciences & Vie, etc.', 'ballesta.jpg'),
(11, 'photographie paysagiste', 'https://www.anseladams.com/', 'Ansel Easton Adams (20 février 1902, San Francisco - 22 avril 1984, Monterey) est un photographe et écologiste américain, connu pour ses photographies en noir et blanc de l\'Ouest américain, notamment dans la Sierra Nevada, et plus particulièrement du parc national de Yosemite. Une de ses plus célèbres photographies s\'intitule Moonrise, Hernandez, Nouveau-Mexique.', 'adams.jpg'),
(12, 'photographie paysagiste', 'https://www.yannarthusbertrand.org/fr/', 'Yann Arthus-Bertrand est né le 13 mars 1946 dans une famille de médaillistes-joailliers, la maison Arthus-Bertrand, fondée au XIXe siècle par Claude Arthus-Bertrand et Michel-Ange Marion.\r\n\r\nEn 1963, âgé de 17 ans, il devient assistant réalisateur puis acteur de cinéma. Il joue entre autres aux côtés de Michèle Morgan dans Dis-moi qui tuer d\'Étienne Périer en 1965 et dans OSS 117 prend des vacances de Pierre Kalfon en 1970.\r\n\r\nEn 1967, il abandonne le cinéma et travaille au parc animalier du château de Saint-Augustin, à Château-sur-Allier2, dans l\'Allier.\r\n\r\nEn 1976, âgé de 30 ans, il part avec son épouse Anne vivre au Kenya dans le parc national Massaï Mara pour étudier le comportement d\'une famille de lions qu\'il photographie chaque jour pendant quelques années.\r\n\r\nParallèlement, il est pilote de montgolfière. C\'est à ce moment qu\'il découvre la terre vue du ciel et qu\'il s\'initie à la photographie aérienne.', 'yann.jpg'),
(13, 'photographie paysagiste', 'https://francofontanaphotographer.com/', 'Franco Fontana est un photographe italien, né le 9 décembre 1933 à Modène1. Il excelle dans la photographie de paysage.\r\n\r\nLes photographies de Fontana ont été utilisées pour illustrer des pochettes d\'albums musicaux de jazz produits par le label ECM.', 'fontana.jpg'),
(14, 'photographie paysagiste', 'https://www.andreasgursky.com/en', 'Andreas Gursky, né le 15 janvier 1955 à Leipzig, est un photographe allemand et professeur à l\'académie publique des beaux-arts de Düsseldorf1.Petit-fils de photographe, Gursky étudie d\'abord la photographie à Essen ; en 1980, il entre à l\'école des beaux-arts de Düsseldorf (Kunstakademie Düsseldorf) et devient l\'élève de Bernd et Hilla Becher2. Sa première œuvre exposée est la photo d\'une cuisinière à gaz allumée (1980; 98 x 71 cm)2. Il est surtout connu pour ses images très grands formats d\'une implacable définition. C\'est un des derniers tenants du réalisme photographique proche des théories de l\'école de Düsseldorf, mais on peut aussi le rapprocher du pop art et d\'Andy Warhol pour le choix de ses thèmes et son goût des séries3.', 'gursky.jpg'),
(28, 'Photographie florale', 'https://www.emiliemoysson.com/', 'Emilie Moysson est née à Libourne en 1977.Diplomée en 2001 en photographie prise de vue de l’école des Gobelins à Paris, c’est aux Studios Daylight qu’elle perfectionne son intérêt pour la lumière auprès de photographes de mode, de portrait et de nature morte comme Eric Traoré, Benny Valsson, Philippe Salomon entre autres.', 'Emilie-moysson.jpg'),
(29, 'Photographie florale', 'https://www.pierrenadler.com/', 'Photographe autodidacte, cela m\'a pris vers l\'âge de 13 ans avec mon Instamatic 104, mon premier appareil photo. J\'ai depuis évolué, aussi bien dans mon matériel photographique que dans ma démarche. J\'aime tout photographier, des petites choses en macro aux gratte-ciels de nos cités modernes.\r\n\r\nMa préférence va vers le noir et blanc mais les couleurs sont parfois la raison d\'être d\'une image.\r\n\r\nJ\'essaie d\'exposer mon travail le plus souvent possible et serais ravi d\'intégrer une galerie mais c\'est très difficile.', 'pierre-nadler.jpg'),
(30, 'Photographie florale', 'http://jpergolesi.com/', 'Jérôme Pergolesi est artiste et poète visuel. Il est né en Franche-Comté en 1973 et vit actuellement à Strasbourg où il se consacre à la création.\r\n\r\nAprès ses études de dessinateur d’exécution en publicité, il a suivi et obtenu une licence en communication multimédia. Il a également été formé durant 3 ans dans un centre de créations numériques.\r\n\r\nIl expose régulièrement ses créations dans les galeries et les foires d’art contemporain. Ses œuvres sont, aujourd’hui, diffusées et vendues en France et à l’international.', 'jerome-pergolesi.jpg'),
(31, 'Photographie florale', 'https://hollywatt.wixsite.com/hollywatt/', 'Artiste de l\'Image Holly Watt est une photographe française. ​ Elle a eu une enfance riche en voyages et en découvertes ce qui l\'a rendue à l\'affut de toutes sortes d\'émotions. Elle découvre la photographie pendant son adolescence et commence à faire ses premières photos en argentique. Avec son appareil en bandoulière, elle effectue plusieurs tours du monde pendant de nombreuses années. D\'une grande curiosité et avec une sensibilité qui lui est propre, Holly aime susciter l’émotion dans notre regard. Attachée à notre planète, elle s\'inspire de ses oeuvres d\'art naturelles. Holly nous invite au voyage avec elle dans son univers.', 'holly-watt.webp');

-- --------------------------------------------------------

--
-- Structure de la table `T_MESSAGE_MES`
--

CREATE TABLE `T_MESSAGE_MES` (
  `MES_idMessage` int(11) NOT NULL,
  `MES_texteMessage` varchar(500) NOT NULL,
  `MES_dateEnvoie` datetime NOT NULL,
  `JUR_idCompteJury` int(11) NOT NULL,
  `DIS_idDiscussion` int(11) NOT NULL,
  `MES_etat` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_MESSAGE_MES`
--

INSERT INTO `T_MESSAGE_MES` (`MES_idMessage`, `MES_texteMessage`, `MES_dateEnvoie`, `JUR_idCompteJury`, `DIS_idDiscussion`, `MES_etat`) VALUES
(1, 'Bonjour', '2024-09-27 12:02:39', 3, 1, 'A'),
(2, 'Bonjour à vous aussi', '2024-09-27 12:02:39', 3, 2, 'A');

-- --------------------------------------------------------

--
-- Structure de la table `T_PARTITIONNEE_PAR`
--

CREATE TABLE `T_PARTITIONNEE_PAR` (
  `CON_idConcours` int(11) NOT NULL,
  `CAT_idCategorie` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `T_PARTITIONNEE_PAR`
--

INSERT INTO `T_PARTITIONNEE_PAR` (`CON_idConcours`, `CAT_idCategorie`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2),
(2, 3),
(3, 1),
(3, 2),
(3, 3),
(18, 1),
(18, 2),
(18, 3);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `T_ACTUALITE_ACT`
--
ALTER TABLE `T_ACTUALITE_ACT`
  ADD PRIMARY KEY (`ACT_idActualite`),
  ADD KEY `fk_act_adm_idx` (`ADM_idCompteAdmin`);

--
-- Index pour la table `T_ADMIN_ADM`
--
ALTER TABLE `T_ADMIN_ADM`
  ADD PRIMARY KEY (`ADM_idCompteAdmin`);

--
-- Index pour la table `T_CANDIDATURE_CAN`
--
ALTER TABLE `T_CANDIDATURE_CAN`
  ADD PRIMARY KEY (`CAN_idCandidature`),
  ADD KEY `fk_can_con_idx` (`CON_idConcours`),
  ADD KEY `fk_can_cat_idx` (`CAT_idCategorie`);

--
-- Index pour la table `T_CATEGORIE_CAT`
--
ALTER TABLE `T_CATEGORIE_CAT`
  ADD PRIMARY KEY (`CAT_idCategorie`);

--
-- Index pour la table `T_COMPTE_COM`
--
ALTER TABLE `T_COMPTE_COM`
  ADD PRIMARY KEY (`COM_idCompte`);

--
-- Index pour la table `T_CONCOURS_CON`
--
ALTER TABLE `T_CONCOURS_CON`
  ADD PRIMARY KEY (`CON_idConcours`),
  ADD KEY `fk_con_adm_idx` (`ADM_idCompteAdmin`);

--
-- Index pour la table `T_DISCUSSION_DIS`
--
ALTER TABLE `T_DISCUSSION_DIS`
  ADD PRIMARY KEY (`DIS_idDiscussion`),
  ADD KEY `CON_idConcours_idx` (`CON_idConcours`);

--
-- Index pour la table `T_DOCUMENT_DOC`
--
ALTER TABLE `T_DOCUMENT_DOC`
  ADD PRIMARY KEY (`DOC_idDocument`),
  ADD KEY `fk_doc_can_idx` (`CAN_idCandidature`);

--
-- Index pour la table `T_EVALUE_EVA`
--
ALTER TABLE `T_EVALUE_EVA`
  ADD PRIMARY KEY (`JUR_idCompteJury`,`CAN_idCandidature`),
  ADD KEY `fk_T_EVALUE_EVA_1_idx` (`CAN_idCandidature`);

--
-- Index pour la table `T_JUGE_JUG`
--
ALTER TABLE `T_JUGE_JUG`
  ADD PRIMARY KEY (`JUR_idCompteJury`,`CON_idConcours`),
  ADD KEY `fk_table1_1_idx` (`CON_idConcours`);

--
-- Index pour la table `T_JURY_JUR`
--
ALTER TABLE `T_JURY_JUR`
  ADD PRIMARY KEY (`JUR_idCompteJury`);

--
-- Index pour la table `T_MESSAGE_MES`
--
ALTER TABLE `T_MESSAGE_MES`
  ADD PRIMARY KEY (`MES_idMessage`),
  ADD KEY `fk_mes_jur_idx` (`JUR_idCompteJury`),
  ADD KEY `fk_mes_dis_idx` (`DIS_idDiscussion`);

--
-- Index pour la table `T_PARTITIONNEE_PAR`
--
ALTER TABLE `T_PARTITIONNEE_PAR`
  ADD PRIMARY KEY (`CON_idConcours`,`CAT_idCategorie`),
  ADD KEY `fk_par_cat_idx` (`CAT_idCategorie`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `T_ACTUALITE_ACT`
--
ALTER TABLE `T_ACTUALITE_ACT`
  MODIFY `ACT_idActualite` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT pour la table `T_CANDIDATURE_CAN`
--
ALTER TABLE `T_CANDIDATURE_CAN`
  MODIFY `CAN_idCandidature` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT pour la table `T_CATEGORIE_CAT`
--
ALTER TABLE `T_CATEGORIE_CAT`
  MODIFY `CAT_idCategorie` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `T_COMPTE_COM`
--
ALTER TABLE `T_COMPTE_COM`
  MODIFY `COM_idCompte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT pour la table `T_CONCOURS_CON`
--
ALTER TABLE `T_CONCOURS_CON`
  MODIFY `CON_idConcours` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT pour la table `T_DISCUSSION_DIS`
--
ALTER TABLE `T_DISCUSSION_DIS`
  MODIFY `DIS_idDiscussion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `T_DOCUMENT_DOC`
--
ALTER TABLE `T_DOCUMENT_DOC`
  MODIFY `DOC_idDocument` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT pour la table `T_MESSAGE_MES`
--
ALTER TABLE `T_MESSAGE_MES`
  MODIFY `MES_idMessage` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `T_ACTUALITE_ACT`
--
ALTER TABLE `T_ACTUALITE_ACT`
  ADD CONSTRAINT `fk_act_adm` FOREIGN KEY (`ADM_idCompteAdmin`) REFERENCES `T_ADMIN_ADM` (`ADM_idCompteAdmin`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_ADMIN_ADM`
--
ALTER TABLE `T_ADMIN_ADM`
  ADD CONSTRAINT `fk_adm_com` FOREIGN KEY (`ADM_idCompteAdmin`) REFERENCES `T_COMPTE_COM` (`COM_idCompte`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_CANDIDATURE_CAN`
--
ALTER TABLE `T_CANDIDATURE_CAN`
  ADD CONSTRAINT `fk_can_cat` FOREIGN KEY (`CAT_idCategorie`) REFERENCES `T_CATEGORIE_CAT` (`CAT_idCategorie`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_can_con` FOREIGN KEY (`CON_idConcours`) REFERENCES `T_CONCOURS_CON` (`CON_idConcours`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_CONCOURS_CON`
--
ALTER TABLE `T_CONCOURS_CON`
  ADD CONSTRAINT `fk_con_adm` FOREIGN KEY (`ADM_idCompteAdmin`) REFERENCES `T_ADMIN_ADM` (`ADM_idCompteAdmin`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_DISCUSSION_DIS`
--
ALTER TABLE `T_DISCUSSION_DIS`
  ADD CONSTRAINT `CON_idConcours` FOREIGN KEY (`CON_idConcours`) REFERENCES `T_CONCOURS_CON` (`CON_idConcours`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_DOCUMENT_DOC`
--
ALTER TABLE `T_DOCUMENT_DOC`
  ADD CONSTRAINT `fk_doc_can` FOREIGN KEY (`CAN_idCandidature`) REFERENCES `T_CANDIDATURE_CAN` (`CAN_idCandidature`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_EVALUE_EVA`
--
ALTER TABLE `T_EVALUE_EVA`
  ADD CONSTRAINT `fk_T_EVALUE_EVA_1` FOREIGN KEY (`CAN_idCandidature`) REFERENCES `T_CANDIDATURE_CAN` (`CAN_idCandidature`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_T_EVALUE_EVA_2` FOREIGN KEY (`JUR_idCompteJury`) REFERENCES `T_JURY_JUR` (`JUR_idCompteJury`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_JUGE_JUG`
--
ALTER TABLE `T_JUGE_JUG`
  ADD CONSTRAINT `fk_table1_1` FOREIGN KEY (`CON_idConcours`) REFERENCES `T_CONCOURS_CON` (`CON_idConcours`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_table1_2` FOREIGN KEY (`JUR_idCompteJury`) REFERENCES `T_JURY_JUR` (`JUR_idCompteJury`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_JURY_JUR`
--
ALTER TABLE `T_JURY_JUR`
  ADD CONSTRAINT `fk_jur_com` FOREIGN KEY (`JUR_idCompteJury`) REFERENCES `T_COMPTE_COM` (`COM_idCompte`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_MESSAGE_MES`
--
ALTER TABLE `T_MESSAGE_MES`
  ADD CONSTRAINT `fk_mes_dis` FOREIGN KEY (`DIS_idDiscussion`) REFERENCES `T_DISCUSSION_DIS` (`DIS_idDiscussion`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_mes_jur` FOREIGN KEY (`JUR_idCompteJury`) REFERENCES `T_JURY_JUR` (`JUR_idCompteJury`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_PARTITIONNEE_PAR`
--
ALTER TABLE `T_PARTITIONNEE_PAR`
  ADD CONSTRAINT `fk_par_cat` FOREIGN KEY (`CAT_idCategorie`) REFERENCES `T_CATEGORIE_CAT` (`CAT_idCategorie`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_par_con` FOREIGN KEY (`CON_idConcours`) REFERENCES `T_CONCOURS_CON` (`CON_idConcours`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
