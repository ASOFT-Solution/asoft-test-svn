IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3121]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3121]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Báo cáo bán hàng theo mã phân tích - tổng hợp theo mặt hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create ON 27/12/2011 by Nguyen Thi Ngoc Minh
---- Modified ON 15/08/2006 by Nguyen Quoc Huy
---- Modified ON 23/03/2007 by Thuy Tuyen: Lấy thêm trường CurrencyID
---- Modified ON 29/07/2010 by Tố Oanh
---- Modified ON 13/12/2010 by Hoang Phuoc: Truong hop isMonth = 1, bo sung begin end
---- Modified ON 27/12/2011 by Nguyễn Bình Minh:
---- Modified ON 09/03/2012 by Lê Thị Thu Hiền : Sửa /(T19.ConversionFactor,0)
---- Modified ON 31/12/2013 by Lê Thị Thu Hiền : bổ sung O01ID - O05ID, O01Name - O05Name (khách hàng CAAN)
---- Modified by Mai Duyen on 31/12/2013: Bổ sung lấy thêm cột InventoryTypeName,I01Name (khách hàng VIMEC)
---- Modified by Phuong Thao on 01/10/2015: Bổ sung lấy thêm cột SalePrice01 , I01ID-I05ID, I01Name-I05Name
---- Modified by Tieu Mai on 04/01/2016: Bo sung them cot VATNo
----
-- <Example>
----
---- 
CREATE PROCEDURE [dbo].[AP3121] 
(
	@DivisionID AS NVARCHAR(50),
	@Group1 AS NVARCHAR(50),
	@IsFilter1 AS TINYINT,
	@Filter1 AS NVARCHAR(50),
	@Group1From AS NVARCHAR(50),
	@Group1To AS NVARCHAR(50),				
	@Group2 AS NVARCHAR(50),
	@IsFilter2 AS TINYINT,
	@Filter2 AS NVARCHAR(50),
	@Group2From AS NVARCHAR(50),
	@Group2To AS NVARCHAR(50),
	@Group3 AS NVARCHAR(50),
	@IsFilter3 AS TINYINT,
	@Filter3 AS NVARCHAR(50),
	@Group3From AS NVARCHAR(50),
	@Group3To AS NVARCHAR(50),
	@FromInventoryID AS NVARCHAR(50),
	@ToInventoryID AS NVARCHAR(50),
	@FromInventoryTypeID AS NVARCHAR(50),
	@ToInventoryTypeID AS NVARCHAR(50),
	@FromDate AS DATETIME,
	@ToDate AS DATETIME,
	@FromMonth AS INT,
	@FromYear AS INT,
	@ToMonth AS INT,
	@ToYear AS INT,
	@IsMonth AS TINYINT,
	@AmountUnit AS INT,
	@IsDebit AS TINYINT
)
AS

DECLARE 	@sSQL AS nvarchar(max),
			@sSQL1 AS nvarchar(max),
			@sWHERE AS varchar(500),
			@sSELECT AS nvarchar(500),
			@sGROUPBY AS nvarchar(500),
			@PeriodFrom AS int,
			@PeriodTo AS int,
			@ConversionAmountUnit AS int,
			@GroupName1 AS nvarchar(250),
			@GroupName2 AS nvarchar(250),
			@GroupName3 AS nvarchar(250),
			@Filter1ID AS nvarchar(250),
			@Filter2ID AS nvarchar(250),
			@Filter3ID AS nvarchar(250),
			@Field1ID AS nvarchar(50),
			@Field2ID AS nvarchar(50),
			@Field3ID AS nvarchar(50)

--------------------------------------
SET @sSQL = '
SELECT 	TransactionID, 
		AT9000.InventoryID AS InventoryID, 			
		AT9000.UnitPrice AS  UnitPrice,
        DivisionID
FROM	AT9000
WHERE	DivisionID =  ''' + @DivisionID + '''  
		AND 
		TransactionTypeID =''T06'' AND
'
 
