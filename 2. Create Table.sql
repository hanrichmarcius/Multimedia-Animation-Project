CREATE DATABASE bEJibunWholeSale
GO
USE bEJibunWholeSale
GO

CREATE FUNCTION quantityCheck(@qty INT, @id CHAR(5))
	 RETURNS INT
	 AS BEGIN
	 DECLARE @minQty INT
	 SELECT @minQty = MinimumPurchase FROM Item WHERE ItemID = @id
	 IF @qty < @minQty
	 RETURN 0

	 RETURN 1
	 END
GO


create table [Customer](
	CustomerID CHAR(5) PRIMARY KEY,
	CustomerName VARCHAR(50) NOT NULL,
	CustomerGender VARCHAR(10) NOT NULL,
	CustomerPhone VARCHAR(15) NOT NULL,
	CustomerDOB DATE NOT NULL,
	
	constraint CustomerIDCheck check (CustomerID like 'CU[0-9][0-9][0-9]'),
	constraint CustomerGenderCheck check (CustomerGender in('Male', 'Female')),
	constraint CustomerPhoneCheck check (len(CustomerPhone) > 9),
	constraint CustomerDOBCheck check (CustomerDOB  between '1990-01-01' and getdate())

);

create table [Staff](
	StaffID CHAR(5) PRIMARY KEY,
	StaffName VARCHAR(50) NOT NULL,
	StaffGender VARCHAR(10) NOT NULL,
	StaffPhone VARCHAR(15) NOT NULL,
	StaffSalary INT NOT NULL,

	constraint StaffIDCheck check (StaffID like 'ST[0-9][0-9][0-9]'),
	constraint StaffGenderCheck check (StaffGender in('Male', 'Female')),
	constraint StaffPhoneCheck check (len(StaffPhone) > 9),
	constraint StaffSalary check (StaffSalary > 0)
);

create table [Vendor](
	VendorID CHAR(5) PRIMARY KEY,
	VendorName VARCHAR(50) NOT NULL,
	VendorPhone VARCHAR(15) NOT NULL,
	VendorAddress VARCHAR(50) NOT NULL,
	VendorEmail VARCHAR(50) NOT NULL,

	constraint VendorIDCheck check (VendorID like 'VE[0-9][0-9][0-9]'),
	constraint VendorPhoneCheck check (len(VendorPhone) >= 9),
	constraint VendorAddressCheck check (VendorAddress like'_%street'),
	constraint VendorEmailCheck check(VendorEmail like '_%@_%.com')
);


create table [ItemType](
	TypeID CHAR(5) PRIMARY KEY,
	TypeName VARCHAR(100) NOT NULL,

	constraint TypeIDCheck check (TypeID like 'IP[0-9][0-9][0-9]'),
	constraint TypeNameCheck check (len(TypeName)>=4)
);

create table [Item](
	ItemID CHAR(5) PRIMARY KEY,
	TypeID CHAR(5) FOREIGN KEY REFERENCES ItemType(TypeID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	ItemName VARCHAR(50) NOT NULL,
	ItemPrice INT NOT NULL,
	MinimumPurchase INT NOT NULL,

	constraint ItemIDCheck check (ItemID like 'IT[0-9][0-9][0-9]'),
	constraint ItemPriceCheck check (ItemPrice > 0),
	constraint MinimumPurchaseCheck check (MinimumPurchase > 0),

);

create table [SalesTransaction](
	SalesID CHAR(5) PRIMARY KEY,
	StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	CustomerID CHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	SalesDate DATE NOT NULL,
	
	constraint SalesIDCheck check (SalesID like 'SA[0-9][0-9][0-9]')
);

CREATE TABLE [SalesDetail](
	 SalesID CHAR(5) FOREIGN KEY REFERENCES SalesTransaction(SalesID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	 ItemID CHAR(5) FOREIGN KEY REFERENCES Item(ItemID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	 SalesItemQTY INT NOT NULL,

	 PRIMARY KEY(SalesID, ItemID),
	 CONSTRAINT QtyCheck CHECK (dbo.quantityCheck(SalesItemQTY, ItemID) = 1)
);

create table [PurchaseTransaction](
	 PurchaseID CHAR(5) PRIMARY KEY,
	 StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	 VendorID CHAR(5) FOREIGN KEY REFERENCES Vendor(VendorID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	 PurchaseDate DATE NOT NULL,

	 constraint PurchaseIDCheck CHECK (PurchaseID LIKE 'PH[0-9][0-9][0-9]')
);

CREATE TABLE [PurchaseDetail](
	 PurchaseID CHAR(5) FOREIGN KEY REFERENCES PurchaseTransaction(PurchaseID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	 ItemID CHAR(5) FOREIGN KEY REFERENCES Item(ItemID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	 ArrivalDate DATE,
	 PurchaseItemQTY INT NOT NULL,

	 PRIMARY KEY(PurchaseID, ItemID)
);

