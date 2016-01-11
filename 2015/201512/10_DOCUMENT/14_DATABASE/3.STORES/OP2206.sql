IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OP2206]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[OP2206]
GO

/****** Object:  StoredProcedure [dbo].[OP2206]    Script Date: 12/16/2010 11:57:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



---Created by: Vo Thanh Huong, date: 28/12/2004
---purpose: Ke thua cac thanh pham tu don hang  ban cho don hang san xuat
--- Last Edit Thuy Tuyen Lay them doi tuong 21/06/2006
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[OP2206]  @DivisionID nvarchar(50),
				@lstSOrderID nvarchar(4000)
AS
Declare @sSQL  nvarchar(4000)

Set  @lstSOrderID = 	Replace(@lstSOrderID, ',', ''',''')
Set @sSQL ='Select T00.DivisionID, T00.InventoryID as ProductID, InventoryName as ProductName, T01.UnitID, T00.OrderQuantity as Productquantity,
		isnull(LinkNo, '''') as LinkNo, '''' as Description, T00.Orders, T02.VoucherNo, T02.OrderDate, T00.RefInfor, T02.ObjectID, AT1202.ObjectName, 
		T00.SOrderID, T00.TransactionID, T00.ConvertedQuantity, T00.ConvertedSalePrice, T00.SalePrice, T00.OriginalAmount, T00.ConvertedAmount, T00.DiscountPercent, 
		T00.DiscountConvertedAmount, T00.VATPercent, T00.VATConvertedAmount, T00.Description as Description2, T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID,
		T00.Notes, T00.Notes01, T00.Notes02, 0 as IsSelected
	From OT2002 T00 inner join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID
		inner join OT2001 T02 on T02.SOrderID = T00.SOrderID  and T00.DivisionID = T02.DivisionID
		Inner Join AT1202 on AT1202.ObjectID = T02.ObjectID and T00.DivisionID = AT1202.DivisionID
	Where T02.DivisionID = ''' + @DivisionID + ''' and T00.SOrderID in (''' + @lstSOrderID + ''')'

If not exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2206')
	EXEC('Create view OV2206 ----tao boi OP2206
			as ' + @sSQL)
Else	
	EXEC('Alter view OV2206 ----tao boi OP2206
			as ' + @sSQL)