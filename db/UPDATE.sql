-- change criminal v_status
DELIMITER //
CREATE OR REPLACE PROCEDURE change_criminal_v_status(iCriminal_ID DECIMAL(6, 0), iStatus CHAR(1))
BEGIN
    IF (iStatus IN ('N', 'Y')) THEN
        UPDATE Criminals
        SET V_status = iStatus
        WHERE Criminal_ID = iCriminal_ID;
    END IF;
END//
DELIMITER ;


-- change criminal p_status
DELIMITER //
CREATE OR REPLACE PROCEDURE change_criminal_p_status(iCriminal_ID DECIMAL(6, 0), iStatus CHAR(1))
BEGIN
    IF (iStatus IN ('N', 'Y')) THEN
        UPDATE Criminals
        SET P_status = iStatus
        WHERE Criminal_ID = iCriminal_ID;
    END IF;
END//
DELIMITER ;

-- change crime classification
DELIMITER //
CREATE OR REPLACE PROCEDURE change_crime_classification(iCrime_ID DECIMAL(9, 0), iclassification CHAR(1))
BEGIN
    IF (iclassification IN ('F', 'M', 'O', 'U')) THEN
        UPDATE Crimes
        SET Classification = iclassification
        WHERE Crime_ID = iCrime_ID;
    END IF;
END//
DELIMITER ;


-- change crime status
DELIMITER //
CREATE OR REPLACE PROCEDURE change_crime_status(iCrime_ID DECIMAL(9, 0), istatus CHAR(2))
BEGIN
    IF (istatus IN ('CL', 'CA', 'IA')) THEN
        UPDATE Crimes
        SET crime_status = istatus
        WHERE Crime_ID = iCrime_ID;
    END IF;
END//
DELIMITER ;


-- change sentence type
DELIMITER //
CREATE OR REPLACE PROCEDURE change_sentence_type(iSentence_ID DECIMAL(6, 0), iType CHAR(1))
BEGIN
    IF (iType IN ('J', 'H', 'P')) THEN
        UPDATE Sentences
        SET Sentence_type = iType
        WHERE Sentence_ID = iSentence_ID;
    END IF;
END//
DELIMITER ;


-- change prob_officer status
DELIMITER //
CREATE OR REPLACE PROCEDURE change_prob_officer_type(iProb_ID DECIMAL(5, 0), iStatus CHAR(1))
BEGIN
    IF (iStatus IN ('A', 'I')) THEN
        UPDATE Prob_Officers
        SET Prob_status = iStatus
        WHERE Prob_ID = iProb_ID;
    END IF;
END//
DELIMITER ;


-- change crime_charge status
DELIMITER //
CREATE OR REPLACE PROCEDURE change_crime_charge_status(iCharge_ID DECIMAL(10, 0), iStatus CHAR(2))
BEGIN
    IF (iStatus IN ('PD', 'GL', 'NG')) THEN
        UPDATE Crime_Charges
        SET Charge_Status = iStatus
        WHERE Charge_ID = iCharge_ID;
    END IF;
END//
DELIMITER ;


-- change officer status
DELIMITER //
CREATE OR REPLACE PROCEDURE change_officer_status(iOfficer_ID DECIMAL(8, 0), iStatus CHAR(1))
BEGIN
    IF (iStatus IN ('A', 'I')) THEN
        UPDATE Officers
        SET Officer_Status = iStatus
        WHERE Officer_ID = iOfficer_ID;
    END IF;
END//
DELIMITER ;


-- change appeal status
DELIMITER //
CREATE OR REPLACE PROCEDURE change_appeal_status(iAppeal_ID DECIMAL(5, 0), iStatus CHAR(1))
BEGIN
    IF (iStatus IN ('P', 'A', 'D')) THEN
        UPDATE Appeals
        SET Appeal_Status = iStatus
        WHERE Appeal_ID = iAppeal_ID;
    END IF;
END//
DELIMITER ;