IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP1305]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP1305]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Store load giá theo bậc thang số lượng
---- Giống store OP1302
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 23/05/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 23/05/2012 by 
-- <Example>
---- 
CREATE PROCEDURE OP1305
( 
	@DivisionID NVARCHAR(50),
	@ObjectID NVARCHAR(50),
	@VoucherDate DATETIME,
	@PriceListID NVARCHAR(50),
	@CurrencyID NVARCHAR(50),
	@Quantity DECIMAL(28,8),
	@InventoryID NVARCHAR(50)
) 
AS 
DECLARE		@sSQL               NVARCHAR(4000),
	        @OTypeID            NVARCHAR(50),
	        @ID_Price           NVARCHAR(50),
	        @ID_Quantity        NVARCHAR(50),
	        @IsQuantityControl  TINYINT,
	        @IsPriceControl     TINYINT,
	        @IsConvertedPrice TINYINT,
	        @OriginalCurrencyID TINYINT,
	        @ExchangeRate DECIMAL(28,8),
	        @BaseCurrencyID NVARCHAR(50),
	        @Operator AS TINYINT,
	        @IsQuantityPrice AS TINYINT,
	        @IsPrice AS TINYINT -- Bảng giá theo bậc thang
	        
SET @BaseCurrencyID = (SELECT TOP 1 BaseCurrencyID FROM AV1004 WHERE DivisionID = @DivisionID)
SET @IsPrice = 0
SET @IsQuantityPrice  = ISNULL((SELECT TOP 1 IsQuantityPrice FROM OT0000 WHERE DivisionID = @DivisionID), 0)
------------->>> Kiểm tra bảng giá có trong bảng giá theo bậc thang
IF EXISTS (SELECT TOP 1 1 FROM OT0117 WHERE DivisionID = @DivisionID AND ID = @PriceListID)
BEGIN
	IF ISNULL (@Quantity,0) <> 0 AND @IsQuantityPrice = 1
		SET @IsPrice = 1
END


	
SET @VoucherDate = DATEADD(dd, DATEDIFF(dd, 0, @VoucherDate), 1)

SELECT	@OTypeID = OPriceTypeID + 'ID',
		@IsPriceControl = IsPriceControl,
		@IsQuantityControl = IsQuantityControl
FROM	OT0000
WHERE	DivisionID = @DivisionID

    
							       
SELECT	@OTypeID = OPriceTypeID + 'ID',
		@IsPriceControl = IsPriceControl,
		@IsQuantityControl = IsQuantityControl
FROM	OT0000
WHERE	DivisionID = @DivisionID

    
--Truong hop khong QL So luong va gia ban
IF @IsPriceControl = 0 AND @IsQuantityControl = 0
BEGIN
    SET @sSQL = '
SELECT		TOP 1 
			CASE WHEN AV1004.Operator = 0 THEN AT1302.SalePrice01*AV1004.ExchangeRate ELSE AT1302.SalePrice01/AV1004.ExchangeRate END AS SalePrice

FROM		AT1302
LEFT JOIN	AT1304
	ON		AT1304.UnitID = AT1302.UnitID
            AND AT1304.DivisionID = AT1302.DivisionID
LEFT JOIN	OT1301
		ON	OT1301.ID = ''' + @PriceListID + '''
			AND OT1301.DivisionID = AT1302.DivisionID
			AND OT1301.IsConvertedPrice = 1
LEFT JOIN	(	SELECT	AV1004.CurrencyID,AV1004.DivisionID, AV1004.Operator,
						COALESCE(AT1012.ExchangeRate,AV1004.ExchangeRate) AS ExchangeRate
				FROM	AV1004
				LEFT JOIN (	SELECT Top 1 DivisionID , CurrencyID, ExchangeRate, ExchangeDate
							FROM AT1012 
							WHERE DATEDIFF(dd, ExchangeDate, '''+CONVERT(VARCHAR(10),@VoucherDate,101)+''') >= 0
							ORDER BY ExchangeDate DESC
							)AT1012
					ON		AT1012.DivisionID = AV1004.DivisionID 
							AND AT1012.CurrencyID = AV1004.CurrencyID
			)	AV1004
		ON	AV1004.CurrencyID = '+CASE WHEN @CurrencyID = @BaseCurrencyID THEN 'ISNULL(OT1301.CurrencyID, '''+@BaseCurrencyID+''')' ELSE ''''+@BaseCurrencyID+'''' END +'
			AND AV1004.DivisionID =  AT1302.DivisionID
WHERE		AT1302.Disabled = 0
			AND AT1302.InventoryID = '''+@InventoryID+''''
