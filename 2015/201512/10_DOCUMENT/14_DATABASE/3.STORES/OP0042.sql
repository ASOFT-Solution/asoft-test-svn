IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0042]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0042]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Detail cho màn hình OF0138 - kế thừa đơn hàng mua [Customize ABA]
-- <History>
---- Create on 20/04/2015 by Lê Thị Hạnh 
---- Modified on ... by 
---- Modified by Tiểu Mai on 18/11/2015: Bổ sung trường hợp có quản lý mặt hàng theo quy cách.
-- <Example>
/* 
OP0042 @DivisionID ='VG', @VoucherIDList = 'CL/01/15/024'',''DD/01/15/005'',''CT/01/15/003'',''DK/01/15/006'',''KH/01/15/006', @SOVoucherID = 'TV20140000000001'
 */
CREATE PROCEDURE [dbo].[OP0042] 	
	@DivisionID NVARCHAR(50),
	@VoucherIDList NVARCHAR(MAX),
	@SOVoucherID NVARCHAR(50) -- Truyền vào khi Edit
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX)
SET @SOVoucherID = ISNULL(@SOVoucherID,'')
-- Load dữ liệu cho Detail cho lưới
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	BEGIN
		SET @sSQL1 = '
		SELECT CONVERT(TINYINT,1) AS IsCheck, ''OT3001'' AS TableID, OT31.POrderID, OT32.TransactionID, 
				ISNULL(OT31.ExchangeRate,0) AS ExchangeRate, 
				OT31.VoucherNo, ISNULL(OT32.Orders,0) AS Orders, OT32.InventoryID, AT12.InventoryName, OT32.UnitID,
				ISNULL(OT32.ConvertedQuantity,0) AS ConvertedQuantity, 
				ISNULL(OT32.ConvertedSalePrice,0) AS ConvertedSalePrice, 
				SUM(ISNULL(OT22.OrderQuantity,0)) AS InheritQuantity,
				ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0) AS RemainQuantity,
				ISNULL(OT32.PurchasePrice,0) AS PurchasePrice, 
				ISNULL(OT32.VATPercent,0) AS VATPercent, 
				OT32.Ana01ID, OT32.Ana02ID, OT32.Ana03ID, OT32.Ana04ID, OT32.Notes,
				OT32.Notes01, OT32.Notes02, OT32.Ana05ID, OT32.Ana06ID, OT32.Ana07ID,
				OT32.Ana08ID, OT32.Ana09ID, OT32.Ana10ID, OT32.Notes03, OT32.Notes04,
				OT32.Notes05, OT32.Notes06, OT32.Notes07, OT32.Notes08, OT32.Notes09,
				(ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0))*ISNULL(OT32.PurchasePrice,0) AS OriginalAmount,
				(ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT31.ExchangeRate,0) AS ConvertedAmount,
				(ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT32.VATPercent,0)/100 AS VATOriginalAmount,
				(ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT31.ExchangeRate,0)*ISNULL(OT32.VATPercent,0)/100 AS VATConvertedAmount,
				ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
				OT31.ObjectID, OT31.[Description], OT31.CurrencyID,
				O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
				O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		FROM OT3002 OT32
		INNER JOIN OT3001 OT31 ON OT31.DivisionID = OT32.DivisionID AND OT31.POrderID = OT32.POrderID
		LEFT JOIN OT2002 OT22 ON OT22.DivisionID = OT32.DivisionID AND OT22.InheritTableID = ''OT3001'' 
				AND OT22.InheritVoucherID = OT32.POrderID AND OT22.InheritTransactionID = OT32.TransactionID
		LEFT JOIN AT1302 AT12 ON AT12.DivisionID = OT32.DivisionID AND AT12.InventoryID = OT32.InventoryID 
		LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT31.DivisionID AND AT14.CurrencyID = OT31.CurrencyID
		LEFT JOIN OT8899 O99 ON O99.DivisionID = OT32.DivisionID AND O99.VoucherID = OT32.POrderID AND O99.TransactionID = OT32.TransactionID AND O99.TableID = ''OT3002''
		WHERE OT32.DivisionID = '''+@DivisionID+''' 
				AND OT32.TransactionID IN (SELECT OT22.InheritTransactionID 
											FROM OT2002 OT22 
											WHERE OT22.DivisionID = '''+@DivisionID+''' AND OT22.SOrderID = '''+@SOVoucherID+''' 
												AND OT22.InheritTableID = ''OT3001'') 
		GROUP BY OT31.POrderID, OT32.TransactionID, OT31.ExchangeRate,
					OT31.VoucherNo, OT32.Orders, OT32.InventoryID, AT12.InventoryName, OT32.UnitID,
					OT32.ConvertedQuantity, OT32.ConvertedSalePrice, OT32.OrderQuantity, 
					OT22.OrderQuantity, OT32.PurchasePrice, OT32.VATPercent, 
					OT32.Ana01ID, OT32.Ana02ID, OT32.Ana03ID, OT32.Ana04ID, OT32.Notes, 
					OT32.Notes01, OT32.Notes02, OT32.Ana05ID, OT32.Ana06ID, OT32.Ana07ID,
					OT32.Ana08ID, OT32.Ana09ID, OT32.Ana10ID, OT32.Notes03, OT32.Notes04,
					OT32.Notes05, OT32.Notes06, OT32.Notes07, OT32.Notes08, OT32.Notes09, 
					AT14.ExchangeRateDecimal, OT31.ObjectID, OT31.[Description], OT31.CurrencyID,
					O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
					O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		UNION '
			
		SET @sSQL2 = '
		SELECT CONVERT(TINYINT,0) AS IsCheck, ''OT3001'' AS TableID, OT31.POrderID, OT32.TransactionID, 
				ISNULL(OT31.ExchangeRate,0) AS ExchangeRate, 
				OT31.VoucherNo, ISNULL(OT32.Orders,0) AS Orders, OT32.InventoryID, AT12.InventoryName, OT32.UnitID,
				ISNULL(OT32.ConvertedQuantity,0) AS ConvertedQuantity, 
				ISNULL(OT32.ConvertedSalePrice,0) AS ConvertedSalePrice,
				SUM(ISNULL(OT22.OrderQuantity,0)) AS InheritQuantity,
				ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) AS RemainQuantity,
				ISNULL(OT32.PurchasePrice,0) AS PurchasePrice, 
				ISNULL(OT32.VATPercent,0) AS VATPercent, 
				OT32.Ana01ID, OT32.Ana02ID, OT32.Ana03ID, OT32.Ana04ID, OT32.Notes,
				OT32.Notes01, OT32.Notes02, OT32.Ana05ID, OT32.Ana06ID, OT32.Ana07ID,
				OT32.Ana08ID, OT32.Ana09ID, OT32.Ana10ID, OT32.Notes03, OT32.Notes04,
				OT32.Notes05, OT32.Notes06, OT32.Notes07, OT32.Notes08, OT32.Notes09,
				(ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)))*ISNULL(OT32.PurchasePrice,0) AS OriginalAmount,
				(ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT31.ExchangeRate,0) AS ConvertedAmount,
				(ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT32.VATPercent,0)/100 AS VATOriginalAmount,
				(ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT31.ExchangeRate,0)*ISNULL(OT32.VATPercent,0)/100 AS VATConvertedAmount,
				ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
				OT31.ObjectID, OT31.[Description], OT31.CurrencyID,
				O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
				O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		FROM OT3002 OT32
		INNER JOIN OT3001 OT31 ON OT31.DivisionID = OT32.DivisionID AND OT31.POrderID = OT32.POrderID
		LEFT JOIN OT2002 OT22 ON OT22.DivisionID = OT32.DivisionID AND OT22.InheritTableID = ''OT3001'' 
				AND OT22.InheritVoucherID = OT32.POrderID AND OT22.InheritTransactionID = OT32.TransactionID
		LEFT JOIN AT1302 AT12 ON AT12.DivisionID = OT32.DivisionID AND AT12.InventoryID = OT32.InventoryID
		LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT31.DivisionID AND AT14.CurrencyID = OT31.CurrencyID
		LEFT JOIN OT8899 O99 ON O99.DivisionID = OT32.DivisionID AND O99.VoucherID = OT32.POrderID AND O99.TransactionID = OT32.TransactionID AND O99.TableID = ''OT3002''
		WHERE OT32.DivisionID = '''+@DivisionID+''' AND OT32.POrderID IN ('''+@VoucherIDList+''')
				AND OT32.TransactionID NOT IN (SELECT OT22.InheritTransactionID 
												FROM OT2002 OT22 
												WHERE OT22.DivisionID = '''+@DivisionID+''' AND OT22.SOrderID = '''+@SOVoucherID+''' 
													AND OT22.InheritTableID = ''OT3001'') 
		GROUP BY OT31.POrderID, OT32.TransactionID, OT31.ExchangeRate,
					OT31.VoucherNo, OT32.Orders, OT32.InventoryID, AT12.InventoryName, OT32.UnitID,
					OT32.ConvertedQuantity, OT32.ConvertedSalePrice, OT32.OrderQuantity, 
					OT22.OrderQuantity, OT32.PurchasePrice, OT32.VATPercent,
					OT32.Ana01ID, OT32.Ana02ID, OT32.Ana03ID, OT32.Ana04ID, OT32.Notes, 
					OT32.Notes01, OT32.Notes02, OT32.Ana05ID, OT32.Ana06ID, OT32.Ana07ID,
					OT32.Ana08ID, OT32.Ana09ID, OT32.Ana10ID, OT32.Notes03, OT32.Notes04,
					OT32.Notes05, OT32.Notes06, OT32.Notes07, OT32.Notes08, OT32.Notes09,
					AT14.ExchangeRateDecimal, OT31.ObjectID, OT31.[Description], OT31.CurrencyID,
					O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
					O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
			HAVING ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) > 0
			ORDER BY VoucherNo, IsCheck DESC, Orders, InventoryID
			'
	END
