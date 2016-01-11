
/****** Object:  StoredProcedure [dbo].[OP2201]    Script Date: 12/16/2010 11:39:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


---Created by: Vo Thanh Huong, date: 28/12/2004
---purpose: Ke thua cac thanh pham tu don hang  san xuat cho du tru nguyen vat lieu
---Last Edit: Tuyen, them cac truong ObjectID, 5 ,=ma phan tich, periodID
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2201]  @DivisionID nvarchar(50),
				@lstSOrderID nvarchar(50)
AS
Declare @sSQL  nvarchar(4000)

Set  @lstSOrderID = 	Replace(@lstSOrderID, ',', ''',''')
Set @sSQL ='Select T00.DivisionID, T00.InventoryID as ProductID, InventoryName as ProductName, T01.UnitID, T00.OrderQuantity as Productquantity,
		isnull(LinkNo, '''') as LinkNo, '''' as Description, T00.Orders, T02.VoucherNo, T02.OrderDate , T02.ObjectID,AT1202.ObjectName,
		T00.Ana01ID,T00.Ana02ID,T00.Ana03ID,T00.Ana04ID,T00.Ana05ID,T02.PeriodID
	From OT2002 T00 inner join AT1302 T01 on T00.InventoryID = T01.InventoryID
		inner join OT2001 T02 on T02.SOrderID = T00.SOrderID 
		Left join AT1202 on AT1202.ObjectID = T02.ObjectID
	Where T02.DivisionID = ''' + @DivisionID + ''' and T00.SOrderID in (''' + @lstSOrderID + ''')'

If not exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2201')
	EXEC('Create view OV2201 ----tao boi OP2201
			as ' + @sSQL)
Else	
	EXEC('Alter view OV2201 ----tao boi OP2201
			as ' + @sSQL)