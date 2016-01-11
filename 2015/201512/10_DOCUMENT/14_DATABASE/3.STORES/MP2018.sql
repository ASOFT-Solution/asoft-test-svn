IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2018]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP2018]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by Hoàng Vũ	Date: 07/07/2015
---Store MP2017 thay thế View MQ2221 và phân bổ sung thêm quyền xem dữ liệu của người
--- Purpose: Load Detail kế thừa đơn hàng sản xuất từ phiếu giao giao việc
--- EXEC MP2018 'AS', 'DHSX_BD_08_2015_0001', 'asoftAdmin'

CREATE PROCEDURE [dbo].[MP2018] 
(
	@DivisionID nvarchar(50),
	@VoucherID nvarchar(50),
	@UserID nvarchar(50)
	
)
AS

Declare @sSQL AS varchar(max),
		@sSQL1 AS varchar(max),
		@DivisionWhere AS VARCHAR(MAX),
		@sWHERE AS VARCHAR(MAX)
				
SET @sSQL ='  Select Distinct x.SOrderID, x.RefOrderID, x.RefSOrderID,x.VoucherTypeID, x.VoucherNo, x.OrderDate, x.Notes, x.ReVoucherNo,
					x.PeriodID, x.PeriodName, x.ObjectID, x.ObjectName, x.DepartmentID, x.DepartmentName, 
					x.EmployeeID, x.EmployeeName, x.InventoryTypeID, x.DivisionID, x.TranMonth, x.TranYear, 
					x.TransactionID, x.Orders, x.ProductID, x.ProductName, x.UnitID, x.AccountID, 
					x.ExtraID, x.ExtraName,
					x.OrderQuantity, x.InheritedQuantity,x.RemainQuantity, 
					x.ConvertedQuantity, x.InheritedConvertedQuantity, x.RemainConvertedQuantity, 
					x.Orders,x.Note, x.Ana01ID, x.Ana02ID, x.Ana03ID, x.Ana04ID, x.Ana05ID, 
					x.Ana06ID, x.Ana07ID, x.Ana08ID, x.Ana09ID, x.Ana10ID, 
					x.Ana01Name, x.Ana02Name, x.Ana03Name, x.Ana04Name, x.Ana05Name,
					x.Ana06Name, x.Ana07Name, x.Ana08Name, x.Ana09Name, x.Ana10Name,
					x.SalePrice, x.ConvertedAmount, x.OriginalAmount,
					x.nvarchar01, x.nvarchar02, x.nvarchar03, x.nvarchar04, x.nvarchar05,
					x.nvarchar06, x.nvarchar07, x.nvarchar08, x.nvarchar09, x.nvarchar10, x.Notes01, x.Notes02
			From (
			Select OT2001.SOrderID, OT2002.RefOrderID, OT2002.RefSOrderID,
					OT2001.VoucherTypeID, OT2001.VoucherNo, OT2001.OrderDate, OT2001.Notes, OT2001.VoucherNo as ReVoucherNo,
					OT2001.PeriodID, MT1601.Description As PeriodName, 
					OT2001.ObjectID, Case When AT1202.IsUpdateName = 1 Then OT2001.ObjectName Else AT1202.ObjectName End As ObjectName, 
					OT2001.DepartmentID, AT1102.DepartmentName, 
					OT2001.EmployeeID, AT1103.FullName As EmployeeName, 
					OT2001.InventoryTypeID, OT2001.DivisionID, OT2001.TranMonth, OT2001.TranYear, 
					OT2002.TransactionID, 
					OT2002.Orders, OT2002.InventoryID As ProductID, AT1302.InventoryName As ProductName, AT1302.UnitID, AT1302.AccountID, 
					OT2002.ExtraID, AT1311.ExtraName,
					OT2002.OrderQuantity, OT2002.ConvertedQuantity,
					isnull((Select Sum(isnull(Quantity,0)) From MT2008 Where MT2008.InheritTransactionID = OT2002.TransactionID),0) As InheritedQuantity,
					isnull((Select Sum(isnull(ConvertedQuantity,0)) From MT2008 Where MT2008.InheritTransactionID = OT2002.TransactionID),0) As InheritedConvertedQuantity,
					OT2002.OrderQuantity - isnull((Select Sum(isnull(Quantity,0)) 
													From MT2008 Where MT2008.InheritTransactionID = OT2002.TransactionID),0) As RemainQuantity,
					OT2002.ConvertedQuantity - isnull((Select Sum(isnull(ConvertedQuantity,0)) 
													From MT2008 Where MT2008.InheritTransactionID = OT2002.TransactionID),0) As RemainConvertedQuantity,
					OT2002.Description As Note, 
					OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID, 
					OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID, 
					A1.AnaName as Ana01Name, A2.AnaName as Ana02Name, A3.AnaName as Ana03Name, A4.AnaName as Ana04Name, A5.AnaName as Ana05Name,
					A6.AnaName as Ana06Name, A7.AnaName as Ana07Name, A8.AnaName as Ana08Name, A9.AnaName as Ana09Name, A10.AnaName as Ana10Name,
					OT2.SalePrice, OT2002.ConvertedAmount, OT2002.OriginalAmount,
					OT2002.nvarchar01, OT2002.nvarchar02, OT2002.nvarchar03, OT2002.nvarchar04, OT2002.nvarchar05,
					OT2002.nvarchar06, OT2002.nvarchar07, OT2002.nvarchar08, OT2002.nvarchar09, OT2002.nvarchar10, OT2002.Notes01, OT2002.Notes02'
SET @sSQL1 =' 	From OT2001 
					Inner join OT2002 On OT2001.SOrderID = OT2002.SOrderID and OT2001.DivisionID = OT2002.DivisionID
					left join OT2002 OT2 On OT2.SOrderID = OT2002.RefSOrderID and OT2.InventoryID = OT2002.InventoryID and OT2.DivisionID = OT2002.DivisionID
					
					--Left join AT1011 on OT2002.DivisionID = AT1011.DivisionID and OT2002.InventoryID = AT1011.InventoryID and OT2002.ExtraID=AT1011.AnaID
					Left join AT1311 on OT2002.DivisionID = AT1311.DivisionID and OT2002.ExtraID = AT1311.ExtraID
					Left Join AT1202 On OT2001.ObjectID = AT1202.ObjectID and OT2001.DivisionID = AT1202.DivisionID
					Left Join AT1102 On OT2001.DepartmentID = AT1102.DepartmentID And OT2001.DivisionID = AT1102.DivisionID
					Left Join AT1103 On OT2001.EmployeeID = AT1103.EmployeeID And OT2001.DivisionID = AT1103.DivisionID
					Left Join MT1601 On OT2001.PeriodID = MT1601.PeriodID and OT2001.DivisionID = MT1601.DivisionID
					Left Join AT1302 On OT2002.InventoryID = AT1302.InventoryID and OT2001.DivisionID = AT1302.DivisionID
					Left Join AT1011 A1 On OT2002.Ana01ID = A1.AnaID And A1.AnaTypeID = ''A01'' and OT2001.DivisionID = A1.DivisionID
					Left Join AT1011 A2 On OT2002.Ana02ID = A2.AnaID And A2.AnaTypeID = ''A02'' and OT2001.DivisionID = A2.DivisionID
					Left Join AT1011 A3 On OT2002.Ana03ID = A3.AnaID And A3.AnaTypeID = ''A03'' and OT2001.DivisionID = A3.DivisionID
					Left Join AT1011 A4 On OT2002.Ana04ID = A4.AnaID And A4.AnaTypeID = ''A04'' and OT2001.DivisionID = A4.DivisionID
					Left Join AT1011 A5 On OT2002.Ana05ID = A5.AnaID And A5.AnaTypeID = ''A05'' and OT2001.DivisionID = A5.DivisionID
					Left Join AT1011 A6 On OT2002.Ana06ID = A6.AnaID And A6.AnaTypeID = ''A06'' and OT2001.DivisionID = A6.DivisionID
					Left Join AT1011 A7 On OT2002.Ana07ID = A7.AnaID And A7.AnaTypeID = ''A07'' and OT2001.DivisionID = A7.DivisionID
					Left Join AT1011 A8 On OT2002.Ana08ID = A8.AnaID And A8.AnaTypeID = ''A08'' and OT2001.DivisionID = A8.DivisionID
					Left Join AT1011 A9 On OT2002.Ana09ID = A9.AnaID And A9.AnaTypeID = ''A09'' and OT2001.DivisionID = A9.DivisionID
					Left Join AT1011 A10 On OT2002.Ana10ID = A10.AnaID And A10.AnaTypeID = ''A10'' and OT2001.DivisionID = A10.DivisionID
			WHERE	OT2001.DivisionID = '''+@DivisionID+''' And OT2001.OrderType = 1 And (MT1601.IsDistribute = 0 or MT1601.IsDistribute is null)
		) x
			Where x.RemainQuantity>0 and x.SOrderID in ('''+@VoucherID+''')
 Order by x.OrderDate, x.VoucherNo, x.Orders
'	

EXEC(@sSQL+@sSQL1)
print @sSQL
print @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
