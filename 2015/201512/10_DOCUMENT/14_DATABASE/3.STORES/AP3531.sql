IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3531]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3531]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- In báo cáo tạm chi Ngân Hàng (mẫu 3 - phiếu kế toán)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/07/2012 by Bao Anh
---- 
-- <Example>
---- EXEC AP3531 'AS', 'ADMIN', 4, 2012, 'AV20120000000009'
CREATE PROCEDURE AP3531
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@VoucherID AS NVARCHAR(50)
) 
AS 

DECLARE @Ssql AS NVARCHAR(MAX)
-----------Phiếu chi tạm ngân hàng
SET @Ssql = N'
SELECT * FROM 
(
	SELECT  TR.VoucherID,		TR.Orders, TR.VoucherDate,   TR.VoucherTypeID,  TR.VoucherNo,
			TR.DebitBankAccountID, TR.CreditBankAccountID,
			TR.CurrencyID,		TR.ExchangeRate,
			TR.DebitAccountID,  TR.CreditAccountID,
			TR.OriginalAmount,  TR.ConvertedAmount,  TR.ObjectID,
			OB.ObjectName,
			TR.VATTypeID,		TR.InvoiceNo,   TR.InvoiceDate, TR.Serial,
			TR.VATGroupID,		
			TR.TDescription,  TR.VDescription, TR.BDescription,
			TR.OrderID,
			TR.Ana01ID,			TR.Ana02ID,    Ana03ID,  TR.Ana04ID,  TR.Ana05ID,
			TR.SenderReceiver,  TR.SRDivisionName,  TR.SRAddress, 
			TR.RefNo01,			TR.RefNo02,  
			TR.TransactionTypeID, TR.Status,
			AT1016.BankAccountNo AS CreditBankAccountNo, 
			AT1016.BankName AS CreditBankName,
			OB.BankAccountNo AS DebitBankAccountNo, 
			OB.BankName AS DebitBankName,			
			CASE WHEN TR.TransactionTypeID = ''T21'' THEN TR.DebitAccountID ELSE TR.CreditAccountID END AccountID,
			AT0001.CompanyName AS DivisionName,	OB.Address As ObjectAddress
			
	FROM	AT9010 TR
	LEFT JOIN AT1202 OB	ON OB.DivisionID = TR.DivisionID AND OB.ObjectID = TR.ObjectID
	LEFT JOIN AT1016 on AT1016.DivisionID = TR.DivisionID AND AT1016.BankAccountID = TR.CreditBankAccountID
	LEFT JOIN AT1016 AT1016D on AT1016D.DivisionID = TR.DivisionID AND AT1016D.BankAccountID = TR.DebitBankAccountID
	LEFT JOIN AT0001 ON AT0001.DivisionID = TR.DivisionID

	WHERE	TR.TranMonth = '+STR(@TranMonth)+'
			AND TR.TranYear = '+STR(@TranYear)+'
			AND TR.TransactionTypeID IN ( ''T22'')
			AND TR.DivisionID = '''+@DivisionID+'''
			AND TR.VoucherID = '''+@VoucherID+'''
	)A
	ORDER BY	VoucherDate, VoucherTypeID,	VoucherNo,	Orders
		'
---PRINT(@Ssql)
EXEC(@Ssql)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