END
ELSE 
IF @IsPriceControl = 1 AND @IsQuantityControl = 1
BEGIN
    IF @PriceListID = '' -- Nếu không chọn bảng giá, sẽ lấy 1 bảng giá thỏa điều kiện đầu tiên
	BEGIN    
		IF ISNULL(@ObjectID, '') = ''
			SELECT	TOP 1 @ID_Price = ISNULL(ID, '')
			FROM	OT1301
			WHERE	@VoucherDate BETWEEN FromDate AND DATEADD(dd, 1, ISNULL(ToDate, CAST('12/30/9999' AS DATETIME)))
					AND OID = '%' 
					AND DivisionID = @DivisionID
					AND [Disabled] = 0
		ELSE
			SELECT		TOP 1 
						@ID_Price = ISNULL(ID, '')
			FROM		OT1301
			WHERE		@VoucherDate BETWEEN FromDate AND DATEADD(dd, 1, ISNULL(ToDate, CAST('12/30/9999' AS DATETIME)))
						AND (
							   SELECT	TOP 1 CASE WHEN @OTypeID = 'O01ID' THEN ISNULL(O01ID, '%')
												 WHEN @OTypeID = 'O02ID' THEN ISNULL(O02ID, '%')
												 WHEN @OTypeID = 'O03ID' THEN ISNULL(O03ID, '%')
												 WHEN @OTypeID = 'O04ID' THEN ISNULL(O04ID, '%')
												 ELSE ISNULL(O05ID, '%')
											END AS ObjectTypeID
							   FROM		AT1202
							   WHERE	ObjectID LIKE ISNULL(@ObjectID, '')
										AND [Disabled] = 0 AND DivisionID = @DivisionID
						   ) LIKE OID
						AND DivisionID = @DivisionID AND [Disabled] = 0
			ORDER BY	ID
	END
	ELSE
		SET @ID_Price = @PriceListID
		
    SET @ID_Quantity = ISNULL((	SELECT	TOP 1 ID
								FROM	OT1303
								WHERE	@VoucherDate BETWEEN FromDate AND CASE WHEN ToDate = '01/01/1900' THEN '12/30/9999' ELSE ToDate END
										AND DivisionID = @DivisionID AND [Disabled] = 0), '')									       
SET @sSQL = 
        '
SELECT 		TOP 1 
			'+ CASE WHEN @IsPrice  = 1 THEN 'CASE WHEN AV1004.Operator = 0 THEN ISNULL(OT0117.Price, ISNULL(OT1302.UnitPrice, AT1302.SalePrice01)*AV1004.ExchangeRate) ELSE ISNULL(OT0117.Price, ISNULL(OT1302.UnitPrice, AT1302.SalePrice01)/AV1004.ExchangeRate) END ' 
				ELSE 'CASE WHEN AV1004.Operator = 0 THEN  ISNULL(OT1302.UnitPrice, AT1302.SalePrice01)*AV1004.ExchangeRate ELSE  ISNULL(OT1302.UnitPrice, AT1302.SalePrice01)/AV1004.ExchangeRate END ' END +' AS SalePrice
			
FROM		AT1302
LEFT JOIN	OT1302
		ON  AT1302.InventoryID = OT1302.InventoryID
			AND AT1302.DivisionID = OT1302.DivisionID
            AND OT1302.ID = ''' + ISNULL(@ID_Price, '') + '''
LEFT JOIN	AT1304 
		ON	AT1304.UnitID = AT1302.UnitID 
			AND AT1304.DivisionID = AT1302.DivisionID			
LEFT JOIN	OT1304 
		ON	OT1304.ID = ''' + @ID_Quantity + ''' 
			AND OT1304.InventoryID = AT1302.InventoryID 
			AND OT1304.DivisionID = AT1302.DivisionID		 
LEFT JOIN	OT1301
		ON	OT1301.ID = ''' + @PriceListID + '''
			AND OT1301.DivisionID = AT1302.DivisionID
			AND OT1301.IsConvertedPrice = 1
LEFT JOIN	(	SELECT	AV1004.CurrencyID,AV1004.DivisionID, AV1004.Operator,
						COALESCE(AT1012.ExchangeRate,AV1004.ExchangeRate) AS ExchangeRate
				FROM	AV1004
				LEFT JOIN (	SELECT Top 1 DivisionID , CurrencyID, ExchangeRate, ExchangeDate
							FROM AT1012 
							WHERE DATEDIFF(dd, ExchangeDate, '''+CONVERT(VARCHAR(10),@VoucherDate,101)+''') >= 0
							ORDER BY ExchangeDate DESC
							)AT1012
					ON		AT1012.DivisionID = AV1004.DivisionID 
							AND AT1012.CurrencyID = AV1004.CurrencyID
			)	AV1004
		ON	AV1004.CurrencyID = '+CASE WHEN @CurrencyID = @BaseCurrencyID THEN 'ISNULL(OT1301.CurrencyID, '''+@BaseCurrencyID+''')' ELSE ''''+@BaseCurrencyID+'''' END +'
			AND AV1004.DivisionID =  AT1302.DivisionID 
