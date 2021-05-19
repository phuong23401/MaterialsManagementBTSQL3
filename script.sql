CREATE TABLE `materials`(
`matID` INT AUTO_INCREMENT PRIMARY KEY,
`matCode` VARCHAR(20) NOT NULL,
`matName` VARCHAR(50) NOT NULL,
`unit` VARCHAR(20) NOT NULL,
`price` INT NOT NULL
);

CREATE TABLE `warehouse`(
`wahID` INT AUTO_INCREMENT PRIMARY KEY,
`matID` INT NOT NULL,
`originalNum` INT NOT NULL,
`importNum` INT NOT NULL,
`exportNum` INT NOT NULL,
FOREIGN KEY (`matID`) REFERENCES `materials`(`matID`)
);

CREATE TABLE `supplier`(
`supID` INT AUTO_INCREMENT PRIMARY KEY,
`supCode` VARCHAR(20) NOT NULL,
`supName` VARCHAR(50) NOT NULL,
`address` VARCHAR(50) NOT NULL,
`phone` VARCHAR(20) NOT NULL
);

CREATE TABLE `orders`(
`orderID` INT AUTO_INCREMENT PRIMARY KEY,
`orderCode` VARCHAR(20) NOT NULL,
`orderDate` DATE NOT NULL,
`supID` INT NOT NULL,
FOREIGN KEY (`supID`) REFERENCES `supplier`(`supID`)
);

CREATE TABLE `importBill`(
`billID` INT AUTO_INCREMENT PRIMARY KEY,
`billCode` VARCHAR(20) NOT NULL,
`impDate` DATE NOT NULL,
`orderID` INT NOT NULL,
FOREIGN KEY (`orderID`) REFERENCES `orders`(`orderID`)
);

CREATE TABLE `exportBill`(
`billID` INT AUTO_INCREMENT PRIMARY KEY,
`billCode` VARCHAR(20) NOT NULL,
`expDate` DATE NOT NULL,
`customerName` VARCHAR(50) NOT NULL
);

CREATE TABLE `ordersDetails`(
`odID` INT AUTO_INCREMENT PRIMARY KEY,
`orderID` INT NOT NULL,
`matID` INT NOT NULL,
`orderNum` INT NOT NULL,
FOREIGN KEY (`orderID`) REFERENCES `orders`(`orderID`),
FOREIGN KEY (`matID`) REFERENCES `materials`(`matID`)
);

CREATE TABLE `impBillDetails`(
`ibdID` INT AUTO_INCREMENT PRIMARY KEY,
`impBillID` INT NOT NULL,
`matID` INT NOT NULL,
`impNum` INT NOT NULL,
`impCost` INT NOT NULL,
`note` VARCHAR(50),
FOREIGN KEY (`impBillID`) REFERENCES `importBill`(`billID`),
FOREIGN KEY (`matID`) REFERENCES `materials`(`matID`)
);

CREATE TABLE `expBillDetails`(
`ebdID` INT AUTO_INCREMENT PRIMARY KEY,
`expBillID` INT NOT NULL,
`matID` INT NOT NULL,
`expNum` INT NOT NULL,
`expCost` INT NOT NULL,
`note` VARCHAR(50),
FOREIGN KEY (`expBillID`) REFERENCES `exportBill`(`billID`),
FOREIGN KEY (`matID`) REFERENCES `materials`(`matID`)
);


INSERT INTO `materials`(`matCode`, `matName`, `unit`, `price`) VALUES
('M01', 'Gạch ốp tường', 'Miếng', 50), 
('M02', 'Gạch ngói', 'Viên', 25), 
('M03', 'Gạch đỏ', 'Viên', 20), 
('M04', 'Xi măng', 'Bao', 40), 
('M05', 'Cưa máy', 'Chiếc', 150);

INSERT INTO `warehouse`(`matID`, `originalNum`, `importNum`, `exportNum`) VALUES
(1, 500, 0, 400),
(2, 500, 0, 300),
(3, 500, 500, 800),
(1, 100, 500, 300),
(4, 200, 200, 300),
(5, 10, 5, 5),
(4, 100, 500, 400),
(2, 200, 300, 400),
(3, 200, 1200, 1100),
(1, 300, 500, 500);

INSERT INTO `supplier`(`supCode`, `supName`, `address`, `phone`) VALUES
('A01', 'CTy TNHH AAA', 'Hà Nội', '0931910JQK'),
('B02', 'CTy VLXD BBB', 'Hải Dương', '0987654321'),
('C03', 'CTy CCC', 'Quảng Ninh', '0323456789');

