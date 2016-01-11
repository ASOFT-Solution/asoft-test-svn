IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2888]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP2888]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create on 10/09/2012 by Bao Anh
---- Purpose: In bao cao nhap xuat ton tung kho theo quy cach (yeu cau cua 2T)
--- <Example>

CREATE PROCEDURE [dbo].[AP2888]
    @DivisionID NVARCHAR(50), 
    @FromMonth INT, 
    @ToMonth INT, 
    @FromYear INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @IsDate TINYINT, 
    @IsGroupID TINYINT, --- 0 Khong nhom; 1 Nhom 1 cap; 2 Nhom 2 cap
    @GroupID1 NVARCHAR(50), 
    @GroupID2 NVARCHAR(50) 
    --- Note : GroupID nhan cac gia tri S1, S2, S3, CI1, CI2, CI3
AS

DECLARE
	@sSQLSelect AS NVARCHAR(4000), 
	@sSQLFrom AS NVARCHAR(4000), 
	@sSQLFrom1 AS NVARCHAR(4000), 
	@sSQLWhere AS NVARCHAR(4000), 
	@sSQLUnion AS NVARCHAR(4000), 
	@GroupField1 AS NVARCHAR(50), 
	@GroupField2 AS NVARCHAR(50), 
	@FromMonthYearText NVARCHAR(20), 
	@ToMonthYearText NVARCHAR(20), 
	@FromDateText NVARCHAR(20), 
	@ToDateText NVARCHAR(20),
	@WhereTime AS NVARCHAR(4000)

-- ??m b?o chu?i không b? null d?n t?i ghép chu?i b? l?i
SET @sSQLSelect = ''
SET @sSQLFrom = ''
SET @sSQLFrom1 = ''
SET @sSQLWhere = ''
SET @sSQLUnion = ''
SET @GroupField1 = ''
SET @GroupField2 = ''
SET @WhereTime = ''

SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

IF @IsDate = 0 --Xac dinh so du theo ky
	BEGIN
		SET @WhereTime = ' AV7000.TranMonth + AV7000.TranYear BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText
		SET @sSQLSelect = ' 
SELECT 
AT1302.S1, AT1302.S2, AT1302.S3, 
AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID, 
AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 

AT2888.InventoryID, AT1302.InventoryName, AT1302.InventoryTypeID, 
AT1302.Specification, AT1302.UnitID, AT1304.UnitName,
AT2888.Parameter01, AT2888.Parameter02, AT2888.Parameter03, AT2888.Parameter04, AT2888.Parameter05,

SUM(CASE WHEN TranMonth + TranYear * 100 = ' + @FromMonthYearText + ' THEN ISNULL(BeginQuantity, 0) ELSE 0 END) AS BeginQuantity, 
SUM(ISNULL(DebitQuantity, 0)) AS DebitQuantity, 
SUM(ISNULL(CreditQuantity, 0)) AS CreditQuantity, 
SUM(CASE WHEN TranMonth + TranYear * 100 = ' + @ToMonthYearText + ' THEN ISNULL(EndQuantity, 0) ELSE 0 END) AS EndQuantity, 

SUM(CASE WHEN TranMonth + TranYear * 100 = ' + @FromMonthYearText + ' THEN ISNULL(BeginAmount, 0) ELSE 0 END) AS BeginAmount, 
SUM(ISNULL(DebitAmount, 0)) AS DebitAmount, 
SUM(ISNULL(CreditAmount, 0)) AS CreditAmount, 
SUM(CASE WHEN TranMonth + TranYear * 100 = ' + @ToMonthYearText + ' THEN ISNULL(EndAmount, 0) ELSE 0 END) AS EndAmount, 

SUM(ISNULL(InDebitQuantity, 0)) AS InDebitQuantity, 
SUM(ISNULL(InCreditQuantity, 0)) AS InCreditQuantity, 

SUM(ISNULL(InDebitAmount, 0)) AS InDebitAmount, 
SUM(ISNULL(InCreditAmount, 0)) AS InCreditAmount, 

AT2888.WareHouseID, AT2888.DivisionID
' 
		SET @sSQLFrom = ' 
