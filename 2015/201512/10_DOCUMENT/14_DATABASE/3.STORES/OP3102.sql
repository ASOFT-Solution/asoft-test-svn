IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3102]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3102]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--Created by: Nguyen Thi Thuy Tuyen, date :30/10/2006
--purpose : Ke thua Yêu c?u mua hàng cho don hang mua
-- Last Edit: Thuy Tuyen 09/09/2009, 26/10/2009
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/
--- Modified by Tiểu Mai on 20/11/2015: Bổ sung trường hợp có thiết lập quản lý mặt hàng theo quy cách.


CREATE PROCEDURE [dbo].[OP3102] 
    @DivisionID NVARCHAR(50), 
    @VoucherID NVARCHAR(200), 
    @VoucherDate DATETIME
AS

DECLARE @sSQL NVARCHAR(4000),
		@sSQL1 NVARCHAR(4000)
		
SET @sSQL = '
	SELECT
	OT3101.DivisionID, 
	OT3101.ROrderID, 
	OT3101.ObjectID, 
	CASE WHEN ISNULL(OT3101.ObjectName, '''') <> '''' THEN OT3101.ObjectName ELSE AT1202.ObjectName END AS ObjectName, 
	CASE WHEN ISNULL(OT3101.Address, '''') <> '''' THEN OT3101.Address ELSE AT1202.Address END AS Address, 
	AT1202.IsUpdateName, 
	OT3101.VoucherTypeID, 
	OT3101.DueDate, 
	AT1103.FullName, 
	OT3101.InventoryTypeID, 
	OT3101.CurrencyID, 
	OT3101.ExchangeRate, 
	OT3101.PaymentID, 
	OT3101.Transport, 
	OT3101.ReceivedAddress, 
	OT3101.EmployeeID, 
	AT1103_S.FullName AS EmployeeIDName, 
	OT3101.ClassifyID, 
	OT3101.Ana01ID, OT3101.Ana02ID, OT3101.Ana03ID, OT3101.Ana04ID, OT3101.Ana05ID, 
	OT3101.Shipdate, 
	OT3101.Description
	FROM OT3101 
	LEFT JOIN AT1202 ON AT1202.ObjectID = OT3101.ObjectID AND AT1202.DivisionID = OT3101.DivisionID 
	LEFT JOIN AT1103 ON AT1103.EmployeeID = OT3101.EmployeeID AND AT1103.DivisionID = OT3101.DivisionID 
	LEFT JOIN AT1103 AT1103_S ON AT1103_S.EmployeeID = OT3101.EmployeeID AND AT1103_S.DivisionID = OT3101.DivisionID 
	WHERE OT3101.ROrderID = ''' + @VoucherID + '''
	AND OT3101.DivisionID = ''' + @DivisionID + '''
	' 		

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN 
	SET @sSQL1 = '
			SELECT 
			OT3101.DivisionID, 
			OT3102.ROrderID, 
			OT3102.TransactionID AS RefTransactionID, 
			OT3102.Orders, 
			OT3102.InventoryID, 
			CASE WHEN ISNULL(OT3102.InventoryCommonName, '''') <> '''' THEN OT3102.InventoryCommonName ELSE AT1302.InventoryName END AS InventoryName, 
			CASE WHEN ISNULL(OT3102.InventoryCommonName, '''') <> '''' THEN 1 ELSE 0 END AS IsEditInventoryName, 
			ISNULL(OT3102.UnitID, AT1302.UnitID) AS UnitID, 
			OV2905.EndQuantity AS OrderQuantity, 
			OT3102.Parameter01, OT3102.Parameter02, OT3102.Parameter03, OT3102.Parameter04, OT3102.Parameter05, 
			OT3102.RequestPrice, 
			OT3102.OriginalAmount, 
			OT3102.ConvertedAmount, 
			OT3102.OriginalAmount - OT3102.DiscountOriginalAmount AS OriginalBeforeTax, 
			OT3102.ConvertedAmount - OT3102.DiscountConvertedAmount AS ConvertedBeforeTax, 
			OT3102.VATPercent, 
			OT3102.VATConvertedAmount, 
			OT3102.VATOriginalAmount, 
			OT3102.DiscountPercent, 
			OT3102.DiscountOriginalAmount, 
			OT3102.DiscountConvertedAmount, 
			OT3102.Ana01ID, OT3102.Ana02ID, OT3102.Ana03ID, OT3102.Ana04ID, OT3102.Ana05ID, 
			OT3102.Ana06ID, OT3102.Ana07ID, OT3102.Ana08ID, OT3102.Ana09ID, OT3102.Ana10ID, 
			OT3102.Notes, OT3102.Notes01, OT3102.Notes02 , 
			OV2905.EndCQuantity AS ConvertedQuantity, 
			OT3102.ConvertedSalePrice, OT3102.Description,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID

			FROM OT3102  
			INNER JOIN OT3101 ON OT3101.ROrderID = OT3102.ROrderID AND OT3101.DivisionID = OT3102.DivisionID 
			INNER JOIN OV2905 ON OV2905.ROrderID = OT3102.ROrderID AND OV2905.TransactionID = OT3102.TransactionID AND OT3102.DivisionID = OT3102.DivisionID 
			LEFT JOIN AT1302 ON AT1302.InventoryID = OT3102.InventoryID AND AT1302.DivisionID = OT3102.DivisionID 
			LEFT JOIN OT8899 O99 ON O99.DivisionID = OT3102.DivisionID AND O99.TransactionID = OT3102.TransactionID AND O99.VoucherID = OT3102.ROrderID AND o99.TableID = ''OT3102''

			WHERE OT3102.ROrderID = ''' + @VoucherID + ''' 
			AND OV2905.EndQuantity > 0
			AND OT3102.DivisionID = ''' + @DivisionID + ''' 
			'		
END
ELSE
	BEGIN		
		SET @sSQL1 = '
					SELECT 
					OT3101.DivisionID, 
					OT3102.ROrderID, 
					OT3102.TransactionID AS RefTransactionID, 
					OT3102.Orders, 
					OT3102.InventoryID, 
					CASE WHEN ISNULL(OT3102.InventoryCommonName, '''') <> '''' THEN OT3102.InventoryCommonName ELSE AT1302.InventoryName END AS InventoryName, 
					CASE WHEN ISNULL(OT3102.InventoryCommonName, '''') <> '''' THEN 1 ELSE 0 END AS IsEditInventoryName, 
					ISNULL(OT3102.UnitID, AT1302.UnitID) AS UnitID, 
					OV2905.EndQuantity AS OrderQuantity, 
					OT3102.Parameter01, OT3102.Parameter02, OT3102.Parameter03, OT3102.Parameter04, OT3102.Parameter05, 
					OT3102.RequestPrice, 
					OT3102.OriginalAmount, 
					OT3102.ConvertedAmount, 
					OT3102.OriginalAmount - OT3102.DiscountOriginalAmount AS OriginalBeforeTax, 
					OT3102.ConvertedAmount - OT3102.DiscountConvertedAmount AS ConvertedBeforeTax, 
					OT3102.VATPercent, 
					OT3102.VATConvertedAmount, 
					OT3102.VATOriginalAmount, 
					OT3102.DiscountPercent, 
					OT3102.DiscountOriginalAmount, 
					OT3102.DiscountConvertedAmount, 
					OT3102.Ana01ID, OT3102.Ana02ID, OT3102.Ana03ID, OT3102.Ana04ID, OT3102.Ana05ID, 
					OT3102.Ana06ID, OT3102.Ana07ID, OT3102.Ana08ID, OT3102.Ana09ID, OT3102.Ana10ID, 
					OT3102.Notes, OT3102.Notes01, OT3102.Notes02 , 
					OV2905.EndCQuantity AS ConvertedQuantity, 
					OT3102.ConvertedSalePrice, OT3102.Description,NULL S01ID, NULL S02ID, NULL S03ID, NULL S04ID, NULL S05ID, NULL S06ID, NULL S07ID, NULL S08ID, NULL S09ID, NULL S10ID,
					NULL S11ID, NULL S12ID, NULL S13ID, NULL S14ID, NULL S15ID, NULL S16ID, NULL S17ID, NULL S18ID, NULL S19ID, NULL S20ID

					FROM OT3102  
					INNER JOIN OT3101 ON OT3101.ROrderID = OT3102.ROrderID AND OT3101.DivisionID = OT3102.DivisionID 
					INNER JOIN OV2905 ON OV2905.ROrderID = OT3102.ROrderID AND OV2905.TransactionID = OT3102.TransactionID AND OT3102.DivisionID = OT3102.DivisionID 
					LEFT JOIN AT1302 ON AT1302.InventoryID = OT3102.InventoryID AND AT1302.DivisionID = OT3102.DivisionID 

					WHERE OT3102.ROrderID = ''' + @VoucherID + ''' 
					AND OV2905.EndQuantity > 0
					AND OT3102.DivisionID = ''' + @DivisionID + ''' 
					'	
	END


IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'OV3108')
DROP VIEW OV3108

EXEC('CREATE VIEW OV3108 -- Tạo bởi OP3102
        AS ' + @sSQL)

IF EXISTS (SELECT Top 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'OV3109')
    DROP VIEW OV3109

EXEC('CREATE VIEW OV3109 -- Tạo bởi OP3102
        AS ' + @sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

