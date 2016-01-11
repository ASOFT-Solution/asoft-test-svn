IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0030]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0030]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created on 01/10/2013 by Bảo Anh
--- Insert dữ liệu vào bảng tồn kho sẵn sàng OT0034 (dùng trong store duyệt đơn hàng OP0034)
--- Edit by: Hoàng Vũ, on 27/02/2015--BỔ sung chức năng giữ chổ cho phiếu giao việc- Customerindex = 43 (Secoin)
--- EXEC OP0030 'AS'

CREATE PROCEDURE [dbo].[OP0030]  
		@DivisionID nvarchar(50)
AS

--- Tạo bảng tạm thay cho view OV2800

--Giu cho SO
SELECT 'SO' as TypeID, T01.DivisionID, T00.SOrderID as OrderID, T00.InventoryID, WareHouseID, ObjectID,EmployeeID,OrderDate,
	sum(isnull(OrderQuantity, 0)) as OrderQuantity, 
	sum(isnull(AdjustQuantity,0)) as AdjustQuantity,
	avg(isnull(ActualQuantity, 0)) as ActualQuantity,
	T00.Finish, T01.Tranmonth, T01.Tranyear
INTO #TAM
From  OT2002 T00 inner join OT2001 T01 on T00.SOrderID = T01.SOrderID 
		
	left join  (--Giao hang SO
	Select T00.OrderID, InventoryID, sum(ActualQuantity) as ActualQuantity
	From AT2007 T00 inner join AT2006 T01 on T00.VoucherID = T01.VoucherID
	Where KindVoucherID in (2, 4) and isnull(T00.OrderID, '') <> ''
	Group by T00.OrderID, InventoryID
	) T02 		on T02.InventoryID = T00.InventoryID and T02.OrderID = T00.SOrderID
Where OrderStatus not in (0, 3,4, 9) and T00.IsPicking = 1  and T01.Disabled = 0
Group by T01.DivisionID,  T00.SOrderID, T00.InventoryID, WareHouseID, T00.Finish, ObjectID,EmployeeID,OrderDate,T01.Tranmonth, T01.Tranyear

--Giu cho DN  (Phieu giao viec- Delivery Note)
Union All
Select 'DN' as TypeID, D.DivisionID, M.VoucherID as OrderID, D.InventoryID, D.WareHouseID, M.ObjectID,M.EmployeeID,M.VoucherDate as OrderDate,
	sum(isnull(D.Quantity, 0)) as OrderQuantity, 
	0 as AdjustQuantity,
	avg(isnull(ActualQuantity, 0)) as ActualQuantity,
	0 as Finish, M.Tranmonth, M.Tranyear
From  MT2007 M inner join MT2008 D on M.VoucherID = D.VoucherID and M.DivisionID = D.DivisionID
		
	left join  (--Xuat hang DN
	Select M.OrderID, D.InventoryID, sum(D.ActualQuantity) as ActualQuantity
	From AT2007 D inner join AT2006 M on M.VoucherID = D.VoucherID and M.DivisionID = D.DivisionID
	Where KindVoucherID in (2, 4) and isnull(M.OrderID, '') <> ''
	Group by M.OrderID, D.InventoryID
	) T02 		on T02.InventoryID = D.InventoryID and T02.OrderID = M.SOrderID
--Where M.OrderStatus in (1)--0:Chưa hoàn tất; 1: hoàn tất 
Group by D.DivisionID, M.VoucherID, D.InventoryID, D.WareHouseID, M.ObjectID,M.EmployeeID,M.VoucherDate, M.Tranmonth, M.Tranyear


Union All
--Hang dang ve PO
Select 'PO' as TypeID, T01.DivisionID, T00.POrderID as OrderID, T00.InventoryID, WareHouseID, ObjectID,EmployeeID,OrderDate,
	sum(isnull(OrderQuantity, 0)) as OrderQuantity, 
	sum(isnull(AdjustQuantity,0)) as AdjustQuantity,
	avg(isnull(ActualQuantity,0)) as ActualQuantity,
	T00.Finish	,T01.Tranmonth, T01.Tranyear
From  OT3002 T00 inner join OT3001 T01 on T00.POrderID = T01.POrderID
	left join (--Nhap hang PO
	Select T00.OrderID, InventoryID, sum(ActualQuantity) as ActualQuantity
	From AT2007 T00 inner join AT2006 T01 on T00.VoucherID = T01.VoucherID
	Where KindVoucherID in (1, 5, 7) and isnull(T00.OrderID, '') <> ''
	Group by T00.OrderID, InventoryID
	) T03 on T03.OrderID = T00.POrderID and T03.InventoryID = T00.InventoryID
