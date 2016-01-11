IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3041]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3041]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


----- In phieu thu: Mau so 2
----- Created by Nguyen Van Nhan, Date 09/11/2007
----- Edit by B.Anh, Date 21/04/2008, Purpose: Lay them truong ObjectID
----- Edit by B.Anh, date 18/08/2009, Purpose: Bo sung cho truong hop chi qua ngan hang
----- Edit by: Dang Le Bao Quynh; Date 27/08/09
----- Purpose: Them 5 ma phan tich
---- Edit by B.Anh, date 27/01/2010	Sua loi thanh tien khong dung
---- Edit by Thien Huynh, date 29/11/2011 Khong Where theo @BatchID nua
--- Vi khong luu BatchID = VoucherID nua ma Sinh BatchID theo tung Hoa don tren luoi
---- Modified on 12/04/2013 by Le Thi Thu Hien : Bo sung AT9000.Serial, AT9000.InvoiceNo, AT9000.InvoiceDate
---- Modified on 13/05/2013 by Le Thi Thu Hien : Bo sung objectName
---- Modified on 13/05/2013 by 
-- <Example>
---- EXEC AP3041 'AS', 1, 2012, 'A', 'B'

CREATE PROCEDURE [dbo].[AP3041] 
				@DivisionID AS nvarchar(50),
				@TranMonth AS int,
				@TranYear AS int,
				@VoucherID AS nvarchar(50),
				@BatchID AS nvarchar(50)
	
 AS
Declare @sSQL AS nvarchar(4000),
	@AT9000Cursor AS cursor,
	@InvoiceNo AS nvarchar(50),
	@Serial AS nvarchar(50),
	@InvoiceNoList AS nvarchar(500),
	@DebitAccountList AS nvarchar(500),
	@DebitAccountID  AS nvarchar(50),
	@CreditAccountList AS nvarchar(500),
	@CreditAccountID  AS nvarchar(50),
	@InvoiceDate nvarchar(10)

Set @sSQL ='
SELECT	A.VoucherID, A.DivisionID, 
		A.TranMonth, A.TranYear, 
		A.Orders,			A.VoucherTypeID,		A.VoucherNo,		A.VoucherDate,
		A.VDescription,		A.TDescription,			A.BDescription,
		A.CreditAccountID,	A.DebitAccountID, 
		A.ObjectID,			A1.ObjectName,
		A.CurrencyID,		A.ExchangeRate,
		A.SenderReceiver,	A.SRDivisionName,		A.SRAddress,
		A.RefNo01,			A.RefNo02, 
		--FullName,
		---ChiefAccountant,
		A.ConvertedAmount,	A.OriginalAmount,
		A.Ana01ID,A.Ana02ID,A.Ana03ID,A.Ana04ID,A.Ana05ID,
		A.Ana06ID,A.Ana07ID,A.Ana08ID,A.Ana09ID,A.Ana10ID,
		A.Serial,			A.InvoiceNo,		A.InvoiceDate
	
FROM	AT9000 A
LEFT JOIN AT1202 A1 ON A1.DivisionID = A.DivisionID AND A1.ObjectID = A.ObjectID
WHERE	A.TransactionTypeID in (''T01'',''T04'',''T14'',''T22'') and
		A.DivisionID = '''+@DivisionID+''' and
		A.VoucherID ='''+@VoucherID+''' 
		---and BatchID = ''' + @BatchID + '''
'


--PRINT @sSQL

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV3041')
	EXEC ('CREATE VIEW AV3041 AS '+@sSQL)
ELSE
	EXEC( 'ALTER VIEW AV3041 AS '+@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

