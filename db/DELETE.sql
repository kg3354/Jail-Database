-- delete appeal
DELIMITER //
CREATE OR REPLACE PROCEDURE delete_appeal(iAppeal_ID DECIMAL(5, 0))
BEGIN
    DELETE FROM Appeals
    WHERE Appeal_ID = iAppeal_ID;
END//
DELIMITER ;


-- delete crime charge
DELIMITER //
CREATE OR REPLACE PROCEDURE delete_crime_charge(iCharge_ID DECIMAL(10, 0))
BEGIN
    DELETE FROM Crime_Charges
    WHERE Charge_ID = iCharge_ID;
END//
DELIMITER ;


-- delete sentence
DELIMITER //
CREATE OR REPLACE PROCEDURE delete_sentence(iSentence_ID DECIMAL(6, 0))
BEGIN
    DELETE FROM Sentences
    WHERE Sentence_ID = iSentence_ID;
END//
DELIMITER ;


-- delete crime_officer pair
DELIMITER //
CREATE OR REPLACE PROCEDURE delete_crime_officer(iCrime_ID DECIMAL(9, 0), 
    iOfficer_ID DECIMAL(8, 0))
BEGIN
    DELETE FROM Crime_Officers
    WHERE Crime_ID = iCrime_ID AND Officer_ID = iOfficer_ID;
END//
DELIMITER ;


-- delete alias
DELIMITER //
CREATE OR REPLACE PROCEDURE delete_alias(iAlias_ID DECIMAL(6, 0))
BEGIN
    DELETE FROM Alias
    WHERE Alias_ID = iAlias_ID;
END//
DELIMITER ;


-- delete prob_officer, with all sentences related to it
DELIMITER //
CREATE OR REPLACE PROCEDURE delete_prob_officer(iProb_ID DECIMAL(5, 0))
BEGIN
    DELETE FROM Prob_Officers
    WHERE Prob_ID = iProb_ID;

    DELETE FROM Sentences
    WHERE Prob_ID = iProb_ID;
END//
DELIMITER ;


-- delete officer, with all crime_officer pairs related to it
DELIMITER //
CREATE OR REPLACE PROCEDURE delete_officer(iOfficer_ID DECIMAL(8, 0))
BEGIN
    DELETE FROM Officers
    WHERE Officer_ID = iOfficer_ID;

    DELETE FROM Crime_officers
    WHERE Officer_ID = iOfficer_ID;
END//
DELIMITER ;


-- delete crime
-- with all crime_offcier pairs/Appeals/crime_charges realted to it
DELIMITER //
CREATE OR REPLACE PROCEDURE delete_crime(iCrime_ID DECIMAL(9, 0))
BEGIN
    DELETE FROM Crimes
    WHERE Crime_ID = iCrime_ID;

    DELETE FROM Crime_Officers
    WHERE Crime_ID = iCrime_ID;

    DELETE FROM Appeals
    WHERE Crime_ID = iCrime_ID;

    DELETE FROM Crime_Charges
    WHERE Crime_ID = iCrime_ID;
END//
DELIMITER ;


-- delete criminal
-- with all alias/crimes/sentences related to it
DELIMITER //
CREATE OR REPLACE PROCEDURE delete_criminal(iCriminal_ID DECIMAL(6, 0))
BEGIN
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
    
END//
DELIMITER ;