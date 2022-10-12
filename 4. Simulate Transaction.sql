INSERT INTO Customer VALUES
('CU016', 'Vincent Philip', 'Male', '08129876543', '2001-03-13'),
('CU017', 'Gilbert', 'Male', '08334455667', '2002-11-07');

INSERT INTO SalesTransaction VALUES 
('SA026', 'ST001', 'CU016', '2021-12-24'),
('SA027', 'ST012', 'CU017', '2021-12-24'),
('SA028', 'ST003', 'CU001', '2021-12-24');


INSERT INTO SalesDetail VALUES 
('SA026', 'IT008', '10'),
('SA027', 'IT016', '50'),
('SA028', 'IT015', '20'),
('SA028', 'IT016', '30');

INSERT INTO PurchaseTransaction VALUES
('PH026','ST001','VE003', '2021-12-12'),
('PH027','ST012','VE006', '2021-11-10'),
('PH028','ST003','VE005', '2021-11-11');

INSERT INTO PurchaseDetail VALUES 
('PH026', 'IT008','2021-12-23', '200'),
('PH027', 'IT016','2021-11-20', '500'),
('PH028', 'IT015','2021-11-22', '1000');