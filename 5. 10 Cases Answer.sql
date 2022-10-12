--1
select ItemName, ItemPrice, sum(PurchaseItemQTY) as [Item Total]
from Item IT join PurchaseDetail PD on IT.ItemID = PD.ItemID
where ArrivalDate = ('')
group by ItemName, ItemPrice
having sum(PurchaseItemQTY) > 100
order by [Item Total] desc

--2
select VendorName, substring(VendorEmail,charindex('@', VendorEmail)+1, len(VendorEmail)) as [Domain Name], AVG(PurchaseItemQTY)as [Average Purchased Item]
from Vendor V join PurchaseTransaction PT on V.VendorID = PT.VendorID join PurchaseDetail PD on PD.PurchaseID = PT.PurchaseID
where VendorAddress like 'Food Street'
and VendorEmail not like'%gmail.com'
group by VendorName, VendorEmail

--3
select datename(month,SalesDate) as [Month], min(SalesItemQTY) as [Minimum Quantity Sold], max(SalesItemQTY) as [Maximum Quantity Sold]
from SalesTransaction ST join SalesDetail SD on ST.SalesID = SD.SalesID join Item IT on IT.ItemID = SD.ItemID join ItemType ITY on ITY.TypeID = IT.TypeID
where year(SalesDate) = '2019'
and TypeName in('Food','Drink')
group by  SalesDate

--4
select replace(S.StaffID, 'ST', 'Staff ') as [Staff Number], StaffName, concat('Rp. ', StaffSalary) as [Salary], count(StaffName) as [Sales Count], avg(SalesItemQTY) as [Average Sales Quantity]
from Staff S join SalesTransaction ST on S.StaffID = ST.StaffID join Customer C on C.CustomerID = ST.CustomerID join SalesDetail SD on SD.SalesID = ST.SalesID
where month(SalesDate) = '02'
and StaffGender != CustomerGender
group by StaffName, S.StaffID, StaffSalary

--5
select concat(left(CustomerName,1),upper(right(CustomerName, 1))) as [Customer Initial], format(SalesDate, 'MM dd, yyyy') as [Transaction Date], SalesItemQTY as [Quantity]
from Customer C join SalesTransaction ST on C.CustomerID = ST.CustomerID join SalesDetail SD on SD.SalesID = ST.SalesID,
(
	select avg(SalesItemQTY) as SalesQTY from SalesDetail
) Average
where SalesItemQTY > Average.SalesQTY
and CustomerGender like 'Female' 

--6
select lower(V.VendorID) as [Display ID], VendorName, concat('+62',substring(VendorPhone,2,len(VendorPhone))) as[Phone Number] 
from Vendor V join PurchaseTransaction PT on V.VendorID = PT.VendorID join PurchaseDetail PD on PD.PurchaseID = PT.PurchaseID,
(
	 select min(PurchaseItemQTY) as [Mina]
	 from PurchaseDetail
) minimum
where PurchaseItemQTY > minimum.Mina
and convert(int, right(PT.PurchaseID, 1)) % 2 = 1
group by V.VendorID,V.VendorName, V.VendorPhone

--7
select S.StaffName, V.VendorName, PT.PurchaseID, total.totalpur as [Total Purchased Quantity], concat(datediff(day, PurchaseDate, getdate()), ' Days ago') as [Ordered Day]
from Staff S join PurchaseTransaction PT on S.StaffID = PT.StaffID join Vendor V on V.VendorID = PT.VendorID join PurchaseDetail PD on PD.PurchaseID = PT.PurchaseID,
(
	 select max(PurchaseItemQTY) as [PurchaseQty] 
	 from PurchaseDetail PD join PurchaseTransaction PT on PD.PurchaseID = PT.PurchaseID
	 where datediff(day,PurchaseDate, ArrivalDate) < 7
) maximum,
(
	select purchaseID AS [identifier], sum(PurchaseItemQTY) as[totalpur]
	from PurchaseDetail
	group by PurchaseID
) total
where total.totalpur > maximum.PurchaseQty and total.identifier = PT.PurchaseID
group by S.StaffName, V.VendorName, PT.PurchaseID,total.totalpur, PurchaseDate, ArrivalDate

--8
select top 2 format(SalesDate, 'dddd') as [Day], count(SD.SalesID) as [Item Sales Amount]
from SalesTransaction ST join SalesDetail SD on ST.SalesID = SD.SalesID join Item I on I.ItemID = SD.ItemID,
(
	select avg(ItemPrice) as [Price]
	from Item I join ItemType IT on I.TypeID = IT.TypeID
	where TypeName in('Electronic', 'Gadgets')
) average
where I.ItemPrice < average.Price
group by SalesDate, SD.SalesID
order by count(SD.SalesID) asc


--9
create view [Customer Statistic by Gender]
as
select CustomerGender, max(SalesItemQTY) as [Maximum Sales], min(SalesItemQTY) as [Minimum Sales]
from Customer C join SalesTransaction ST on C.CustomerID = ST.CustomerID join SalesDetail SD on SD.SalesID = ST.SalesID
where convert(int, left(CustomerDOB,4)) between 1998 and 1999
and SalesItemQTY between 10 and 50
group by CustomerGender

-- View the view
select * from [Customer Statistic by Gender]


--10
create view [Item Type Statistic]
as
select upper(TypeName) as [Item Type], avg(ItemPrice) as [Average Price], count(I.ItemID) as [Number of Item Variety]
from Item I join ItemType IT on I.TypeID = IT.TypeID
where TypeName like 'F%'
and MinimumPurchase > 5
group by TypeName

select * from [Item Type Statistic]