ELSE
	BEGIN
		SET @sSQL1 = '
			SELECT CONVERT(TINYINT,1) AS IsCheck, ''OT3001'' AS TableID, OT31.POrderID, OT32.TransactionID, 
				   ISNULL(OT31.ExchangeRate,0) AS ExchangeRate, 
				   OT31.VoucherNo, ISNULL(OT32.Orders,0) AS Orders, OT32.InventoryID, AT12.InventoryName, OT32.UnitID,
				   ISNULL(OT32.ConvertedQuantity,0) AS ConvertedQuantity, 
				   ISNULL(OT32.ConvertedSalePrice,0) AS ConvertedSalePrice, 
				   SUM(ISNULL(OT22.OrderQuantity,0)) AS InheritQuantity,
				   ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0) AS RemainQuantity,
				   ISNULL(OT32.PurchasePrice,0) AS PurchasePrice, 
				   ISNULL(OT32.VATPercent,0) AS VATPercent, 
				   OT32.Ana01ID, OT32.Ana02ID, OT32.Ana03ID, OT32.Ana04ID, OT32.Notes,
				   OT32.Notes01, OT32.Notes02, OT32.Ana05ID, OT32.Ana06ID, OT32.Ana07ID,
				   OT32.Ana08ID, OT32.Ana09ID, OT32.Ana10ID, OT32.Notes03, OT32.Notes04,
				   OT32.Notes05, OT32.Notes06, OT32.Notes07, OT32.Notes08, OT32.Notes09,
				  (ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0))*ISNULL(OT32.PurchasePrice,0) AS OriginalAmount,
				  (ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT31.ExchangeRate,0) AS ConvertedAmount,
				  (ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT32.VATPercent,0)/100 AS VATOriginalAmount,
				  (ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) + ISNULL(OT32.OrderQuantity,0))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT31.ExchangeRate,0)*ISNULL(OT32.VATPercent,0)/100 AS VATConvertedAmount,
				   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
				   OT31.ObjectID, OT31.[Description], OT31.CurrencyID
			FROM OT3002 OT32
			INNER JOIN OT3001 OT31 ON OT31.DivisionID = OT32.DivisionID AND OT31.POrderID = OT32.POrderID
			LEFT JOIN OT2002 OT22 ON OT22.DivisionID = OT32.DivisionID AND OT22.InheritTableID = ''OT3001'' 
				 AND OT22.InheritVoucherID = OT32.POrderID AND OT22.InheritTransactionID = OT32.TransactionID
			LEFT JOIN AT1302 AT12 ON AT12.DivisionID = OT32.DivisionID AND AT12.InventoryID = OT32.InventoryID 
			LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT31.DivisionID AND AT14.CurrencyID = OT31.CurrencyID
			WHERE OT32.DivisionID = '''+@DivisionID+''' 
				  AND OT32.TransactionID IN (SELECT OT22.InheritTransactionID 
											 FROM OT2002 OT22 
											 WHERE OT22.DivisionID = '''+@DivisionID+''' AND OT22.SOrderID = '''+@SOVoucherID+''' 
												   AND OT22.InheritTableID = ''OT3001'') 
			GROUP BY OT31.POrderID, OT32.TransactionID, OT31.ExchangeRate,
					 OT31.VoucherNo, OT32.Orders, OT32.InventoryID, AT12.InventoryName, OT32.UnitID,
					 OT32.ConvertedQuantity, OT32.ConvertedSalePrice, OT32.OrderQuantity, 
					 OT22.OrderQuantity, OT32.PurchasePrice, OT32.VATPercent, 
					 OT32.Ana01ID, OT32.Ana02ID, OT32.Ana03ID, OT32.Ana04ID, OT32.Notes, 
					 OT32.Notes01, OT32.Notes02, OT32.Ana05ID, OT32.Ana06ID, OT32.Ana07ID,
					 OT32.Ana08ID, OT32.Ana09ID, OT32.Ana10ID, OT32.Notes03, OT32.Notes04,
					 OT32.Notes05, OT32.Notes06, OT32.Notes07, OT32.Notes08, OT32.Notes09, 
					 AT14.ExchangeRateDecimal, OT31.ObjectID, OT31.[Description], OT31.CurrencyID
			UNION '
			
		SET @sSQL2 = '
			SELECT CONVERT(TINYINT,0) AS IsCheck, ''OT3001'' AS TableID, OT31.POrderID, OT32.TransactionID, 
					ISNULL(OT31.ExchangeRate,0) AS ExchangeRate, 
					OT31.VoucherNo, ISNULL(OT32.Orders,0) AS Orders, OT32.InventoryID, AT12.InventoryName, OT32.UnitID,
					ISNULL(OT32.ConvertedQuantity,0) AS ConvertedQuantity, 
					ISNULL(OT32.ConvertedSalePrice,0) AS ConvertedSalePrice,
					SUM(ISNULL(OT22.OrderQuantity,0)) AS InheritQuantity,
					ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) AS RemainQuantity,
					ISNULL(OT32.PurchasePrice,0) AS PurchasePrice, 
					ISNULL(OT32.VATPercent,0) AS VATPercent, 
					OT32.Ana01ID, OT32.Ana02ID, OT32.Ana03ID, OT32.Ana04ID, OT32.Notes,
					OT32.Notes01, OT32.Notes02, OT32.Ana05ID, OT32.Ana06ID, OT32.Ana07ID,
					OT32.Ana08ID, OT32.Ana09ID, OT32.Ana10ID, OT32.Notes03, OT32.Notes04,
					OT32.Notes05, OT32.Notes06, OT32.Notes07, OT32.Notes08, OT32.Notes09,
				   (ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)))*ISNULL(OT32.PurchasePrice,0) AS OriginalAmount,
				   (ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT31.ExchangeRate,0) AS ConvertedAmount,
				   (ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT32.VATPercent,0)/100 AS VATOriginalAmount,
				   (ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)))*ISNULL(OT32.PurchasePrice,0)*ISNULL(OT31.ExchangeRate,0)*ISNULL(OT32.VATPercent,0)/100 AS VATConvertedAmount,
					ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
					OT31.ObjectID, OT31.[Description], OT31.CurrencyID
			FROM OT3002 OT32
			INNER JOIN OT3001 OT31 ON OT31.DivisionID = OT32.DivisionID AND OT31.POrderID = OT32.POrderID
			LEFT JOIN OT2002 OT22 ON OT22.DivisionID = OT32.DivisionID AND OT22.InheritTableID = ''OT3001'' 
				 AND OT22.InheritVoucherID = OT32.POrderID AND OT22.InheritTransactionID = OT32.TransactionID
			LEFT JOIN AT1302 AT12 ON AT12.DivisionID = OT32.DivisionID AND AT12.InventoryID = OT32.InventoryID
			LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT31.DivisionID AND AT14.CurrencyID = OT31.CurrencyID
			WHERE OT32.DivisionID = '''+@DivisionID+''' AND OT32.POrderID IN ('''+@VoucherIDList+''')
				  AND OT32.TransactionID NOT IN (SELECT OT22.InheritTransactionID 
												 FROM OT2002 OT22 
												 WHERE OT22.DivisionID = '''+@DivisionID+''' AND OT22.SOrderID = '''+@SOVoucherID+''' 
													   AND OT22.InheritTableID = ''OT3001'') 
			GROUP BY OT31.POrderID, OT32.TransactionID, OT31.ExchangeRate,
					 OT31.VoucherNo, OT32.Orders, OT32.InventoryID, AT12.InventoryName, OT32.UnitID,
					 OT32.ConvertedQuantity, OT32.ConvertedSalePrice, OT32.OrderQuantity, 
					 OT22.OrderQuantity, OT32.PurchasePrice, OT32.VATPercent,
					 OT32.Ana01ID, OT32.Ana02ID, OT32.Ana03ID, OT32.Ana04ID, OT32.Notes, 
					 OT32.Notes01, OT32.Notes02, OT32.Ana05ID, OT32.Ana06ID, OT32.Ana07ID,
					 OT32.Ana08ID, OT32.Ana09ID, OT32.Ana10ID, OT32.Notes03, OT32.Notes04,
					 OT32.Notes05, OT32.Notes06, OT32.Notes07, OT32.Notes08, OT32.Notes09,
					 AT14.ExchangeRateDecimal, OT31.ObjectID, OT31.[Description], OT31.CurrencyID
			 HAVING ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) > 0
			 ORDER BY VoucherNo, IsCheck DESC, Orders, InventoryID
				'
	END

EXEC (@sSQL1 + @sSQL2) 
--PRINT (@sSQL1)
--PRINT (@sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