IF @IsMonth = 0
    SET @sSQL = @sSQL + ' CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) BETWEEN ''' + CONVERT(NVARCHAR(10), @FromDate, 101) + ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 101) + ''' '
ELSE
    SET @sSQL = @sSQL + ' TranMonth + TranYear * 100 BETWEEN ' + STR(@FromMonth) + '+ 100 * ' + STR(@FromYear) + ' AND ' + STR(@ToMonth) + ' + 100 * ' + STR(@ToYear) + '  '

IF NOT EXISTS (SELECT TOP 1 1 FROM   SysObjects WHERE  NAME = 'AV3211' AND Xtype = 'V')
    EXEC ('CREATE VIEW AV3211 -- tao boi AP3121     
        AS ' + @sSQL)
ELSE
    EXEC ('ALTER VIEW AV3211 -- tao boi AP3121
		AS ' + @sSQL)
----------------------------------------------

IF @AmountUnit = 0
    SET @ConversionAmountUnit = 1

IF @AmountUnit = 1
    SET @ConversionAmountUnit = 1000

IF @AmountUnit = 2
    SET @ConversionAmountUnit = 1000000

SET @PeriodFrom = @FromMonth + @FromYear * 100
SET @PeriodTo = @ToMonth + @ToYear * 100

IF @Group1 != ''
    EXEC AP4700 @Group1,
         @Field1ID OUTPUT

IF @Group2 != ''
    EXEC AP4700 @Group2,
         @Field2ID OUTPUT

IF @Group3 != ''
    EXEC AP4700 @Group3,
         @Field3ID OUTPUT

SET @sWHERE = ''
SET @sSELECT = ''
SET @sGROUPBY = ''

IF @IsDebit = 1
    SET @sWHERE = @sWHERE + ' AV4301.D_C = ''D'''
ELSE
    SET @sWHERE = @sWHERE + ' AV4301.D_C = ''C'''

