IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2063]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP2063]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Lấy dữ liệu phiếu nhập kho hàng về trước để lập hóa đơn sau tại màn hình mua hàng (AF0063)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 25/10/2011 by Nguyễn Bình Minh
---- 
---- Modified by Tieu Mai on 16/12/2015: Bo sung ke thua thong tin quy cach khi co thiet lap quan ly mat hang theo quy cach. 
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP2063]
(
	@DivisionID AS NVARCHAR(50),	
	@TranMonth AS INT,
	@TranYear AS INT,
	@CurrencyID AS NVARCHAR(50),
	@ExchangeRate AS DECIMAL(28,8),
	@GoodsFirstVoucherID AS NVARCHAR(50) 
) 
AS
DECLARE @Operator AS TINYINT,
		@UnitCostDecimals AS TINYINT,
		@OriginalDecimal AS TINYINT,
		@BaseCurrencyID AS NVARCHAR(50)
	
SELECT  @BaseCurrencyID = BaseCurrencyID, @Operator = Operator, @UnitCostDecimals = UnitCostDecimals, @OriginalDecimal = OriginalDecimal
FROM	AV1004 
WHERE	DivisionID = @DivisionID AND CurrencyID = @CurrencyID

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)

	SELECT		WHD.InventoryID,
			WHD.UnitID,
			INV.InventoryName,
			WHD.DebitAccountID,
			WHD.CreditAccountID,
			ROUND(	CASE WHEN @BaseCurrencyID = @CurrencyID THEN WHD.UnitPrice 
					ELSE
						CASE WHEN @Operator = 0 AND WHD.ActualQuantity <> 0 AND @ExchangeRate <> 0 THEN 
								WHD.ConvertedAmount / WHD.ActualQuantity / @ExchangeRate
							WHEN @Operator = 1 AND WHD.ActualQuantity <> 0 AND @ExchangeRate <> 0 THEN
							 	WHD.ConvertedAmount / WHD.ActualQuantity * @ExchangeRate
						ELSE 0 END
			      	END, @UnitCostDecimals) AS UnitPrice,
			WHD.ActualQuantity AS Quantity,
			ROUND(	CASE WHEN @BaseCurrencyID = @CurrencyID THEN WHD.ConvertedAmount 
					ELSE
						CASE WHEN @Operator = 0 THEN 
								WHD.ConvertedAmount / @ExchangeRate
							WHEN @Operator = 1 THEN
							 	WHD.ConvertedAmount * @ExchangeRate
						ELSE 0 END
			      	END, @OriginalDecimal) AS OriginalAmount,
			WHD.ConvertedAmount,
			WHD.PeriodID,		WHD.ProductID,			
			WHD.Ana01ID,		WHD.Ana02ID,		WHD.Ana03ID,		WHD.Ana04ID,		WHD.Ana05ID,
			WHD.VoucherID AS ReVoucherID,
			WHD.BatchID AS ReBatchID,
			WHD.TransactionID AS ReTransactionID,			
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
		AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
		AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
		AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
		AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name
	FROM		AT2007 WHD
	INNER JOIN	AT2006 WH
			ON	WH.VoucherID = WHD.VoucherID AND WH.DivisionID = WHD.DivisionID
	LEFT JOIN	AT1302 INV
			ON	INV.InventoryID = WHD.InventoryID AND INV.DivisionID = WHD.DivisionID
	left join WT8899 O99 on O99.DivisionID = WHD.DivisionID and O99.VoucherID = WHD.VoucherID and O99.TransactionID = WHD.TransactionID
	LEFT JOIN AT0128 AT01 ON AT01.StandardID = O99.S01ID AND AT01.StandardTypeID = 'S01'
	LEFT JOIN AT0128 AT02 ON AT02.StandardID = O99.S02ID AND AT02.StandardTypeID = 'S02'
	LEFT JOIN AT0128 AT03 ON AT03.StandardID = O99.S03ID AND AT03.StandardTypeID = 'S03'
	LEFT JOIN AT0128 AT04 ON AT04.StandardID = O99.S04ID AND AT04.StandardTypeID = 'S04'
	LEFT JOIN AT0128 AT05 ON AT05.StandardID = O99.S05ID AND AT05.StandardTypeID = 'S05'
	LEFT JOIN AT0128 AT06 ON AT06.StandardID = O99.S06ID AND AT06.StandardTypeID = 'S06'
	LEFT JOIN AT0128 AT07 ON AT07.StandardID = O99.S07ID AND AT07.StandardTypeID = 'S07'
	LEFT JOIN AT0128 AT08 ON AT08.StandardID = O99.S08ID AND AT08.StandardTypeID = 'S08'
	LEFT JOIN AT0128 AT09 ON AT09.StandardID = O99.S09ID AND AT09.StandardTypeID = 'S09'
	LEFT JOIN AT0128 AT10 ON AT10.StandardID = O99.S10ID AND AT10.StandardTypeID = 'S10'
	LEFT JOIN AT0128 AT11 ON AT11.StandardID = O99.S11ID AND AT11.StandardTypeID = 'S11'
	LEFT JOIN AT0128 AT12 ON AT12.StandardID = O99.S12ID AND AT12.StandardTypeID = 'S12'
	LEFT JOIN AT0128 AT13 ON AT13.StandardID = O99.S13ID AND AT13.StandardTypeID = 'S13'
	LEFT JOIN AT0128 AT14 ON AT14.StandardID = O99.S15ID AND AT14.StandardTypeID = 'S14'
	LEFT JOIN AT0128 AT15 ON AT15.StandardID = O99.S15ID AND AT15.StandardTypeID = 'S15'
	LEFT JOIN AT0128 AT16 ON AT16.StandardID = O99.S16ID AND AT16.StandardTypeID = 'S16'
	LEFT JOIN AT0128 AT17 ON AT17.StandardID = O99.S17ID AND AT17.StandardTypeID = 'S17'
	LEFT JOIN AT0128 AT18 ON AT18.StandardID = O99.S18ID AND AT18.StandardTypeID = 'S18'
	LEFT JOIN AT0128 AT19 ON AT19.StandardID = O99.S19ID AND AT19.StandardTypeID = 'S19'
	LEFT JOIN AT0128 AT20 ON AT20.StandardID = O99.S20ID AND AT20.StandardTypeID = 'S20'		
	WHERE		WH.VoucherID = @GoodsFirstVoucherID AND WH.IsGoodsFirstVoucher = 1 AND WH.KindVoucherID = 1
				AND WH.TranMonth = @TranMonth AND WH.TranYear = @TranYear
				AND WH.DivisionID = @DivisionID	