FROM AT2888 
INNER JOIN AT1302 ON AT1302.DivisionID = AT2888.DivisionID AND AT1302.InventoryID = AT2888.InventoryID
INNER JOIN AT1304 ON AT1304.DivisionID = AT2888.DivisionID AND AT1304.UnitID = AT1302.UnitID
LEFT JOIN AT1309 ON AT1309.DivisionID = AT2888.DivisionID AND AT1309.InventoryID = AT1302.InventoryID AND AT1309.UnitID = AT1302.UnitID
' 
		SET @sSQLWhere = ' 
WHERE AT2888.DivisionID = ''' + @DivisionID + ''' 
AND AT2888.WareHouseID LIKE ''' + @WareHouseID + ''' 
AND AT2888.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
AND AT2888.TranMonth + 100 * AT2888.TranYear BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + '

GROUP BY 
AT2888.DivisionID, AT2888.InventoryID, InventoryName, 
AT2888.Parameter01, AT2888.Parameter02, AT2888.Parameter03, AT2888.Parameter04, AT2888.Parameter05,
AT2888.WareHouseID, AT1302.UnitID, AT1309.UnitID, AT1309.ConversionFactor, AT1309.Operator, 
AT1304.UnitName, AT1302.S1, AT1302.S2, AT1302.S3, 
AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID, AT1302. InventoryTypeID, AT1302.Specification, 
AT1302.Notes01, AT1302.Notes02, AT1302.Notes03
'
	END
