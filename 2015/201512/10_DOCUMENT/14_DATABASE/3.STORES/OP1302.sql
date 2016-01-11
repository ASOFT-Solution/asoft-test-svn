IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP1302]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP1302]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Lay gia ban cua mat hang cho man hinh lap don hang ban - QUAN LY GIA
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 18/08/2005 by Vo Thanh Huong
---- Modified on 24/06/2009,03/09/2009 by Thuy Tuyen
---- Modified on 03/08/2010 by Thanh Trẫm
---- Modified on 15/09/2011 by Nguyễn Bình Minh
------ 1. Sửa lỗi lấy tùy chọn và dữ liệu bảng giá không theo đơn vị
------ 2. Bổ sung lấy thêm mã bảng giá để dùng đổ dữ liệu combo bảng giá
---- Modified on 16/02/2012 by Lê Thị Thu Hiền : Bổ sung CurrencyID
---- Modified on 28/05/2012 by Lê Thị Thu Hiền : Load bảng giá theo bậc thang
---- Modified on 06/06/2012 by Bao Anh: Lay thong tin QL gia trong truong hop mat hang nhieu DVT
---- Modified on 25/06/2012 by Bao Anh: Sua cach lay SalePrice khi dung DVT quy doi
---- Modified on 26/06/2012 by Bao Anh: Gan SalePrice = 0 khi gia tri NULL
---- Modified on 27/06/2012 by Bao Anh: Sua loi khi cau SQL tao view vuot qua 4000 ky tu
---- Modified on 16/01/2013 by Lê Thị Thu Hiền : Bổ sung thêm DiscountAmount1->10
---- Modified on 06/02/2013 by Lê Thị Thu Hiền : Bổ sung ISNULL(BaseCurrencyID,0)
---- Modified on 14/10/2015 by Nguyễn Thanh Thịnh : Bổ sung thêm trường đơn giá theo số lượng
-- <Example>
--- EXEC OP1302 'mp', '%', '05-05-2012', '0', 'VND'

CREATE PROCEDURE [dbo].[OP1302]
(
    @DivisionID NVARCHAR(50),
    @ObjectID NVARCHAR(50),
    @VoucherDate DATETIME,
    @PriceListID NVARCHAR(50) = '',
    @CurrencyID NVARCHAR(50) = ''
) 
AS
DECLARE 
    @sSQL NVARCHAR(max),
    @OTypeID NVARCHAR(50),
    @ID_Price NVARCHAR(50),
    @ID_Quantity NVARCHAR(50),
    @IsQuantityControl TINYINT,
    @IsPriceControl TINYINT,
    @IsConvertedPrice TINYINT,
    @OriginalCurrencyID TINYINT,
    @ExchangeRate DECIMAL(28,8),
    @BaseCurrencyID NVARCHAR(50),
    @Operator TINYINT,
    @IsConvertedUnit AS TINYINT,
    @sSQL1 NVARCHAR(max)
SET @sSQL = ''
SET @sSQL1 = ''
SET @BaseCurrencyID = (SELECT TOP 1 ISNULL(BaseCurrencyID,0) FROM AV1004 WHERE DivisionID = @DivisionID)
SET @IsConvertedUnit = (SELECT TOP 1 ISNULL(IsConvertUnit,0) AS IsConvertUnit FROM OT0000 WHERE DivisionID = @DivisionID)

----------->>> Thiết lập bảng giá
--SELECT @OriginalCurrencyID = CurrencyID,
-- @IsConvertedPrice = IsConvertedPrice 
--FROM OT1301
--WHERE DivisionID = @DivisionID
-- AND ID = @PriceListID
----------<<< 
--SET @ExchangeRate = 1
--SET @Operator = 1

--IF @IsConvertedPrice = 1 AND @OriginalCurrencyID = @BaseCurrencyID
--SELECT @ExchangeRate = ExchangeRate ,
-- @Operator = Operator
--FROM AV1004 
--WHERE CurrencyID = @OriginalCurrencyID AND DivisionID = @DivisionID

--TypeQuantityControl 0: Khong
--1 Toi thieu
--2 Toi da
--3 Toi thieu va toi da 

--TypePriceControl 0: Khong
--1 Toi thieu
--2 Toi da
--3 Toi thieu va toi da 

SET @VoucherDate = DATEADD(dd, DATEDIFF(dd, 0, @VoucherDate), 1)

SELECT
    @OTypeID = OPriceTypeID + 'ID',
    @IsPriceControl = ISNULL(IsPriceControl, 0),
    @IsQuantityControl = ISNULL(IsQuantityControl,0)
FROM OT0000
WHERE DivisionID = @DivisionID

--Truong hop khong QL So luong va gia ban
IF @IsPriceControl = 0 AND @IsQuantityControl = 0
    BEGIN
        SET @sSQL = '
SELECT 
AT1302.DivisionID,
AT1302.InventoryID,
AT1302.InventoryName,
AT1302.Specification,
AT1302.UnitID,
AT1304.UnitName,
AT1302.InventoryTypeID,
AT1302.IsStocked,
AT1302.VATGroupID,
AT1302.VATPercent,
ISNULL((CASE WHEN AV1004.Operator = 0 THEN AT1302.SalePrice01 * AV1004.ExchangeRate 
             ELSE AT1302.SalePrice01 / AV1004.ExchangeRate END), 0) AS SalePrice,