Where OrderStatus not in (0, 3,4, 9) and T00.IsPicking = 1  and T01.Disabled = 0
Group by T01.DivisionID, T00.POrderID, T00.InventoryID, WareHouseID, T00.Finish	,ObjectID,EmployeeID,OrderDate,T01.Tranmonth, T01.Tranyear
Union All
--Giu cho du tru ES
Select 'ES' as TypeID, T01.DivisionID,  T00.EstimateID as OrderID, MaterialID as InventoryID, T01.WareHouseID, '' as  ObjectID,EmployeeID, null as OrderDate,
	sum(isnull(MaterialQuantity, 0)) as OrderQuantity, 
	0 as AdjustQuantity, avg(isnull(ActualQuantity,0)) as ActualQuantity,
	0 as Finish, T01.Tranmonth, T01.Tranyear
From  OT2203 T00 inner join OT2201 T01 on T00.EstimateID = T01.EstimateID
	left join (--Xuat hang ES
	Select T00.OrderID, InventoryID, sum(ActualQuantity) as ActualQuantity
	From AT2007 T00 inner join AT2006 T01 on T00.VoucherID = T01.VoucherID
	Where KindVoucherID in (2, 4) and isnull(T00.OrderID, '') <> ''
	Group by T00.DivisionID, T00.OrderID, InventoryID
	) T03 on T03.OrderID = T00.EstimateID and T03.InventoryID = T00.MaterialID 
Where OrderStatus not in (0, 2, 9) and T00.IsPicking = 1 -- and T01.Disabled = 0
Group by T01.DivisionID, T00.EstimateID, MaterialID, T01.WareHouseID,EmployeeID,T01.Tranmonth, T01.Tranyear

--- Tạo bảng tạm thay cho view OV2401
----- So du
Select AT2017.DivisionID,  WareHouseID,  InventoryID, 
	Sum(ActualQuantity) as 	DebitQuantity,
	0 as			CreditQuantity
Into #TAM1
From AT2017 inner join AT2016 on AT2016.VoucherID = AT2017.VoucherID
Group by AT2017.DivisionID,  WareHouseID,  InventoryID
Union All  --- Nhap kho
Select 	AT2008.DivisionID,  WareHouseID,  InventoryID, 
	Sum(DebitQuantity) as 	DebitQuantity,
	0 as			CreditQuantity
From AT2008 
Group by AT2008.DivisionID, WareHouseID ,  InventoryID
Union All  ---- Xuat kho
Select 	AT2008.DivisionID,  WareHouseID,  InventoryID, 
	0 as 	DebitQuantity,
	Sum(CreditQuantity) as	CreditQuantity
From AT2008 
Group by AT2008.DivisionID,  WareHouseID, InventoryID

--- Insert dữ liệu vào bảng ngầm OT0034
DELETE FROM OT0034 Where DivisionID = @DivisionID

INSERT INTO OT0034 (DivisionID,WarehouseID,InventoryID,SQuantity,PQuantity,EndQuantity)
SELECT		@DivisionID as DivisionID,
			ISNULL(OP.WareHouseID, WH.WareHouseID) AS WareHouseID,
			ISNULL(OP.InventoryID, WH.InventoryID) AS InventoryID,
			Sum(isnull(OP.SQuantity, 0)) as SQuantity,
			Sum(isnull(OP.PQuantity, 0)) as PQuantity,
			WH.EndQuantity

FROM		(
				Select DivisionID, WareHouseID, InventoryID, 
						Sum(CASE WHEN TypeID <> 'PO' AND Finish <> 1 THEN Isnull(OrderQuantity,0) - isnull(ActualQuantity, 0) ELSE 0 END) AS SQuantity,
						Sum(CASE WHEN TypeID = 'PO' AND Finish <> 1 THEN isnull(OrderQuantity, 0) - isnull(ActualQuantity, 0) ELSE 0 END) AS PQuantity
			    from #TAM 
				Group by DivisionID, WareHouseID, InventoryID, TypeID, Finish
			 )OP
full JOIN	(Select DivisionID,  WareHouseID,  InventoryID, Sum(ISNULL(DebitQuantity, 0)) - Sum(ISNULL(CreditQuantity, 0)) AS EndQuantity 
			 From #TAM1
			 Group by DivisionID,  WareHouseID,  InventoryID
			 ) WH
ON	WH.DivisionID = OP.DivisionID AND WH.WareHouseID = OP.WareHouseID AND WH.InventoryID = OP.InventoryID
WHERE Isnull(OP.DivisionID, WH.DivisionID) = @DivisionID
GROUP BY	ISNULL(OP.WareHouseID, WH.WareHouseID),ISNULL(OP.InventoryID, WH.InventoryID), WH.EndQuantity

DROP TABLE #TAM
DROP TABLE #TAM1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON