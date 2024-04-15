create table Criminals(
    Criminal_ID DECIMAL(6, 0),
    Last_name VARCHAR(15),
    First_name VARCHAR(10),
    Street VARCHAR(30),
    City VARCHAR(20),
    State_code CHAR(2),
    Zip CHAR(5),
    Phone CHAR(10),
    V_status CHAR(1) DEFAULT 'N',
    P_Status CHAR(1) DEFAULT 'N',
    PRIMARY KEY (Criminal_ID)
);

create table Alias(
    Alias_ID DECIMAL(6, 0),
    Criminal_ID DECIMAL(6, 0) REFERENCES Criminals(Criminal_ID),
    Alias VARCHAR(15),
    PRIMARY KEY (Alias_ID)
);

create table Crimes(
    Crime_ID DECIMAL(9, 0),
    Criminal_ID DECIMAL(6, 0) REFERENCES Criminals(Criminal_ID),
    Classification CHAR(1) DEFAULT 'U',
    Date_charged DATE,
    Crime_status CHAR(2) NOT NULL,
    Hearing_date DATE,
    Appeal_cut_date DATE,

    PRIMARY KEY (Crime_ID),
    CHECK (hearing_date > date_charged)
);

create table Prob_officers(
    Prob_ID DECIMAL(5, 0),
    Last_name VARCHAR(15),
    First_name VARCHAR(10),
    Street VARCHAR(30),
    City VARCHAR(20),
    State_code CHAR(2),
    Zip CHAR(5),
    Phone CHAR(10),
    Email VARCHAR(30),
    Prob_Status CHAR(1) NOT NULL,

    PRIMARY KEY (Prob_ID)
);

create table Sentences(
    Sentence_ID DECIMAL(6, 0),
    Criminal_ID DECIMAL(6, 0) REFERENCES Criminals(Criminal_ID),
    Sentence_type CHAR(1),
    Prob_ID DECIMAL(5, 0) REFERENCES Prob_officers(Prob_ID),
    StartDate DATE,
    EndDate DATE, 
    Violations DECIMAL(3, 0) NOT NULL,

    PRIMARY KEY (Sentence_ID),
    CHECK (EndDate > StartDate)
);


create table Officers(
    Officer_ID DECIMAL(8, 0),
    Last_name VARCHAR(15),
    First_name VARCHAR(10),
    Precinct CHAR(4) NOT NULL,
    Badge VARCHAR(14),
    Phone CHAR(10),
    Officer_status CHAR(1) DEFAULT 'A',

    UNIQUE (Badge),
    PRIMARY KEY (Officer_ID)
);

create table Crime_officers(
    Crime_ID DECIMAL(9, 0) REFERENCES Crimes(Crime_ID),
    Officer_ID DECIMAL(8, 0) REFERENCES Officers(Officer_ID),

    PRIMARY KEY (Crime_ID, Officer_ID)
);



create table Appeals(
    Appeal_ID DECIMAL(5, 0),
    Crime_ID DECIMAL(9, 0) REFERENCES Crimes(Crime_ID),
    Filing_date DATE,
    Hearing_date DATE,
    Appeal_status CHAR(1) DEFAULT 'P',

    PRIMARY KEY (Appeal_ID)
);

create table Crime_code(
    Crime_code DECIMAL(3, 0) NOT NULL,
    Code_description VARCHAR(30) NOT NULL,

    UNIQUE(Code_description),
    PRIMARY KEY (Crime_code)
);

create table Crime_charges(
    Charge_ID DECIMAL(10, 0),
    Crime_ID DECIMAL(9, 0) REFERENCES Crimes(Crime_ID),
    Crime_code DECIMAL(3, 0) REFERENCES Crime_code(Crime_code),
    Charge_status CHAR(2),
    Fine_amount DECIMAL(7, 2),
    Court_fee DECIMAL(7, 2),
    Amount_paid DECIMAL(7, 2),
    Pay_due_date DATE,

    PRIMARY KEY (Charge_ID)
);