ELSE
	SELECT		WHD.InventoryID,
			WHD.UnitID,
			INV.InventoryName,
			WHD.DebitAccountID,
			WHD.CreditAccountID,
			ROUND(	CASE WHEN @BaseCurrencyID = @CurrencyID THEN WHD.UnitPrice 
					ELSE
						CASE WHEN @Operator = 0 AND WHD.ActualQuantity <> 0 AND @ExchangeRate <> 0 THEN 
								WHD.ConvertedAmount / WHD.ActualQuantity / @ExchangeRate
							WHEN @Operator = 1 AND WHD.ActualQuantity <> 0 AND @ExchangeRate <> 0 THEN
							 	WHD.ConvertedAmount / WHD.ActualQuantity * @ExchangeRate
						ELSE 0 END
			      	END, @UnitCostDecimals) AS UnitPrice,
			WHD.ActualQuantity AS Quantity,
			ROUND(	CASE WHEN @BaseCurrencyID = @CurrencyID THEN WHD.ConvertedAmount 
					ELSE
						CASE WHEN @Operator = 0 THEN 
								WHD.ConvertedAmount / @ExchangeRate
							WHEN @Operator = 1 THEN
							 	WHD.ConvertedAmount * @ExchangeRate
						ELSE 0 END
			      	END, @OriginalDecimal) AS OriginalAmount,
			WHD.ConvertedAmount,
			WHD.PeriodID,		WHD.ProductID,			
			WHD.Ana01ID,		WHD.Ana02ID,		WHD.Ana03ID,		WHD.Ana04ID,		WHD.Ana05ID,
			WHD.VoucherID AS ReVoucherID,
			WHD.BatchID AS ReBatchID,
			WHD.TransactionID AS ReTransactionID
	FROM		AT2007 WHD
	INNER JOIN	AT2006 WH
			ON	WH.VoucherID = WHD.VoucherID AND WH.DivisionID = WHD.DivisionID
	LEFT JOIN	AT1302 INV
			ON	INV.InventoryID = WHD.InventoryID AND INV.DivisionID = WHD.DivisionID
	WHERE		WH.VoucherID = @GoodsFirstVoucherID AND WH.IsGoodsFirstVoucher = 1 AND WH.KindVoucherID = 1
				AND WH.TranMonth = @TranMonth AND WH.TranYear = @TranYear
				AND WH.DivisionID = @DivisionID