IF @IsFilter1 = 1
BEGIN
    EXEC AP4700 @Filter1,
         @Filter1ID OUTPUT
    
    SET @sWHERE = @sWHERE + ' AND (AV4301.' + @Filter1ID + ' BETWEEN ''' + @Group1From + ''' AND ''' + @Group1To + ''') '
    
    SET @sSELECT = @sSELECT + ' AV4301.' + @Filter1ID + ' AS Filter1, '
    SET @sGROUPBY = @sGROUPBY + ', AV4301.' + @Filter1ID
END

IF @IsFilter2 = 1
BEGIN
    EXEC AP4700 @Filter2, @Filter2ID OUTPUT
    
    SET @sWHERE = @sWHERE + ' AND  (AV4301.' + @Filter2ID + ' BETWEEN ''' + @Group2From + ''' AND ''' + @Group2To + ''') '
    
    SET @sSELECT = @sSELECT + ' AV4301.' + @Filter2ID + ' AS Filter2, '
    SET @sGROUPBY = @sGROUPBY + ', AV4301.' + @Filter2ID
END

IF @IsFilter3 = 1
BEGIN
    EXEC AP4700 @Filter3, @Filter3ID OUTPUT
    
    SET @sWHERE = @sWHERE + ' AND (AV4301.' + @Filter3ID + ' BETWEEN ''' + @Group3From + ''' AND ''' + @Group3To + ''') '
    
    SET @sSELECT = @sSELECT + ' AV4301.' + @Filter3ID + ' AS Filter3, '
    SET @sGROUPBY = @sGROUPBY + ', AV4301.' + @Filter3ID
END

IF @IsMonth = 0
BEGIN
    SET @sSQL = '	
	SELECT	' + (CASE WHEN @Group1 != '' THEN ' V1.SelectionID AS Group1ID,
		   V1.SelectionName AS Group1Name,
		   ' ELSE '' END) 
				+ (CASE WHEN @Group2 != '' THEN ' V2.SelectionID AS Group2ID,
		   V2.SelectionName AS Group2Name,
		   ' ELSE '' END) 
				+ (CASE WHEN @Group3 != '' THEN ' V3.SelectionID AS Group3ID,
		   V3.SelectionName AS Group3Name,
		   ' ELSE ''END) + ' 
		   ' + @sSELECT + ' 
		   AV4301.InventoryID AS InvID,
		   T02.InventoryName, T02.Specification, T02.Varchar01, T02.Varchar02,
		   T34.UnitName,
		   AV4301.AnaName01,
		   ISNULL(V11.UnitPrice, 0) AS AVGUnitPrice,
		   ISNULL(AV4301.UnitPrice, 0) AS PriceList,
		   ISNULL(AV4301.CommissionPercent, 0) AS CommissionPercent,
		   ISNULL(AV4301.DiscountRate, 0) AS DisacountRate,
		   SUM(ISNULL(AV4301.Quantity, 0)) AS Quantity,
		   T19.ConversionFactor,
		   AV4301.VATTypeID,
		   CAST(SUM(ISNULL(AV4301.Quantity, 0)) AS INT) / CASE WHEN ISNULL(T19.ConversionFactor,0) = 0 THEN 1 ELSE T19.ConversionFactor END AS 
		   ConvertQuantity,
		   CAST(SUM(ISNULL(AV4301.Quantity, 0)) AS INT) % CASE WHEN ISNULL(T19.ConversionFactor,0) = 0 THEN 1 ELSE T19.ConversionFactor END AS 
		   ConvertQuantity1,
		   T34C.UnitName AS UnitNameC,
		   SUM(ISNULL(AV4301.OriginalAmount, 0)) / 
		   ' + LTRIM(RTRIM(STR(@ConversionAmountUnit))) 
				+ ' AS OriginalAmount,
		   SUM(ISNULL(AV4301.ConvertedAmount, 0)) / 
		   ' + LTRIM(RTRIM(STR(@ConversionAmountUnit))) 
				+ ' AS ConvertedAmount,
		   SUM(ISNULL(AV4301.VATOriginalAmount, 0)) / 
		   ' + LTRIM(RTRIM(STR(@ConversionAmountUnit))) 
				+ ' AS VATOriginalAmount,
		   SUM(ISNULL(AV4301.VATConvertedAmount, 0)) / 
		   ' + LTRIM(RTRIM(STR(@ConversionAmountUnit))) 
				+ ' AS VATConvertedAmount,
		   AV4301.CurrencyID,
		   AV4301.DivisionID ,
		    MAX(ISNULL(AV4301.O01ID,'''')) AS O01ID, 
		    MAX(ISNULL(AV4301.O02ID,'''')) AS O02ID, 
		    MAX(ISNULL(AV4301.O03ID,'''')) AS O03ID, 
		    MAX(ISNULL(AV4301.O04ID,'''')) AS O04ID, 
		    MAX(ISNULL(AV4301.O05ID,'''')) AS O05ID, 
			MAX(AV4301.O01Name) AS O01Name,
			MAX(AV4301.O02Name) AS O02Name,
			MAX(AV4301.O03Name) AS O03Name,
			MAX(AV4301.O04Name) AS O04Name,
			MAX(AV4301.O05Name) AS O05Name,
			Max(AV4301.CO3ID) as CO3ID, 
			Max(AV4301.InventoryTypeName) AS InventoryTypeName,
			ISNULL(T02.I01ID,'''') AS I01ID,
			ISNULL(T02.I02ID,'''') AS I02ID,
			ISNULL(T02.I03ID,'''') AS I03ID,
			ISNULL(T02.I04ID,'''') AS I04ID,
			ISNULL(T02.I05ID,'''') AS I05ID,
			ISNULL(I01.AnaName,'''') AS I01Name,
			ISNULL(I02.AnaName,'''') AS I02Name,
			ISNULL(I03.AnaName,'''') AS I03Name,
			ISNULL(I04.AnaName,'''') AS I04Name,
			ISNULL(I05.AnaName,'''') AS I05Name,
			T02.SalePrice01,
			AT1202.VATNo
  '   
    
    SET @sSQL1 = 'FROM AV4301 ' + (
            CASE WHEN @Group1 != '' THEN ' LEFT JOIN AV6666 V1 ON V1.SelectionType = ''' + @Group1 + ''' AND V1.DivisionID = AV4301.DivisionID 
				AND V1.SelectionID = AV4301.' + @Field1ID + '
					'
			ELSE '' END
			) +
			(CASE WHEN @Group2 != '' THEN ' LEFT JOIN AV6666 V2 ON V2.SelectionType = ''' + @Group2 + ''' AND V2.DivisionID = AV4301.DivisionID
				AND V2.SelectionID = AV4301.' + @Field2ID + '
				'
			ELSE '' END
			) +
			(
            CASE WHEN @Group3 != '' THEN ' LEFT JOIN AV6666 V3 ON V3.SelectionType = ''' + @Group3 + ''' AND V3.DivisionID = AV4301.DivisionID
				AND V3.SelectionID = AV4301.' + @Field3ID + '
				'
            ELSE ''END
			) + '
		LEFT JOIN AT1302 AS T02 ON T02.InventoryID = AV4301.InventoryID AND T02.DivisionID = AV4301.DivisionID
		LEFT JOIN AV3211 AS V11 ON V11.InventoryID = AV4301.InventoryID AND V11.TransactionID = AV4301.TransactionID  AND V11.DivisionID = AV4301.DivisionID
		LEFT JOIN AT1304 AS T34 ON T34.UnitID = AV4301.UnitID  AND T34.DivisionID = AV4301.DivisionID
		LEFT JOIN AT1309 AS T19 ON 	T19.Orders = 1 AND T19.InventoryID = AV4301.InventoryID  AND T19.DivisionID = AV4301.DivisionID
		LEFT JOIN AT1304 AS T34C ON T34C.UnitID = T19.UnitID AND T34C.DivisionID = AV4301.DivisionID
		LEFT JOIN AT1015 I01 ON I01.AnaID = T02.I01ID AND I01.AnaTypeID = ''I01''  AND I01.DivisionID = T02.DivisionID  
		LEFT JOIN AT1015 I02 ON I02.AnaID = T02.I02ID AND I02.AnaTypeID = ''I02''  AND I02.DivisionID = T02.DivisionID 
		LEFT JOIN AT1015 I03 ON I03.AnaID = T02.I03ID AND I03.AnaTypeID = ''I03''  AND I03.DivisionID = T02.DivisionID 
		LEFT JOIN AT1015 I04 ON I04.AnaID = T02.I04ID AND I04.AnaTypeID = ''I04''  AND I04.DivisionID = T02.DivisionID 
		LEFT JOIN AT1015 I05 ON I05.AnaID = T02.I05ID AND I05.AnaTypeID = ''I05''  AND I05.DivisionID = T02.DivisionID
		LEFT JOIN AT1202 ON AV4301.ObjectID = AT1202.ObjectID and AV4301.DivisionID = AT1202.DivisionID
		WHERE	AV4301.DivisionID = ''' + @DivisionID +  ''' AND 
				CONVERT(DATETIME,CONVERT(VARCHAR(10),AV4301.VoucherDate,101),101) BETWEEN ''' + CONVERT(NVARCHAR(10), @FromDate, 101) +  ''' AND ''' + CONVERT(NVARCHAR(10), @ToDate, 101) +  ''' 
				AND (AV4301.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''')
				AND (T02.InventoryTypeID BETWEEN ''' + @FromInventoryTypeID + ''' AND ''' + @ToInventoryTypeID + ''')
				AND AV4301.TransactionTypeID in (''T04'',''T40'') AND
		' + @sWHERE + '

		GROUP BY ' + (CASE WHEN @Group1 != '' THEN ' V1.SelectionID, V1.SelectionName, ' ELSE '' END)
					+ (CASE WHEN @Group2 != '' THEN ' V2.SelectionID, V2.SelectionName, 'ELSE '' END) 
					+ (CASE WHEN @Group3 != '' THEN ' V3.SelectionID, V3.SelectionName, ' ELSE '' END) 
					+ '
					AV4301.InventoryID, V11.UnitPrice, AV4301.UnitPrice, T02.InventoryName, T02.Specification, T02.Varchar01, T02.Varchar02,
					AV4301.DiscountRate, T19.ConversionFactor,  AV4301.VATTypeID, 
					T19.Operator, T34C.UnitName, AV4301.AnaName01,AV4301.CurrencyID,
					AV4301.CommissionPercent, T34.UnitName, AV4301.DivisionID, 
					ISNULL(T02.I01ID,''''),
					ISNULL(T02.I02ID,''''),
					ISNULL(T02.I03ID,''''),
					ISNULL(T02.I04ID,''''),
					ISNULL(T02.I05ID,''''),
					ISNULL(I01.AnaName,''''),
					ISNULL(I02.AnaName,''''),
					ISNULL(I03.AnaName,''''),
					ISNULL(I04.AnaName,''''),
					ISNULL(I05.AnaName,''''),					
					T02.SalePrice01, AT1202.VATNo
					
  ' + @sGROUPBY
END
ELSE
BEGIN
    SET @sSQL = '
	SELECT	' + (CASE  WHEN @Group1 != '' THEN  ' V1.SelectionID AS Group1ID, V1.SelectionName AS Group1Name, ' ELSE '' END) 
				+ (CASE WHEN @Group2 != '' THEN ' V2.SelectionID AS Group2ID, V2.SelectionName AS Group2Name, ' ELSE ''END) 
				+ (CASE WHEN @Group3 != '' THEN ' V3.SelectionID AS Group3ID, V3.SelectionName AS Group3Name, ' ELSE '' END) 
				+ '
		' + @sSELECT + '		
			AV4301.InventoryID AS InvID, T02.InventoryName, T02.Specification, T02.Varchar01, T02.Varchar02, 
			T34.UnitName, AV4301.AnaName01,
			ISNULL(AV4301.UnitPrice, 0)  AS PriceList,
			ISNULL(AV4301.CommissionPercent, 0) AS CommissionPercent,
			ISNULL(AV4301.DiscountRate, 0) AS DisacountRate,
			SUM(ISNULL(AV4301.Quantity, 0)) AS Quantity,	
			T19.ConversionFactor, AV4301.VATTypeID,
			CAST(SUM(ISNULL(AV4301.Quantity, 0)) AS INT) / CASE WHEN ISNULL(T19.ConversionFactor,0) = 0 THEN 1 ELSE T19.ConversionFactor END AS ConvertQuantity,
			CAST(SUM(ISNULL(AV4301.Quantity, 0)) AS INT) % CASE WHEN ISNULL(T19.ConversionFactor,0) = 0 THEN 1 ELSE T19.ConversionFactor END AS ConvertQuantity1,
			T34C.UnitName AS UnitNameC, 
			SUM(ISNULL(AV4301.OriginalAmount, 0)) / ' + LTRIM(RTRIM(STR(@ConversionAmountUnit))) 
			+ ' AS OriginalAmount,
			SUM(ISNULL(AV4301.ConvertedAmount, 0)) / ' + LTRIM(RTRIM(STR(@ConversionAmountUnit))) 
			+ ' AS ConvertedAmount,
			SUM(ISNULL(AV4301.VATOriginalAmount, 0)) / ' + LTRIM(RTRIM(STR(@ConversionAmountUnit))) 
			+ ' AS VATOriginalAmount,
			SUM(ISNULL(AV4301.VATConvertedAmount, 0)) / ' + LTRIM(RTRIM(STR(@ConversionAmountUnit))) 
			+ ' AS VATConvertedAmount,
			AV4301.CurrencyID, AV4301.DivisionID, 
			MAX(ISNULL(AV4301.O01ID,'''')) AS O01ID, 
		    MAX(ISNULL(AV4301.O02ID,'''')) AS O02ID, 
		    MAX(ISNULL(AV4301.O03ID,'''')) AS O03ID, 
		    MAX(ISNULL(AV4301.O04ID,'''')) AS O04ID, 
		    MAX(ISNULL(AV4301.O05ID,'''')) AS O05ID, 
			MAX(AV4301.O01Name) AS O01Name,
			MAX(AV4301.O02Name) AS O02Name,
			MAX(AV4301.O03Name) AS O03Name,
			MAX(AV4301.O04Name) AS O04Name,
			MAX(AV4301.O05Name) AS O05Name,
			Max(AV4301.CO3ID) as CO3ID,  
			Max(AV4301.InventoryTypeName) AS InventoryTypeName,
			ISNULL(T02.I01ID,'''') AS I01ID,
			ISNULL(T02.I02ID,'''') AS I02ID,
			ISNULL(T02.I03ID,'''') AS I03ID,
			ISNULL(T02.I04ID,'''') AS I04ID,
			ISNULL(T02.I05ID,'''') AS I05ID,
			ISNULL(I01.AnaName,'''') AS I01Name,
			ISNULL(I02.AnaName,'''') AS I02Name,
			ISNULL(I03.AnaName,'''') AS I03Name,
			ISNULL(I04.AnaName,'''') AS I04Name,
			ISNULL(I05.AnaName,'''') AS I05Name,
			T02.SalePrice01,
			AT1202.VATNo
  '    
    SET @sSQL1 = ' FROM AV4301 ' 
					+ (CASE WHEN @Group1 != '' THEN ' LEFT JOIN AV6666 V1 ON V1.SelectionType = ''' + @Group1 + ''' AND V1.DivisionID = AV4301.DivisionID 
							AND V1.SelectionID = AV4301.' + @Field1ID + '
							'
						ELSE '' END) 
					+ (CASE WHEN @Group2 != '' THEN ' LEFT JOIN AV6666 V2 ON V2.SelectionType = ''' + @Group2 + ''' AND V2.DivisionID = AV4301.DivisionID
							AND V2.SelectionID = AV4301.' + @Field2ID + '
							'
				         ELSE '' END) 
				    + (CASE WHEN @Group3 != '' THEN ' LEFT JOIN AV6666 V3 ON V3.SelectionType = ''' + @Group3 + ''' AND V3.DivisionID = AV4301.DivisionID
						    AND V3.SelectionID = AV4301.' + @Field3ID + '
						    '
						ELSE ''END) 
					+ '
		LEFT JOIN AT1302 AS T02 ON T02.InventoryID = AV4301.InventoryID  AND T02.DivisionID = AV4301.DivisionID 
		LEFT JOIN AV3211 AS V11 ON V11.InventoryID = AV4301.InventoryID AND V11.TransactionID = AV4301.TransactionID
									AND V11.DivisionID = AV4301.DivisionID 
		LEFT JOIN AT1304 AS T34 ON T34.UnitID = AV4301.UnitID AND T34.DivisionID = AV4301.DivisionID 
		LEFT JOIN AT1309 AS T19 ON T19.Orders = 1 AND T19.InventoryID = AV4301.InventoryID AND T19.DivisionID = AV4301.DivisionID 
		LEFT JOIN AT1304 AS T34C ON T34C.UnitID = T19.UnitID AND T34C.DivisionID = AV4301.DivisionID 
		LEFT JOIN AT1015 I01 ON I01.AnaID = T02.I01ID AND I01.AnaTypeID = ''I01''  AND I01.DivisionID = T02.DivisionID  
		LEFT JOIN AT1015 I02 ON I02.AnaID = T02.I02ID AND I02.AnaTypeID = ''I02''  AND I02.DivisionID = T02.DivisionID 
		LEFT JOIN AT1015 I03 ON I03.AnaID = T02.I03ID AND I03.AnaTypeID = ''I03''  AND I03.DivisionID = T02.DivisionID 
		LEFT JOIN AT1015 I04 ON I04.AnaID = T02.I04ID AND I04.AnaTypeID = ''I04''  AND I04.DivisionID = T02.DivisionID 
		LEFT JOIN AT1015 I05 ON I05.AnaID = T02.I05ID AND I05.AnaTypeID = ''I05''  AND I05.DivisionID = T02.DivisionID
		LEFT JOIN AT1202 ON AV4301.ObjectID = AT1202.ObjectID and AV4301.DivisionID = AT1202.DivisionID		
		WHERE	AV4301.DivisionID = ''' + @DivisionID + 
				''' AND ((AV4301.TranMonth + AV4301.TranYear*100) BETWEEN ''' + LTRIM(RTRIM(STR(@PeriodFrom))) + ''' AND ''' + LTRIM(RTRIM(STR(@PeriodTo))) + ''')
				AND (AV4301.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') 
				AND (T02.InventoryTypeID BETWEEN ''' + @FromInventoryTypeID + ''' AND ''' + @ToInventoryTypeID + ''')
				AND AV4301.TransactionTypeID  in (''T04'',''T40'') 
				AND ' + @sWHERE + '

		GROUP BY ' + (CASE  WHEN @Group1 != '' THEN ' V1.SelectionID, V1.SelectionName, ' ELSE '' END) 
					+ (CASE WHEN @Group2 != '' THEN ' V2.SelectionID, V2.SelectionName, ' ELSE '' END) 
					+ (CASE WHEN @Group3 != '' THEN '	V3.SelectionID, 	V3.SelectionName, ' ELSE '' END ) + '
				AV4301.InventoryID, V11.UnitPrice, T02.InventoryName, T02.Specification, T02.Varchar01, T02.Varchar02, 
				AV4301.CommissionPercent, AV4301.UnitPrice,
				AV4301.DiscountRate, AV4301.CurrencyID ,T19.ConversionFactor, AV4301.VATTypeID,T19.Operator, T34C.UnitName, AV4301.AnaName01,
				T34.UnitName, AV4301.DivisionID, 
				ISNULL(T02.I01ID,''''),
				ISNULL(T02.I02ID,''''),
				ISNULL(T02.I03ID,''''),
				ISNULL(T02.I04ID,''''),
				ISNULL(T02.I05ID,''''),
				ISNULL(I01.AnaName,''''),
				ISNULL(I02.AnaName,''''),
				ISNULL(I03.AnaName,''''),
				ISNULL(I04.AnaName,''''),
				ISNULL(I05.AnaName,''''),					
				T02.SalePrice01, AT1202.VATNo 
 ' + @sGROUPBY
END

--PRINT (@sSQL)
--print(@sSQL1)

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE  NAME = 'AV3121' AND Xtype = 'V')
    EXEC ('CREATE VIEW AV3121 -- tao boi AP3121
           AS ' + @sSQL + @sSQL1)
ELSE
    EXEC ('ALTER VIEW AV3121 -- tao boi AP3121
		   AS ' + @sSQL + @sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

