-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 08, 2024 at 01:42 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jail`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `change_appeal_status` (`iAppeal_ID` DECIMAL(5,0), `iStatus` CHAR(1))   BEGIN
    IF (iStatus IN ('P', 'A', 'D')) THEN
        UPDATE Appeals
        SET Appeal_Status = iStatus
        WHERE Appeal_ID = iAppeal_ID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_crime_charge_status` (`iCharge_ID` DECIMAL(10,0), `iStatus` CHAR(2))   BEGIN
    IF (iStatus IN ('PD', 'GL', 'NG')) THEN
        UPDATE Crime_Charges
        SET Charge_Status = iStatus
        WHERE Charge_ID = iCharge_ID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_crime_classification` (`iCrime_ID` DECIMAL(9,0), `iclassification` CHAR(1))   BEGIN
    IF (iclassification IN ('F', 'M', 'O', 'U')) THEN
        UPDATE Crimes
        SET Classification = iclassification
        WHERE Crime_ID = iCrime_ID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_crime_status` (`iCrime_ID` DECIMAL(9,0), `istatus` CHAR(2))   BEGIN
    IF (istatus IN ('CL', 'CA', 'IA')) THEN
        UPDATE Crimes
        SET crime_status = istatus
        WHERE Crime_ID = iCrime_ID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_criminal_p_status` (`iCriminal_ID` DECIMAL(6,0), `iStatus` CHAR(1))   BEGIN
    IF (iStatus IN ('N', 'Y')) THEN
        UPDATE Criminals
        SET P_status = iStatus
        WHERE Criminal_ID = iCriminal_ID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_criminal_v_status` (`iCriminal_ID` DECIMAL(6,0), `iStatus` CHAR(1))   BEGIN
    IF (iStatus IN ('N', 'Y')) THEN
        UPDATE Criminals
        SET V_status = iStatus
        WHERE Criminal_ID = iCriminal_ID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_officer_status` (`iOfficer_ID` DECIMAL(8,0), `iStatus` CHAR(1))   BEGIN
    IF (iStatus IN ('A', 'I')) THEN
        UPDATE Officers
        SET Officer_Status = iStatus
        WHERE Officer_ID = iOfficer_ID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_prob_officer_type` (`iProb_ID` DECIMAL(5,0), `iStatus` CHAR(1))   BEGIN
    IF (iStatus IN ('A', 'I')) THEN
        UPDATE Prob_Officers
        SET Prob_status = iStatus
        WHERE Prob_ID = iProb_ID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_sentence_type` (`iSentence_ID` DECIMAL(6,0), `iType` CHAR(1))   BEGIN
    IF (iType IN ('J', 'H', 'P')) THEN
        UPDATE Sentences
        SET Sentence_type = iType
        WHERE Sentence_ID = iSentence_ID;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_alias` (`iAlias_ID` DECIMAL(6,0))   BEGIN
    DELETE FROM Alias
    WHERE Alias_ID = iAlias_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_appeal` (`iAppeal_ID` DECIMAL(5,0))   BEGIN
    DELETE FROM Appeals
    WHERE Appeal_ID = iAppeal_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_crime` (`iCrime_ID` DECIMAL(9,0))   BEGIN
    DELETE FROM Crimes
    WHERE Crime_ID = iCrime_ID;

    DELETE FROM Crime_Officers
    WHERE Crime_ID = iCrime_ID;

    DELETE FROM Appeals
    WHERE Crime_ID = iCrime_ID;

    DELETE FROM Crime_Charges
    WHERE Crime_ID = iCrime_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_crime_charge` (`iCharge_ID` DECIMAL(10,0))   BEGIN
    DELETE FROM Crime_Charges
    WHERE Charge_ID = iCharge_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_crime_officer` (`iCrime_ID` DECIMAL(9,0), `iOfficer_ID` DECIMAL(8,0))   BEGIN
    DELETE FROM Crime_Officers
    WHERE Crime_ID = iCrime_ID AND Officer_ID = iOfficer_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_criminal` (`iCriminal_ID` DECIMAL(6,0))   BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE Current_Crime_ID DECIMAL(9, 0);
    DECLARE Crime_ID_Cur CURSOR FOR (
        SELECT Crime_ID
        FROM Crimes
        WHERE Criminal_ID = iCriminal_ID
    );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DELETE FROM Criminals
    WHERE Criminal_ID = iCriminal_ID;

    DELETE FROM Alias
    WHERE Criminal_ID = iCriminal_ID;

    DELETE FROM Sentences
    WHERE Criminal_ID = iCriminal_ID;

    OPEN Crime_ID_Cur;
    REPEAT
        FETCH Crime_ID_Cur INTO Current_Crime_ID;
        CALL delete_crime(Current_Crime_ID);
    UNTIL done
    END REPEAT;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_officer` (`iOfficer_ID` DECIMAL(8,0))   BEGIN
    DELETE FROM Officers
    WHERE Officer_ID = iOfficer_ID;

    DELETE FROM Crime_officers
    WHERE Officer_ID = iOfficer_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_prob_officer` (`iProb_ID` DECIMAL(5,0))   BEGIN
    DELETE FROM Prob_Officers
    WHERE Prob_ID = iProb_ID;

    DELETE FROM Sentences
    WHERE Prob_ID = iProb_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_sentence` (`iSentence_ID` DECIMAL(6,0))   BEGIN
    DELETE FROM Sentences
    WHERE Sentence_ID = iSentence_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_appeal` (`iCrime_ID` DECIMAL(9,0), `iFiling_date` DATE, `iHearing_date` DATE, `iAppeal_status` CHAR(1))   BEGIN
    IF (iCrime_ID IN (SELECT Crime_ID FROM Crimes)) THEN

        INSERT INTO Appeals VALUES
        (get_new_appeal_ID(), iCrime_ID, iFiling_date, 
            iHearing_date, iAppeal_status);

    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_charge` (`iCrime_ID` DECIMAL(9,0), `iCrime_code` DECIMAL(3,0), `iCharge_status` CHAR(2), `iFine_amount` DECIMAL(7,2), `iCourt_fee` DECIMAL(7,2), `iAmount_paid` DECIMAL(7,2), `iPay_due_date` DATE)   BEGIN
    IF ((iCrime_ID IN (SELECT Crime_ID FROM Crimes)) AND
        (iCrime_code IN (SELECT Crime_Code FROM Crime_Codes))) THEN

        INSERT INTO Crime_Charges VALUES
        (get_new_charge_ID(), iCrime_ID, iCrime_code, iCharge_status, iFine_amount,
            iCourt_fee, iAmount_paid, iPay_due_date);

    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_crime` (`icriminal_ID` DECIMAL(6,0), `iclassification` CHAR(1), `idate_charged` DATE, `icrime_status` CHAR(2), `ihearing_date` DATE, `iappeal_cut_date` DATE)   BEGIN
    IF (icriminal_ID IN (SELECT Criminal_ID FROM Criminals)) THEN
        INSERT INTO Crimes VALUES
        (get_new_crime_ID(), iclassification, idate_charged, 
            icrime_status, ihearing_date, iappeal_cut_date);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_crime_offcier` (`iCrime_ID` DECIMAL(9,0), `iOfficer_ID` DECIMAL(8,0))   BEGIN
    IF ((iCrime_ID IN (SELECT Crime_ID FROM Crimes)) AND
        (iOfficer_ID IN (SELECT Officer_ID FROM Officers))) THEN
        
        INSERT INTO Crime_Officers VALUES
        (iCrime_ID, iOfficer_ID);

    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_criminal` (`ilast` VARCHAR(15), `ifirst` VARCHAR(10), `istreet` VARCHAR(30), `icity` VARCHAR(20), `istate` CHAR(2), `izip` CHAR(5), `iphone` CHAR(10), `iv_status` CHAR(1), `ip_status` CHAR(1))   BEGIN
    INSERT INTO Criminals VALUES
    (get_new_criminal_ID(), ilast, ifirst, istreet, icity, istate, 
        izip, iphone, iv_status, ip_status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_officer` (`iLast_name` VARCHAR(15), `iFirst_name` VARCHAR(10), `iPrecinct` CHAR(4), `iBadge` VARCHAR(14), `iPhone` CHAR(10), `iOfficer_status` CHAR(1))   BEGIN
    INSERT INTO Officers VALUES
    (get_new_officer_ID(), iLast_name, iFirst_name, iPrecinct, iBadge, 
        iPhone, iOfficer_status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_prob_officer` (`iLast_name` VARCHAR(15), `iFirst_name` VARCHAR(10), `iStreet` VARCHAR(30), `iCity` VARCHAR(20), `iState_code` CHAR(2), `iZip` CHAR(5), `iPhone` CHAR(10), `iEmail` VARCHAR(30), `iProb_Status` CHAR(1))   BEGIN
    INSERT INTO Prob_Officers VALUES
    (get_new_prob_ID(), iProb_ID, iLast_name, iFirst_name, iStreet, 
        iCity, iState_code, iZip, iPhone, iEmail, iProb_Status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_sentence` (`iCriminal_ID` DECIMAL(6,0), `iSentence_type` CHAR(1), `iProb_ID` DECIMAL(5,0), `iStartDate` DATE, `iEndDate` DATE, `iViolations` DECIMAL(3,0))   BEGIN
    IF ((iCriminal_ID IN (SELECT criminal_ID FROM Criminals)) AND 
        (iProb_ID IN (SELECT Prob_ID FROM Prob_Officers))) THEN

        INSERT INTO Sentences VALUES
        (get_new_sentence_ID(), iCriminal_ID, iSentence_type, iProb_ID, 
            iStartDate, iEndDate, iViolations);

    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_crime_condition` (`iCrime_ID` DECIMAL(9,0))   BEGIN
    SELECT * 
    FROM Crimes
    WHERE Crime_ID = iCrime_ID;

    SELECT * 
    FROM Criminals
    WHERE Criminal_ID IN (
        SELECT Criminal_ID
        FROM Crimes
        WHERE Crime_ID = iCrime_ID
    );

    SELECT *
    FROM Officers
    WHERE Officer_ID IN (
        SELECT Officer_ID
        FROM Crime_Officers
        WHERE Crime_ID = iCrime_ID
    );

    SELECT *
    FROM Appeals
    WHERE Crime_ID = iCrime_ID;

    SELECT *
    FROM Crime_Charges
    WHERE Crime_ID = iCrime_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_criminal` (`ilast` VARCHAR(15), `ifirst` VARCHAR(10))   BEGIN
    SELECT *
    FROM Criminals
    WHERE first_name = ifirst AND last_name = ilast;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_criminal_condition` (`icriminal_ID` DECIMAL(6,0))   BEGIN
    SELECT *
    FROM Criminals
    WHERE Criminal_ID = icriminal_ID;

    SELECT *
    FROM Crimes
    WHERE criminal_ID = icrimianl_ID;

    SELECT *
    FROM Alias
    WHERE criminal_ID = icriminal_ID;

    SELECT *
    FROM Sentences
    WHERE criminal_ID = icriminal_ID;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_new_appeal_ID` () RETURNS DECIMAL(5,0) DETERMINISTIC BEGIN
    DECLARE new_id DECIMAL(5, 0);
    SET new_id = (
        SELECT MAX(Appeal_ID)
        FROM Appeals
    ) + 1;
    RETURN new_id;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_new_charge_ID` () RETURNS DECIMAL(10,0) DETERMINISTIC BEGIN
    DECLARE new_id DECIMAL(10, 0);
    SET new_id = (
        SELECT MAX(Charge_ID)
        FROM Crime_Charges
    ) + 1;
    RETURN new_id;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_new_crime_ID` () RETURNS DECIMAL(9,0) DETERMINISTIC BEGIN
    DECLARE new_id DECIMAL(9, 0);
    SET new_id = (
        SELECT MAX(crime_ID)
        FROM Crimes
    ) + 1;
    RETURN new_id;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_new_criminal_ID` () RETURNS DECIMAL(6,0) DETERMINISTIC BEGIN
    DECLARE new_id DECIMAL(6, 0);
    SET new_id = (
        SELECT MAX(criminal_ID)
        FROM Criminals
    ) + 1;
    RETURN new_id;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_new_officer_ID` () RETURNS DECIMAL(8,0) DETERMINISTIC BEGIN
    DECLARE new_id DECIMAL(8, 0);
    SET new_id = (
        SELECT MAX(Officer_ID)
        FROM Officers
    ) + 1;
    RETURN new_id;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_new_prob_ID` () RETURNS DECIMAL(5,0) DETERMINISTIC BEGIN
    DECLARE new_id DECIMAL(5, 0);
    SET new_id = (
        SELECT MAX(prob_ID)
        FROM Prob_Officers
    ) + 1;
    RETURN new_id;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_new_sentence_ID` () RETURNS DECIMAL(6,0) DETERMINISTIC BEGIN
    DECLARE new_id DECIMAL(6, 0);
    SET new_id = (
        SELECT MAX(Sentence_ID)
        FROM Sentences
    ) + 1;
    RETURN new_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Alias`
--

CREATE TABLE `Alias` (
  `Alias_ID` decimal(6,0) NOT NULL,
  `Criminal_ID` decimal(6,0) DEFAULT NULL,
  `Alias` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Alias`
--

INSERT INTO `Alias` (`Alias_ID`, `Criminal_ID`, `Alias`) VALUES
(101101, 100001, 'Joe'),
(101102, 100002, 'Jane'),
(101103, 100003, 'Rob'),
(101104, 100004, 'Mike'),
(101105, 100005, 'Mary'),
(101106, 100006, 'Car'),
(101107, 100007, 'Liz'),
(101108, 100008, 'Trash'),
(101109, 100009, 'Animal'),
(101110, 100010, 'Jose');

-- --------------------------------------------------------

--
-- Table structure for table `Appeals`
--

CREATE TABLE `Appeals` (
  `Appeal_ID` decimal(5,0) NOT NULL,
  `Crime_ID` decimal(9,0) DEFAULT NULL,
  `Filing_date` date DEFAULT NULL,
  `Hearing_date` date DEFAULT NULL,
  `Appeal_status` char(1) DEFAULT 'P'
) ;

--
-- Dumping data for table `Appeals`
--

INSERT INTO `Appeals` (`Appeal_ID`, `Crime_ID`, `Filing_date`, `Hearing_date`, `Appeal_status`) VALUES
(70000, 123340001, '2023-05-01', '2023-06-01', 'P'),
(70001, 123340001, '2023-05-02', '2023-06-02', 'P'),
(70002, 123340001, '2023-06-01', '2023-07-01', 'P'),
(70003, 123340001, '2023-07-01', '2023-08-01', 'P'),
(70004, 123340001, '2023-08-01', '2023-09-01', 'P'),
(70005, 123340001, '2023-08-11', '2023-09-11', 'P'),
(70006, 123340001, '2023-09-01', '2023-10-01', 'P'),
(70007, 123340001, '2023-10-01', '2023-11-01', 'P'),
(70008, 123340001, '2024-01-01', '2024-02-01', 'P'),
(70009, 123340001, '2024-02-01', '2024-03-01', 'P'),
(70010, 123340001, '2024-03-01', '2024-04-01', 'P');

-- --------------------------------------------------------

--
-- Table structure for table `Crimes`
--

CREATE TABLE `Crimes` (
  `Crime_ID` decimal(9,0) NOT NULL,
  `Criminal_ID` decimal(6,0) DEFAULT NULL,
  `Classification` char(1) DEFAULT 'U',
  `Date_charged` date DEFAULT NULL,
  `Crime_status` char(2) NOT NULL,
  `Hearing_date` date DEFAULT NULL,
  `Appeal_cut_date` date DEFAULT NULL
) ;

--
-- Dumping data for table `Crimes`
--

INSERT INTO `Crimes` (`Crime_ID`, `Criminal_ID`, `Classification`, `Date_charged`, `Crime_status`, `Hearing_date`, `Appeal_cut_date`) VALUES
(123340001, 100001, 'U', '2022-01-10', 'CA', '2022-02-15', '2023-03-05'),
(123340002, 100002, 'F', '2022-02-15', 'CL', '2022-03-18', '2023-04-04'),
(123340003, 100003, 'M', '2022-03-21', 'IA', '2022-04-20', '2023-05-16'),
(123340004, 100004, 'U', '2023-04-16', 'CL', '2023-05-22', '2023-06-17'),
(123340005, 100005, 'F', '2023-05-18', 'CA', '2023-06-24', '2023-07-29'),
(123340006, 100006, 'M', '2023-06-20', 'CL', '2023-07-30', '2023-08-10'),
(123340007, 100007, 'U', '2023-07-22', 'IA', '2023-08-28', '2023-09-12'),
(123340008, 100008, 'F', '2023-08-24', 'CL', '2023-09-30', '2023-10-15'),
(123340009, 100009, 'M', '2023-09-26', 'CA', '2023-11-02', '2023-11-17'),
(123340010, 100010, 'U', '2023-10-28', 'CL', '2024-01-05', '2024-04-01');

-- --------------------------------------------------------

--
-- Table structure for table `Crime_charges`
--

CREATE TABLE `Crime_charges` (
  `Charge_ID` decimal(10,0) NOT NULL,
  `Crime_ID` decimal(9,0) DEFAULT NULL,
  `Crime_code` decimal(3,0) DEFAULT NULL,
  `Charge_status` char(2) DEFAULT NULL,
  `Fine_amount` decimal(7,2) DEFAULT NULL,
  `Court_fee` decimal(7,2) DEFAULT NULL,
  `Amount_paid` decimal(7,2) DEFAULT NULL,
  `Pay_due_date` date DEFAULT NULL
) ;

--
-- Dumping data for table `Crime_charges`
--

INSERT INTO `Crime_charges` (`Charge_ID`, `Crime_ID`, `Crime_code`, `Charge_status`, `Fine_amount`, `Court_fee`, `Amount_paid`, `Pay_due_date`) VALUES
(1243000000, 100001, 701, 'PD', 2000.00, 200.00, 2200.00, '2024-01-01'),
(1243000001, 100002, 702, 'GL', 100.00, 20.00, 120.00, '2024-02-01'),
(1243000002, 100003, 703, 'GL', 100.00, 20.00, 120.00, '2024-03-01'),
(1243000003, 100004, 704, 'PD', 2000.00, 200.00, 2200.00, '2024-04-01'),
(1243000004, 100005, 705, 'NG', 4000.00, 400.00, 4400.00, '2024-05-01'),
(1243000005, 100006, 706, 'NG', 5000.00, 500.00, 5500.00, '2024-06-01'),
(1243000006, 100007, 707, 'PD', 2500.00, 200.00, 270.00, '2024-07-01'),
(1243000007, 100008, 708, 'PD', 400.00, 20.00, 420.00, '2024-08-01'),
(1243000008, 100009, 709, 'NG', 1000.00, 100.00, 1100.00, '2024-09-01'),
(1243000009, 100010, 710, 'GL', 1000.00, 100.00, 1100.00, '2025-02-01');

-- --------------------------------------------------------

--
-- Table structure for table `Crime_codes`
--

CREATE TABLE `Crime_codes` (
  `Crime_code` decimal(3,0) NOT NULL,
  `Code_description` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Crime_codes`
--

INSERT INTO `Crime_codes` (`Crime_code`, `Code_description`) VALUES
(703, 'Cyber security attack'),
(706, 'Cyberbullying'),
(702, 'Harassment'),
(707, 'Kidnapping'),
(708, 'Murder'),
(704, 'Noise issue'),
(709, 'Rape'),
(701, 'Robery'),
(705, 'Speeding'),
(710, 'Stalking');

-- --------------------------------------------------------

--
-- Table structure for table `Crime_officers`
--

CREATE TABLE `Crime_officers` (
  `Crime_ID` decimal(9,0) NOT NULL,
  `Officer_ID` decimal(8,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Crime_officers`
--

INSERT INTO `Crime_officers` (`Crime_ID`, `Officer_ID`) VALUES
(123340001, 90000001),
(123340002, 90000001),
(123340003, 90000002),
(123340004, 90000003),
(123340005, 90000007),
(123340006, 90000005),
(123340007, 90000001),
(123340007, 90000002),
(123340007, 90000003),
(123340007, 90000004);

-- --------------------------------------------------------

--
-- Table structure for table `Criminals`
--

CREATE TABLE `Criminals` (
  `Criminal_ID` decimal(6,0) NOT NULL,
  `Last_name` varchar(15) DEFAULT NULL,
  `First_name` varchar(10) DEFAULT NULL,
  `Street` varchar(30) DEFAULT NULL,
  `City` varchar(20) DEFAULT NULL,
  `State_code` char(2) DEFAULT NULL,
  `Zip` char(5) DEFAULT NULL,
  `Phone` char(10) DEFAULT NULL,
  `V_status` char(1) DEFAULT 'N',
  `P_Status` char(1) DEFAULT 'N'
) ;

--
-- Dumping data for table `Criminals`
--

INSERT INTO `Criminals` (`Criminal_ID`, `Last_name`, `First_name`, `Street`, `City`, `State_code`, `Zip`, `Phone`, `V_status`, `P_Status`) VALUES
(100001, 'Smith', 'John', '370 Jay Street', 'Brooklyn', 'NY', '11201', '3228545898', 'N', 'N'),
(100002, 'Johnson', 'Jane', '1134 Hillside Drive', 'Queens', 'NY', '11701', '1115674986', 'Y', 'N'),
(100003, 'Williams', 'Robert', '444 Maple Tree St', 'Columbus', 'OH', '43210', '1245554209', 'N', 'Y'),
(100004, 'Brown', 'Michael', '7842 Old Wine Dr', 'Columbus', 'OH', '43201', '3305248078', 'N', 'N'),
(100005, 'Jones', 'Mary', '89 Gold St', 'Cleveland', 'OH', '44236', '4125789890', 'Y', 'N'),
(100006, 'Garcia', 'Carlos', '6 Metro Tech', 'Lakewood', 'NM', '87001', '1157839455', 'N', 'N'),
(100007, 'Miller', 'Elizabeth', '789 wooded view St', 'Denver', 'CO', '98001', '4432112344', 'N', 'Y'),
(100008, 'Frank', 'Qin', '890 Spring St', 'Cleveland', 'OH', '44230', '9897864167', 'Y', 'N'),
(100009, 'Haoyu', 'Xie', '5 Metro', 'Brooklyn', 'NY', '11201', '9098987877', 'N', 'N'),
(100010, 'Dee', 'Joseph', '124 Canel St', 'Brookside', 'NV', '89005', '1859684567', 'Y', 'Y');

-- --------------------------------------------------------

--
-- Table structure for table `Officers`
--

CREATE TABLE `Officers` (
  `Officer_ID` decimal(8,0) NOT NULL,
  `Last_name` varchar(15) DEFAULT NULL,
  `First_name` varchar(10) DEFAULT NULL,
  `Precinct` char(4) NOT NULL,
  `Badge` varchar(14) DEFAULT NULL,
  `Phone` char(10) DEFAULT NULL,
  `Officer_status` char(1) DEFAULT 'A'
) ;

--
-- Dumping data for table `Officers`
--

INSERT INTO `Officers` (`Officer_ID`, `Last_name`, `First_name`, `Precinct`, `Badge`, `Phone`, `Officer_status`) VALUES
(90000001, 'Andrews', 'Bronte', '101', '404001', '3300123456', 'A'),
(90000002, 'Vaughn', 'Abdullah', '101', '404002', '4756477898', 'A'),
(90000003, 'Parker', 'Jesse', '116', '404003', '4446667654', 'A'),
(90000004, 'Solis', 'Bartosz', '54', '404004', '8987876789', 'A'),
(90000005, 'Mayer', 'Gary', '101', '404005', '1409087463', 'A'),
(90000006, 'Mcdonald', 'Penelope', '101', '404006', '3332216754', 'A'),
(90000007, 'Villanueva', 'Peter', '51', '404007', '6657894532', 'A'),
(90000008, 'Mcdaniel', 'Jada', '105', '404008', '1102234578', 'A'),
(90000009, 'Hubbard', 'Madiha', '121', '404009', '9098987890', 'A'),
(90000010, 'Moss', 'Alison', '101', '404010', '1244432211', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `Prob_officers`
--

CREATE TABLE `Prob_officers` (
  `Prob_ID` decimal(5,0) NOT NULL,
  `Last_name` varchar(15) DEFAULT NULL,
  `First_name` varchar(10) DEFAULT NULL,
  `Street` varchar(30) DEFAULT NULL,
  `City` varchar(20) DEFAULT NULL,
  `State_code` char(2) DEFAULT NULL,
  `Zip` char(5) DEFAULT NULL,
  `Phone` char(10) DEFAULT NULL,
  `Email` varchar(30) DEFAULT NULL,
  `Prob_Status` char(1) NOT NULL
) ;

--
-- Dumping data for table `Prob_officers`
--

INSERT INTO `Prob_officers` (`Prob_ID`, `Last_name`, `First_name`, `Street`, `City`, `State_code`, `Zip`, `Phone`, `Email`, `Prob_Status`) VALUES
(20001, 'Lee', 'Kathleen', '123 Justice Rd', 'Fairview', 'CA', '90001', '3235550123', 'klee@gmail.com', 'A'),
(20002, 'Lau', 'Andy', '456 Law Ln', 'Liberty', 'TX', '75002', '2145550124', 'alau@gmail.com', 'A'),
(20003, 'Fisher', 'Nancy', '789 Order St', 'Justice', 'FL', '33102', '3055550125', 'nfisher@gmail.com', 'A'),
(20004, 'Gray', 'Gavin', '101 Patrol Pl', 'Civic', 'NY', '10002', '2125550126', 'ggray@gmail.com', 'I'),
(20005, 'Evans', 'Tim', '202 Guard Gt', 'Lawton', 'CO', '80015', '3035550127', 'tevans@gmail.com', 'A'),
(20006, 'Schnabel', 'Thomas', '303 Shield Sh', 'Peaceful', 'NV', '89102', '7025550128', 'tschnabel@gmail.com', 'A'),
(20007, 'Guo', 'Kai', '404 Badge Blvd', 'Safetown', 'AZ', '85002', '6025550129', 'kguocom', 'A'),
(20008, 'Chow', 'Mia', '505 Cop Ct', 'Secure', 'MI', '48002', '3135550130', 'mchow@gmail.com', 'A'),
(20009, 'Nguyen', 'Nick', '505 Cop Ct', 'Secure', 'MI', '48002', '3135550130', 'nnguyen@gmail.com', 'I'),
(20010, 'Lopez', 'Diego', '505 Cop Ct', 'Secure', 'MI', '48002', '3135550130', 'dlopez@gmail.com', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `Sentences`
--

CREATE TABLE `Sentences` (
  `Sentence_ID` decimal(6,0) NOT NULL,
  `Criminal_ID` decimal(6,0) DEFAULT NULL,
  `Sentence_type` char(1) DEFAULT NULL,
  `Prob_ID` decimal(5,0) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Violations` decimal(3,0) NOT NULL
) ;

--
-- Dumping data for table `Sentences`
--

INSERT INTO `Sentences` (`Sentence_ID`, `Criminal_ID`, `Sentence_type`, `Prob_ID`, `StartDate`, `EndDate`, `Violations`) VALUES
(300001, 100001, 'P', 20001, '2023-05-01', '2024-04-01', 1),
(300002, 100003, 'J', 20002, '2023-05-01', '2023-11-01', 1),
(300003, 100010, 'P', 20003, '2023-06-01', '2024-06-01', 1),
(300004, 100001, 'J', 20004, '2023-06-01', '2023-09-01', 2),
(300005, 100001, 'P', 20005, '2023-08-01', '2024-08-01', 1),
(300006, 100001, 'J', 20006, '2023-09-01', '2023-12-01', 1),
(300007, 100002, 'P', 20007, '2023-10-01', '2024-10-01', 2),
(300008, 100008, 'J', 20008, '2023-11-01', '2024-01-01', 1),
(300009, 100004, 'P', 20009, '2023-12-01', '2024-12-01', 1),
(300010, 100001, 'J', 20010, '2024-01-01', '2024-03-01', 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Alias`
--
ALTER TABLE `Alias`
  ADD PRIMARY KEY (`Alias_ID`);

--
-- Indexes for table `Appeals`
--
ALTER TABLE `Appeals`
  ADD PRIMARY KEY (`Appeal_ID`);

--
-- Indexes for table `Crimes`
--
ALTER TABLE `Crimes`
  ADD PRIMARY KEY (`Crime_ID`);

--
-- Indexes for table `Crime_charges`
--
ALTER TABLE `Crime_charges`
  ADD PRIMARY KEY (`Charge_ID`);

--
-- Indexes for table `Crime_codes`
--
ALTER TABLE `Crime_codes`
  ADD PRIMARY KEY (`Crime_code`),
  ADD UNIQUE KEY `Code_description` (`Code_description`);

--
-- Indexes for table `Crime_officers`
--
ALTER TABLE `Crime_officers`
  ADD PRIMARY KEY (`Crime_ID`,`Officer_ID`);

--
-- Indexes for table `Criminals`
--
ALTER TABLE `Criminals`
  ADD PRIMARY KEY (`Criminal_ID`);

--
-- Indexes for table `Officers`
--
ALTER TABLE `Officers`
  ADD PRIMARY KEY (`Officer_ID`),
  ADD UNIQUE KEY `Badge` (`Badge`);

--
-- Indexes for table `Prob_officers`
--
ALTER TABLE `Prob_officers`
  ADD PRIMARY KEY (`Prob_ID`);

--
-- Indexes for table `Sentences`
--
ALTER TABLE `Sentences`
  ADD PRIMARY KEY (`Sentence_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