CAST(0 AS DECIMAL(28,8)) AS UnitPrice,
CAST(0 AS DECIMAL(28,8)) AS MinPrice , 
CAST(0 AS DECIMAL(28,8)) AS MaxPrice,
CAST(0 AS DECIMAL(28,8)) AS MinQuantity, 
CAST(0 AS DECIMAL(28,8)) AS MaxQuantity,
0 AS TypePriceControl,
0 AS TypeQuantityControl,
ISNULL(AT1302.SalePrice01, 0) As SalePrice01,
ISNULL(AT1302.SalePrice02, 0) As SalePrice02,
ISNULL(AT1302.SalePrice03, 0) As SalePrice03,
ISNULL(AT1302.SalePrice04, 0) As SalePrice04,
ISNULL(AT1302.SalePrice05, 0) As SalePrice05,
CAST(NULL AS NVARCHAR(250)) AS Notes,
CAST(NULL AS NVARCHAR(250)) AS Notes01,
CAST(NULL AS NVARCHAR(250)) AS Notes02,
AT1302.Barcode,
CAST(0 AS DECIMAL(28,8)) AS DiscountPercent,
CAST(0 AS DECIMAL(28,8)) AS DiscountAmount,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent01,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount01,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent02,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount02,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent03,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount03,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent04,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount04,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent05,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount05,
ISNULL(OT0117.FromQuantity1, 0) As FromQuantity1, ISNULL(OT0117.ToQuantity1, 0) As ToQuantity1, ISNULL(OT0117.Price1, 0) As Price1,ISNULL(OT0117.DiscountAmount1, 0) As DiscountAmount1,
ISNULL(OT0117.FromQuantity2, 0) As FromQuantity2, ISNULL(OT0117.ToQuantity2, 0) As ToQuantity2, ISNULL(OT0117.Price2, 0) As Price2,ISNULL(OT0117.DiscountAmount2, 0) As DiscountAmount2,
ISNULL(OT0117.FromQuantity3, 0) As FromQuantity3, ISNULL(OT0117.ToQuantity3, 0) As ToQuantity3, ISNULL(OT0117.Price3, 0) As Price3,ISNULL(OT0117.DiscountAmount3, 0) As DiscountAmount3,
ISNULL(OT0117.FromQuantity4, 0) As FromQuantity4, ISNULL(OT0117.ToQuantity4, 0) As ToQuantity4, ISNULL(OT0117.Price4, 0) As Price4,ISNULL(OT0117.DiscountAmount4, 0) As DiscountAmount4,
ISNULL(OT0117.FromQuantity5, 0) As FromQuantity5, ISNULL(OT0117.ToQuantity5, 0) As ToQuantity5, ISNULL(OT0117.Price5, 0) As Price5,ISNULL(OT0117.DiscountAmount5, 0) As DiscountAmount5,
ISNULL(OT0117.FromQuantity6, 0) As FromQuantity6, ISNULL(OT0117.ToQuantity6, 0) As ToQuantity6, ISNULL(OT0117.Price6, 0) As Price6,ISNULL(OT0117.DiscountAmount6, 0) As DiscountAmount6,
ISNULL(OT0117.FromQuantity7, 0) As FromQuantity7, ISNULL(OT0117.ToQuantity7, 0) As ToQuantity7, ISNULL(OT0117.Price7, 0) As Price7,ISNULL(OT0117.DiscountAmount7, 0) As DiscountAmount7,
ISNULL(OT0117.FromQuantity8, 0) As FromQuantity8, ISNULL(OT0117.ToQuantity8, 0) As ToQuantity8, ISNULL(OT0117.Price8, 0) As Price8,ISNULL(OT0117.DiscountAmount8, 0) As DiscountAmount8,
ISNULL(OT0117.FromQuantity9, 0) As FromQuantity9, ISNULL(OT0117.ToQuantity9, 0) As ToQuantity9, ISNULL(OT0117.Price9, 0) As Price9,ISNULL(OT0117.DiscountAmount9, 0) As DiscountAmount9,
ISNULL(OT0117.FromQuantity10, 0) As FromQuantity10,ISNULL(OT0117.ToQuantity10, 0) As ToQuantity10,ISNULL(OT0117.Price10, 0) As Price10,ISNULL(OT0117.DiscountAmount10, 0) As DiscountAmount10,
ISNULL(OT0117.Price, 0) AS OT0117Price,
ISNULL(OT0117.Discount, 0) AS OT0117Discount,
CAST(NULL AS NVARCHAR(250)) AS O01ID,
 0 TrayPrice, 0 DecreaseTrayPrice,NULL Qtyfrom,NULL QtyTo 
'

        SET @sSQL1 = ' 
FROM AT1302
LEFT JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT1302.DivisionID
LEFT JOIN OT1301 ON OT1301.ID = ''' + @PriceListID + ''' AND OT1301.DivisionID = AT1302.DivisionID AND OT1301.IsConvertedPrice = 1
LEFT JOIN (
            SELECT AV1004.CurrencyID,AV1004.DivisionID, AV1004.Operator, 
            COALESCE(AT1012.ExchangeRate, AV1004.ExchangeRate) AS ExchangeRate
            FROM AV1004 
            LEFT JOIN ( 
                        SELECT Top 1 DivisionID , CurrencyID, ExchangeRate, ExchangeDate
                        FROM AT1012 
                        WHERE DATEDIFF(dd, ExchangeDate, ''' + CONVERT(VARCHAR(10),@VoucherDate,101) + ''') >= 0
                        ORDER BY ExchangeDate DESC
                      )AT1012 ON AT1012.DivisionID = AV1004.DivisionID AND AT1012.CurrencyID = AV1004.CurrencyID
          ) AV1004 ON AV1004.CurrencyID = ' + CASE WHEN @CurrencyID = @BaseCurrencyID THEN 'ISNULL(OT1301.CurrencyID, ''' + @BaseCurrencyID + ''')' 
                                                ELSE '''' + @BaseCurrencyID + '''' END + ' AND AV1004.DivisionID = AT1302.DivisionID
