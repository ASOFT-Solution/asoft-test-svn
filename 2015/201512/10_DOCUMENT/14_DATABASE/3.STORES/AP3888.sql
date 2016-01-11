  
---- Create on 10/09/2012 by Bao Anh  
---- Purpose: In bao cao nhap xuat ton theo kho (all warehouse) co quy cach (yeu cau cua 2T)  
---- <Example>  
----   
  
ALTER PROCEDURE [dbo].[AP3888]  
    @DivisionID AS nvarchar(50),   
    @FromMonth AS int,   
    @ToMonth AS int,   
    @FromYear AS int,   
    @ToYear AS int,   
    @FromDate AS datetime,   
    @ToDate AS datetime,   
    @FromInventoryID AS nvarchar(50),   
    @ToInventoryID AS nvarchar(50),   
    @IsDate AS tinyint,   
    @IsGroupID AS tinyint, --- 0 Khong nhom; 1 Nhom 1 cap; 2 Nhom 2 cap  
    @GroupID1 AS nvarchar(50),   
    @GroupID2 AS nvarchar(50)   
    --- Note : GroupID nhan cac gia tri S1, S2, S3, CI1, CI2, CI3  
AS  
  
DECLARE   
    @sSQL1 AS nvarchar(4000),   
    @sSQL2 AS nvarchar(4000),   
    @sSQL3 AS nvarchar(4000),   
    @sSQL4 AS nvarchar(4000),   
    @GroupField1 AS nvarchar(20),   
    @GroupField2 AS nvarchar(20),   
    @FromMonthYearText NVARCHAR(20),   
    @ToMonthYearText NVARCHAR(20),   
    @FromDateText NVARCHAR(20),   
    @ToDateText NVARCHAR(20),  
    @strTime        AS NVARCHAR(4000)  
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)  
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)  
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)  
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'  
  
IF @IsDate = 1  
    ---- xac dinh so lieu theo ngay  
    SET @strTime = ' and (  D_C=''BD''   or VoucherDate < ''' + @FromDateText + ''') '  
ELSE  
    SET @strTime = ' and ( D_C=''BD'' or TranMonth+ 100*TranYear< ' + @FromMonthYearText + ' ) '   
  
  
        SET @sSQL1 = N'  
SELECT   
InventoryID, InventoryName, UnitID, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,  
S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID,   
UnitName, VATPercent, InventoryTypeID, Specification,   
V7.Notes01, V7.Notes02, V7.Notes03, V7.Notes04, V7.Notes05,V7.Notes06, V7.Notes07, V7.Notes08, V7.Notes09, V7.Notes10, V7.Notes11, V7.Notes12, V7.Notes13, V7.Notes14, V7.Notes15, V7.SourceNo,  
sum(isnull(SignQuantity,0))  as BeginQuantity,  
sum(isnull(SignConvertedQuantity,0))  as BeginConvertedQuantity,  
sum(isnull(SignAmount,0)) as BeginAmount,  
sum(isnull(SignMarkQuantity,0))  as BeginMarkQuantity,  
DivisionID  
'  
SET @sSQL2 = '  
FROM AV7000 V7  
WHERE DivisionID LIKE ''' + @DivisionID + '''  
and D_C in (''D'',''C'', ''BD'' )  
AND InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''''  
SET @sSQL2 = @sSQL2 + @strTime + ' '  
Set @sSQL2 = @sSQL2 + N'  
  
GROUP BY InventoryID, InventoryName, UnitID, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,  
S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID,  
UnitName, VATPercent, InventoryTypeID, Specification,   
V7.Notes01, V7.Notes02, V7.Notes03, V7.Notes04, V7.Notes05,V7.Notes06, V7.Notes07, V7.Notes08, V7.Notes09, V7.Notes10, V7.Notes11, V7.Notes12, V7.Notes13, V7.Notes14, V7.Notes15, V7.SourceNo,   
V7.DivisionID  
'  
IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype ='V' AND Name ='AV7016')  
EXEC(' CREATE VIEW AV7016 AS ' + @sSQL1 + @sSQL2)  
ELSE  
EXEC(' ALTER VIEW AV7016 AS ' + @sSQL1 + @sSQL2)  
  
