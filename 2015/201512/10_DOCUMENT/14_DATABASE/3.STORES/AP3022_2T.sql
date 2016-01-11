IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3022_2T]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3022_2T]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Khanh Van
--Date 28/08/2013
--Purpose: In bao cao chi tiet doanh so ban hang theo doi tuong cho 2T, thêm vào ConvertedQuantity



CREATE PROCEDURE [dbo].[AP3022_2T] 
	@DivisionID as nvarchar(50) ,
	@sSQLWhere as nvarchar(max)  
as
declare @sSQL1 as nvarchar(max),
		@sSQL2 as nvarchar(max),
		@sSQL3 as nvarchar(max)
		
set @sSQL1=N'
	SELECT  AT1202.ObjectID,
			AT1202.ObjectName,
			AT1202.Address,
			AT1202.LegalCapital,
			AT1202.Note,
			AT1202.Note1,
			AT9000.InventoryID,
			Case when isnull(AT9000.InventoryName1,'''')= '''' then  isnull(AT1302.InventoryName,'''')  Else AT9000.InventoryName1 end as InventoryName,
			AT1302.UnitID,
			AT1304.UnitName,
	       	AT9000.Serial,
			AT9000.InvoiceNo,
			AT9000.VoucherID,
			AT9000.VoucherNo,
			AT9000.InvoiceDate,
			AT9000.VoucherDate,
			isnull(AT9000.Quantity,0) as Quantity,
			isnull(AT9000.ConvertedQuantity,0) as ConvertedQuantity,
			isnull(AT9000.MarkQuantity,0) as MarkQuantity,
			AT9000.CurrencyID,
			AT9000.UnitPrice,
			isnull(AT9000.OriginalAmount,0)/(Case when isnull(AT9000.Quantity,0)=0 then 1 else AT9000.Quantity end) as SalePrice01,
			isnull(AT9000.ConvertedAmount,0)/(Case when isnull(AT9000.Quantity,0)=0 then 1 else AT9000.Quantity end) as SalePrice02,
			isnull(AT9000.OriginalAmount,0) as OriginalAmount,
			isnull(AT9000.ConvertedAmount,0) as ConvertedAmount, VATRate,  
			Isnull(AT9000.VATOriginalAmount,0) as VATOriginalAmount,
			Isnull(AT9000.VATConvertedAmount,0) as VATConvertedAmount,
			(Isnull (AT9000.UnitPrice,0) * Isnull (VATRate,0))/100  + Isnull(AT9000.UnitPrice,0) as VATUnitPrice,
			(Select Sum(Isnull (T9.OriginalAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'')  as VATOriginalAmountForInvoice,
			(Select Sum(Isnull (T9.ConvertedAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'')  as VATConvertedAmountForInvoice,
			isnull(AT2007.UnitPrice,0) as PrimeCostPrice,
			isnull(AT2007.ConvertedAmount,0) as PrimeCostAmount,
			AT9000.DebitAccountID,
			AT9000.CreditAccountID,
			AT9000.VDescription, AT9000.BDescription, AT9000.TDescription, AT9000.Duedate,
					'
set @sSQL2=N'
			
			AT9000.VoucherTypeID, AT9000.DiscountRate, AT9000.DiscountAmount, AT9000.DivisionID,
			AT2007.Parameter01,AT2007.Parameter02,AT2007.Parameter03,AT2007.Parameter04,
			AT2007.Parameter05,AT9000.UParameter01,AT9000.UParameter02,AT9000.UParameter03,AT9000.UParameter04,AT9000.UParameter05,AT2007.Notes01, AT2007.Notes02, AT2007.Notes03, AT2007.Notes04, AT2007.Notes05, AT2007.Notes06, AT2007.Notes07, AT2007.Notes08, AT2007.Notes09, AT2007.Notes10, AT2007.Notes11, AT2007.Notes12, AT2007.Notes13, AT2007.Notes14, AT2007.Notes15, AT2007.SourceNo,
			AT9000.RefNo01, AT9000.RefNo02,
			(Select Count(ObjectID) From AT1202 A Where A.O02ID = AT1202.O02ID) As FieldName, 
			AT1302.InventoryTypeID, AT2006.WareHouseID, AT1303.WareHouseName, AT9000.IsMultiTax, isnull(V00.ConvertedAmount,0) as Commission 

	FROM AT9000 	
	LEFT JOIN AT1302 on AT9000.InventoryID=AT1302.InventoryID and AT9000.DivisionID=AT1302.DivisionID
   	LEFT JOIN AT1202 on AT9000.ObjectID=AT1202.ObjectID	 and AT9000.DivisionID=AT1202.DivisionID
	LEFT JOIN AT1304 on AT1304.UnitID = AT1302.UnitID and AT9000.DivisionID=AT1304.DivisionID
	LEFT JOIN AT1010 on AT1010.VATGroupID = AT9000.VATGroupID and AT9000.DivisionID=AT1010.DivisionID
	Left JOIN AT2007 ON AT9000.DivisionID = AT2007.DivisionID AND AT9000.VoucherID = AT2007.VoucherID and AT9000.InventoryID = AT2007.InventoryID and AT9000.Orders = AT2007.Orders	
	Left Join (Select * from AT9000 where TransactionTypeID = ''T54'') V00 ON AT9000.DivisionID = V00.DivisionID AND AT9000.VoucherID = V00.VoucherID and AT9000.InventoryID = V00.InventoryID and AT9000.Orders = V00.Orders
	'
set @sSQL3=N'

	LEFT JOIN AT2006 on (AT9000.VoucherID = AT2006.VoucherID Or AT9000.WOrderID = AT2006.VoucherID) And AT9000.DivisionID = AT2006.DivisionID
	LEFT JOIN AT1303 on AT2006.WareHouseID = AT1303.WareHouseID And AT2006.DivisionID = AT1303.DivisionID
	/*Lay truc tiep thue thue row
	LEFT JOIN (	SELECT	DivisionID, VoucherID, BatchID, OriginalAmount AS VATOriginalAmount, ConvertedAmount AS VATConvertedAmount
				FROM	AT9000 A
	           	WHERE	A.DivisionID = '''+@DivisionID+'''
	           			AND A.TransactionTypeID = ''T14''
				) VAT
		ON		VAT.DivisionID = AT9000.DivisionID AND VAT.VoucherID = AT9000.VoucherID 
				AND VAT.BatchID = AT9000.BatchID
	*/			
	WHERE	AT9000.DivisionID='''+@DivisionID+'''
			and AT9000.TransactionTypeID in (''T04'',''T40'')
			and '+@sSQLWhere+''

PRINT(@sSQL1)
PRINT(@sSQL2)
PRINT(@sSQL3)
IF  EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE NAME = 'AV3025' AND XTYPE ='V')
	DROP VIEW AV3025
EXEC ('CREATE VIEW AV3025 --tao boi AP3022_2T
			 as '+@sSQL1+@sSQL2+@sSQL3)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON