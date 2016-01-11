IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0057]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0057]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Do nguon ke thua don hang ban tai man hinh don hang mua
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 28/12/2011 by Le Thi Thu Hien
---- 
---- Modified on 05/01/2012 by Le Thi Thu Hien : Bo sung SOrderID
---- Modified on 09/01/2012 by Le Thi Thu Hien : Bo sung Barcode ,DeliveryDate
---- Modified on 13/01/2012 by Le Thi Thu Hien : Bo sung khong ke thua phieu chua duyet
-- <Example>
---- 
CREATE PROCEDURE OP0057
( 
		@DivisionID AS NVARCHAR(50)

) 
AS 
DECLARE @sSQL AS NVARCHAR(MAX),
		@sSQL1 AS NVARCHAR(MAX)

SET @sSQL = N'
SELECT * FROM OT2001 
WHERE	SOrderID NOT IN ( SELECT ISNULL(SOrderID, '''') FROM OT3001)
		AND OrderStatus NOT IN (0, 3, 9)
		'
--PRINT(@sSQL)
IF NOT EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV0057' )
	EXEC('CREATE VIEW OV0057' + ' ---- OP0057
			AS ' + @sSQL )
ELSE	
	EXEC('ALTER VIEW OV0057' + ' ---- OP0057
			AS ' + @sSQL )
			
SET @sSQL1 = N'
SELECT	OT2002.InventoryID,  AT1302.InventoryName, AT1302.Barcode,
		OT2002.UnitID, 
		OT2002.ConvertedQuantity,		
		CASE WHEN ISNULL(AT1004.Operator, 0) = 0 THEN ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*ISNULL(OT2001.ExchangeRate,1) 
													ELSE ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)/ISNULL(OT2001.ExchangeRate,1) END AS ConvertedSaleprice, 
		OT2002.OrderQuantity,				
		ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice) AS PurchasePrice,

		ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*OT2002.OrderQuantity AS OriginalAmount,			
		CASE WHEN ISNULL(AT1004.Operator, 0) = 0 THEN ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*ISNULL(OT2001.ExchangeRate,1)*OT2002.OrderQuantity
													ELSE ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*OT2002.OrderQuantity/ISNULL(OT2001.ExchangeRate,1) END AS ConvertedAmount,

		ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*OT2002.OrderQuantity  AS OriginalAmountBeforeVAT,	
		CASE WHEN ISNULL(AT1004.Operator, 0) = 0 THEN ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*ISNULL(OT2001.ExchangeRate,1)*OT2002.OrderQuantity
													ELSE ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*OT2002.OrderQuantity/ISNULL(OT2001.ExchangeRate,1) END AS ConvertAmountBeforeVAT,

		ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*OT2002.OrderQuantity  AS OriginalAmountAfterVAT,	
		CASE WHEN ISNULL(AT1004.Operator, 0) = 0 THEN ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*ISNULL(OT2001.ExchangeRate,1)*OT2002.OrderQuantity
													ELSE ISNULL(OT2002.ConvertedSalepriceInput,OT2002.Saleprice)*OT2002.OrderQuantity/ISNULL(OT2001.ExchangeRate,1) END AS ConvertedAmountAfterVAT,
		OT2001.CurrencyID,OT2001.ExchangeRate, AT1004.Operator,
		OT2002.SOrderID, OT2002.DeliveryDate 
		
FROM		OT2002 
LEFT JOIN	AT1302 ON AT1302.InventoryID = OT2002.InventoryID AND AT1302.DivisionID = OT2002.DivisionID
LEFT JOIN	OT2001 ON OT2001.SOrderID = OT2002.SOrderID AND OT2001.DivisionID = OT2002.DivisionID 
LEFT JOIN	AT1004 ON AT1004.CurrencyID = OT2001.CurrencyID AND AT1004.DivisionID = OT2002.DivisionID 

WHERE	OT2002.SOrderID NOT IN ( SELECT ISNULL(SOrderID, '''') FROM OT3001)
		AND OrderStatus NOT IN (0, 3, 9)
		'
--PRINT(@sSQL1)
IF NOT EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV0058' )
	EXEC('CREATE VIEW OV0058' + ' ---- OP0057
			AS ' + @sSQL1 )
ELSE	
	EXEC('ALTER VIEW OV0058' + ' ---- OP0057
			AS ' + @sSQL1 )


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