IF @IsDate = 1  
    ---- xac dinh so lieu theo ngay  
    SET @strTime = ' and (VoucherDate  Between  ''' + @FromDateText + '''  and ''' + @ToDateText + '''  ) '  
ELSE  
    SET @strTime = ' and (TranMonth+ 100*TranYear Between ' + @FromMonthYearText + ' and  ' + @ToMonthYearText + '  ) '   
  
SET @sSQL1 = N'  
  
SELECT InventoryID, InventoryName, UnitID, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,  
S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID, VATPercent, InventoryTypeID, Specification,   
AV7016.Notes01, AV7016.Notes02, AV7016.Notes03, AV7016.Notes04, AV7016.Notes05, AV7016.Notes06, AV7016.Notes07, AV7016.Notes08, AV7016.Notes09, AV7016.Notes10, AV7016.Notes11, AV7016.Notes12, AV7016.Notes13, AV7016.Notes14, AV7016.Notes15, AV7016.SourceNo
,  
UnitName,   
BeginQuantity,   
BeginConvertedQuantity,   
AV7016.BeginMarkQuantity,  
BeginAmount,   
0 AS DebitQuantity,   
0 AS CreditQuantity,  
0 AS DebitConvertedQuantity,   
0 AS CreditConvertedQuantity,  
0 AS DebitMarkQuantity,   
0 AS CreditMarkQuantity,    
0 AS DebitAmount,   
0 AS CreditAmount,   
0 AS EndQuantity,   
0 AS EndConvertedQuantity,   
0 AS EndMarkQuantity,   
0 AS EndAmount, AV7016.DivisionID  
'  
 SET @sSQL2 = N'  
FROM AV7016  
WHERE   
(AV7016.InventoryID   
+ convert(varchar(50),Isnull(AV7016.Parameter01,0))   
+ convert(varchar(50),Isnull(AV7016.Parameter02,0))   
+ convert(varchar(50),Isnull(AV7016.Parameter03,0))   
+ convert(varchar(50),Isnull(AV7016.Parameter04,0))   
+ convert(varchar(50),Isnull(AV7016.Parameter05,0)))  
NOT IN   
(SELECT (InventoryID   
+ convert(varchar(50),Isnull(Parameter01,0))   
+ convert(varchar(50),Isnull(Parameter02,0))  
+ convert(varchar(50),Isnull(Parameter03,0))   
+ convert(varchar(50),Isnull(Parameter04,0))   
+ convert(varchar(50),Isnull(Parameter05,0)))  
FROM AV7001 AV7000   
WHERE AV7000.DivisionID LIKE ''' + @DivisionID + '''   
AND AV7000.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''  
AND AV7000.D_C IN (''D'', ''C'') '  
SET @sSQL2 = @sSQL2 + @strTime + ' ) AND AV7016.DivisionID LIKE ''' + @DivisionID + ''''  
  
SET @sSQL3 = N'  
  
UNION ALL  
  
SELECT   
AV7000.InventoryID, AV7000.InventoryName, AV7000.UnitID,  
isnull(AV7000.Parameter01,0) as Parameter01, isnull(AV7000.Parameter02,0) as Parameter02, isnull(AV7000.Parameter03,0) as Parameter03, isnull(AV7000.Parameter04,0) as Parameter04, isnull(AV7000.Parameter05,0) as Parameter05,  
AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID,   
AV7000.VATPercent, AV7000.InventoryTypeID,   
AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08, AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15, AV7000.SourceNo,  
AV7000.UnitName,   
ISNULL(AV7016.BeginQuantity, 0) AS BeginQuantity,   
ISNULL(AV7016.BeginConvertedQuantity, 0) AS BeginConvertedQuantity,   
ISNULL(AV7016.BeginMarkQuantity, 0) AS BeginMarkQuantity,   
ISNULL(AV7016.BeginAmount, 0) AS BeginAmount,   
SUM(CASE WHEN D_C = ''D'' THEN ISNULL(AV7000.ActualQuantity, 0) ELSE 0 END) AS DebitQuantity,   
SUM(CASE WHEN D_C = ''C'' THEN ISNULL(AV7000.ActualQuantity, 0) ELSE 0 END) AS CreditQuantity,   
SUM(CASE WHEN D_C = ''D'' THEN ISNULL(AV7000.ConvertedQuantity, 0) ELSE 0 END) AS DebitConvertedQuantity,   
SUM(CASE WHEN D_C = ''C'' THEN ISNULL(AV7000.ConvertedQuantity, 0) ELSE 0 END) AS CreditConvertedQuantity,   
SUM(CASE WHEN D_C = ''D'' THEN ISNULL(AV7000.MarkQuantity, 0) ELSE 0 END) AS DebitMarkQuantity,   
SUM(CASE WHEN D_C = ''C'' THEN ISNULL(AV7000.MarkQuantity, 0) ELSE 0 END) AS CreditMarkQuantity,   
SUM(CASE WHEN D_C = ''D'' THEN ISNULL(AV7000.ConvertedAmount, 0) ELSE 0 END) AS DebitAmount,   
SUM(CASE WHEN D_C = ''C'' THEN ISNULL(AV7000.ConvertedAmount, 0) ELSE 0 END) AS CreditAmount,   
0 AS EndQuantity,   
0 AS EndConvertedQuantity,   
0 AS EndMarkQuantity,  
0 AS EndAmount, AV7000.DivisionID   
'  
        SET @sSQL4 =N'  
FROM AV7001 AV7000   
LEFT JOIN AV7016 ON AV7000.InventoryID = AV7016.InventoryID and isnull(AV7000.Parameter01,0) = isnull(AV7016.Parameter01,0) and isnull(AV7000.Parameter02,0) = isnull(AV7016.Parameter02,0)  and isnull(AV7000.Parameter03,0) = isnull(AV7016.Parameter03,0) and isnull(AV7000.Parameter04,0) = isnull(AV7016.Parameter04,0) and isnull(AV7000.Parameter05,0) = isnull(AV7016.Parameter05,0)   
AND AV7000.UnitID = AV7016.UnitID AND AV7016.DivisionID = AV7000.DivisionID  and AV7000.SourceNo = AV7016.SourceNo
  
WHERE AV7000.IsTemp = 0   
AND AV7000.D_C IN (''D'', ''C'')   
AND AV7000.DivisionID LIKE ''' + @DivisionID + '''   
AND AV7000.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''''  
SET @sSQL4 = @sSQL4 + @strTime + ' '  
Set @sSQL4 = @sSQL4 + N'  
  
  
GROUP BY AV7000.InventoryID, AV7000.InventoryName, AV7000.UnitID,  
AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03, AV7000.Parameter04, AV7000.Parameter05,  
AV7000.UnitName, AV7016.BeginQuantity, AV7016.BeginConvertedQuantity,AV7016.BeginAmount,   
AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID,   
AV7000.VATPercent, AV7000.InventoryTypeID, AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08, AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12
, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15, AV7000.SourceNo,BeginMarkQuantity, AV7000.DivisionID   
'  
        IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype ='V' AND Name ='AV3088')  
            EXEC(' CREATE VIEW AV3088 AS ' + @sSQL1 + @sSQL2 + @sSQL3 + @sSQL4) ---TAO BOI AP3888  
        ELSE  
            EXEC(' ALTER VIEW AV3088 AS ' + @sSQL1 + @sSQL2 + @sSQL3 + @sSQL4) ---TAO BOI AP3888  
      
  
SET @sSQL1 = N'  
SELECT AV3088.InventoryID,   
InventoryName,   
AV3088.UnitID, AV3088.Parameter01, AV3088.Parameter02, AV3088.Parameter03, AV3088.Parameter04, AV3088.Parameter05,  
UnitName, AV3088.VATPercent, AV3088.InventoryTypeID, Specification,   
AV3088.Notes01, AV3088.Notes02, AV3088.Notes03, AV3088.Notes04, AV3088.Notes05, AV3088.Notes06, AV3088.Notes07, AV3088.Notes08, AV3088.Notes09, AV3088.Notes10, AV3088.Notes11, AV3088.Notes12, AV3088.Notes13, AV3088.Notes14, AV3088.Notes15, AV3088.SourceNo
,  
AT1309.UnitID AS ConversionUnitID, AT1309.ConversionFactor, AT1309.Operator,   
S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID,   
SUM(BeginQuantity) AS BeginQuantity,   
SUM(BeginConvertedQuantity) AS BeginConvertedQuantity,   
SUM(BeginMarkQuantity) AS BeginMarkQuantity,   
SUM(BeginAmount) AS BeginAmount,   
Sum(DebitQuantity) as DebitQuantity,   
Sum(CreditQuantity) as CreditQuantity,   
Sum(DebitConvertedQuantity) as DebitConvertedQuantity,   
Sum(CreditConvertedQuantity) as CreditConvertedQuantity,   
Sum(DebitMarkQuantity) as DebitMarkQuantity,   
Sum(CreditMarkQuantity) as CreditMarkQuantity,  
Sum(DebitAmount) as DebitAmount,   
Sum(CreditAmount)as CreditAmount,   
0 AS InDebitAmount, 0 AS InCreditAmount, 0 AS InDebitQuantity, 0 AS InDebitConvertedQuantity,  0 AS InDebitMarkQuantity,   
0 AS InCreditQuantity, 0 AS InCreditConvertedQuantity,0 AS InCreditMarkQuantity,   
SUM(BeginQuantity) + Sum(DebitQuantity) - Sum(CreditQuantity) AS EndQuantity,   
SUM(BeginConvertedQuantity) + Sum(DebitConvertedQuantity) - Sum(CreditConvertedQuantity) AS EndConvertedQuantity,  
SUM(BeginMarkQuantity) + Sum(DebitMarkQuantity) - Sum(CreditMarkQuantity) AS EndMarkQuantity,   
SUM(BeginAmount) + Sum(DebitAmount) - Sum(CreditAmount) AS EndAmount, AV3088.DivisionID   
'  
        SET @sSQL2 = N'  