'+ CASE WHEN @IsPrice = 1 THEN '	
LEFT JOIN	OT0117 
		ON	OT0117.DivisionID = OT1302.DivisionID 
			AND OT0117.ID = OT1302.ID 
			AND OT0117.InventoryID = OT1302.InventoryID 
			AND OT0117.Disabled = 0
			AND '+STR(@Quantity)+' BETWEEN OT0117.FromQuantity AND OT0117.ToQuantity' 
		ELSE '' END +' 
WHERE		AT1302.Disabled  = 0
			AND AT1302.InventoryID = '''+@InventoryID+''''
END
ELSE 
IF @IsPriceControl = 1 AND @IsQuantityControl = 0
BEGIN
    IF @PriceListID = '' -- Nếu không chọn bảng giá, sẽ lấy 1 bảng giá thỏa điều kiện đầu tiên
	BEGIN 
		IF ISNULL(@ObjectID, '') = ''
			SELECT TOP 1 @ID_Price = ISNULL(ID, '')
			FROM   OT1301
			WHERE  @VoucherDate BETWEEN FromDate AND DATEADD(dd, 1, ISNULL(ToDate, CAST('12/30/9999' AS DATETIME)))
				   AND OID = '%' AND DivisionID = @DivisionID
		ELSE
			SELECT		TOP 1 
						@ID_Price = ISNULL(ID, '')
			FROM		OT1301
			WHERE		@VoucherDate BETWEEN FromDate AND DATEADD(dd, 1, ISNULL(ToDate, CAST('12/30/9999' AS DATETIME)))
						AND (
							   SELECT	TOP 1 
										CASE WHEN @OTypeID = 'O01ID' THEN ISNULL(O01ID, '%')
											 WHEN @OTypeID = 'O02ID' THEN ISNULL(O02ID, '%')
											 WHEN @OTypeID = 'O03ID' THEN ISNULL(O03ID, '%')
											 WHEN @OTypeID = 'O04ID' THEN ISNULL(O04ID, '%')
											 ELSE ISNULL(O05ID, '%')
										END AS ObjectTypeID
							   FROM		AT1202
							   WHERE	ObjectID LIKE ISNULL(@ObjectID, '')
										AND DivisionID = @DivisionID AND [Disabled] = 0
						   ) LIKE OID
						 AND DivisionID = @DivisionID AND [Disabled] = 0
			ORDER BY	ID
    END
    ELSE 
    	SET @ID_Price = @PriceListID
    	
    SET @sSQL = 
        '
	SELECT		TOP 1 
				'+ CASE WHEN @IsPrice  = 1 THEN 'CASE WHEN AV1004.Operator = 0 THEN ISNULL(OT0117.Price, ISNULL(OT1302.UnitPrice, AT1302.SalePrice01)*AV1004.ExchangeRate) ELSE ISNULL(OT0117.Price, ISNULL(OT1302.UnitPrice, AT1302.SalePrice01)/AV1004.ExchangeRate) END '
					ELSE 'CASE WHEN AV1004.Operator = 0 THEN ISNULL(OT1302.UnitPrice, AT1302.SalePrice01)*AV1004.ExchangeRate ELSE ISNULL(OT1302.UnitPrice, AT1302.SalePrice01)/AV1004.ExchangeRate END ' END +' AS SalePrice
				
	FROM		AT1302
	LEFT JOIN	OT1302
			ON  AT1302.InventoryID = OT1302.InventoryID
				AND AT1302.DivisionID = OT1302.DivisionID
				AND OT1302.ID = ''' + ISNULL(@ID_Price, '') + '''
	LEFT JOIN	AT1304
			ON  AT1304.UnitID = AT1302.UnitID
				AND AT1304.DivisionID = AT1302.DivisionID
	LEFT JOIN	OT1301
			ON	OT1301.ID = ''' + @PriceListID  + '''
				AND OT1301.DivisionID = AT1302.DivisionID
				AND OT1301.IsConvertedPrice = 1
	LEFT JOIN	(	SELECT	AV1004.CurrencyID,AV1004.DivisionID, AV1004.Operator,
						COALESCE(AT1012.ExchangeRate,AV1004.ExchangeRate) AS ExchangeRate
				FROM	AV1004
				LEFT JOIN (	SELECT Top 1 DivisionID , CurrencyID, ExchangeRate, ExchangeDate 
							FROM AT1012 
							WHERE DATEDIFF(dd, ExchangeDate, '''+CONVERT(VARCHAR(10),@VoucherDate,101)+''') >= 0
							ORDER BY ExchangeDate DESC
							)AT1012
					ON		AT1012.DivisionID = AV1004.DivisionID 
							AND AT1012.CurrencyID = AV1004.CurrencyID
			)	AV1004
			ON	AV1004.CurrencyID = '+CASE WHEN @CurrencyID = @BaseCurrencyID THEN 'ISNULL(OT1301.CurrencyID, '''+@BaseCurrencyID+''')' ELSE ''''+@BaseCurrencyID+'''' END +'
				AND AV1004.DivisionID =  AT1302.DivisionID'
	+ CASE WHEN @IsPrice = 1 THEN '	
	LEFT JOIN	OT0117 
			ON	OT0117.DivisionID = OT1302.DivisionID 
				AND OT0117.ID = OT1302.ID 
				AND OT0117.InventoryID = OT1302.InventoryID 
				AND OT0117.Disabled = 0
				AND '+STR(@Quantity)+' BETWEEN OT0117.FromQuantity AND OT0117.ToQuantity' 
		ELSE '' END +' 
	WHERE		AT1302.Disabled = 0
				AND AT1302.InventoryID = '''+@InventoryID+''''
