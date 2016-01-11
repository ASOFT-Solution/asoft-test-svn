IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0085]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV0085]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- View tạo report in hàng hoạt phiếu thu ngân hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/03/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 16/03/2012 by 
-- <Example>
---- 
CREATE VIEW AV0085	
AS	
SELECT	
		CONVERT(nvarchar(50),'') AS VoucherID,	
	CONVERT(nvarchar(50),'') AS DivisionID,	
	CONVERT(int,0) AS TranMonth,	
	CONVERT(int,0) AS TranYear,	
	CONVERT(nvarchar(50),'') AS VoucherTypeID,	
	CONVERT(nvarchar(50),'') AS VoucherNo,	
	CONVERT(datetime,GETDATE()) AS VoucherDate,	
	CONVERT(nvarchar(250),'') AS VDescription,	
	CONVERT(nvarchar(4000),'') AS InvoiceNoList,	
	CONVERT(nvarchar(4000),'') AS CorAccountList,	
	CONVERT(decimal(28,8),0) AS CorOriginalAmount1,	
	CONVERT(decimal(28,8),0) AS CorOriginalAmount2,	
	CONVERT(decimal(28,8),0) AS CorOriginalAmount3,	
	CONVERT(decimal(28,8),0) AS CorConvertedAmount1,	
	CONVERT(decimal(28,8),0) AS CorConvertedAmount2,	
	CONVERT(decimal(28,8),0) AS CorConvertedAmount3,	
	CONVERT(nvarchar(50),'') AS AccountID,	
	CONVERT(nvarchar(50),'') AS ObjectID,	
	CONVERT(nvarchar(50),'') AS CurrencyID,	
	CONVERT(decimal(28,8),0) AS ExchangeRate,	
	CONVERT(nvarchar(250),'') AS SenderReceiver,	
	CONVERT(nvarchar(250),'') AS SRDivisionName,	
	CONVERT(nvarchar(250),'') AS SRAddress,	
	CONVERT(nvarchar(100),'') AS RefNo01,	
	CONVERT(nvarchar(100),'') AS RefNo02,	
	CONVERT(nvarchar(50),'') AS BankAccountID,	
	CONVERT(nvarchar(250),'') AS BankName,	
	CONVERT(nvarchar(50),'') AS BankAccountNo,	
	CONVERT(nvarchar(250),'') AS DivisionAddress,	
	CONVERT(decimal(38,8),0) AS ConvertedAmount,	
	CONVERT(decimal(38,8),0) AS OriginalAmount,	
	CONVERT(nvarchar(250),'') AS ObjectAddress,	
	CONVERT(nvarchar(250),'') AS OriginalAmountInWord	
	
	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