FROM AV3088   
LEFT JOIN AT1309 ON AT1309.InventoryID = AV3088.InventoryID AND AT1309.UnitID = AV3088.UnitID AND AT1309.DivisionID = AV3088.DivisionID  
  
GROUP BY S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID,   
AV3088.InventoryID, InventoryName, AV3088.UnitID, AV3088.Parameter01, AV3088.Parameter02, AV3088.Parameter03, AV3088.Parameter04, AV3088.Parameter05,   
UnitName, AT1309.UnitID, AT1309.ConversionFactor, AT1309.Operator,   
AV3088.VATPercent, AV3088.InventoryTypeID, Specification,   
AV3088.Notes01, AV3088.Notes02, AV3088.Notes03, AV3088.Notes04, AV3088.Notes05, AV3088.Notes06, AV3088.Notes07, AV3088.Notes08, AV3088.Notes09, AV3088.Notes10, AV3088.Notes11, AV3088.Notes12, AV3088.Notes13, AV3088.Notes14, AV3088.Notes15, AV3088.SourceNo
,AV3088.DivisionID   
'  
print @sSQL1 + @sSQL2  
  
IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype ='V' AND Name ='AV3098')  
    EXEC(' CREATE VIEW AV3098 AS ' + @sSQL1 + @sSQL2)  
ELSE  
    EXEC(' ALTER VIEW AV3098 AS ' + @sSQL1 + @sSQL2)  
      