ELSE --Xac dinh so du theo ngay
	BEGIN
		SET @WhereTime = ' AV7000.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''''
		SET @sSQLSelect = ' 
SELECT 
AV7000.S1, AV7000.S2, AV7000.S3, 
AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID, 
AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, 

AV7000.InventoryID, AV7000.InventoryName, AV7000.InventoryTypeID,
AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03, AV7000.Parameter04, AV7000.Parameter05,
AV7000.Specification, AV7000.UnitID, AV7000.UnitName, 

SUM(SignQuantity) AS BeginQuantity, 
0 AS DebitQuantity, 
0 AS CreditQuantity, 
0 AS DebitAmount, 

SUM(SignAmount) AS BeginAmount, 
0 AS CreditAmount, 
0 AS EndQuantity, 
0 AS EndAmount, 

0 AS InDebitQuantity, 
0 AS InCreditQuantity, 

0 AS InDebitAmount, 
0 AS InCreditAmount, 

AV7000.WareHouseID, AV7000.DivisionID
'
		SET @sSQLFrom = ' 
FROM AV7000
'
		SET @sSQLWhere = ' 
WHERE AV7000.DivisionID = ''' + @DivisionID + ''' 
AND AV7000.WareHouseID LIKE ''' + @WareHouseID + ''' 
AND AV7000.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
AND (AV7000.VoucherDate < ''' + @FromDateText + ''' OR D_C = ''BD'')

GROUP BY 
DivisionID, WareHouseID, InventoryID, InventoryName, 
AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03, AV7000.Parameter04, AV7000.Parameter05,
UnitID, UnitName, S1, S2, S3,
I01ID, I02ID, I03ID, I04ID, I05ID, InventoryTypeID, Specification, Notes01, Notes02, Notes03
'
	END

IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV7018' )
	EXEC ('CREATE VIEW AV7018 -- Tao boi AP2888
		AS ' + @sSQLSelect + @sSQLFrom + @sSQLWhere)
ELSE
	EXEC ('ALTER VIEW AV7018 -- Tao boi AP2888
		AS ' + @sSQLSelect + @sSQLFrom + @sSQLWhere)

SET @sSQLSelect = '
SELECT 
AV7018.S1, AV7018.S2, AV7018.S3, 
AV7018.I01ID, AV7018.I02ID, AV7018.I03ID, AV7018.I04ID, AV7018.I05ID, 
AV7018.Notes01, AV7018.Notes02, AV7018.Notes03, 

AV7018.InventoryID, AV7018.InventoryName, AV7018.InventoryTypeID,
AV7018.Parameter01, AV7018.Parameter02, AV7018.Parameter03, AV7018.Parameter04, AV7018.Parameter05,
AV7018.Specification, AV7018.UnitID, AV7018.UnitName, 

ISNULL(AV7018.BeginQuantity, 0) AS BeginQuantity, 
AV7018.DebitQuantity, 
AV7018.CreditQuantity, 
AV7018.EndQuantity, 

ISNULL(AV7018.BeginAmount, 0) AS BeginAmount, 
AV7018.DebitAmount, 
AV7018.CreditAmount, 
AV7018.EndAmount, 

AV7018.InDebitQuantity, 
AV7018.InCreditQuantity, 

AV7018.WareHouseID, AV7018.DivisionID
'
SET @sSQLFrom = '
FROM AV7018
'
SET @sSQLWhere = ' 
WHERE AV7018.WareHouseID LIKE ''' + @WareHouseID + ''' AND AV7018.DivisionID =''' + @DivisionID + ''' 
AND AV7018.InventoryID NOT IN 
(
SELECT InventoryID FROM AV7000 
WHERE AV7000.DivisionID =''' + @DivisionID + ''' 
AND AV7000.WareHouseID LIKE ''' + @WareHouseID + ''' 
AND AV7000.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
AND AV7000.D_C IN (''D'', ''C'') 
AND ' + @WhereTime + '
)
'
SET @sSQLUnion = ' 

UNION ALL

SELECT 
AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID, 
AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, 

AV7000.InventoryID, AV7000.InventoryName, AV7000.InventoryTypeID,
AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03, AV7000.Parameter04, AV7000.Parameter05,
AV7000.Specification, AV7000.UnitID, AV7000.UnitName, 

ISNULL(AV7018.BeginQuantity, 0) AS BeginQuantity, 
SUM(CASE WHEN D_C = ''D'' THEN ISNULL(AV7000.ActualQuantity, 0) ELSE 0 END) AS DebitQuantity, 
SUM(CASE WHEN D_C = ''C'' THEN ISNULL(AV7000.ActualQuantity, 0) ELSE 0 END) AS CreditQuantity, 
0 AS EndQuantity, ISNULL(AV7018.BeginAmount, 0) AS BeginAmount, 
SUM(CASE WHEN D_C = ''D'' THEN ISNULL(AV7000.ConvertedAmount, 0) ELSE 0 END) AS DebitAmount, 
SUM(CASE WHEN D_C = ''C'' THEN ISNULL(AV7000.ConvertedAmount, 0) ELSE 0 END) AS CreditAmount, 
0 AS EndAmount, 

SUM(CASE WHEN D_C = ''D'' AND KindVoucherID = 3 THEN ISNULL(AV7000.ActualQuantity, 0) ELSE 0 END) AS InDebitQuantity, 
SUM(CASE WHEN D_C = ''C'' AND KindVoucherID = 3 THEN ISNULL(AV7000.ActualQuantity, 0) ELSE 0 END) AS InCreditQuantity, 

AV7000.WareHouseID, AV7000.DivisionID

FROM AV7000 
LEFT JOIN AV7018 ON AV7018.DivisionID = AV7000.DivisionID AND AV7000.WareHouseID = AV7018.WareHouseID AND AV7000.InventoryID = AV7018.InventoryID

WHERE AV7000.DivisionID =''' + @DivisionID + ''' 
AND AV7000.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
AND AV7000.WareHouseID LIKE ''' + @WareHouseID + ''' 
AND AV7000.D_C IN (''D'', ''C'') 
AND ' + @WhereTime + '

GROUP BY 
AV7000.S1, AV7000.S2, AV7000.S3, 
AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID, 
AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, 
AV7000.InventoryID, AV7000.InventoryName, AV7000.InventoryTypeID,
AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03, AV7000.Parameter04, AV7000.Parameter05,
AV7000.Specification, 
AV7000.UnitID, AV7000.UnitName, 
AV7018.BeginQuantity, AV7018.BeginAmount, 
AV7000.WareHouseID, 
AV7000.DivisionID
'

IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2088' ) 
	EXEC ('CREATE VIEW AV2088 -- Tao boi AP2888
		AS ' + @sSQLSelect + @sSQLFrom + @sSQLWhere + @sSQLUnion)
ELSE
	EXEC ('ALTER VIEW AV2088 -- Tao boi AP2888
		AS ' + @sSQLSelect + @sSQLFrom + @sSQLWhere + @sSQLUnion)

SET @sSQLSelect = '
SELECT 
AV2088.S1, AV2088.S2, AV2088.S3, 
AV2088.I01ID, AV2088.I02ID, AV2088.I03ID, AV2088.I04ID, AV2088.I05ID, 
AV2088.Notes01, AV2088.Notes02, AV2088.Notes03, 

AV2088.InventoryID, AV2088.InventoryName, AV2088.InventoryTypeID,
AV2088.Parameter01, AV2088.Parameter02, AV2088.Parameter03, AV2088.Parameter04, AV2088.Parameter05, 
AV2088.Specification, AV2088.UnitID, AV2088.UnitName, 

AT1309.UnitID AS ConversionUnitID, AT1309.ConversionFactor, AT1309.Operator, 

SUM(AV2088.BeginQuantity) AS BeginQuantity, 
SUM(AV2088.DebitQuantity) AS DebitQuantity, 
SUM(AV2088.CreditQuantity) AS CreditQuantity, 
SUM(AV2088.BeginQuantity + DebitQuantity - CreditQuantity) AS EndQuantity, 

SUM(AV2088.BeginAmount) AS BeginAmount, 
SUM(AV2088.DebitAmount) AS DebitAmount, 
SUM(AV2088.CreditAmount) AS CreditAmount, 
SUM(AV2088.BeginAmount + DebitAmount - CreditAmount) AS EndAmount, 

0 AS InDebitAmount, 0 AS InCreditAmount, 
SUM(AV2088.InDebitQuantity) AS InDebitQuantity, 
SUM(AV2088.InCreditQuantity) AS InCreditQuantity, 
AV2088.WareHouseID, 
AV2088.DivisionID
'
SET @sSQLFrom = ' 
FROM AV2088 
LEFT JOIN AT1309 ON AT1309.DivisionID = AV2088.DivisionID AND AT1309.InventoryID = AV2088.InventoryID AND AT1309.UnitID = AV2088.UnitID
'
SET @sSQLWhere = ' 
WHERE (BeginQuantity <> 0 OR BeginAmount <> 0 
OR DebitQuantity <> 0 OR DebitAmount <> 0 
OR CreditQuantity <> 0 OR CreditAmount <> 0 
OR EndQuantity <> 0 OR EndAmount <> 0)
AND AV2088.DivisionID =''' + @DivisionID + ''' 

GROUP BY 
AV2088.S1, AV2088.S2, AV2088.S3, 
AV2088.I01ID, AV2088.I02ID, AV2088.I03ID, AV2088.I04ID, AV2088.I05ID, 
AV2088.Notes01, AV2088.Notes02, AV2088.Notes03, 
AV2088.InventoryID, AV2088.InventoryName, AV2088.InventoryTypeID,
AV2088.Parameter01, AV2088.Parameter02, AV2088.Parameter03, AV2088.Parameter04, AV2088.Parameter05, 
AV2088.Specification, 
AV2088.UnitID, AV2088.UnitName, 
AT1309.UnitID, AT1309.ConversionFactor, AT1309.Operator, 
AV2088.WareHouseID, 
AV2088.DivisionID
'

----Theo ngay----------------------------------------------------
IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2098' )
	EXEC ('CREATE VIEW AV2098 -- Tao boi AP2888
		AS ' + @sSQLSelect + @sSQLFrom + @sSQLWhere)
ELSE
	EXEC ('ALTER VIEW AV2098 -- Tao boi AP2888
		AS ' + @sSQLSelect + @sSQLFrom + @sSQLWhere)

SET @GroupField1 = ( 
SELECT CASE @GroupID1
WHEN 'CI1' THEN 'S1'
WHEN 'CI2' THEN 'S2'
WHEN 'CI3' THEN 'S3'
WHEN 'I01' THEN 'I01ID'
WHEN 'I02' THEN 'I02ID'
WHEN 'I03' THEN 'I03ID'
WHEN 'I04' THEN 'I04ID'
WHEN 'I05' THEN 'I05ID' END)

SET @GroupField2 = ( 
SELECT CASE @GroupID2
WHEN 'CI1' THEN 'S1'
WHEN 'CI2' THEN 'S2'
WHEN 'CI3' THEN 'S3'
WHEN 'I01' THEN 'I01ID'
WHEN 'I02' THEN 'I02ID'
WHEN 'I03' THEN 'I03ID'
WHEN 'I04' THEN 'I04ID'
WHEN 'I05' THEN 'I05ID' END)

SET @GroupField1 = ISNULL(@GroupField1, '')
SET @GroupField2 = ISNULL(@GroupField2, '')

SET @sSQLFrom1 = ' 
LEFT JOIN (	SELECT	A.InventoryID, SUM(A.MinQuantity) AS MinQuantity, SUM(A.MaxQuantity) AS MaxQuantity, A.DivisionID
			FROM	AT1314 A 
   			WHERE	A.WareHouseID = '''+@WareHouseID+''' OR A.WareHouseID = ''%''
   			GROUP BY A.InventoryID, A.DivisionID, A.WareHouseID ) AT1314
	ON		AT1314.DivisionID = AV2098.DivisionID AND AT1314.InventoryID = AV2098.InventoryID
'

IF ((@IsGroupID >= 2) AND (@GroupField1 <> '') AND (@GroupField2 <> ''))
BEGIN
SET @IsGroupID = 2
SET @sSQLSelect = ' SELECT V1.ID AS GroupID1, V1.SName GroupName1, V2.ID AS GroupID2, V2.SName GroupName2, '
SET @sSQLFrom = ' 
FROM		AV2098 AS AV2098 
LEFT JOIN	AV1310 V1 ON V1.DivisionID = AV2098.DivisionID AND V1.ID = AV2098.' + @GroupField1 + ' AND V1.TypeID =''' + @GroupID1 + ''' 
LEFT JOIN	AV1310 V2 ON V2.DivisionID = AV2098.DivisionID AND V2.ID = AV2098.' + @GroupField2 + ' AND V2.TypeID =''' + @GroupID2 + '''
'
END
ELSE IF ((@IsGroupID >= 1) AND ((@GroupField1 <> '') OR (@GroupField2 <> '')))
BEGIN 
SET @sSQLSelect = ' SELECT V1.ID AS GroupID1, V1.SName GroupName1, '''' AS GroupID2, '''' GroupName2, '
SET @sSQLFrom = ' 
FROM		AV2098 AS AV2098 
LEFT JOIN	AV1310 V1 ON V1.DivisionID = AV2098.DivisionID AND V1.ID = AV2098.' + @GroupField1 + ' AND V1.TypeID =''' + @GroupID1 + ''' 
'
END
ELSE
BEGIN
SET @sSQLSelect = ' SELECT '''' AS GroupID1, '''' AS GroupName1, '''' AS GroupID2, '''' AS GroupName2, '
SET @sSQLFrom = ' 
FROM		AV2098 AS AV2098
'
END

SET @sSQLSelect = @sSQLSelect + ' 
AV2098.S1, AV2098.S2, AV2098.S3, 
AV2098.I01ID, AV2098.I02ID, AV2098.I03ID, AV2098.I04ID, AV2098.I05ID, 
AV2098.Notes01, AV2098.Notes02, AV2098.Notes03, 
AV2098.InventoryID, AV2098.InventoryName, AV2098.InventoryTypeID,
AV2098.Parameter01, AV2098.Parameter02, AV2098.Parameter03, AV2098.Parameter04, AV2098.Parameter05,
AV2098.Specification, 
AV2098.UnitID, AV2098.UnitName, 
AV2098.ConversionUnitID, AV2098.ConversionFactor, AV2098.Operator, 

CASE WHEN (AV2098.ConversionFactor = NULL OR AV2098.ConversionFactor = 0) 
THEN NULL ELSE ISNULL(AV2098.EndQuantity, 0) / AV2098.ConversionFactor END AS ConversionQuantity, 

AV2098.BeginQuantity, 
AV2098.DebitQuantity, 
AV2098.CreditQuantity, 
AV2098.EndQuantity, 

AV2098.BeginAmount, 
AV2098.DebitAmount, 
AV2098.CreditAmount, 
AV2098.EndAmount, 

AV2098.InDebitAmount, 
AV2098.InCreditAmount, 
AV2098.InDebitQuantity, 
AV2098.InCreditQuantity, 

AV2098.DivisionID,
AT1314.MinQuantity, AT1314.MaxQuantity
'
SET @sSQLFrom = @sSQLFrom + @sSQLFrom1 + ' 
WHERE (BeginQuantity <> 0 OR BeginAmount <> 0 
OR DebitQuantity <> 0 OR DebitAmount <> 0 
OR CreditQuantity <> 0 OR CreditAmount <> 0 
OR EndQuantity <> 0 OR EndAmount <> 0)
AND AV2098.DivisionID =''' + @DivisionID + ''' 
'

IF NOT EXISTS ( SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV2008' )
	EXEC ('CREATE VIEW AV2008 -- Tao boi AP2888
		AS ' + @sSQLSelect + @sSQLFrom)
ELSE
	EXEC ('ALTER VIEW AV2008 -- Tao boi AP2888
		AS ' + @sSQLSelect + @sSQLFrom)
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON