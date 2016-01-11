
/****** Object:  StoredProcedure [dbo].[OP1310]    Script Date: 12/16/2010 11:08:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--VAN HUNG
---Created by:  Vo Thanh Huong, date: 30/12/2005
---purpose: In HOP DONG 

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP1310] @DivisionID nvarchar(50),
				@ContractNo nvarchar(50),
				@ContractDate datetime,
				@SOrderID nvarchar(50)			
 AS 
DECLARE @sSQL nvarchar(4000)

Set @sSQL = '
Select  OT2001.DivisionID,  	
		OT2001.SOrderID,  	
		OT2001.VoucherNo, 
		OT2001.ContractNo, 
		OT2001.ContractDate, 
		OT2001.ObjectID, 
		isnull(OT2001.ObjectName, AT1202.ObjectName) as ObjectName,
		AT1202.Address, 
		AT1202.Tel,
		AT1202.Fax,
		AT1202.Email,
		AT1202.BankName,
		AT1202.BankAccountNo,
		AT1202.Note1, --giam doc
		AT1202.Note,  --nguoi lien he
		AT1202.VatNo as VATNo,
		AT1101.DivisionName,
		AT1101.Address as DAddress,
		AT1101.Tel as DTel,
		AT1101.Fax as DFax,
		AT1101.Email as DEmail,
		AT1101.VATNo as DVatNo,
		AT1101.ContactPerson as DContactPerson,
		OT2002.Orders,
		OT2002.InventoryID,
		AT1302.InventoryName,
		AT1304.UnitName, 
		OT2002.OrderQuantity,
		OT2002.SalePrice,
		OT2002.VATPercent,
		isnull(OT2002.OriginalAmount, 0) as OriginalAmount,
		isnull(OT2002.ConvertedAmount,0) as ConvertedAmount,
		isnull(OT2002.VATOriginalAmount,0) as VATOriginalAmount,
		isnull(VATConvertedAmount,0) as VATConvertedAmount,
		OT2002.Description as TDescription	
From  OT2002 inner join OT2001   on  OT2002.SOrderID = OT2001.SOrderID 
		inner join AT1202 on  OT2001.ObjectID = AT1202.ObjectID 
		inner join AT1101 on  AT1101.DivisionID = ''' + @DivisionID + '''
		inner join AT1302 on  AT1302.InventoryID = OT2002.InventoryID
		inner join AT1304 on  AT1304.UnitID = OT2002.UnitID
WHERE OT2001.DivisionID = ''' + @DivisionID + ''' and 
		OT2001.SOrderID = ''' + @SOrderID + ''' and 
		ContractNo = ''' + @ContractNo + ''''


If not exists (Select Top 1 1 From sysObjects Where   XType = 'V' and Name = 'OV1310' )
	EXEC('CREATE VIEW OV1310 --tao boi OP1310 
			as ' + @sSQL)
ELSE 	
	EXEC('ALTER  VIEW OV1310 --tao boi OP1310 
			as ' + @sSQL)