SET @GroupField1 =   
(  
    SELECT CASE @GroupID1  
        WHEN 'CI1' THEN 'S1'  
        WHEN 'CI2' THEN 'S2'  
        WHEN 'CI3' THEN 'S3'  
        WHEN 'I01' THEN 'I01ID'  
        WHEN 'I02' THEN 'I02ID'  
        WHEN 'I03' THEN 'I03ID'  
        WHEN 'I04' THEN 'I04ID'  
        WHEN 'I05' THEN 'I05ID'   
    END  
)  
SET @GroupField2 = @GroupField1  
  
SET @GroupField2 =   
(  
    SELECT CASE @GroupID2  
        WHEN 'CI1' THEN 'S1'  
        WHEN 'CI2' THEN 'S2'  
        WHEN 'CI3' THEN 'S3'  
        WHEN 'I01' THEN 'I01ID'  
        WHEN 'I02' THEN 'I02ID'  
        WHEN 'I03' THEN 'I03ID'  
        WHEN 'I04' THEN 'I04ID'  
        WHEN 'I05' THEN 'I05ID'   
    END  
)  
  
SET @GroupField1 = ISNULL(@GroupField1, '')  
SET @GroupField2 = ISNULL(@GroupField2, '')  
          
IF ((@IsGroupID >= 2) AND (@GroupField1 <> '') AND (@GroupField2 <> ''))  
    BEGIN  
        SET @sSQL1 = N'  
SELECT   
V1.ID AS GroupID1, V2.ID AS GroupID2,   
V1.SName AS GroupName1, V2.SName AS GroupName2,   
AV3098.InventoryID, S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID,   
AV3098.InventoryName, AV3098.Parameter01, AV3098.Parameter02, AV3098.Parameter03, AV3098.Parameter04, AV3098.Parameter05,   
AV3098.UnitID, AV3098.UnitName, VATPercent, AV3098.InventoryTypeID, AV3098.Specification,   
AV3098.Notes01, AV3098.Notes02, AV3098.Notes03, AV3098.Notes04, AV3098.Notes05, AV3098.Notes06, AV3098.Notes07, AV3098.Notes08, AV3098.Notes09, AV3098.Notes10, AV3098.Notes11, AV3098.Notes12, AV3098.Notes13, AV3098.Notes14, AV3098.Notes15, AV3098.SourceNo
,  
AV3098.ConversionUnitID, AV3098.ConversionFactor, AV3098.Operator,   
AV3098.BeginQuantity, AV3098.BeginConvertedQuantity, AV3098.EndQuantity, AV3098.EndConvertedQuantity,AV3098.BeginMarkQuantity, AV3098.EndMarkQuantity,   
CASE WHEN AV3098.ConversionFactor = NULL OR AV3098.ConversionFactor = 0 THEN NULL  
ELSE ISNULL(AV3098.EndQuantity, 0) / AV3098.ConversionFactor END AS ConversionQuantity,   
AV3098.DebitQuantity, AV3098.CreditQuantity, AV3098.DebitMarkQuantity, AV3098.CreditMarkQuantity,   
AV3098.BeginAmount, AV3098.EndAmount,   
AV3098.DebitAmount, AV3098.CreditAmount,   
AV3098.InDebitAmount, AV3098.InCreditAmount, AV3098.InDebitQuantity,  AV3098.InDebitConvertedQuantity,  AV3098.InDebitMarkQuantity,   
AV3098.InCreditQuantity,AV3098.InCreditConvertedQuantity, AV3098.InCreditMarkQuantity, AV3098.DivisionID,  
AT1314.MinQuantity, AT1314.MaxQuantity  
'  
        SET @sSQL2 = N'  
