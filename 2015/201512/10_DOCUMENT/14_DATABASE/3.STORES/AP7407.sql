IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7407]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7407]
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
---- Modified on 10/09/2015 by Tiểu Mai: Bổ sung tên 10 MPT, 10 tham số Parameter.
--EXEC AP7407  @DivisionID='AS', @CurrencyID='VND', @FromAccountID=N'3311',@ToAccountID=N'357',@FromObjectID=N'CD0001',@ToObjectID=N'SD0003', @SQLwhere ='AND (D3.TranMonth + 100 * D3.TranYear BETWEEN     201508 AND     201508)'

CREATE PROCEDURE [dbo].[AP7407]  
				@DivisionID as nvarchar(50) ,
				@CurrencyID as nvarchar(50),
				@FromAccountID as nvarchar(50),
				@ToAccountID as nvarchar(50),
				@FromObjectID as nvarchar(50),
				@ToObjectID as nvarchar(50),	
				@SQLwhere as nvarchar(4000)
AS
Declare @sql as nvarchar(4000), @sql1 AS NVARCHAR(4000)
----  Phat sinh No
set @sql = '
	SELECT D3.TransactionID,
		BatchID,
		VoucherID,
		TableID,
		D3.DivisionID,
		TranMonth,
		TranYear,
		''00'' as RPTransactionType, 
		D3.TransactionTypeID, 
		D3.ObjectID, 
		D3.DebitAccountID as DebitAccountID,
		D3.CreditAccountID as CreditAccountID, 
		D3.DebitAccountID as AccountID,   
		D3.VoucherNo,
		D3.VoucherTypeID,
		D3.VoucherDate,
		D3.InvoiceNo,
		D3.InvoiceDate,
		D3.Serial, 
		D3.VDescription,
		D3.BDescription,
		isnull(D3.TDescription, isnull(D3.BDescription, D3.VDescription)) as TDescription,
		NULL Ana01ID,
		NULL Ana02ID,
		NULL Ana03ID,
		NULL Ana04ID,
		NULL Ana05ID,
		NULL Ana06ID,
		NULL Ana07ID,
		NULL Ana08ID,
		NULL Ana09ID,
		NULL Ana10ID,
		A1.AnaName AS Ana01Name,A2.AnaName AS Ana02Name,A3.AnaName AS Ana03Name,A4.AnaName AS Ana04Name,A5.AnaName AS Ana05Name,
		A6.AnaName AS Ana06Name,A7.AnaName AS Ana07Name,A8.AnaName AS Ana08Name,A9.AnaName AS Ana09Name,A10.AnaName AS Ana10Name,
		D3.CurrencyIDCN,  
		D3.ExchangeRate, 
		D3.OriginalAmountCN as OriginalAmount,
		D3.ConvertedAmount, 
		D3.OriginalAmountCN as SignOriginalAmount,
		D3.ConvertedAmount as SignConvertedAmount, 
		D3.Status,
		D3.CreateUserID,
		D3.LastModifyUserID,
		D3.CreateDate,
		D3.LastModifyDate,
		D3.Duedate,
		D3.Parameter01,D3.Parameter02,D3.Parameter03,D3.Parameter04,D3.Parameter05,D3.Parameter06,D3.Parameter07,D3.Parameter08,D3.Parameter09,D3.Parameter10
