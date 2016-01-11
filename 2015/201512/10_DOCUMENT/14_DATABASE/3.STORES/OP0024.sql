/****** Object:  StoredProcedure [dbo].[OP0024]    Script Date: 12/16/2010 14:18:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



---Created by: Vo Thanh Huong, date: 07/09/2005
---Purpose: Loc du lieu cho man hinh truy van Phieu hieu chinh

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP0024] @DivisionID nvarchar(50),
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int     ---Tra ra view OV0024 	Master
  							    -- OV0025	Detail		
		
AS
DECLARE @sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000),
	@FromPeriod nvarchar(50),
	@ToPeriod nvarchar(50)		

Select @FromPeriod = cast(@FromMonth + @FromYear*100 as nvarchar(20)), 
		@ToPeriod = cast(@ToMonth + @ToYear*100 as nvarchar(20)) 
		
Set @sSQL1 = 
N'Select 	OT2006.VoucherID, 
		OT2006.DivisionID, 
		OT2006.TranMonth, 
		OT2006.TranYear, 
		OT2006.VoucherTypeID, 
		OT2006.VoucherNo, 
		OT2006.VoucherDate, 
		OT2006.CurrencyID, 
		OT2006.ExchangeRate, 
		OT2006.Description, 
		OT2006.ObjectID, 
		case when isnull(OT2006.ObjectName, '''') = '''' then AT1202.ObjectName else OT2006.ObjectName end as ObjectName,
		case when isnull(OT2006.Address, '''') = '''' then AT1202.Address else OT2006.Address end as Address,
		OT2006.DeliveryAddress, 
		OT2006.EmployeeID, 
		OT2006.OrderStatus, 		
		OV1001.Description as OrderStatusName, 
		OV1001.EDescription as EOrderStatusName, 
		OT2006.RefOrderID, 
		OT2006.CreateDate, 
		OT2006.CreateUserID, 
		OT2006.LastModifyDate, 
		OT2006.LastModifyUserID,
		OT2006.Ana01ID, 
		OT2006.Ana02ID, 
		OT2006.Ana03ID, 
		OT2006.Ana04ID, 
		OT2006.Ana05ID, 
		OT1002_1.AnaName as Ana01Name, 
		OT1002_2.AnaName as Ana02Name, 
		OT1002_3.AnaName as Ana03Name, 
		OT1002_4.AnaName as Ana04Name, 
		OT1002_5.AnaName as Ana05Name, 
		AT1103.FullName,

		AT1004.CurrencyName,
		OT2006.OrderType,
		OriginalAmount=(Select sum(isnull(OriginalAmount,0)) as OriginalAmount From OT2007 Where OT2007.VoucherID = OT2006.VoucherID),
 		ConvertedAmount=(Select sum(isnull(ConvertedAmount,0)) as ConvertedAmount From OT2007 Where OT2007.VoucherID = OT2006.VoucherID)'
		
Set @sSQL2 = 
N'	
From OT2006 
		left join AT1202 on AT1202.DivisionID = OT2006.DivisionID and AT1202.ObjectID = OT2006.ObjectID
		left join OT1002 OT1002_1 on OT1002_1.DivisionID = OT2006.DivisionID and OT1002_1.AnaID = OT2006.Ana01ID and OT1002_1.AnaTypeID = ''S01''
		left join OT1002 OT1002_2 on OT1002_2.DivisionID = OT2006.DivisionID and OT1002_2.AnaID = OT2006.Ana02ID and OT1002_2.AnaTypeID = ''S02''
		left join OT1002 OT1002_3 on OT1002_3.DivisionID = OT2006.DivisionID and OT1002_3.AnaID = OT2006.Ana03ID and OT1002_3.AnaTypeID = ''S03''
		left join OT1002 OT1002_4 on OT1002_4.DivisionID = OT2006.DivisionID and OT1002_4.AnaID = OT2006.Ana04ID and OT1002_4.AnaTypeID = ''S04''
		left join OT1002 OT1002_5 on OT1002_5.DivisionID = OT2006.DivisionID and OT1002_5.AnaID = OT2006.Ana05ID and OT1002_5.AnaTypeID = ''S05''		
		inner join AT1004 on AT1004.DivisionID = OT2006.DivisionID and AT1004.CurrencyID = OT2006.CurrencyID
		left join AT1103 on AT1103.DivisionID = OT2006.DivisionID and AT1103.EmployeeID = OT2006.EmployeeID
		left join OV1001 on OV1001.DivisionID = OT2006.DivisionID and OV1001.OrderStatus = OT2006.OrderStatus and OV1001.TypeID= ''AO''
				
Where OT2006.DivisionID like  ''' + @DivisionID + ''' and 
		OT2006.TranMonth + OT2006.TranYear*100 between ' + @FromPeriod + ' and ' + @ToPeriod


IF not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0024')
	Exec('Create View OV0024  ---tao boi OP0024
		 as '+@sSQL1+@sSQL2)
ELSE
	Exec('Alter View OV0024  ---tao boi OP0024
		 as '+@sSQL1+@sSQL2)

Set @sSQL1 = N'
Select	OT2007.DivisionID, 	
		OT2007.TransactionID, 
		OT2007.VoucherID, 
		OT2007.InventoryID, 
		OT2007.UnitID, 
		OT2007.AdjustQuantity, 
		OT2007.AdjustPrice, 
		OT2007.OriginalAmount, 
		OT2007.ConvertedAmount, 
		OT2007.IsPicking, 
		OT2007.WareHouseID, 
		OT2007.TDescription, 
		OT2007.RefOrderID, 
		OT2007.RefTransactionID, 
		OT2007.Ana01ID, 
		OT2007.Ana02ID, 
		OT2007.Ana03ID, 
		OT2007.Ana04ID, 
		OT2007.Ana05ID, 
		OT2007.Ana06ID, 
		OT2007.Ana07ID, 
		OT2007.Ana08ID, 
		OT2007.Ana09ID, 
		OT2007.Ana10ID, 
		OT2007.Orders,
		case when isnull(OT2007.InventoryCommonName, '''') = '''' then AT1302.InventoryName else 
		OT2007.InventoryCommonName end as InventoryName, 
		OT2007.InventoryCommonName,	
		case when isnull(OT2007.InventoryCommonName, '''') = '''' then 0 else 1 end as IsUpdate,
		AT1304.UnitName,
		OT2002.OrderQuantity,
		OT2002.SalePrice,
		OT2007.DataType '

Set @sSQL2 = N'
From OT2007 
		inner join OT2006 on OT2007.DivisionID = OT2006.DivisionID and OT2007.VoucherID = OT2006.VoucherID
		left join AT1302 on AT1302.DivisionID = OT2006.DivisionID and AT1302.InventoryID = OT2007.InventoryID
		left join AT1304 on AT1304.DivisionID = OT2006.DivisionID and AT1304.UnitID = OT2007.UnitID	
		left join OT2002 on OT2002.DivisionID = OT2006.DivisionID and OT2002.SOrderID = OT2007.RefOrderID and OT2002.TransactionID = OT2007.RefTransactionID 
	
Where OT2006.DivisionID like  ''' + @DivisionID + ''' and 
		OT2006.TranMonth + OT2006.TranYear*100 between ' + @FromPeriod + ' and ' + @ToPeriod

IF not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV0025')
	Exec('Create View OV0025  ---tao boi OP0024
		 as '+@sSQL1+@sSQL2)
ELSE
	Exec('Alter View OV0025  ---tao boi OP0024
		 as '+@sSQL1+@sSQL2)