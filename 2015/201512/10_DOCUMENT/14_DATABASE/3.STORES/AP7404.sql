IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7404]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP7404]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




------- Created by Nguyen Van Nhan, Date 27/08/2003
------- Purpose: In chi tiet Cong no phai thu
-----Edited by Nguyen Thi Ngoc Minh, Date 27/04/2004
-----Purpose: Cho phep chon loai ngay len bao cao theo ngay  va theo ky
-----Edited by Nguyen Quoc Huy, Date 26/07/2006
--- Edited by Bao Anh	Date: 25/10/2012	Bo sung TableID
---- Modified on 27/05/2013 by Lê Thị Thu Hiền : Bổ sung thêm Ana06ID --> Ana10ID
---- Modified by Tieu Mai on 08/12/2015: Bo sung 10 tham so parameter

CREATE PROCEDURE [dbo].[AP7404]  
				@DivisionID as nvarchar(50) ,
				@CurrencyID as nvarchar(50),
				@FromAccountID as nvarchar(50),
				@ToAccountID as nvarchar(50),
				@FromObjectID as nvarchar(50),
				@ToObjectID as nvarchar(50),
				@SQLwhere as nvarchar(500)
AS
Declare @sql as nvarchar(MAX)
------ Phat sinh No
set @sql = '
SELECT TransactionID,
	D3.BatchID, 
	D3.VoucherID,
	D3.DivisionID,
	D3.TranMonth,
	D3.TranYear,
	''00'' as RPTransactionType,
	D3.TransactionTypeID, 
	D3.ObjectID, 
	DebitAccountID as DebitAccountID,
	CreditAccountID as CreditAccountID, 
	DebitAccountID as AccountID,   
	D3.VoucherNo, 
	D3.VoucherTypeID,
	VoucherDate,
	InvoiceNo,
	InvoiceDate,
	Serial,
	D3.DueDate,
	VDescription,
	BDescription,
	TDescription, 
	D3.Ana01ID,
	D3.Ana02ID,
	D3.Ana03ID,
	D3.Ana04ID,
	D3.Ana05ID,
	D3.Ana06ID,
	D3.Ana07ID,
	D3.Ana08ID,
	D3.Ana09ID,
	D3.Ana10ID,
	D3.CurrencyIDCN as CurrencyID,
	D3.ExchangeRate, 
	OriginalAmountCN as OriginalAmount,
	D3.ConvertedAmount, 
	OriginalAmountCN as SignOriginalAmount,
	D3.ConvertedAmount as SignConvertedAmount, 
	Status, 
	D3.CreateUserID,
	D3.LastModifyUserID,
	D3.CreateDate,
	D3.LastModifyDate,
	D3.OrderID,
	OT2001.Orderdate,
	D3.TableID,
	D3.Parameter01, D3.Parameter02,
	D3.Parameter03, D3.Parameter04,
	D3.Parameter05, D3.Parameter06,
	D3.Parameter07, D3.Parameter08,
	D3.Parameter09, D3.Parameter10
FROM AT9000 D3 -- inner  join AT1005 on D3.DebitAccountID = AT1005.AccountID
left  join OT2001 on OT2001.SorderID = D3.OrderID and OT2001.DivisionID = D3.DivisionID
WHERE  D3.DebitAccountID in (Select AccountID from AT1005 Where GroupID =''G03'') and  --- Thuoc nhom cong no phai thu
		D3.DivisionID = ''' +  @DivisionID + ''' 
		and	D3.TransactionTypeID <> ''T00''
		and	D3.CurrencyIDCN like ''' + @CurrencyID+''' '
		
Set @SQL = @SQL +  @SQLwhere

if @FromObjectID <> '%'
	set @SQL= @SQL + ' and D3.ObjectID >= ''' + @FromObjectID + ''' and D3.ObjectID <= ''' + @ToObjectID + ''''

 If @FromAccountID <> '%' 
	set @SQL= @SQL + ' and D3.DebitAccountID >=''' + @FromAccountID + ''' and D3.DebitAccountID<= '''+ @ToAccountID + '''  '

Set @sql = @sql + 'UNION ALL 
	SELECT TransactionID,
		BatchID,
		D3.VoucherID,
		D3.DivisionID, 
		D3.TranMonth, 
		D3.TranYear,
		''01'' as RPTransactionType, 
		TransactionTypeID, 
		(Case When D3.TransactionTypeID = ''T99'' then CreditObjectID else D3.ObjectID End) as ObjectID,     
		DebitAccountID as DebitAccountID,
		CreditAccountID  as CreditAccountID, 
		CreditAccountID as AccountID,
		D3.VoucherNo, 
		D3.VoucherTypeID, 
		VoucherDate,
		InvoiceNo,
		InvoiceDate,
		Serial,
		D3.DueDate,
		VDescription,
		BDescription,
		TDescription,
		D3.Ana01ID,
		D3.Ana02ID,
		D3.Ana03ID,
		D3.Ana04ID,
		D3.Ana05ID,
		D3.Ana06ID,
		D3.Ana07ID,
		D3.Ana08ID,
		D3.Ana09ID,
		D3.Ana10ID,
		D3.CurrencyIDCN as CurrencyID,
		D3.ExchangeRate,
		OriginalAmountCN as OriginalAmount,
		D3.ConvertedAmount, 
		OriginalAmountCN * (-1) as SignOriginalAmount,
		D3.ConvertedAmount * (-1) as SignConvertedAmount,  --- Phat sinh Co		
		Status,
		D3.CreateUserID,
		D3.LastModifyUserID,
		D3.CreateDate,
		D3.LastModifyDate,
		D3.OrderID,
		OT2001.Orderdate,
		D3.TableID,
		D3.Parameter01, D3.Parameter02,
		D3.Parameter03, D3.Parameter04,
		D3.Parameter05, D3.Parameter06,
		D3.Parameter07, D3.Parameter08,
		D3.Parameter09, D3.Parameter10
FROM  AT9000 D3 
Left  join OT2001 on OT2001.SorderID = D3.OrderID and OT2001.DivisionID = D3.DivisionID
Where CreditAccountID in (Select AccountID From AT1005 WHere GroupID =''G03'') and  ---- Phat sinh Co		
	D3.DivisionID = '''+ @DivisionID + ''' 
	and	D3.TransactionTypeID <>''T00'' 
	and	D3.CurrencyIDCN like '''+@CurrencyID+''' 	
	'

Set @SQL = @SQL +  @SQLwhere

if @FromObjectID <> '%'
	set @SQL= @SQL + ' and (Case when D3.TransactionTypeID = ''T99'' Then D3.CreditObjectID else D3.ObjectID End) >= ''' + @FromObjectID + ''' and (Case when D3.TransactionTypeID =''T99'' then D3.CreditObjectID else D3.ObjectID End)  <=''' + @ToObjectID+ ''''

 If @FromAccountID <> '%' 
	set @SQL= @SQL + ' and D3.CreditAccountID >=''' + @FromAccountID + ''' and D3.CreditAccountID<= '''+ @ToAccountID + '''  '

--Print @SQL
If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7404]') and OBJECTPROPERTY(id, N'IsView') = 1)
     Exec ('  Create View AV7404 as ' + @SQL)
Else
     Exec ('  Alter View AV7404  As ' + @SQL)




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
