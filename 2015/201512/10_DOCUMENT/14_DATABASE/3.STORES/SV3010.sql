IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[SV3010]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[SV3010]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- View bao cao don hang ban khach hang Antin
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 22/11/2011 by Le Thi Thu Hien
---- 
---- Modified on 03/12/2011 by Le Thi Thu Hien : Bo sung 1 so cot Address, Tel, 5 khoan muc OCode
---- Modified on 09/01/2012 by Le Thi Thu Hien : Bo sung SumOriginalAmount, SumConvertedAmount
-- <Example>
---- 		
CREATE VIEW SV3010		
AS		
SELECT	CONVERT(nvarchar(50),'') AS DivisionID,	
	CONVERT(nvarchar(50),'') AS VoucherNo,	
	CONVERT(datetime,GETDATE()) AS OrderDate,	
	CONVERT(nvarchar(50),'') AS ObjectID,
	CONVERT(nvarchar(250),'') AS ObjectName,
	CONVERT(nvarchar(250),'') AS Address,					
	CONVERT(nvarchar(100),'') AS Tel,
	CONVERT(nvarchar(50),'') AS O01ID,	
	CONVERT(nvarchar(50),'') AS O02ID,	
	CONVERT(nvarchar(50),'') AS O03ID,	
	CONVERT(nvarchar(50),'') AS O04ID,	
	CONVERT(nvarchar(50),'') AS O05ID,
	CONVERT(nvarchar(250),'') AS O01Name, 
	CONVERT(nvarchar(250),'') AS O02Name, 
	CONVERT(nvarchar(250),'') AS O03Name, 
	CONVERT(nvarchar(250),'') AS O04Name, 
	CONVERT(nvarchar(250),'') AS O05Name,	
	CONVERT(nvarchar(50),'') AS InventoryID,	
	CONVERT(nvarchar(250),'') AS InventoryName,	
	CONVERT(nvarchar(50),'') AS UnitID,	
	CONVERT(nvarchar(250),'') AS UnitName,	
	CONVERT(decimal(28,8),0) AS OrderQuantity,	
	CONVERT(decimal(28,8),0) AS SalesPrice,	
	CONVERT(decimal(38,6),0) AS SalePriceConverted,	
	CONVERT(decimal(28,8),0) AS DiscountOriginalAmount,	
	CONVERT(decimal(38,6),0) AS DiscountConvertedAmount,	
	CONVERT(decimal(28,8),0) AS OriginalAmount,	
	CONVERT(decimal(28,8),0) AS ConvertedAmount,	
	CONVERT(nvarchar(50),'') AS CurrencyID,	
	CONVERT(nvarchar(50),'') AS CurrencyIDCN,	
	CONVERT(decimal(28,8),0) AS ExchangeRate,	
	CONVERT(decimal(28,8),0) AS BeginOriginalAmount,	
	CONVERT(decimal(28,8),0) AS BeginConvertedAmount,	
	CONVERT(decimal(28,8),0) AS ReceivedAmount,
	CONVERT(decimal(28,8),0) AS SumOriginalAmount,	
	CONVERT(decimal(28,8),0) AS SumConvertedAmount,		
	CONVERT(nvarchar(50),'') AS OrderID	

		
		
		

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