FROM AT9000 D3 
	LEFT JOIN AT1011 A1	 ON A1.DivisionID = D3.DivisionID  AND A1.AnaID = D3.Ana01ID  AND A1.AnaTypeID = ''A01''
	LEFT JOIN AT1011 A2	 ON A2.DivisionID = D3.DivisionID  AND A2.AnaID = D3.Ana02ID  AND A2.AnaTypeID = ''A02''
	LEFT JOIN AT1011 A3	 ON A3.DivisionID = D3.DivisionID  AND A3.AnaID = D3.Ana03ID  AND A3.AnaTypeID = ''A03''
	LEFT JOIN AT1011 A4	 ON A4.DivisionID = D3.DivisionID  AND A4.AnaID = D3.Ana04ID  AND A4.AnaTypeID = ''A04''
	LEFT JOIN AT1011 A5	 ON A5.DivisionID = D3.DivisionID  AND A5.AnaID = D3.Ana05ID  AND A5.AnaTypeID = ''A05''
	LEFT JOIN AT1011 A6	 ON A6.DivisionID = D3.DivisionID  AND A6.AnaID = D3.Ana06ID  AND A6.AnaTypeID = ''A06''
	LEFT JOIN AT1011 A7	 ON A7.DivisionID = D3.DivisionID  AND A7.AnaID = D3.Ana07ID  AND A7.AnaTypeID = ''A07''
	LEFT JOIN AT1011 A8	 ON A8.DivisionID = D3.DivisionID  AND A8.AnaID = D3.Ana08ID  AND A8.AnaTypeID = ''A08''
	LEFT JOIN AT1011 A9	 ON A9.DivisionID = D3.DivisionID  AND A9.AnaID = D3.Ana09ID  AND A9.AnaTypeID = ''A09''
	LEFT JOIN AT1011 A10 ON A10.DivisionID = D3.DivisionID AND A10.AnaID = D3.Ana10ID AND A10.AnaTypeID = ''A10''
	WHERE D3.DebitAccountID in (SELECT AccountID FROM AT1005 WHERE GroupID = ''G04'' And DivisionID = ''' + @DivisionID + ''')  --- Thuoc nhom cong no phai tra
		and D3.DivisionID = '''+ @DivisionID + ''' 
		and	D3.TransactionTypeID <>''T00'' 
		and	D3.CurrencyIDCN like ''' + @CurrencyID+''''
Set @SQL = @SQL +  @SQLwhere

