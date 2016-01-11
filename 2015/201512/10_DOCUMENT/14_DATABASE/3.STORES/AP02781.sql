IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP02781]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP02781]
GO
------ Created by Khanh Van, Date 06/01/2014.  
------ Doanh so ban hang lay gia von chi nhanh chinh - customize cho Sieu Thanh
 ----- Exec  AP02781 'STH', 'KBH','','', 1,2013,1,2013,0,'CHN'
CREATE PROCEDURE [dbo].[AP02781]  
  @OriginalDivisionID AS nvarchar(50),  
  @WarehouseID AS nvarchar(50), 
  @FromDate AS datetime,  
  @ToDate AS datetime,  
  @FromMonth AS int,  
  @FromYear AS int,  
  @ToMonth AS int,  
  @ToYear AS int,  
  @IsDate AS int,  
  @BrandDivisionID AS nvarchar(50) 
 
as  
DECLARE  
 @sSQL AS nvarchar(4000),  
 @sSQL1 AS nvarchar(4000),  
 @sSQL2 AS nvarchar(4000),  
 @sWhere AS nvarchar(4000), 
 @sSQLWhere AS nvarchar(4000),  
 @FromPeriod AS int,  
 @ToPeriod AS int  
 
SET  @sWhere =N''
If @IsDate = 1 -- theo ngay 
Begin
	SET @FromPeriod =(Month(@FromDate)+Year(@FromDate)*100)  
	SET @ToPeriod=(Month(@ToDate)+Year(@ToDate)*100)  
End
Else
Begin
	SET @FromPeriod =(@FromMonth+@FromYear*100)  
	SET @ToPeriod=(@ToMonth+@ToYear*100)  
