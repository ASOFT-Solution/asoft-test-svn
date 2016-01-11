IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV3501]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV3501]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In báo cáo tạm chi Ngân Hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 10/04/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 10/04/2012 by 
-- <Example>
----
	
CREATE VIEW AV3501	
AS	
SELECT	CONVERT(nvarchar(50),'') AS VoucherID,
	CONVERT(int,0) AS Orders,
	CONVERT(datetime,GETDATE()) AS VoucherDate,
	CONVERT(nvarchar(50),'') AS VoucherTypeID,
	CONVERT(nvarchar(50),'') AS VoucherNo,
	CONVERT(nvarchar(50),'') AS DebitBankAccountID,
	CONVERT(nvarchar(50),'') AS CreditBankAccountID,
	CONVERT(nvarchar(50),'') AS CurrencyID,
	CONVERT(decimal(28,8),0) AS ExchangeRate,
	CONVERT(nvarchar(50),'') AS DebitAccountID,
	CONVERT(nvarchar(50),'') AS CreditAccountID,
	CONVERT(decimal(28,8),0) AS OriginalAmount,
	CONVERT(decimal(28,8),0) AS ConvertedAmount,
	CONVERT(nvarchar(50),'') AS ObjectID,
	CONVERT(nvarchar(250),'') AS ObjectName,
	CONVERT(nvarchar(50),'') AS VATTypeID,
	CONVERT(nvarchar(50),'') AS InvoiceNo,
	CONVERT(datetime,GETDATE()) AS InvoiceDate,
	CONVERT(nvarchar(50),'') AS Serial,
	CONVERT(nvarchar(50),'') AS VATGroupID,
	CONVERT(nvarchar(250),'') AS TDescription,
	CONVERT(nvarchar(250),'') AS VDescription,
	CONVERT(nvarchar(250),'') AS BDescription,
	CONVERT(nvarchar(50),'') AS OrderID,
	CONVERT(nvarchar(50),'') AS Ana01ID,
	CONVERT(nvarchar(50),'') AS Ana02ID,
	CONVERT(nvarchar(50),'') AS Ana03ID,
	CONVERT(nvarchar(50),'') AS Ana04ID,
	CONVERT(nvarchar(50),'') AS Ana05ID,
	CONVERT(nvarchar(250),'') AS SenderReceiver,
	CONVERT(nvarchar(250),'') AS SRDivisionName,
	CONVERT(nvarchar(100),'') AS RefNo01,
	CONVERT(nvarchar(100),'') AS RefNo02,
	CONVERT(nvarchar(50),'') AS TransactionTypeID,
	CONVERT(nvarchar(50),'') AS Status,
	CONVERT(nvarchar(50),'') AS CreditBankAccountNo,
	CONVERT(nvarchar(250),'') AS CreditBankName,
	CONVERT(nvarchar(50),'') AS DebitBankAccountNo,
	CONVERT(nvarchar(250),'') AS DebitBankName,
	CONVERT(nvarchar(50),'') AS AccountID,
	CONVERT(nvarchar(250),'') AS DivisionName,
	CONVERT(nvarchar(250),'') AS Address
	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