FROM AV3098  
LEFT JOIN AV1310 V1 ON V1.ID = AV3098.' + @GroupField1 + ' AND V1.TypeID =''' + @GroupID1 + ''' AND V1.DivisionID = AV3098.DivisionID  
LEFT JOIN AV1310 V2 ON V2.ID = AV3098.' + @GroupField2 + ' AND V2.TypeID =''' + @GroupID2 + ''' AND V2.DivisionID = AV3098.DivisionID LEFT JOIN ( SELECT A.InventoryID, SUM(A.MinQuantity) AS MinQuantity, SUM(A.MaxQuantity) AS MaxQuantity, DivisionID  
   FROM AT1314 A GROUP BY InventoryID, DivisionID ) AT1314  
 ON  AT1314.DivisionID = AV3098.DivisionID AND AT1314.InventoryID = AV3098.InventoryID WHERE (BeginQuantity <> 0 OR BeginAmount <> 0 OR DebitQuantity <> 0 OR DebitAmount <> 0 OR  
CreditQuantity <> 0 OR CreditAmount <> 0 OR EndQuantity <> 0 OR EndAmount <>0 )  
AND AV3098.DivisionID = ''' + @DivisionID + '''  
'  
    END   
ELSE IF ((@IsGroupID >= 1) AND ((@GroupField1 <> '') OR (@GroupField2 <> '')))  
    BEGIN          
        IF(@GroupField1 = '') SET @GroupField1 = @GroupField2  
        SET @sSQL1 = N'  
SELECT   
V1.ID AS GroupID1, '''' AS GroupID2,   
V1.SName AS GroupName1, '''' AS GroupName2,   
AV3098.InventoryID, S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID,   
AV3098.InventoryName, AV3098.Parameter01, AV3098.Parameter02, AV3098.Parameter03, AV3098.Parameter04, AV3098.Parameter05,  
AV3098.UnitID, AV3098.UnitName, AV3098.VATPercent, AV3098.InventoryTypeID, AV3098.Specification,   
AV3098.Notes01, AV3098.Notes02, AV3098.Notes03, AV3098.Notes04, AV3098.Notes05, AV3098.Notes06, AV3098.Notes07, AV3098.Notes08, AV3098.Notes09, AV3098.Notes10, AV3098.Notes11, AV3098.Notes12, AV3098.Notes13, AV3098.Notes14, AV3098.Notes15, AV3098.SourceNo
,  
AV3098.ConversionUnitID, AV3098.ConversionFactor, AV3098.Operator,   
AV3098.BeginQuantity, AV3098.EndQuantity,   
AV3098.BeginConvertedQuantity, AV3098.BeginConvertedQuantity,   
AV3098.BeginMarkQuantity, AV3098.EndMarkQuantity,   
CASE WHEN AV3098.ConversionFactor = NULL OR AV3098.ConversionFactor = 0 THEN NULL  
ELSE ISNULL(AV3098.EndQuantity, 0) / AV3098.ConversionFactor END AS ConversionQuantity,   
AV3098.DebitQuantity, AV3098.CreditQuantity,   
AV3098.DebitConvertedQuantity, AV3098.CreditConvertedQuantity,   
AV3098.DebitMarkQuantity, AV3098.CreditMarkQuantity,  
AV3098.BeginAmount, AV3098.EndAmount,   
AV3098.DebitAmount, AV3098.CreditAmount,   
AV3098.InDebitAmount, AV3098.InCreditAmount, AV3098.InDebitQuantity, AV3098.InDebitConvertedQuantity,AV3098.InDebitMarkQuantity,   
AV3098.InCreditQuantity,AV3098.InCreditConvertedQuantity,AV3098.InCreditMarkQuantity, AV3098.DivisionID,  
AT1314.MinQuantity, AT1314.MaxQuantity   
'  
        SET @sSQL2 = N'  
FROM AV3098  LEFT JOIN AV1310 V1 ON V1.ID = AV3098.' + @GroupField1 + ' AND V1.TypeID =''' + @GroupID1 + ''' AND V1.DivisionID = AV3098.DivisionID LEFT JOIN ( SELECT A.InventoryID, SUM(A.MinQuantity) AS MinQuantity, SUM(A.MaxQuantity) AS MaxQuantity, Divi
sionID  
   FROM AT1314 A GROUP BY InventoryID, DivisionID ) AT1314  
 ON  AT1314.DivisionID = AV3098.DivisionID AND AT1314.InventoryID = AV3098.InventoryID WHERE (BeginQuantity <> 0 OR BeginAmount <> 0 OR DebitQuantity <> 0 OR DebitAmount <> 0 OR  
CreditQuantity <> 0 OR CreditAmount <> 0 OR EndQuantity <> 0 OR EndAmount <>0 )  
AND AV3098.DivisionID = ''' + @DivisionID + '''  
'  
    END       
