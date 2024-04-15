-- PROCEDURE:
-- given a criminal name, search for the crinimal info
DELIMITER //
CREATE OR REPLACE PROCEDURE search_criminal(ilast VARCHAR(15), ifirst VARCHAR(10))
BEGIN
    SELECT *
    FROM Criminals
    WHERE first_name = ifirst AND last_name = ilast;
END //
DELIMITER ;

-- given a criminal ID, print the criminal info
-- also print all crimes/alias/sentences related to that criminal
DELIMITER //
CREATE OR REPLACE PROCEDURE search_criminal_condition(icriminal_ID DECIMAL(6, 0))
BEGIN
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
END //
DELIMITER ;


-- given a crime ID, print the crime info
-- also print all criminals/officers/appeals/charges related to that crime
DELIMITER //
CREATE OR REPLACE PROCEDURE search_crime_condition(iCrime_ID DECIMAL(9, 0))
BEGIN
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
END //
DELIMITER ;




-- FUNCTION:
-- find the next criminal ID to be inserted
DELIMITER //
CREATE OR REPLACE FUNCTION get_new_criminal_ID() RETURNS DECIMAL(6, 0) DETERMINISTIC
BEGIN
    DECLARE new_id DECIMAL(6, 0);
    SET new_id = (
        SELECT MAX(criminal_ID)
        FROM Criminals
    ) + 1;
    RETURN new_id;
END//
DELIMITER ;


-- find the next crime ID to be inserted
DELIMITER //
CREATE OR REPLACE FUNCTION get_new_crime_ID() RETURNS DECIMAL(9, 0) DETERMINISTIC
BEGIN
    DECLARE new_id DECIMAL(9, 0);
    SET new_id = (
        SELECT MAX(crime_ID)
        FROM Crimes
    ) + 1;
    RETURN new_id;
END//
DELIMITER ;


-- find the next prob ID to be inserted
DELIMITER //
CREATE OR REPLACE FUNCTION get_new_prob_ID() RETURNS DECIMAL(5, 0) DETERMINISTIC
BEGIN
    DECLARE new_id DECIMAL(5, 0);
    SET new_id = (
        SELECT MAX(prob_ID)
        FROM Prob_Officers
    ) + 1;
    RETURN new_id;
END//
DELIMITER ;


-- find the next officer ID to be inserted
DELIMITER //
CREATE OR REPLACE FUNCTION get_new_officer_ID() RETURNS DECIMAL(8, 0) DETERMINISTIC
BEGIN
    DECLARE new_id DECIMAL(8, 0);
    SET new_id = (
        SELECT MAX(Officer_ID)
        FROM Officers
    ) + 1;
    RETURN new_id;
END//
DELIMITER ;


-- find the next sentence ID to be inserted
DELIMITER //
CREATE OR REPLACE FUNCTION get_new_sentence_ID() RETURNS DECIMAL(6, 0) DETERMINISTIC
BEGIN
    DECLARE new_id DECIMAL(6, 0);
    SET new_id = (
        SELECT MAX(Sentence_ID)
        FROM Sentences
    ) + 1;
    RETURN new_id;
END//
DELIMITER ;


-- find the next appeal ID to be inserted
DELIMITER //
CREATE OR REPLACE FUNCTION get_new_appeal_ID() RETURNS DECIMAL(5, 0) DETERMINISTIC
BEGIN
    DECLARE new_id DECIMAL(5, 0);
    SET new_id = (
        SELECT MAX(Appeal_ID)
        FROM Appeals
    ) + 1;
    RETURN new_id;
END//
DELIMITER ;


-- find the next charge ID to be inserted
DELIMITER //
CREATE OR REPLACE FUNCTION get_new_charge_ID() RETURNS DECIMAL(10, 0) DETERMINISTIC
BEGIN
    DECLARE new_id DECIMAL(10, 0);
    SET new_id = (
        SELECT MAX(Charge_ID)
        FROM Crime_Charges
    ) + 1;
    RETURN new_id;
END//
DELIMITER ;