LEFT JOIN OT0117 ON OT0117.DivisionID = AT1302.DivisionID AND OT0117.InventoryID = AT1302.InventoryID AND OT0117.ID = ''' + @PriceListID + '''

WHERE AT1302.Disabled = 0
'
    END
ELSE IF @IsPriceControl = 1 AND @IsQuantityControl = 1
    BEGIN
        IF @PriceListID = '' -- Nếu không chọn bảng giá, sẽ lấy 1 bảng giá thỏa điều kiện đầu tiên
            BEGIN 
                IF ISNULL(@ObjectID, '') = ''
                    SELECT TOP 1 @ID_Price = ISNULL(ID, '')
                    FROM OT1301
                    WHERE @VoucherDate BETWEEN FromDate AND DATEADD(dd, 1, ISNULL(ToDate, CAST('12/30/9999' AS DATETIME)))
                    AND OID = '%' AND DivisionID = @DivisionID AND [Disabled] = 0
                ELSE
                    SELECT TOP 1 
                    @ID_Price = ISNULL(ID, '')
                    FROM OT1301
                    WHERE @VoucherDate BETWEEN FromDate AND DATEADD(dd, 1, ISNULL(ToDate, CAST('12/30/9999' AS DATETIME)))
                    AND (
                        SELECT TOP 1 
                            CASE WHEN @OTypeID = 'O01ID' THEN ISNULL(O01ID, '%')
                                 WHEN @OTypeID = 'O02ID' THEN ISNULL(O02ID, '%')
                                 WHEN @OTypeID = 'O03ID' THEN ISNULL(O03ID, '%')
                                 WHEN @OTypeID = 'O04ID' THEN ISNULL(O04ID, '%')
                            ELSE ISNULL(O05ID, '%')
                            END AS ObjectTypeID
                        FROM AT1202
                        WHERE ObjectID LIKE ISNULL(@ObjectID, '') AND [Disabled] = 0 AND DivisionID = @DivisionID
                        ) LIKE OID AND DivisionID = @DivisionID AND [Disabled] = 0
                    ORDER BY ID
            END
        ELSE
            SET @ID_Price = @PriceListID

        SET @ID_Quantity = ISNULL(( 
                                    SELECT TOP 1 ID
                                    FROM OT1303
                                    WHERE @VoucherDate BETWEEN FromDate AND CASE WHEN ToDate = '01/01/1900' THEN '12/30/9999' ELSE ToDate END
                                    AND DivisionID = @DivisionID AND [Disabled] = 0), 
                                 '') 
        SET @sSQL = 
'
SELECT 
AT1302.DivisionID,
AT1302.InventoryID, 
AT1302.InventoryName,
AT1302.Specification,
ISNULL(OT1302.UnitID, AT1302.UnitID) AS UnitID, 
AT1304.UnitName, 
AT1302.InventoryTypeID, 
AT1302.IsStocked,
AT1302.VATGroupID,
AT1302.VATPercent,

ISNULL((CASE WHEN AV1004.Operator = 0 
		THEN ISNULL((CASE WHEN ''' + LTRIM(@IsConvertedUnit) + ''' = ''0'' 
						THEN ISNULL(OT1312.UnitPrice,OT1302.UnitPrice)
						ELSE ISNULL(OT1312.UnitPrice,OT1302.ConvertedUnitPrice) END), AT1302.SalePrice01)* AV1004.ExchangeRate 
		ELSE ISNULL((CASE WHEN ''' + LTRIM(@IsConvertedUnit) + ''' = ''0'' 
						THEN ISNULL(OT1312.UnitPrice,OT1302.UnitPrice)
						ELSE ISNULL(OT1312.UnitPrice,OT1302.ConvertedUnitPrice) END), AT1302.SalePrice01)/ AV1004.ExchangeRate END),0) 
AS SalePrice,

CASE WHEN AV1004.Operator = 0 
    THEN OT1302.UnitPrice * AV1004.ExchangeRate 
    ELSE OT1302.UnitPrice / AV1004.ExchangeRate 
END AS UnitPrice,

ISNULL(OT1302.MinPrice, 0) As MinPrice, 
ISNULL(OT1302.MaxPrice, 0) As MaxPrice,
ISNULL(OT1304.MinQuantity, 0) As MinQuantity, 
ISNULL(OT1304.MaxQuantity, 0) As MaxQuantity,

CASE WHEN ISNULL(OT1302.MaxPrice, 0) <> 0 AND ISNULL(OT1302.MinPrice, 0) <> 0 THEN 3
     WHEN ISNULL(OT1302.MaxPrice, 0) <> 0 AND ISNULL(OT1302.MinPrice, 0) = 0 THEN 2
     WHEN ISNULL(OT1302.MaxPrice, 0) = 0 AND ISNULL(OT1302.MinPrice, 0) <> 0 THEN 1 
     ELSE 0 
END AS TypePriceControl,

CASE WHEN ISNULL(OT1304.MaxQuantity, 0) <> 0 AND ISNULL(OT1304.MinQuantity, 0) <> 0 THEN 3
     WHEN ISNULL(OT1304.MaxQuantity, 0) <> 0 AND ISNULL(OT1304.MinQuantity, 0) = 0 THEN 2
     WHEN ISNULL(OT1304.MaxQuantity, 0) = 0 AND ISNULL(OT1304.MinQuantity, 0) <> 0 THEN 1 
     ELSE 0 
