IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7407_ST]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7407_ST]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------- Created by Nguyen Van Nhan, Date 27/08/2003
------- Purpose: In chi tiet Cong no phai tra
-----Edited by Nguyen Thi Ngoc Minh, Date 27/04/2004
-----Purpose: Cho phep chon loai ngay len bao cao theo ngay  va theo ky
-----Edited by Nguyen Quoc Huy, Date 26/07/2006
---- Modified on 27/10/2012 by Bao Anh: Bo sung TableID
---- Modified on 27/05/2013 by Lê Thị Thu Hiền : Bổ sung thêm Ana06ID --> Ana10ID
---- Modified on 13/11/2014 by Mai Duyen : Bổ sung thêm DatabaseName (tinh năng In báo cao chi tiet no phai tra 2 Database, KH SIEUTHANH)
---- Modified on 04/12/2014 by Mai Duyen : convert Ana

CREATE PROCEDURE [dbo].[AP7407_ST]  
				@DivisionID as nvarchar(50) ,
				@CurrencyID as nvarchar(50),
				@FromAccountID as nvarchar(50),
				@ToAccountID as nvarchar(50),
				@FromObjectID as nvarchar(50),
				@ToObjectID as nvarchar(50),	
				@SQLwhere as nvarchar(4000),
				@DatabaseName as nvarchar(250) =''
AS
Declare @sql as nvarchar(4000),
	@TableDBO as nvarchar(250)

If @DatabaseName  ='' 
	 Set @TableDBO=''
Else
	Set @TableDBO = '[' +  @DatabaseName + '].DBO.'
	
----  Phat sinh No
set @sql = '
	SELECT TransactionID,
		BatchID,
		VoucherID,
		TableID,
		D3.DivisionID,
		TranMonth,
		TranYear,
		''00'' as RPTransactionType, 
		TransactionTypeID, 
		ObjectID, 
		DebitAccountID as DebitAccountID,
		CreditAccountID as CreditAccountID, 
		DebitAccountID as AccountID,   
		VoucherNo,
		VoucherTypeID,
		VoucherDate,
		InvoiceNo,
		InvoiceDate,
		Serial, 
		VDescription,
		BDescription,
		isnull(TDescription, isnull(BDescription, VDescription)) as TDescription,
		'''' as  Ana01ID,
		'''' as  Ana02ID,
		'''' as  Ana03ID,
		'''' as  Ana04ID,
		'''' as  Ana05ID,
		'''' as  Ana06ID,
		'''' as  Ana07ID,
		'''' as  Ana08ID,
		'''' as  Ana09ID,
		'''' as  Ana10ID,
		D3.CurrencyIDCN,  
		ExchangeRate, 
		OriginalAmountCN as OriginalAmount,
		ConvertedAmount, 
		OriginalAmountCN as SignOriginalAmount,
		ConvertedAmount as SignConvertedAmount, 
		Status,
		CreateUserID,
		LastModifyUserID,
		CreateDate,
		LastModifyDate,
		Duedate	
	FROM ' + @TableDBO + 'AT9000 D3 
	WHERE D3.DebitAccountID in (SELECT AccountID FROM AT1005 WHERE GroupID = ''G04'' And DivisionID = ''' + @DivisionID + ''')  --- Thuoc nhom cong no phai tra
		and D3.DivisionID = '''+ @DivisionID + ''' 
		and	D3.TransactionTypeID <>''T00'' 
		and	D3.CurrencyIDCN like ''' + @CurrencyID+''' 	'

Set @SQL = @SQL +  @SQLwhere

if @FromObjectID <> '%'
	set @SQL= @SQL + '  and D3.ObjectID >= ''' + @FromObjectID + ''' and D3.ObjectID <=''' + @ToObjectID+ '''	'

 If @FromAccountID <> '%' 
	set @SQL= @SQL +' and D3.DebitAccountID >=''' + @FromAccountID + ''' and D3.DebitAccountID <= '''+ @ToAccountID + '''  '

Set @sql = @sql + 'UNION ALL 
	SELECT TransactionID,
		BatchID, 
		VoucherID,
		TableID,
		D3.DivisionID,
		TranMonth,
		TranYear,
		''01'' as RPTransactionType,
		TransactionTypeID, 
		Case when TransactionTypeID =''T99'' then CreditObjectID else ObjectID end As ObjectID,   
		DebitAccountID as DebitAccountID,
		CreditAccountID  as CreditAccountID, 
		CreditAccountID as AccountID,
		VoucherNo,
		VoucherTypeID,
		VoucherDate,
		InvoiceNo,
		InvoiceDate,
		Serial, 
		VDescription,
		BDescription,
		isnull(TDescription, isnull(BDescription, VDescription)) as TDescription,
		'''' as  Ana01ID,
		'''' as  Ana02ID,
		'''' as  Ana03ID,
		'''' as  Ana04ID,
		'''' as  Ana05ID,
		'''' as  Ana06ID,
		'''' as  Ana07ID,
		'''' as  Ana08ID,
		'''' as  Ana09ID,
		'''' as  Ana10ID,
		D3.CurrencyIDCN,
		ExchangeRate,
		OriginalAmountCN as OriginalAmount ,  ConvertedAmount, 
		OriginalAmountCN*(-1) as SignOriginalAmount ,  ConvertedAmount*(-1) as SignConvertedAmount,  --- Phat sinh Co		
		Status, 	CreateUserID, LastModifyUserID, CreateDate,LastModifyDate,Duedate
	From  ' + @TableDBO + 'AT9000 D3
	Where 	CreditAccountID in (Select AccountID From AT1005 WHere GroupID = ''G04'' And DivisionID=''' + @DivisionID + ''')   ---- Phat sinh Co
		and D3.DivisionID = ''' + @DivisionID + ''' 
		and	D3.TransactionTypeID <> ''T00''
		and	D3.CurrencyIDCN like ''' + @CurrencyID + ''' 	'

Set @SQL = @SQL +  @SQLwhere

if @FromObjectID <> '%'
	set @SQL= @SQL + ' and (Case when D3.TransactionTypeID =''T99'' Then  D3.CreditObjectID else  D3.ObjectID End) >= ''' + @FromObjectID + ''' and (Case when D3.TransactionTypeID = ''T99'' then D3.CreditObjectID else   D3.ObjectID End)  <=''' + @ToObjectID+ '''	'

If @FromAccountID <> '%' 
	set @SQL= @SQL + ' and D3.CreditAccountID >= ''' + @FromAccountID + ''' and D3.CreditAccountID <= '''+ @ToAccountID + '''  '


If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7407_ST]') and OBJECTPROPERTY(id, N'IsView') = 1)
     Exec ('  Create View AV7407_ST as ' + @SQL)
Else
     Exec ('  Alter View AV7407_ST  As ' + @SQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