END
ELSE
------------Quan ly so luong
BEGIN
    SET @ID_Quantity = ISNULL((	SELECT	TOP 1 ID
								FROM	OT1303
								WHERE	@VoucherDate BETWEEN FromDate AND CASE WHEN ToDate = '01/01/1900' THEN '12/30/9999' ELSE ToDate END
										AND DivisionID = @DivisionID AND [Disabled] = 0), '')

	 SET @sSQL = '
	SELECT		TOP 1 
				'+ CASE WHEN @IsPrice  = 1 THEN 'CASE WHEN AV1004.Operator = 0 THEN ISNULL(OT0117.Price, AT1302.SalePrice01*AV1004.ExchangeRate ELSE AT1302.SalePrice01/AV1004.ExchangeRate) END'
				ELSE 'CASE WHEN AV1004.Operator = 0 THEN AT1302.SalePrice01*AV1004.ExchangeRate ELSE AT1302.SalePrice01/AV1004.ExchangeRate END' END +' AS SalePrice
				
	FROM		AT1302
	LEFT JOIN	AT1304
			ON  AT1304.UnitID = AT1302.UnitID
				AND AT1304.DivisionID = AT1302.DivisionID
	LEFT JOIN	OT1304
			ON  OT1304.ID = ''' + @ID_Quantity + '''
				AND OT1304.InventoryID = AT1302.InventoryID
				AND OT1304.DivisionID = AT1302.DivisionID
	LEFT JOIN	OT1301
			ON	OT1301.ID = ''' + @PriceListID  + '''
				AND OT1301.DivisionID = AT1302.DivisionID
				AND OT1301.IsConvertedPrice = 1
	LEFT JOIN	(	SELECT	AV1004.CurrencyID,AV1004.DivisionID, AV1004.Operator,
						COALESCE(AT1012.ExchangeRate,AV1004.ExchangeRate) AS ExchangeRate
				FROM	AV1004
				LEFT JOIN (	SELECT Top 1 DivisionID , CurrencyID, ExchangeRate, ExchangeDate 
							FROM AT1012 
							WHERE DATEDIFF(dd, ExchangeDate, '''+CONVERT(VARCHAR(10),@VoucherDate,101)+''') >= 0
							ORDER BY ExchangeDate DESC
							)AT1012
					ON		AT1012.DivisionID = AV1004.DivisionID 
							AND AT1012.CurrencyID = AV1004.CurrencyID
			)	AV1004
			ON	AV1004.CurrencyID = '+CASE WHEN @CurrencyID = @BaseCurrencyID THEN 'ISNULL(OT1301.CurrencyID, '''+@BaseCurrencyID+''')' ELSE ''''+@BaseCurrencyID+'''' END +'
				AND AV1004.DivisionID =  AT1302.DivisionID'
	+ CASE WHEN @IsPrice = 1 THEN '	
	LEFT JOIN	OT0117 
			ON	OT0117.DivisionID = OT1302.DivisionID 
				AND OT0117.ID = OT1302.ID 
				AND OT0117.InventoryID = OT1302.InventoryID 
				AND OT0117.Disabled = 0
				AND '+STR(@Quantity)+' BETWEEN OT0117.FromQuantity AND OT0117.ToQuantity' 
		ELSE '' END +' 
	WHERE		AT1302.Disabled = 0
				AND AT1302.InventoryID = '''+@InventoryID+''''
END 

PRINT(@sSQL)
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

