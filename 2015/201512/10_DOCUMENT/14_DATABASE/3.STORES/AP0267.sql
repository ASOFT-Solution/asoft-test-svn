IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0267]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0267]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bao Anh	Date: 17/09/2012
---- Purpose: Loc danh sach phieu tam chi qua ngan hang
-- <Example> AP0267 'AS',1,2012,1,2012,'01/01/2012','01/31/2012',0,'%','T22',''
 
CREATE PROCEDURE AP0267
( 
		@DivisionID AS VARCHAR(20),
		@FromMonth int,
	    @FromYear int,
	    @ToMonth int,
	    @ToYear int,  
	    @FromDate as datetime,
	    @ToDate as Datetime,
	    @IsDate as tinyint, ----0 theo ky, 1 theo ngày
	    @ObjectID nvarchar(50),
	    @TransactionTypeID as nvarchar(50),
	    @VoucherID nvarchar(50) --- Addnew: truyen ''; Edit:  so chung tu vua duoc chon sua
) 
AS 

DECLARE @sSQL AS VARCHAR(8000),
		@sWhere  as nvarchar(4000)	

IF @IsDate = 0
	Set  @sWhere = '
	And  TranMonth+TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ' '
else
	Set  @sWhere = '
	And VoucherDate Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''''

SET @sSQL = '	
	SELECT	CONVERT(tinyint, 0) AS Choose, VoucherID, BatchID, TransactionID, Orders, VoucherNo, VoucherDate, DueDate,
			T90.ObjectID, (Case when  isnull(AT1202.IsUpdateName,0) <> 0 then VATObjectName else AT1202.ObjectName end) as ObjectName,
			isnull(AT1202.IsUpdateName,0) as IsUpdateName, VoucherTypeID, T90.EmployeeID, AT1103.FullName as EmployeeName,
			SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02, CreditBankAccountID, DebitBankAccountID,
			AT1016.BankName as CreditBankAccountName, AT1016.BankAccountNo, AT1016.AccountID,
			T90.CurrencyID, ExchangeRate, VDescription, Serial, InvoiceNo, InvoiceDate, DebitAccountID, CreditAccountID,
			OriginalAmount, ConvertedAmount, VATObjectID, VATObjectName, VATObjectAddress,
			(Case when  isnull(AT1202.IsUpdateName,0) <> 0 then T90.VATNo else AT1202.VATNo  end) as VATNo, VATTypeID, T90.VATGroupID,
			BDescription,TDescription, T90.OrderID, T90.PeriodID, M01.Description as PeriodName, OTransactionID, ProductID, AT1302.InventoryName as ProductName,
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID
			
	FROM		AT9010 T90
	LEFT JOIN	AT1202 on T90.ObjectID = AT1202.ObjectID And T90.DivisionID = AT1202.DivisionID
	LEFT JOIN	AT1103 on T90.EmployeeID = AT1103.EmployeeID And T90.DivisionID = AT1103.DivisionID
	LEFT JOIN	AT1016 on T90.CreditBankAccountID = AT1016.BankAccountID And T90.DivisionID = AT1016.DivisionID
	LEFT JOIN	AT1302 on T90.ProductID = AT1302.InventoryID And T90.DivisionID = AT1302.DivisionID
	LEFT JOIN	MT1601 M01 on M01.PeriodID = T90.PeriodID and M01.DivisionID = T90.DivisionID
	
	WHERE		T90.DivisionID = ''' + @DivisionID + '''
				AND T90.ObjectID like ''' + @ObjectID + '''
				AND Isnull(T90.Status,0) = 1 AND TransactionTypeID = ''' + @TransactionTypeID + '''
				AND Isnull(T90.ReVoucherID,'''') = '''''
				+ @sWhere

if isnull(@VoucherID,'') <> ''	--- khi load edit	
	SET @sSQL = @sSQL + ' UNION	
		SELECT	CONVERT(tinyint, 1) AS Choose, VoucherID, BatchID, TransactionID, Orders, VoucherNo, VoucherDate, DueDate,
			T90.ObjectID, (Case when  isnull(AT1202.IsUpdateName,0) <> 0 then VATObjectName else AT1202.ObjectName end) as ObjectName,
			isnull(AT1202.IsUpdateName,0) as IsUpdateName, VoucherTypeID, T90.EmployeeID, AT1103.FullName as EmployeeName,
			SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02, CreditBankAccountID, DebitBankAccountID,
			AT1016.BankName as CreditBankAccountName, AT1016.BankAccountNo, AT1016.AccountID,
			T90.CurrencyID, ExchangeRate, VDescription, Serial, InvoiceNo, InvoiceDate, DebitAccountID, CreditAccountID,
			OriginalAmount, ConvertedAmount, VATObjectID, VATObjectName, VATObjectAddress,
			(Case when  isnull(AT1202.IsUpdateName,0) <> 0 then T90.VATNo else AT1202.VATNo  end) as VATNo, VATTypeID, T90.VATGroupID,
			BDescription,TDescription, T90.OrderID, T90.PeriodID, M01.Description as PeriodName, OTransactionID, ProductID, AT1302.InventoryName as ProductName,
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID
				
		FROM		AT9010 T90
 		LEFT JOIN	AT1202 on T90.ObjectID = AT1202.ObjectID And T90.DivisionID = AT1202.DivisionID
 		LEFT JOIN	AT1103 on T90.EmployeeID = AT1103.EmployeeID And T90.DivisionID = AT1103.DivisionID
 		LEFT JOIN	AT1016 on T90.CreditBankAccountID = AT1016.BankAccountID And T90.DivisionID = AT1016.DivisionID
 		LEFT JOIN	AT1302 on T90.ProductID = AT1302.InventoryID And T90.DivisionID = AT1302.DivisionID
 		LEFT JOIN	MT1601 M01 on M01.PeriodID = T90.PeriodID and M01.DivisionID = T90.DivisionID
 		
 		WHERE		T90.DivisionID = ''' + @DivisionID + ''' AND T90.ReVoucherID = ''' + @VoucherID + ''''
 		
SET @sSQL = @sSQL + ' Order by VoucherDate, VoucherID, Orders'

---print @sSQL			
EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

