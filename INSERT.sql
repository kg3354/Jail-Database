INSERT INTO Criminals (Criminal_ID, Last_name, First_name, Street, City, State_code, Zip, Phone, V_status, P_Status) VALUES
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

INSERT INTO Alias (Alias_ID, Criminal_ID, Alias) VALUES
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

INSERT INTO CRIMES (Crime_ID, Criminal_ID, Classification, Date_charged, Crime_status, Hearing_date, Appeal_cut_date) VALUES
(123340001, 100001, 'U', '2022-01-10', 'OP', '2022-02-15', '2023-03-05'),
(123340002, 100002, 'F', '2022-02-15', 'CL', '2022-03-18', '2023-04-04'),
(123340003, 100003, 'M', '2022-03-21', 'OP', '2022-04-20', '2023-05-16'),
(123340004, 100004, 'U', '2023-04-16', 'CL', '2023-05-22', '2023-06-17'),
(123340005, 100005, 'F', '2023-05-18', 'OP', '2023-06-24', '2023-07-29'),
(123340006, 100006, 'M', '2023-06-20', 'CL', '2023-07-30', '2023-08-10'),
(123340007, 100007, 'U', '2023-07-22', 'OP', '2023-08-28', '2023-09-12'),
(123340008, 100008, 'F', '2023-08-24', 'CL', '2023-09-30', '2023-10-15'),
(123340009, 100009, 'M', '2023-09-26', 'OP', '2023-11-02', '2023-11-17'),
(123340010, 100010, 'U', '2023-10-28', 'CL', '2024-01-05', '2024-04-01');

INSERT INTO Prob_officers (Prob_ID, Last_name, First_name, Street, City, State_code, Zip, Phone, Email, Prob_Status) VALUES
(20001, 'Lee', 'Kathleen', '123 Justice Rd', 'Fairview', 'CA', '90001', '3235550123', 'klee@gmail.com', 'A'),
(20002, 'Lau', 'Andy', '456 Law Ln', 'Liberty', 'TX', '75002', '2145550124', 'alau@gmail.com', 'A'),
(20003, 'Fisher', 'Nancy', '789 Order St', 'Justice', 'FL', '33102', '3055550125', 'nfisher@gmail.com', 'A'),
(20004, 'Gray', 'Gavin', '101 Patrol Pl', 'Civic', 'NY', '10002', '2125550126', 'ggray@gmail.com', 'A'),
(20005, 'Evans', 'Tim', '202 Guard Gt', 'Lawton', 'CO', '80015', '3035550127', 'tevans@gmail.com', 'A'),
(20006, 'Schnabel', 'Thomas', '303 Shield Sh', 'Peaceful', 'NV', '89102', '7025550128', 'tschnabel@gmail.com', 'A'),
(20007, 'Guo', 'Kai', '404 Badge Blvd', 'Safetown', 'AZ', '85002', '6025550129', 'kguocom', 'A'),
(20008, 'Chow', 'Mia', '505 Cop Ct', 'Secure', 'MI', '48002', '3135550130', 'mchow@gmail.com', 'A'),
(20009, 'Nguyen', 'Nick', '505 Cop Ct', 'Secure', 'MI', '48002', '3135550130', 'nnguyen@gmail.com', 'A'),
(20010, 'Lopez', 'Diego', '505 Cop Ct', 'Secure', 'MI', '48002', '3135550130', 'dlopez@gmail.com', 'A');

INSERT INTO Sentences (Sentence_ID, Criminal_ID, Sentence_type, Prob_ID, StartDate, EndDate, Violations) VALUES
(300001, 100001, 'P', 20001, '2023-05-01', '2024-04-01', 0),
(300002, 100003, 'J', 20002, '2023-05-01', '2023-11-01', 1),
(300003, 100010, 'P', 20003, '2023-06-01', '2024-06-01', 0),
(300004, 100001, 'J', 20004, '2023-06-01', '2023-09-01', 2),
(300005, 100001, 'P', 20005, '2023-08-01', '2024-08-01', 1),
(300006, 100001, 'J', 20006, '2023-09-01', '2023-12-01', 0),
(300007, 100002, 'P', 20007, '2023-10-01', '2024-10-01', 2),
(300008, 100008, 'J', 20008, '2023-11-01', '2024-01-01', 1),
(300009, 100004, 'P', 20009, '2023-12-01', '2024-12-01', 0),
(300010, 100001, 'J', 20010, '2024-01-01', '2024-03-01', 3);


INSERT INTo Officers (Officer_ID, Last_name, First_name, Precinct, Badge, Phone, Officer_status) VALUES
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



INSERT INTO Crime_officers(Crime_ID, Officer_ID) VALUES
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


INSERT INTO Crime_code(Crime_code, Code_description) VALUES
(701, 'Robery'),
(702, 'Harassment'),
(703, 'Cyber security attack'),
(704, 'Noise issue'),
(705, 'Speeding'),
(706, 'Cyberbullying'),
(707, 'Kidnapping'),
(708, 'Murder'),
(709, 'Rape'),
(710, 'Stalking');




INSERT INTO Appeals (Appeal_ID, Crime_ID, Filing_date, Hearing_date, Appeal_status) VALUES
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



INSERT INTO Crime_charges(Charge_ID, Crime_ID, Crime_code, Charge_status, Fine_amount, Court_fee, Amount_paid, Pay_due_date) VALUES
(1243000000, 100001, 701, 'Y', 2000, 200, 2200, '2024-01-01'),
(1243000001, 100002, 702, 'Y', 100, 20, 120, '2024-02-01'),
(1243000002, 100003, 703, 'Y', 100, 20, 120, '2024-03-01'),
(1243000003, 100004, 704, 'Y', 2000, 200, 2200, '2024-04-01'),
(1243000004, 100005, 705, 'Y', 4000, 400, 4400, '2024-05-01'),
(1243000005, 100006, 706, 'Y', 5000, 500, 5500, '2024-06-01'),
(1243000006, 100007, 707, 'Y', 2500, 200, 270, '2024-07-01'),
(1243000007, 100008, 708, 'Y', 400, 20, 420, '2024-08-01'),
(1243000008, 100009, 709, 'Y', 1000, 100, 1100, '2024-9-01'),
(1243000009, 100010, 710, 'Y', 1000, 100, 1100, '2025-02-01');