if @FromObjectID <> '%'
	set @SQL= @SQL + '  and D3.ObjectID >= ''' + @FromObjectID + ''' and D3.ObjectID <=''' + @ToObjectID+ '''	'

 If @FromAccountID <> '%' 
	set @SQL= @SQL +' and D3.DebitAccountID >=''' + @FromAccountID + ''' and D3.DebitAccountID <= '''+ @ToAccountID + '''  '

Set @sql1 = 'UNION ALL 
	SELECT D3.TransactionID,
		BatchID, 
		VoucherID,
		TableID,
		D3.DivisionID,
		TranMonth,
		TranYear,
		''01'' as RPTransactionType,
		D3.TransactionTypeID, 
		Case when D3.TransactionTypeID =''T99'' then D3.CreditObjectID else D3.ObjectID end As ObjectID,   
		D3.DebitAccountID as DebitAccountID,
		D3.CreditAccountID  as CreditAccountID, 
		D3.CreditAccountID as AccountID,
		D3.VoucherNo,
		D3.VoucherTypeID,
		D3.VoucherDate,
		D3.InvoiceNo,
		D3.InvoiceDate,
		D3.Serial, 
		D3.VDescription,
		D3.BDescription,
		isnull(D3.TDescription, isnull(D3.BDescription, D3.VDescription)) as TDescription,
		NULL Ana01ID,
		NULL Ana02ID,
		NULL Ana03ID,
		NULL Ana04ID,
		NULL Ana05ID,
		NULL Ana06ID,
		NULL Ana07ID,
		NULL Ana08ID,
		NULL Ana09ID,
		NULL Ana10ID,
		A1.AnaName AS Ana01Name,A2.AnaName AS Ana02Name,A3.AnaName AS Ana03Name,A4.AnaName AS Ana04Name,A5.AnaName AS Ana05Name,
		A6.AnaName AS Ana06Name,A7.AnaName AS Ana07Name,A8.AnaName AS Ana08Name,A9.AnaName AS Ana09Name,A10.AnaName AS Ana10Name,
		D3.CurrencyIDCN,
		D3.ExchangeRate,
		D3.OriginalAmountCN as OriginalAmount ,  D3.ConvertedAmount, 
		D3.OriginalAmountCN*(-1) as SignOriginalAmount ,  D3.ConvertedAmount*(-1) as SignConvertedAmount,  --- Phat sinh Co		
		D3.Status, 	D3.CreateUserID, D3.LastModifyUserID, D3.CreateDate,D3.LastModifyDate,D3.Duedate,
		D3.Parameter01,D3.Parameter02,D3.Parameter03,D3.Parameter04,D3.Parameter05,D3.Parameter06,D3.Parameter07,D3.Parameter08,D3.Parameter09,D3.Parameter10
	From  AT9000 D3
	LEFT JOIN AT1011 A1	 ON A1.DivisionID = D3.DivisionID  AND A1.AnaID = D3.Ana01ID  AND A1.AnaTypeID = ''A01''
	LEFT JOIN AT1011 A2	 ON A2.DivisionID = D3.DivisionID  AND A2.AnaID = D3.Ana02ID  AND A2.AnaTypeID = ''A02''
	LEFT JOIN AT1011 A3	 ON A3.DivisionID = D3.DivisionID  AND A3.AnaID = D3.Ana03ID  AND A3.AnaTypeID = ''A03''
	LEFT JOIN AT1011 A4	 ON A4.DivisionID = D3.DivisionID  AND A4.AnaID = D3.Ana04ID  AND A4.AnaTypeID = ''A04''
	LEFT JOIN AT1011 A5	 ON A5.DivisionID = D3.DivisionID  AND A5.AnaID = D3.Ana05ID  AND A5.AnaTypeID = ''A05''
	LEFT JOIN AT1011 A6	 ON A6.DivisionID = D3.DivisionID  AND A6.AnaID = D3.Ana06ID  AND A6.AnaTypeID = ''A06''
	LEFT JOIN AT1011 A7	 ON A7.DivisionID = D3.DivisionID  AND A7.AnaID = D3.Ana07ID  AND A7.AnaTypeID = ''A07''
	LEFT JOIN AT1011 A8	 ON A8.DivisionID = D3.DivisionID  AND A8.AnaID = D3.Ana08ID  AND A8.AnaTypeID = ''A08''
	LEFT JOIN AT1011 A9	 ON A9.DivisionID = D3.DivisionID  AND A9.AnaID = D3.Ana09ID  AND A9.AnaTypeID = ''A09''
	LEFT JOIN AT1011 A10 ON A10.DivisionID = D3.DivisionID AND A10.AnaID = D3.Ana10ID AND A10.AnaTypeID = ''A10''
	Where 	D3.CreditAccountID in (Select AccountID From AT1005 WHere GroupID = ''G04'' And DivisionID=''' + @DivisionID + ''')   ---- Phat sinh Co
		and D3.DivisionID = ''' + @DivisionID + ''' 
		and	D3.TransactionTypeID <> ''T00''
		and	D3.CurrencyIDCN like ''' + @CurrencyID + ''' 	'

Set @SQL1 = @SQL1 +  @SQLwhere

if @FromObjectID <> '%'
	set @SQL1= @SQL1 + ' and (Case when D3.TransactionTypeID =''T99'' Then  D3.CreditObjectID else  D3.ObjectID End) >= ''' + @FromObjectID + ''' and (Case when D3.TransactionTypeID = ''T99'' then D3.CreditObjectID else   D3.ObjectID End)  <=''' + @ToObjectID+ '''	'

If @FromAccountID <> '%' 
	set @SQL1= @SQL1 + ' and D3.CreditAccountID >= ''' + @FromAccountID + ''' and D3.CreditAccountID <= '''+ @ToAccountID + '''  '

--PRINT (@sql + @sql1)
If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7407]') and OBJECTPROPERTY(id, N'IsView') = 1)
     Exec ('  Create View AV7407 as ' + @SQL+@sql1)
Else
     Exec ('  Alter View AV7407  As ' + @SQL+@sql1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