ELSE  
    BEGIN  
        SET @sSQL1 = N'  
SELECT '''' AS GroupID1, '''' AS GroupID2, '''' AS GroupName1, '''' AS GroupName2,   
AV3098.InventoryID, S1, S2, S3, I01ID, I02ID, I03ID, I04ID, I05ID,   
AV3098.InventoryName, AV3098.Parameter01, AV3098.Parameter02, AV3098.Parameter03, AV3098.Parameter04, AV3098.Parameter05,  
AV3098.UnitID, AV3098.UnitName, AV3098.VATPercent, AV3098.InventoryTypeID, Specification,   
AV3098.Notes01, AV3098.Notes02, AV3098.Notes03, AV3098.Notes04, AV3098.Notes05, AV3098.Notes06, AV3098.Notes07, AV3098.Notes08, AV3098.Notes09, AV3098.Notes10, AV3098.Notes11, AV3098.Notes12, AV3098.Notes13, AV3098.Notes14, AV3098.Notes15, AV3098.SourceNo
,  
AV3098.ConversionUnitID, AV3098.ConversionFactor, AV3098.Operator,   
AV3098.BeginQuantity, AV3098.EndQuantity,   
AV3098.BeginConvertedQuantity, AV3098.EndConvertedQuantity,   
AV3098.BeginMarkQuantity, AV3098.EndMarkQuantity,   
CASE WHEN AV3098.ConversionFactor = NULL OR AV3098.ConversionFactor = 0 THEN NULL  
ELSE ISNULL(AV3098.EndQuantity, 0) / AV3098.ConversionFactor END AS ConversionQuantity,   
AV3098.DebitQuantity, AV3098.CreditQuantity,   
AV3098.DebitConvertedQuantity, AV3098.CreditConvertedQuantity,   
AV3098.DebitMarkQuantity, AV3098.CreditMarkQuantity,   
AV3098.BeginAmount, AV3098.EndAmount,   
AV3098.DebitAmount, AV3098.CreditAmount,   
AV3098.InDebitAmount, AV3098.InCreditAmount, AV3098.InDebitQuantity,AV3098.InDebitConvertedQuantity, AV3098.InDebitMarkQuantity,   
AV3098.InCreditQuantity, AV3098.InCreditConvertedQuantity,AV3098.InCreditMarkQuantity, AV3098.DivisionID , AT1314.MinQuantity, AT1314.MaxQuantity '         SET @sSQL2 = N'  
FROM AV3098   
LEFT JOIN ( SELECT A.InventoryID, SUM(A.MinQuantity) AS MinQuantity, SUM(A.MaxQuantity) AS MaxQuantity, DivisionID  
   FROM AT1314 A GROUP BY InventoryID, DivisionID  ) AT1314  
 ON  AT1314.DivisionID = AV3098.DivisionID AND AT1314.InventoryID = AV3098.InventoryID  
WHERE (BeginQuantity <> 0 OR BeginAmount <> 0 OR DebitQuantity <> 0 OR DebitAmount <> 0 OR  
CreditQuantity <> 0 OR CreditAmount <> 0 OR EndQuantity <> 0 OR EndAmount <>0 )  
AND AV3098.DivisionID = ''' + @DivisionID + '''  
'  
    END  
      
--print '-----------------------------'  
--print @IsGroupID  
--print @GroupField1  
--print @GroupField2  
--print '-----------------------------'  
  
IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype ='V' AND Name ='AV3008')  
    EXEC(' CREATE VIEW AV3008 AS ' + @sSQL1 + @sSQL2)  
ELSE  
    EXEC(' ALTER VIEW AV3008 AS ' + @sSQL1 + @sSQL2)  