End 
If @IsDate = 1 -- theo ngay  
 Set @sSQLWhere ='CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.VoucherDate,101),101) BETWEEN  '''+convert(nvarchar(10),@FromDate,101)+''' AND '''+convert(nvarchar(10),@ToDate,101)+''''  
Else  -- theo ky  
  Set @sSQLWhere ='AT9000.TranMonth + AT9000.TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+' '  
--- Lấy giá vốn

Set @sSQL = N'Select InventoryID, isnull(UnitPrice,0) as OriginalPrice, TranMonth, TranYear 
			Into #Temp
			From AT2008 
			where DivisionID ='''+@OriginalDivisionID+'''
			and TranMonth+TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+' 
			and WarehouseID ='''+@WarehouseID+'''
			'
set @sSQL1=N'
SELECT  AT9000.InventoryID,
		AT1302.InventoryName,
		CASE WHEN ISNULL(AT9000.InventoryName1,'''')= '''' then  isnull(AT1302.InventoryName,'''')  Else AT9000.InventoryName1 end AS InventoryName1,
		AT1302.UnitID,
		AT1302.S1,
		AT1302.S2,
		AT1302.S3,
		AT1304.UnitName,
	    AT9000.Serial,
		AT9000.ObjectID,
		AT1202.ObjectName,
		AT9000.VATObjectID,
		OB.ObjectName AS VATObjectName,
		AT1202.Address,
		AT9000.InvoiceNo,
		AT9000.VoucherDate,
		AT9000.VoucherNo,
		AT9000.DebitAccountID,
		AT9000.CreditAccountID,
		AT9000.InvoiceDate,
		AT9000.Quantity,
		isnull(OriginalPrice,0) as OriginalPrice,
		AT9000.UnitPrice,
		AT2008.UnitPrice as DivisionPrice,
		AT9000.CurrencyID,
		AT9000.OriginalAmount,
		AT9000.ConvertedAmount , VATRate,
		AT9000.Ana01ID,   AT9000.Ana02ID, AT9000.Ana03ID, AT9000.Ana04ID, AT9000.Ana05ID,
		AT9000.VDescription, AT9000.BDescription, AT9000.TDescription,
		(Isnull (AT9000.OriginalAmount,0) * Isnull (VATRate,0))/100  AS VATOriginalAmount,
		(Isnull (AT9000.ConvertedAmount,0) * Isnull (VATRate,0))/100  AS VATConvertedAmount,
		(Isnull (AT9000.UnitPrice,0) * Isnull (VATRate,0))/100  + Isnull(AT9000.UnitPrice,0) AS VATUnitPrice,
		(SELECT Sum(Isnull (T9.OriginalAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'' and T9.DivisionID = AT9000.DivisionID)  AS VATOriginalAmountForInvoice,
		(SELECT Sum(Isnull (T9.ConvertedAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'' and T9.DivisionID = AT9000.DivisionID)  AS VATConvertedAmountForInvoice,
		AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID,
		I1.AnaName AS I01Name, I2.AnaName AS I02Name, I3.AnaName AS I03Name, I4.AnaName AS I04Name, I5.AnaName AS I05Name,
		AT9000.VoucherTypeID, AT9000.DiscountRate, AT9000.DiscountAmount, AT9000.DivisionID,
		AT9000.UParameter01, AT9000.UParameter02, AT9000.UParameter03, AT9000.UParameter04, AT9000.UParameter05,
		AT1302.IsStocked, AT2006.VoucherNo As WVoucherNo 
		'

set @sSQL2=N'
FROM AT9000 	
LEFT JOIN AT1302 on AT9000.InventoryID=AT1302.InventoryID and AT9000.DivisionID=AT1302.DivisionID
LEFT JOIN AT1015 I1 On AT1302.I01ID = I1.AnaID And I1.AnaTypeID = ''I01''  and AT9000.DivisionID=I1.DivisionID
LEFT JOIN AT1015 I2 On AT1302.I02ID = I2.AnaID And I2.AnaTypeID = ''I02''  and AT9000.DivisionID=I2.DivisionID
LEFT JOIN AT1015 I3 On AT1302.I03ID = I3.AnaID And I3.AnaTypeID = ''I03''  and AT9000.DivisionID=I3.DivisionID
LEFT JOIN AT1015 I4 On AT1302.I04ID = I4.AnaID And I4.AnaTypeID = ''I04''  and AT9000.DivisionID=I4.DivisionID
LEFT JOIN AT1015 I5 On AT1302.I05ID = I5.AnaID And I5.AnaTypeID = ''I05''  and AT9000.DivisionID=I5.DivisionID

LEFT JOIN AT1304 on AT1302.UnitID=AT1304.UnitID  and AT9000.DivisionID=AT1304.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID = AT9000.ObjectID  and AT9000.DivisionID=AT1202.DivisionID
LEFT JOIN AT1202 OB on OB.ObjectID = AT9000.VATObjectID  and AT9000.DivisionID=OB.DivisionID
LEFT JOIN AT1010 on AT1010.VATGroupID = AT9000.VATGroupID  and AT9000.DivisionID=AT1010.DivisionID
LEFT JOIN AT2006 on isnull(AT9000.WOrderID,0) = isnull(AT2006.VoucherID,0)  and AT9000.DivisionID=AT2006.DivisionID  
LEFT JOIN #Temp T on T.InventoryID = AT9000.InventoryID and T.TranMonth= AT9000.TranMonth and T.TranYear = AT9000.TranYear
LEFT JOIN AT2008 on AT2008.DivisionID = AT9000.DivisionID and AT2008.InventoryID = AT9000.InventoryID and AT2008.TranMonth = AT9000.TranMonth and AT2008.TranYear = AT9000.TranYear
WHERE	AT9000.DivisionID='''+@BrandDivisionID+'''
		AND AT9000.TransactionTypeID in  (''T04'',''T40'') and AT2008.WarehouseID =''KBH''
'

IF ISNULL(@sSQLWhere,'') <> ''
SET @sWhere = N' 
		AND '+@sSQLWhere+''
		

EXEC (@sSQL+@sSQL1 +@sSQL2 + @sWhere)