END AS TypeQuantityControl,

ISNULL(AT1302.SalePrice01, 0) As SalePrice01,
ISNULL(AT1302.SalePrice02, 0) As SalePrice02,
ISNULL(AT1302.SalePrice03, 0) As SalePrice03,
ISNULL(AT1302.SalePrice04, 0) As SalePrice04,
ISNULL(AT1302.SalePrice05, 0) As SalePrice05,

ISNULL(OT1302.Notes, '''') AS Notes,
ISNULL(OT1302.Notes01, '''') AS Notes01,
ISNULL(OT1302.Notes02, '''') AS Notes02,
AT1302.Barcode,
ISNULL(DiscountPercent, 0) AS DiscountPercent,
ISNULL(DiscountAmount, 0) AS DiscountAmount,
ISNULL(SaleOffPercent01, 0) AS SaleOffPercent01,
ISNULL(SaleOffAmount01, 0) AS SaleOffAmount01,
ISNULL(SaleOffPercent02, 0) AS SaleOffPercent02,
ISNULL(SaleOffAmount02, 0) AS SaleOffAmount02,
ISNULL(SaleOffPercent03, 0) AS SaleOffPercent03,
ISNULL(SaleOffAmount03, 0) AS SaleOffAmount03,
ISNULL(SaleOffPercent04, 0) AS SaleOffPercent04,
ISNULL(SaleOffAmount04, 0) AS SaleOffAmount04,
ISNULL(SaleOffPercent05, 0) AS SaleOffPercent05,
ISNULL(SaleOffAmount05, 0) AS SaleOffAmount05,
ISNULL(OT0117.FromQuantity1, 0) As FromQuantity1, ISNULL(OT0117.ToQuantity1, 0) As ToQuantity1, ISNULL(OT0117.Price1, 0) As Price1,ISNULL(OT0117.DiscountAmount1, 0) As DiscountAmount1,
ISNULL(OT0117.FromQuantity2, 0) As FromQuantity2, ISNULL(OT0117.ToQuantity2, 0) As ToQuantity2, ISNULL(OT0117.Price2, 0) As Price2,ISNULL(OT0117.DiscountAmount2, 0) As DiscountAmount2,
ISNULL(OT0117.FromQuantity3, 0) As FromQuantity3, ISNULL(OT0117.ToQuantity3, 0) As ToQuantity3, ISNULL(OT0117.Price3, 0) As Price3,ISNULL(OT0117.DiscountAmount3, 0) As DiscountAmount3,
ISNULL(OT0117.FromQuantity4, 0) As FromQuantity4, ISNULL(OT0117.ToQuantity4, 0) As ToQuantity4, ISNULL(OT0117.Price4, 0) As Price4,ISNULL(OT0117.DiscountAmount4, 0) As DiscountAmount4,
ISNULL(OT0117.FromQuantity5, 0) As FromQuantity5, ISNULL(OT0117.ToQuantity5, 0) As ToQuantity5, ISNULL(OT0117.Price5, 0) As Price5,ISNULL(OT0117.DiscountAmount5, 0) As DiscountAmount5,
ISNULL(OT0117.FromQuantity6, 0) As FromQuantity6, ISNULL(OT0117.ToQuantity6, 0) As ToQuantity6, ISNULL(OT0117.Price6, 0) As Price6,ISNULL(OT0117.DiscountAmount6, 0) As DiscountAmount6,
ISNULL(OT0117.FromQuantity7, 0) As FromQuantity7, ISNULL(OT0117.ToQuantity7, 0) As ToQuantity7, ISNULL(OT0117.Price7, 0) As Price7,ISNULL(OT0117.DiscountAmount7, 0) As DiscountAmount7,
ISNULL(OT0117.FromQuantity8, 0) As FromQuantity8, ISNULL(OT0117.ToQuantity8, 0) As ToQuantity8, ISNULL(OT0117.Price8, 0) As Price8,ISNULL(OT0117.DiscountAmount8, 0) As DiscountAmount8,
ISNULL(OT0117.FromQuantity9, 0) As FromQuantity9, ISNULL(OT0117.ToQuantity9, 0) As ToQuantity9, ISNULL(OT0117.Price9, 0) As Price9,ISNULL(OT0117.DiscountAmount9, 0) As DiscountAmount9,
ISNULL(OT0117.FromQuantity10, 0) As FromQuantity10,ISNULL(OT0117.ToQuantity10, 0) As ToQuantity10,ISNULL(OT0117.Price10, 0) As Price10,ISNULL(OT0117.DiscountAmount10, 0) As DiscountAmount10,
ISNULL(OT0117.Price, 0) AS OT0117Price,
ISNULL(OT0117.Discount, 0) AS OT0117Discount,
AT1202.O01ID,
ISNULL(OT1302.TrayPrice,0) [TrayPrice] , ISNULL(OT1302.DecreaseTrayPrice,0) [DecreaseTrayPrice],OT1312.Qtyfrom,OT1312.QtyTo
'
        SET @sSQL1 = ' 
FROM AT1302
FULL JOIN OT1302 ON AT1302.InventoryID = OT1302.InventoryID AND AT1302.DivisionID = OT1302.DivisionID AND OT1302.ID = ''' + ISNULL(@ID_Price, '') + '''
LEFT JOIN OT1312 ON OT1312.ID = OT1302.DetailID AND OT1312.DivisionID = OT1302.DivisionID AND OT1312.PriceID = ''' + ISNULL(@ID_Price, '') + '''
LEFT JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT1302.DivisionID 
LEFT JOIN OT1304 ON OT1304.ID = ''' + @ID_Quantity + ''' AND OT1304.InventoryID = AT1302.InventoryID AND OT1304.DivisionID = AT1302.DivisionID 
LEFT JOIN OT1301 ON OT1301.ID = ''' + @PriceListID + ''' AND OT1301.DivisionID = AT1302.DivisionID AND OT1301.IsConvertedPrice = 1
LEFT JOIN (
            SELECT AV1004.CurrencyID,AV1004.DivisionID, AV1004.Operator, 
                COALESCE(AT1012.ExchangeRate,AV1004.ExchangeRate) AS ExchangeRate
            FROM AV1004
            LEFT JOIN (
                        SELECT Top 1 DivisionID , CurrencyID, ExchangeRate, ExchangeDate
                        FROM AT1012 
                        WHERE DATEDIFF(dd, ExchangeDate, ''' + CONVERT(VARCHAR(10),@VoucherDate,101) + ''') >= 0
                        ORDER BY ExchangeDate DESC
                      )AT1012 ON AT1012.DivisionID = AV1004.DivisionID AND AT1012.CurrencyID = AV1004.CurrencyID
           ) AV1004 ON AV1004.CurrencyID = ' + CASE WHEN @CurrencyID = @BaseCurrencyID THEN 'ISNULL(OT1301.CurrencyID, ''' + @BaseCurrencyID + ''')' ELSE '''' + @BaseCurrencyID + '''' END + ' AND AV1004.DivisionID = AT1302.DivisionID
LEFT JOIN OT0117 ON OT0117.DivisionID = AT1302.DivisionID AND OT0117.InventoryID = AT1302.InventoryID AND OT0117.ID = ''' + @PriceListID + '''
LEFT JOIN AT1202 ON AT1202.ObjectID = ''' + @ObjectID + ''' AND AT1202.DivisionID = ''' + @DivisionID + ''' 

WHERE AT1302.Disabled = 0
'
    END
ELSE IF @IsPriceControl = 1 AND @IsQuantityControl = 0
    BEGIN
        IF @PriceListID = '' -- Nếu không chọn bảng giá, sẽ lấy 1 bảng giá thỏa điều kiện đầu tiên
            BEGIN 
                IF ISNULL(@ObjectID, '') = ''
                    SELECT TOP 1 @ID_Price = ISNULL(ID, '')
                    FROM OT1301
                    WHERE @VoucherDate BETWEEN FromDate AND DATEADD(dd, 1, ISNULL(ToDate, CAST('12/30/9999' AS DATETIME)))
                    AND OID = '%' AND DivisionID = @DivisionID
                ELSE
                    SELECT TOP 1 
                    @ID_Price = ISNULL(ID, '')
                    FROM OT1301
                    WHERE @VoucherDate BETWEEN FromDate AND DATEADD(dd, 1, ISNULL(ToDate, CAST('12/30/9999' AS DATETIME)))
                    AND (
                            SELECT TOP 1 
                            CASE WHEN @OTypeID = 'O01ID' THEN ISNULL(O01ID, '%')
                            WHEN @OTypeID = 'O02ID' THEN ISNULL(O02ID, '%')
                            WHEN @OTypeID = 'O03ID' THEN ISNULL(O03ID, '%')
                            WHEN @OTypeID = 'O04ID' THEN ISNULL(O04ID, '%')
                            ELSE ISNULL(O05ID, '%')
                            END AS ObjectTypeID
                            FROM AT1202
                            WHERE ObjectID LIKE ISNULL(@ObjectID, '')
                            AND DivisionID = @DivisionID AND [Disabled] = 0
                        ) LIKE OID
                    AND DivisionID = @DivisionID AND [Disabled] = 0
                    ORDER BY ID
            END
    ELSE 
        SET @ID_Price = @PriceListID

        SET @sSQL = '
SELECT 
AT1302.DivisionID,
AT1302.InventoryID,
AT1302.InventoryName,
AT1302.Specification,
ISNULL(OT1302.UnitID,AT1302.UnitID) AS UnitID,
AT1304.UnitName,
AT1302.InventoryTypeID,
AT1302.IsStocked,
AT1302.VATGroupID,
AT1302.VATPercent,
	ISNULL((CASE WHEN AV1004.Operator = 0 
			THEN ISNULL((CASE WHEN ''' + LTRIM(@IsConvertedUnit) + ''' = ''0'' 
							THEN ISNULL(OT1312.UnitPrice,OT1302.UnitPrice)
							ELSE ISNULL(OT1312.UnitPrice,OT1302.ConvertedUnitPrice) END), AT1302.SalePrice01)*AV1004.ExchangeRate 
			ELSE ISNULL((CASE WHEN ''' + LTRIM(@IsConvertedUnit) + ''' = ''0'' 
							THEN ISNULL(OT1312.UnitPrice,OT1302.UnitPrice)
							ELSE ISNULL(OT1312.UnitPrice,OT1302.ConvertedUnitPrice) END), AT1302.SalePrice01)/AV1004.ExchangeRate END),0) 
	AS SalePrice,
CASE WHEN AV1004.Operator = 0 THEN OT1302.UnitPrice*AV1004.ExchangeRate ELSE OT1302.UnitPrice/AV1004.ExchangeRate END AS UnitPrice,
ISNULL(OT1302.MinPrice, 0) AS MinPrice,
ISNULL(OT1302.MaxPrice, 0) AS MaxPrice,
CAST(NULL AS DECIMAL(28, 8)) AS MinQuantity,
CAST(NULL AS DECIMAL(28, 8)) AS MaxQuantity,
CASE WHEN ISNULL(OT1302.MaxPrice, 0) <> 0 AND ISNULL(OT1302.MinPrice, 0) <> 0 THEN 3
     WHEN ISNULL(OT1302.MaxPrice, 0) <> 0 AND ISNULL(OT1302.MinPrice, 0) = 0 THEN 2
     WHEN ISNULL(OT1302.MaxPrice, 0) = 0 AND ISNULL(OT1302.MinPrice, 0) <> 0 THEN 1 
     ELSE 0 
END AS TypePriceControl, 
0 AS TypeQuantityControl,
ISNULL(AT1302.SalePrice01, 0) As SalePrice01,
ISNULL(AT1302.SalePrice02, 0) As SalePrice02,
ISNULL(AT1302.SalePrice03, 0) As SalePrice03,
ISNULL(AT1302.SalePrice04, 0) As SalePrice04,
ISNULL(AT1302.SalePrice05, 0) As SalePrice05,
ISNULL(OT1302.Notes, '''') AS Notes,
ISNULL(OT1302.Notes01, '''') AS Notes01,
ISNULL(OT1302.Notes02, '''') AS Notes02,
AT1302.Barcode,
ISNULL(DiscountPercent, 0) AS DiscountPercent,
ISNULL(DiscountAmount, 0) AS DiscountAmount,
ISNULL(SaleOffPercent01, 0) AS SaleOffPercent01,
ISNULL(SaleOffAmount01, 0) AS SaleOffAmount01,
ISNULL(SaleOffPercent02, 0) AS SaleOffPercent02,
ISNULL(SaleOffAmount02, 0) AS SaleOffAmount02,
ISNULL(SaleOffPercent03, 0) AS SaleOffPercent03,
ISNULL(SaleOffAmount03, 0) AS SaleOffAmount03,
ISNULL(SaleOffPercent04, 0) AS SaleOffPercent04,
ISNULL(SaleOffAmount04, 0) AS SaleOffAmount04,
ISNULL(SaleOffPercent05, 0) AS SaleOffPercent05,
ISNULL(SaleOffAmount05, 0) AS SaleOffAmount05,
ISNULL(OT0117.FromQuantity1, 0) As FromQuantity1, ISNULL(OT0117.ToQuantity1, 0) As ToQuantity1, ISNULL(OT0117.Price1, 0) As Price1,ISNULL(OT0117.DiscountAmount1, 0) As DiscountAmount1,
ISNULL(OT0117.FromQuantity2, 0) As FromQuantity2, ISNULL(OT0117.ToQuantity2, 0) As ToQuantity2, ISNULL(OT0117.Price2, 0) As Price2,ISNULL(OT0117.DiscountAmount2, 0) As DiscountAmount2,
ISNULL(OT0117.FromQuantity3, 0) As FromQuantity3, ISNULL(OT0117.ToQuantity3, 0) As ToQuantity3, ISNULL(OT0117.Price3, 0) As Price3,ISNULL(OT0117.DiscountAmount3, 0) As DiscountAmount3,
ISNULL(OT0117.FromQuantity4, 0) As FromQuantity4, ISNULL(OT0117.ToQuantity4, 0) As ToQuantity4, ISNULL(OT0117.Price4, 0) As Price4,ISNULL(OT0117.DiscountAmount4, 0) As DiscountAmount4,
ISNULL(OT0117.FromQuantity5, 0) As FromQuantity5, ISNULL(OT0117.ToQuantity5, 0) As ToQuantity5, ISNULL(OT0117.Price5, 0) As Price5,ISNULL(OT0117.DiscountAmount5, 0) As DiscountAmount5,
ISNULL(OT0117.FromQuantity6, 0) As FromQuantity6, ISNULL(OT0117.ToQuantity6, 0) As ToQuantity6, ISNULL(OT0117.Price6, 0) As Price6,ISNULL(OT0117.DiscountAmount6, 0) As DiscountAmount6,
ISNULL(OT0117.FromQuantity7, 0) As FromQuantity7, ISNULL(OT0117.ToQuantity7, 0) As ToQuantity7, ISNULL(OT0117.Price7, 0) As Price7,ISNULL(OT0117.DiscountAmount7, 0) As DiscountAmount7,
ISNULL(OT0117.FromQuantity8, 0) As FromQuantity8, ISNULL(OT0117.ToQuantity8, 0) As ToQuantity8, ISNULL(OT0117.Price8, 0) As Price8,ISNULL(OT0117.DiscountAmount8, 0) As DiscountAmount8,
ISNULL(OT0117.FromQuantity9, 0) As FromQuantity9, ISNULL(OT0117.ToQuantity9, 0) As ToQuantity9, ISNULL(OT0117.Price9, 0) As Price9,ISNULL(OT0117.DiscountAmount9, 0) As DiscountAmount9,
ISNULL(OT0117.FromQuantity10, 0) As FromQuantity10,ISNULL(OT0117.ToQuantity10, 0) As ToQuantity10,ISNULL(OT0117.Price10, 0) As Price10,ISNULL(OT0117.DiscountAmount10, 0) As DiscountAmount10,
ISNULL(OT0117.Price, 0) AS OT0117Price,
ISNULL(OT0117.Discount, 0) AS OT0117Discount,
AT1202.O01ID,
ISNULL(OT1302.TrayPrice,0) [TrayPrice] , ISNULL(OT1302.DecreaseTrayPrice,0) [DecreaseTrayPrice],OT1312.Qtyfrom,OT1312.QtyTo
'
        SET @sSQL1 = ' 
FROM AT1302
FULL JOIN OT1302 ON AT1302.InventoryID = OT1302.InventoryID AND AT1302.DivisionID = OT1302.DivisionID AND OT1302.ID = ''' + ISNULL(@ID_Price, '') + '''
LEFT JOIN OT1312 ON OT1312.ID = OT1302.DetailID AND OT1312.DivisionID = OT1302.DivisionID AND OT1312.PriceID = ''' + ISNULL(@ID_Price, '') + '''
LEFT JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT1302.DivisionID 
LEFT JOIN OT1301 ON OT1301.ID = ''' + @PriceListID + ''' AND OT1301.DivisionID = AT1302.DivisionID AND OT1301.IsConvertedPrice = 1
LEFT JOIN (
            SELECT AV1004.CurrencyID,AV1004.DivisionID, AV1004.Operator,
                COALESCE(AT1012.ExchangeRate,AV1004.ExchangeRate) AS ExchangeRate
            FROM AV1004
            LEFT JOIN (
                        SELECT Top 1 DivisionID , CurrencyID, ExchangeRate, ExchangeDate 
                        FROM AT1012 
                        WHERE DATEDIFF(dd, ExchangeDate, ''' + CONVERT(VARCHAR(10),@VoucherDate,101) + ''') >= 0
                        ORDER BY ExchangeDate DESC
                      )AT1012 ON AT1012.DivisionID = AV1004.DivisionID AND AT1012.CurrencyID = AV1004.CurrencyID
          ) AV1004 ON AV1004.CurrencyID = ' + CASE WHEN @CurrencyID = @BaseCurrencyID THEN 'ISNULL(OT1301.CurrencyID, ''' + @BaseCurrencyID + ''')' ELSE '''' + @BaseCurrencyID + '''' END + ' AND AV1004.DivisionID = AT1302.DivisionID
LEFT JOIN OT0117 ON OT0117.DivisionID = AT1302.DivisionID AND OT0117.InventoryID = AT1302.InventoryID AND OT0117.ID = ''' + @PriceListID + '''
LEFT JOIN AT1202 ON AT1202.ObjectID = ''' + @ObjectID + ''' AND AT1202.DivisionID = ''' + @DivisionID + '''

WHERE AT1302.Disabled = 0
'
    END
ELSE
------------Quan ly so luong
    BEGIN
        SET @ID_Quantity = ISNULL(( SELECT TOP 1 ID
        FROM OT1303
        WHERE @VoucherDate BETWEEN FromDate AND CASE WHEN ToDate = '01/01/1900' THEN '12/30/9999' ELSE ToDate END
        AND DivisionID = @DivisionID AND [Disabled] = 0), '')

        SET @sSQL = '
SELECT
AT1302.DivisionID,
AT1302.InventoryID,
AT1302.InventoryName,
AT1302.Specification,
AT1302.UnitID,
AT1304.UnitName,
AT1302.InventoryTypeID,
AT1302.IsStocked,
AT1302.VATGroupID,
AT1302.VATPercent,
ISNULL((CASE WHEN AV1004.Operator = 0 
	THEN AT1302.SalePrice01*AV1004.ExchangeRate 
	ELSE AT1302.SalePrice01/AV1004.ExchangeRate END),0) 
AS SalePrice,
CAST(NULL AS DECIMAL(28,8)) AS UnitPrice,
CAST(NULL AS DECIMAL(28,8)) AS MinPrice,
CAST(NULL AS DECIMAL(28,8)) AS MaxPrice,
ISNULL(OT1304.MinQuantity, 0) AS MinQuantity,
ISNULL(OT1304.MaxQuantity, 0) AS MaxQuantity,
0 AS TypePriceControl,
CASE WHEN ISNULL(OT1304.MaxQuantity, 0) <> 0 AND ISNULL(OT1304.MinQuantity, 0) <> 0 THEN 3
     WHEN ISNULL(OT1304.MaxQuantity, 0) <> 0 AND ISNULL(OT1304.MinQuantity, 0) = 0 THEN 2
     WHEN ISNULL(OT1304.MaxQuantity, 0) = 0 AND ISNULL(OT1304.MinQuantity, 0) <> 0 THEN 1 
     ELSE 0 
END AS TypeQuantityControl,
ISNULL(AT1302.SalePrice01, 0) As SalePrice01,
ISNULL(AT1302.SalePrice02, 0) As SalePrice02,
ISNULL(AT1302.SalePrice03, 0) As SalePrice03,
ISNULL(AT1302.SalePrice04, 0) As SalePrice04,
ISNULL(AT1302.SalePrice05, 0) As SalePrice05,
CAST(NULL AS NVARCHAR(250)) AS Notes,
CAST(NULL AS NVARCHAR(250)) AS Notes01,
CAST(NULL AS NVARCHAR(250)) AS Notes02,
AT1302.Barcode,
CAST(0 AS DECIMAL(28,8)) AS DiscountPercent,
CAST(0 AS DECIMAL(28,8)) AS DiscountAmount,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent01,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount01,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent02,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount02,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent03,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount03,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent04,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount04,
CAST(0 AS DECIMAL(28,8)) AS SaleOffPercent05,
CAST(0 AS DECIMAL(28,8)) AS SaleOffAmount05,
ISNULL(OT0117.FromQuantity1, 0) As FromQuantity1, ISNULL(OT0117.ToQuantity1, 0) As ToQuantity1, ISNULL(OT0117.Price1, 0) As Price1,ISNULL(OT0117.DiscountAmount1, 0) As DiscountAmount1,
ISNULL(OT0117.FromQuantity2, 0) As FromQuantity2, ISNULL(OT0117.ToQuantity2, 0) As ToQuantity2, ISNULL(OT0117.Price2, 0) As Price2,ISNULL(OT0117.DiscountAmount2, 0) As DiscountAmount2,
ISNULL(OT0117.FromQuantity3, 0) As FromQuantity3, ISNULL(OT0117.ToQuantity3, 0) As ToQuantity3, ISNULL(OT0117.Price3, 0) As Price3,ISNULL(OT0117.DiscountAmount3, 0) As DiscountAmount3,
ISNULL(OT0117.FromQuantity4, 0) As FromQuantity4, ISNULL(OT0117.ToQuantity4, 0) As ToQuantity4, ISNULL(OT0117.Price4, 0) As Price4,ISNULL(OT0117.DiscountAmount4, 0) As DiscountAmount4,
ISNULL(OT0117.FromQuantity5, 0) As FromQuantity5, ISNULL(OT0117.ToQuantity5, 0) As ToQuantity5, ISNULL(OT0117.Price5, 0) As Price5,ISNULL(OT0117.DiscountAmount5, 0) As DiscountAmount5,
ISNULL(OT0117.FromQuantity6, 0) As FromQuantity6, ISNULL(OT0117.ToQuantity6, 0) As ToQuantity6, ISNULL(OT0117.Price6, 0) As Price6,ISNULL(OT0117.DiscountAmount6, 0) As DiscountAmount6,
ISNULL(OT0117.FromQuantity7, 0) As FromQuantity7, ISNULL(OT0117.ToQuantity7, 0) As ToQuantity7, ISNULL(OT0117.Price7, 0) As Price7,ISNULL(OT0117.DiscountAmount7, 0) As DiscountAmount7,
ISNULL(OT0117.FromQuantity8, 0) As FromQuantity8, ISNULL(OT0117.ToQuantity8, 0) As ToQuantity8, ISNULL(OT0117.Price8, 0) As Price8,ISNULL(OT0117.DiscountAmount8, 0) As DiscountAmount8,
ISNULL(OT0117.FromQuantity9, 0) As FromQuantity9, ISNULL(OT0117.ToQuantity9, 0) As ToQuantity9, ISNULL(OT0117.Price9, 0) As Price9,ISNULL(OT0117.DiscountAmount9, 0) As DiscountAmount9,
ISNULL(OT0117.FromQuantity10, 0) As FromQuantity10,ISNULL(OT0117.ToQuantity10, 0) As ToQuantity10,ISNULL(OT0117.Price10, 0) As Price10,ISNULL(OT0117.DiscountAmount10, 0) As DiscountAmount10,
ISNULL(OT0117.Price, 0) AS OT0117Price,
ISNULL(OT0117.Discount, 0) AS OT0117Discount,
CAST(NULL AS NVARCHAR(250)) AS O01ID,
0 TrayPrice , 0 DecreaseTrayPrice,NULL Qtyfrom,NULL QtyTo 
'
        SET @sSQL1 = ' 
FROM AT1302 
LEFT JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT1302.DivisionID
LEFT JOIN OT1304 ON OT1304.ID = ''' + @ID_Quantity + ''' AND OT1304.InventoryID = AT1302.InventoryID AND OT1304.DivisionID = AT1302.DivisionID
LEFT JOIN OT1301 ON OT1301.ID = ''' + @PriceListID + ''' AND OT1301.DivisionID = AT1302.DivisionID AND OT1301.IsConvertedPrice = 1
LEFT JOIN (
            SELECT AV1004.CurrencyID,AV1004.DivisionID, AV1004.Operator,
                COALESCE(AT1012.ExchangeRate,AV1004.ExchangeRate) AS ExchangeRate
            FROM AV1004
            LEFT JOIN (
                        SELECT Top 1 DivisionID , CurrencyID, ExchangeRate, ExchangeDate 
                        FROM AT1012 
                        WHERE DATEDIFF(dd, ExchangeDate, ''' + CONVERT(VARCHAR(10),@VoucherDate,101) + ''') >= 0
                        ORDER BY ExchangeDate DESC
                      )AT1012 ON AT1012.DivisionID = AV1004.DivisionID AND AT1012.CurrencyID = AV1004.CurrencyID
          ) AV1004 ON AV1004.CurrencyID = ' + CASE WHEN @CurrencyID = @BaseCurrencyID THEN 'ISNULL(OT1301.CurrencyID, ''' + @BaseCurrencyID + ''')' ELSE '''' + @BaseCurrencyID + '''' END + ' AND AV1004.DivisionID = AT1302.DivisionID
LEFT JOIN OT0117 ON OT0117.DivisionID = AT1302.DivisionID AND OT0117.InventoryID = AT1302.InventoryID AND OT0117.ID = ''' + @PriceListID + '''

WHERE AT1302.Disabled = 0
'
END 

--PRINT @sSQL
--PRINT(@sSQL1)
IF NOT EXISTS(SELECT TOP 1 1 FROM SysObjects WHERE XType = 'V' AND NAME = 'OV1302')
    EXEC ('CREATE VIEW OV1302 -- Tao boi OP1302 
        AS ' + @sSQL + @sSQL1)
ELSE
    EXEC ('ALTER VIEW OV1302 -- Tao boi OP1302 
        AS ' + @sSQL + @sSQL1)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