INSERT INTO `orders`(`orderCode`, `orderDate`, `supID`) VALUES
('OD01', '2021-03-19', 1), 
('OD02', '2021-04-19', 2), 
('OD03', '2021-05-19', 3); 

INSERT INTO `importBill`(`billCode`, `impDate`, `orderID`) VALUES
('N01', '2021-03-20', 1),
('N02', '2021-04-22', 2),
('N03', '2021-05-25', 3);

INSERT INTO `exportBill`(`billCode`, `expDate`, `customerName`) VALUES
('X01', '2021-03-20', 'Nguyen Van A'),
('X02', '2021-04-23', 'Nguyen The B'),
('X03', '2021-03-25', 'Nguyen Trong C');

INSERT INTO `ordersDetails`(`orderID`, `matID`, `orderNum`) VALUES
(1, 5, 5), 
(2, 1, 1000), 
(2, 2, 300), 
(2, 3, 1700), 
(3, 4, 200), 
(3, 4, 500);

INSERT INTO `impBillDetails`(`impBillID`, `matID`, `impNum`, `impCost`) VALUES
(1, 5, 5, 120),
(2, 1, 1000, 45),
(2, 2, 300, 20),
(2, 3, 1700, 18),
(3, 4, 200, 35),
(3, 4, 500, 35);

INSERT INTO `expBillDetails`(`expBillID`, `matID`, `expNum`, `expCost`) VALUES
(1, 5, 5, 150),
(2, 1, 1000, 50),
(2, 2, 300, 25),
(2, 3, 1700, 20),
(3, 4, 200, 40),
(3, 4, 500, 40);


-- 1. số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền
SELECT COUNT(IBD.`ibdID`) AS `ibdNum`, M.`matCode`, M.`matName`, IBD.`impNum`, IBD.`impCost`, (`impNum` * `impCost`) AS `impPrice` FROM `impBillDetails` IBD
JOIN `materials` M ON IBD.`matID` = M.`matID`
GROUP BY M.`matCode`;

-- 2. số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng, mã nhà cung cấp, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập
SELECT COUNT(IBD.`ibdID`) AS `ibdNum`, IB.`impDate`, COUNT(OD.`odID`) AS `orderNum`, S.`supCode`, M.`matCode`, M.`matName`, IBD.`impNum`, IBD.`impCost`, (`impNum` * `impCost`) AS `impPrice` FROM `impBillDetails` IBD
JOIN `ordersDetails` OD ON IBD.`matID` = OD.`matID`
JOIN `materials` M ON IBD.`matID` = M.`matID`
JOIN `importBill` IB ON IBD.`impBillID` = IB.`billID`
JOIN `orders` O ON IB.`orderID` = O.`orderID`
JOIN `supplier` S ON O.`supID` = S.`supID`
GROUP BY M.`matCode`;


-- 3. số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập có số lượng nhập > 500
SELECT COUNT(IBD.`ibdID`) AS `ibdNum`, M.`matCode`, IBD.`impNum`, IBD.`impCost`, (`impNum` * `impCost`) AS `impPrice` FROM `impBillDetails` IBD
JOIN `ordersDetails` OD ON IBD.`matID` = OD.`matID`
JOIN `materials` M ON IBD.`matID` = M.`matID`
WHERE IBD.`impNum` > 500
GROUP BY M.`matCode`;

-- 4. số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập vật tư có đơn vị tính là Viên
SELECT COUNT(IBD.`ibdID`) AS `ibdNum`, M.`matCode`, M.`matName`, IBD.`impNum`, IBD.`impCost`, (`impNum` * `impCost`) AS `impPrice` FROM `impBillDetails` IBD
JOIN `ordersDetails` OD ON IBD.`matID` = OD.`matID`
JOIN `materials` M ON IBD.`matID` = M.`matID`
WHERE M.`unit` = 'Viên'
GROUP BY M.`matCode`;

-- 5. số phiếu xuất hàng, tên khách hàng, mã vật tư, tên vật tư, số lượng xuất, đơn giá xuất, thành tiền xuất
SELECT COUNT(EBD.`ebdID`) AS `exbNum`, EB.`customerName`, M.`matCode`, M.`matName`, EBD.`expNum`, EBD.`expCost`, (`expNum` * `expCost`) AS `expPrice` FROM `expBillDetails` EBD
JOIN `exportBill` EB ON EBD.`expBillID` = EB.`billID`
JOIN `materials` M ON EBD.`matID` = M.`matID`
GROUP BY M.`matCode`;
