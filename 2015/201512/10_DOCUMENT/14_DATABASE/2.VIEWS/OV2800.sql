IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV2800]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV2800]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---Created by: Vo Thanh Huong, date: 08/04/2005
---Purpose: Tinh so luong hang giu cho (SO, ES), hang dang ve(PO) 
---Edit: Thuy Tuyen, them truong Tranmonth, Tranyear
---Edit: Hoàng Vũ, on 14/08/2015, them thêm giữ chổ phiếu giao việc (Khách hàng secoin)

CREATE VIEW [dbo].[OV2800] as
--Giu cho SO

Select 'SO' as TypeID, T01.DivisionID, T00.SOrderID as OrderID, T00.InventoryID, WareHouseID, ObjectID,EmployeeID,OrderDate,
	sum(isnull(OrderQuantity, 0)) as OrderQuantity, 
	sum(isnull(AdjustQuantity,0)) as AdjustQuantity,
	avg(isnull(ActualQuantity, 0)) as ActualQuantity,
	T00.Finish, T01.Tranmonth, T01.Tranyear
From  OT2002 T00 inner join OT2001 T01 on T00.SOrderID = T01.SOrderID 
		
	left join  (--Giao hang SO
	Select T00.OrderID, InventoryID, sum(ActualQuantity) as ActualQuantity
	From AT2007 T00 inner join AT2006 T01 on T00.VoucherID = T01.VoucherID
	Where KindVoucherID in (2, 4) and isnull(T00.OrderID, '') <> ''
	Group by T00.OrderID, InventoryID
	) T02 		on T02.InventoryID = T00.InventoryID and T02.OrderID = T00.SOrderID
Where OrderStatus not in (0, 3,4, 9) and T00.IsPicking = 1  and T01.Disabled = 0
Group by T01.DivisionID,  T00.SOrderID, T00.InventoryID, WareHouseID, T00.Finish, ObjectID,EmployeeID,OrderDate,T01.Tranmonth, T01.Tranyear
Union All
--Giu cho DN như giu cho SO  (Phieu giao viec- Delivery Note)
Select  'DN' as TypeID, z.DivisionID, z.OrderID, z.InventoryID, z.WareHouseID, z.ObjectID, z.EmployeeID, z.VoucherDate
						, sum(z.OrderQuantity) as OrderQuantity  --Giữ chỗ
						, 0 as AdjustQuantity --Điều chỉnh
						, sum(z.ActualQuantity) as ActualQuantity --Thực xuất
						
						, z.Finish, z.Tranmonth, z.Tranyear
				From 
				(
						Select D.DivisionID, M.VoucherID as OrderID, D.RInventoryID as InventoryID, D.WareHouseID, M.ObjectID,M.EmployeeID,M.VoucherDate,
							1 as OrderQuantity, 
							0 as AdjustQuantity,
							isnull(A.ActualQuantity, 0) as ActualQuantity,
							0 as Finish, M.Tranmonth, M.Tranyear
						From  MT2007 M inner join MT2008 D on M.VoucherID = D.VoucherID and M.DivisionID = D.DivisionID 
										Left join AT2007 A  on A.InheritVoucherID = D.VoucherID and A.InheritTransactionID = D.TransactionID
										left join AT2006 B on A.VoucherID = B.VoucherID and A.DivisionID = B.DivisionID 
										and KindVoucherID in (2, 4)
						Where D.InventoryID is not null and D.WareHouseID is not null
				) z
Group by z.DivisionID, z.OrderID, z.InventoryID, z.WareHouseID, z.ObjectID, z.EmployeeID, z.VoucherDate, z.Finish, z.Tranmonth, z.Tranyear

Union All

--Hang dang ve PO
Select 'PO' as TypeID, T01.DivisionID, T00.POrderID, T00.InventoryID, WareHouseID, ObjectID,EmployeeID,OrderDate,
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

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
