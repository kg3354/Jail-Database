-- insert a new criminal
DELIMITER //
CREATE OR REPLACE PROCEDURE new_criminal(
    ilast VARCHAR(15), ifirst VARCHAR(10), istreet VARCHAR(30),
    icity VARCHAR(20), istate CHAR(2), izip CHAR(5), 
    iphone CHAR(10), iv_status CHAR(1), ip_status CHAR(1))
BEGIN
    INSERT INTO Criminals VALUES
    (get_new_criminal_ID(), ilast, ifirst, istreet, icity, istate, 
        izip, iphone, iv_status, ip_status);
END//
DELIMTER ;


-- insert a new crime
DELIMITER //
CREATE OR REPLACE PROCEDURE new_crime(
    icriminal_ID DECIMAL(6,0), 
    iclassification CHAR(1), 
    idate_charged DATE, 
    icrime_status CHAR(2), 
    ihearing_date DATE, 
    iappeal_cut_date DATE)
BEGIN
    IF (icriminal_ID IN (SELECT Criminal_ID FROM Criminals)) THEN
        INSERT INTO Crimes (Crime_ID, Criminal_ID, Classification, Date_Charged, Crime_Status, Hearing_Date, Appeal_Cut_Date)
        VALUES (get_new_crime_ID(), icriminal_ID, iclassification, idate_charged, icrime_status, ihearing_date, iappeal_cut_date);
    END IF;
END //
DELIMITER ;


-- insert a new prob_officer
DELIMITER //
CREATE OR REPLACE PROCEDURE new_prob_officer(
    iLast_name VARCHAR(15),
    iFirst_name VARCHAR(10),
    iStreet VARCHAR(30),
    iCity VARCHAR(20),
    iState_code CHAR(2),
    iZip CHAR(5),
    iPhone CHAR(10),
    iEmail VARCHAR(30),
    iProb_Status CHAR(1))
BEGIN
    INSERT INTO Prob_Officers VALUES
    (get_new_prob_ID(), iProb_ID, iLast_name, iFirst_name, iStreet, 
        iCity, iState_code, iZip, iPhone, iEmail, iProb_Status);
END//
DELIMITER ;


-- insert a new officer
DELIMITER //
CREATE OR REPLACE PROCEDURE new_officer(
    iLast_name VARCHAR(15),
    iFirst_name VARCHAR(10),
    iPrecinct CHAR(4),
    iBadge VARCHAR(14),
    iPhone CHAR(10),
    iOfficer_status CHAR(1))
BEGIN
    INSERT INTO Officers VALUES
    (get_new_officer_ID(), iLast_name, iFirst_name, iPrecinct, iBadge, 
        iPhone, iOfficer_status);
END//
DELIMITER ;


-- insert a new sentence
DELIMITER //
CREATE OR REPLACE PROCEDURE new_sentence(
    iCriminal_ID DECIMAL(6, 0),
    iSentence_type CHAR(1),
    iProb_ID DECIMAL(5, 0),
    iStartDate DATE,
    iEndDate DATE, 
    iViolations DECIMAL(3, 0))
BEGIN
    IF ((iCriminal_ID IN (SELECT criminal_ID FROM Criminals)) AND 
        (iProb_ID IN (SELECT Prob_ID FROM Prob_Officers))) THEN

        INSERT INTO Sentences VALUES
        (get_new_sentence_ID(), iCriminal_ID, iSentence_type, iProb_ID, 
            iStartDate, iEndDate, iViolations);

    END IF;
END//
DELIMITER ;


-- insert a new appeal
DELIMITER //
CREATE OR REPLACE PROCEDURE new_appeal(
    iCrime_ID DECIMAL(9, 0),
    iFiling_date DATE,
    iHearing_date DATE,
    iAppeal_status CHAR(1)
)
BEGIN
    IF (iCrime_ID IN (SELECT Crime_ID FROM Crimes)) THEN

        INSERT INTO Appeals VALUES
        (get_new_appeal_ID(), iCrime_ID, iFiling_date, 
            iHearing_date, iAppeal_status);

    END IF;
END//
DELIMITER ;



-- insert a new crime charge
DELIMITER //
CREATE OR REPLACE PROCEDURE new_charge(
    iCrime_ID DECIMAL(9, 0),
    iCrime_code DECIMAL(3, 0),
    iCharge_status CHAR(2),
    iFine_amount DECIMAL(7, 2),
    iCourt_fee DECIMAL(7, 2),
    iAmount_paid DECIMAL(7, 2),
    iPay_due_date DATE
)
BEGIN
    IF ((iCrime_ID IN (SELECT Crime_ID FROM Crimes)) AND
        (iCrime_code IN (SELECT Crime_Code FROM Crime_Codes))) THEN

        INSERT INTO Crime_Charges VALUES
        (get_new_charge_ID(), iCrime_ID, iCrime_code, iCharge_status, iFine_amount,
            iCourt_fee, iAmount_paid, iPay_due_date);

    END IF;
END//
DELIMITER ;


-- insert a new crime_officer
DELIMITER //
CREATE OR REPLACE PROCEDURE new_crime_offcier(
    iCrime_ID DECIMAL(9, 0),
    iOfficer_ID DECIMAL(8, 0)
)
BEGIN
    IF ((iCrime_ID IN (SELECT Crime_ID FROM Crimes)) AND
        (iOfficer_ID IN (SELECT Officer_ID FROM Officers))) THEN
        
        INSERT INTO Crime_Officers VALUES
        (iCrime_ID, iOfficer_ID);

    END IF;
END//
DELIMITER ;