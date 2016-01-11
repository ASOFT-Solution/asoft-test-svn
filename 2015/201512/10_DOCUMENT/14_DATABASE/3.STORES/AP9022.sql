/****** Object:  StoredProcedure [dbo].[AP9022]    Script Date: 08/02/2010 15:07:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
---- Created by Nguyen Thi Ngoc Minh
---- Date 24/08/2004
---- Purpose: Loc ra cac phieu mau (template)


/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP9022] 	
	@DivisionID as nvarchar(50)

 AS
Declare @sSQL as nvarchar(4000)

Set @sSQL=N'
Select distinct	AT9002.DivisionID, AT9002.TemplateID, AT9002.TemplateVoucherID, AT9002.TemplateBatchID,
	AT9002.TemplateTransactionID, AT9002.Description, IsStockVoucher, 
	AT9002.ObjectID, T02.ObjectName, AT9002.CreditObjectID, T12.ObjectName as CreditObjectName,
	VATObjectID, VATObjectName, 
	ExchangeRate, DiscountRate,
	isnull(Quantity,0) as Quantity,
	isnull(OriginalAmount,0) as OriginalAmount,
	isnull(ConvertedAmount,0) as ConvertedAmount,
	VoucherTypeID, AT9002.EmployeeID, 
	SenderReceiver, SRDivisionName, SRAddress, VDescription, 
	AT9002.WareHouseID, AT1303.WareHouseName,
	WE.WareHouseName as WareHouseName2, AT9002.WareHouseID2
From AT9002 	left join AT1202 T02 on T02.ObjectID = AT9002.ObjectID and T02.DivisionID = AT9002.DivisionID
		left join AT1202 T12 on T12.ObjectID = AT9002.CreditObjectID and T12.DivisionID = AT9002.DivisionID
		left join AT1303 on AT9002.WareHouseID = AT1303.WarehouseID and AT9002.DivisionID = AT1303.DivisionID
		left join AT1303 as WE on AT9002.WareHouseID2 = WE.WarehouseID and AT9002.DivisionID = WE.DivisionID
Where 	AT9002.DivisionID ='''+@DivisionID+''''

--Print @sSQL

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV9022')
	Exec('Create View AV9022 	--Created by AP9022
			as '+@ssql)
Else
	Exec('Alter View AV9022 	--Created by AP9022
			as '+@ssql)