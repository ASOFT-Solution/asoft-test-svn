IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0711]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0711]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Lọc theo mã phân tích nghiệp vụ + theo quy cách hàng hóa
-- <Param>
---- 
-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP0711]
(
    @DivisionID       AS NVARCHAR(50),
    @WareHouseID      AS NVARCHAR(50),
    @FromObjectID     AS NVARCHAR(50),
    @ToObjectID       AS NVARCHAR(50),
    @FromInventoryID  AS NVARCHAR(50),
    @ToInventoryID    AS NVARCHAR(50),
    @FromMonth        AS INT,
    @FromYear         AS INT,
    @ToMonth          AS INT,
    @ToYear           AS INT,
    @FromDate         AS DATETIME,
    @ToDate           AS DATETIME,
    @IsDate           AS TINYINT,
    @FromAna01ID      NVARCHAR(50),
    @ToAna01ID        NVARCHAR(50),
    @FromAna02ID      NVARCHAR(50),
    @ToAna02ID        NVARCHAR(50),
    @FromAna03ID      NVARCHAR(50),
    @ToAna03ID        NVARCHAR(50),
    @FromAna04ID      NVARCHAR(50),
    @ToAna04ID        NVARCHAR(50),
    @FromAna05ID      NVARCHAR(50),
    @ToAna05ID        NVARCHAR(50),
    @FromAna06ID      NVARCHAR(50),
    @ToAna06ID        NVARCHAR(50),
    @FromAna07ID      NVARCHAR(50),
    @ToAna07ID        NVARCHAR(50),
    @FromAna08ID      NVARCHAR(50),
    @ToAna08ID        NVARCHAR(50),
    @FromAna09ID      NVARCHAR(50),
    @ToAna09ID        NVARCHAR(50),
    @FromAna10ID      NVARCHAR(50),
    @ToAna10ID        NVARCHAR(50)
)
AS
DECLARE @sSQL           AS NVARCHAR(MAX),
		@sSQL1           AS NVARCHAR(MAX),
		@sSQL2           AS NVARCHAR(MAX),
		@sSQL3           AS NVARCHAR(MAX),
        @WareHouseName  AS NVARCHAR(250),
        @WareHouseID2   AS NVARCHAR(50),
        @strTime        AS NVARCHAR(4000),
        @AnaWhere       AS NVARCHAR(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

SET @AnaWhere = ''

IF PATINDEX('[%]', @FromAna01ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana01ID Like N''' + @FromAna01ID + ''''
END
ELSE
	IF @FromAna01ID IS NOT NULL AND @FromAna01ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana01ID,'''') >= N''' + REPLACE(@FromAna01ID, '[]', '') + 
									''' And Isnull(AV7000.Ana01ID,'''') <= N''' + REPLACE(@ToAna01ID, '[]', '') + ''''
	END	

IF PATINDEX('[%]', @FromAna02ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana02ID Like N''' + @FromAna02ID + ''''
END
ELSE
	IF @FromAna02ID IS NOT NULL AND @FromAna02ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana02ID,'''') >= N''' + REPLACE(@FromAna02ID, '[]', '') + 
									''' And Isnull(AV7000.Ana02ID,'''') <= N''' + REPLACE(@ToAna02ID, '[]', '') + ''''
	END	

IF PATINDEX('[%]', @FromAna03ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana03ID Like N''' + @FromAna03ID + ''''
END
ELSE
	IF @FromAna03ID IS NOT NULL AND @FromAna03ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana03ID,'''') >= N''' +	REPLACE(@FromAna03ID, '[]', '') + 
									''' And Isnull(AV7000.Ana03ID,'''') <= N''' + REPLACE(@ToAna03ID, '[]', '') + ''''
	END

IF PATINDEX('[%]', @FromAna04ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana04ID Like N''' + @FromAna04ID + ''''
END
ELSE
	IF @FromAna04ID IS NOT NULL AND @FromAna04ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana04ID,'''') >= N''' + REPLACE(@FromAna04ID, '[]', '') + 
									''' And Isnull(AV7000.Ana04ID,'''') <= N''' + REPLACE(@ToAna04ID, '[]', '') + ''''
	END	

IF PATINDEX('[%]', @FromAna05ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana05ID Like N''' + @FromAna05ID + ''''
END
ELSE
	IF @FromAna05ID IS NOT NULL AND @FromAna05ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana05ID,'''') >= N''' + REPLACE(@FromAna05ID, '[]', '') + 
									''' And Isnull(AV7000.Ana05ID,'''') <= N''' + REPLACE(@ToAna05ID, '[]', '') + ''''
	END
	
IF PATINDEX('[%]', @FromAna06ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana06ID Like N''' + @FromAna06ID + ''''
END
ELSE
	IF @FromAna06ID IS NOT NULL AND @FromAna06ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana06ID,'''') >= N''' + REPLACE(@FromAna06ID, '[]', '') + 
									''' And Isnull(AV7000.Ana06ID,'''') <= N''' + REPLACE(@ToAna06ID, '[]', '') + ''''
	END	

IF PATINDEX('[%]', @FromAna07ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana07ID Like N''' + @FromAna07ID + ''''
END
ELSE
	IF @FromAna07ID IS NOT NULL AND @FromAna07ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana07ID,'''') >= N''' + REPLACE(@FromAna07ID, '[]', '') + 
									''' And Isnull(AV7000.Ana07ID,'''') <= N''' + REPLACE(@ToAna07ID, '[]', '') + ''''
	END	

IF PATINDEX('[%]', @FromAna08ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana08ID Like N''' + @FromAna08ID + ''''
END
ELSE
	IF @FromAna08ID IS NOT NULL AND @FromAna08ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana08ID,'''') >= N''' +	REPLACE(@FromAna08ID, '[]', '') + 
									''' And Isnull(AV7000.Ana08ID,'''') <= N''' + REPLACE(@ToAna08ID, '[]', '') + ''''
	END

IF PATINDEX('[%]', @FromAna09ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana09ID Like N''' + @FromAna09ID + ''''
END
ELSE
	IF @FromAna09ID IS NOT NULL AND @FromAna09ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana09ID,'''') >= N''' + REPLACE(@FromAna09ID, '[]', '') + 
									''' And Isnull(AV7000.Ana09ID,'''') <= N''' + REPLACE(@ToAna09ID, '[]', '') + ''''
	END	

IF PATINDEX('[%]', @FromAna10ID) > 0
BEGIN
    SET @AnaWhere = @AnaWhere + ' And AV7000.Ana10ID Like N''' + @FromAna10ID + ''''
END
ELSE
	IF @FromAna10ID IS NOT NULL AND @FromAna10ID <> ''
	BEGIN
		SET @AnaWhere = @AnaWhere + ' And Isnull(AV7000.Ana10ID,'''') >= N''' + REPLACE(@FromAna10ID, '[]', '') + 
									''' And Isnull(AV7000.Ana10ID,'''') <= N''' + REPLACE(@ToAna10ID, '[]', '') + ''''
	END

IF @WareHouseID = '%'
BEGIN
    SET @WareHouseName = 'N''TÊt c¶'''
    SET @WareHouseID2 = 'N''%'''
END
ELSE
	BEGIN
		SET @WareHouseName = 'AV7000.WareHouseName'
		SET @WareHouseID2 = 'AV7000.WareHouseID'
	END

IF @IsDate = 1
    ---- xac dinh so lieu theo ngay
    SET @strTime = ' and (  D_C=''BD''   or VoucherDate < ''' + @FromDateText + ''') '
ELSE
    SET @strTime = ' and ( D_C=''BD'' or TranMonth+ 100*TranYear< ' + @FromMonthYearText + ' ) ' 

SET @sSQL2 = N'LEFT JOIN AT0128 A10 ON A10.DivisionID = AV7000.DivisionID AND A10.StandardID = AV7000.S01ID AND A10.StandardTypeID = ''S01''
LEFT JOIN AT0128 A11 ON A11.DivisionID = AV7000.DivisionID AND A11.StandardID = AV7000.S02ID AND A11.StandardTypeID = ''S02''
LEFT JOIN AT0128 A12 ON A12.DivisionID = AV7000.DivisionID AND A12.StandardID = AV7000.S03ID AND A12.StandardTypeID = ''S03''
LEFT JOIN AT0128 A13 ON A13.DivisionID = AV7000.DivisionID AND A13.StandardID = AV7000.S04ID AND A13.StandardTypeID = ''S04''
LEFT JOIN AT0128 A14 ON A14.DivisionID = AV7000.DivisionID AND A14.StandardID = AV7000.S05ID AND A14.StandardTypeID = ''S05''
LEFT JOIN AT0128 A15 ON A15.DivisionID = AV7000.DivisionID AND A15.StandardID = AV7000.S06ID AND A15.StandardTypeID = ''S06''
LEFT JOIN AT0128 A16 ON A16.DivisionID = AV7000.DivisionID AND A16.StandardID = AV7000.S07ID AND A16.StandardTypeID = ''S07''
LEFT JOIN AT0128 A17 ON A17.DivisionID = AV7000.DivisionID AND A17.StandardID = AV7000.S08ID AND A17.StandardTypeID = ''S08''
LEFT JOIN AT0128 A18 ON A18.DivisionID = AV7000.DivisionID AND A18.StandardID = AV7000.S09ID AND A18.StandardTypeID = ''S09''
LEFT JOIN AT0128 A19 ON A19.DivisionID = AV7000.DivisionID AND A19.StandardID = AV7000.S10ID AND A19.StandardTypeID = ''S10''
LEFT JOIN AT0128 A20 ON A20.DivisionID = AV7000.DivisionID AND A20.StandardID = AV7000.S11ID AND A20.StandardTypeID = ''S11''
LEFT JOIN AT0128 A21 ON A21.DivisionID = AV7000.DivisionID AND A21.StandardID = AV7000.S12ID AND A21.StandardTypeID = ''S12''
LEFT JOIN AT0128 A22 ON A22.DivisionID = AV7000.DivisionID AND A22.StandardID = AV7000.S13ID AND A22.StandardTypeID = ''S13''
LEFT JOIN AT0128 A23 ON A23.DivisionID = AV7000.DivisionID AND A23.StandardID = AV7000.S14ID AND A23.StandardTypeID = ''S14''
LEFT JOIN AT0128 A24 ON A24.DivisionID = AV7000.DivisionID AND A24.StandardID = AV7000.S15ID AND A24.StandardTypeID = ''S15''
LEFT JOIN AT0128 A25 ON A25.DivisionID = AV7000.DivisionID AND A25.StandardID = AV7000.S16ID AND A25.StandardTypeID = ''S16''
LEFT JOIN AT0128 A26 ON A26.DivisionID = AV7000.DivisionID AND A26.StandardID = AV7000.S17ID AND A26.StandardTypeID = ''S17''
LEFT JOIN AT0128 A27 ON A27.DivisionID = AV7000.DivisionID AND A27.StandardID = AV7000.S18ID AND A27.StandardTypeID = ''S18''
LEFT JOIN AT0128 A28 ON A28.DivisionID = AV7000.DivisionID AND A28.StandardID = AV7000.S19ID AND A28.StandardTypeID = ''S19''
LEFT JOIN AT0128 A29 ON A29.DivisionID = AV7000.DivisionID AND A29.StandardID = AV7000.S20ID AND A29.StandardTypeID = ''S20'' 
Where 	AV7000.DivisionID like N''' + @DivisionID + 
    ''' and
D_C in (''D'',''C'', ''BD'' ) and
(AV7000.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID
    + ''') and
(AV7000.WareHouseID like   N''' + @WareHouseID + 
    ''' ) and
(AV7000.ObjectID between  N''' + @FromObjectID + ''' and  N''' + @ToObjectID
    + ''')  ' + @AnaWhere + ' '

SET @sSQL = ' Select DISTINCT ' + @WareHouseID2 + ' as WareHouseID ,' + @WareHouseName + 
    ' as WareHouseName,
	 AV7000.ObjectID, AV7000.ObjectName,  AV7000.Address,
	 AV7000.InventoryID,	 AV7000.InventoryName, 
	 AV7000.UnitID,		 AV7000.S1, 	 AV7000.S2, 
	 AV7000.S3, 	 AV7000.I01ID, 	 AV7000.I02ID, 	 AV7000.I03ID, 	 AV7000.I04ID, 	 AV7000.I05ID, 	
	ISNULL(AV7000.Parameter01,0) Parameter01, ISNULL(AV7000.Parameter02,0) Parameter02, ISNULL(AV7000.Parameter03,0) Parameter03, ISNULL(AV7000.Parameter04,0) Parameter04, ISNULL(AV7000.Parameter05,0) Parameter05, 
	 AV7000.UnitName, AV7000.InventoryTypeID, AV7000.Specification ,
	AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03 ,
	sum(isnull(SignQuantity,0))  as BeginQuantity,
	sum(isnull(SignConvertedQuantity,0))  as BeginConvertedQuantity,
	sum(isnull(SignAmount,0)) as BeginAmount,
	sum(isnull(SignMarkQuantity,0))  as BeginMarkQuantity,
	AV7000.DivisionID, 
	AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08,
	AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15, ISNULL(AV7000.SourceNo,'''') [SourceNo],
	AV7000.S01ID, AV7000.S02ID, AV7000.S03ID, AV7000.S04ID, AV7000.S05ID, AV7000.S06ID, AV7000.S07ID, AV7000.S08ID, AV7000.S09ID, AV7000.S10ID,
	AV7000.S11ID, AV7000.S12ID, AV7000.S13ID, AV7000.S14ID, AV7000.S15ID, AV7000.S16ID, AV7000.S17ID, AV7000.S18ID, AV7000.S19ID, AV7000.S20ID,
	A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
	A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
	A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
	A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20		
From AV7002 AV7000
'

SET @Ssql2 = @Ssql2 + @strTime + ' '

IF @WareHouseID <> '%'
    SET @sSQl3 =' Group by  AV7000.DivisionID,  ' + @WareHouseID2 + 
        '  ,' + @WareHouseName + 
        ',  AV7000.ObjectID,    AV7000.InventoryID,	 AV7000.InventoryName,	  AV7000.UnitID,
 AV7000.S1, 	 AV7000.S2, 	 AV7000.S3, 	 AV7000.I01ID, 	 AV7000.I02ID, 	 AV7000.I03ID, 	 AV7000.I04ID, 	 AV7000.I05ID, 
  ISNULL(AV7000.Parameter01,0) , ISNULL(AV7000.Parameter02,0) , ISNULL(AV7000.Parameter03,0) , ISNULL(AV7000.Parameter04,0) , ISNULL(AV7000.Parameter05,0) , 
 AV7000.UnitName ,AV7000.ObjectName, AV7000.Address , AV7000.InventoryTypeID, AV7000.Specification, AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03, 	AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08,
	AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15, ISNULL(AV7000.SourceNo,''''),
	AV7000.S01ID, AV7000.S02ID, AV7000.S03ID, AV7000.S04ID, AV7000.S05ID, AV7000.S06ID, AV7000.S07ID, AV7000.S08ID, AV7000.S09ID, AV7000.S10ID,
	AV7000.S11ID, AV7000.S12ID, AV7000.S13ID, AV7000.S14ID, AV7000.S15ID, AV7000.S16ID, AV7000.S17ID, AV7000.S18ID, AV7000.S19ID, AV7000.S20ID,
	A10.StandardName, A11.StandardName, A12.StandardName, A13.StandardName, A14.StandardName,
	A15.StandardName, A16.StandardName, A17.StandardName, A18.StandardName, A19.StandardName,
	A20.StandardName, A21.StandardName, A22.StandardName, A23.StandardName, A24.StandardName, 
	A25.StandardName, A26.StandardName, A27.StandardName, A28.StandardName, A29.StandardName
'
ELSE
    SET @sSQl3 =  
        ' Group by  AV7000.DivisionID, AV7000.ObjectID,     AV7000.InventoryID,	 AV7000.InventoryName,	  AV7000.UnitID,
 AV7000.S1, 	 AV7000.S2, 	 AV7000.S3, 	 AV7000.I01ID, 	 AV7000.I02ID, 	 AV7000.I03ID, 	 AV7000.I04ID, 	 AV7000.I05ID, 
ISNULL(AV7000.Parameter01,0), ISNULL(AV7000.Parameter02,0), ISNULL(AV7000.Parameter03,0), ISNULL(AV7000.Parameter04,0), ISNULL(AV7000.Parameter05,0), 
 AV7000.UnitName , AV7000.ObjectName, AV7000.Address , AV7000.InventoryTypeID, AV7000.Specification, AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03,AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08,
	AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15, ISNULL(AV7000.SourceNo,''''),
	AV7000.S01ID, AV7000.S02ID, AV7000.S03ID, AV7000.S04ID, AV7000.S05ID, AV7000.S06ID, AV7000.S07ID, AV7000.S08ID, AV7000.S09ID, AV7000.S10ID,
	AV7000.S11ID, AV7000.S12ID, AV7000.S13ID, AV7000.S14ID, AV7000.S15ID, AV7000.S16ID, AV7000.S17ID, AV7000.S18ID, AV7000.S19ID, AV7000.S20ID,
	A10.StandardName, A11.StandardName, A12.StandardName, A13.StandardName, A14.StandardName,
	A15.StandardName, A16.StandardName, A17.StandardName, A18.StandardName, A19.StandardName,
	A20.StandardName, A21.StandardName, A22.StandardName, A23.StandardName, A24.StandardName, 
	A25.StandardName, A26.StandardName, A27.StandardName, A28.StandardName, A29.StandardName 
	'
--PRINT @sSQL
--PRINT @sSQL2
--PRINT @sSQL3
IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE  Xtype = 'V' AND NAME = 'AV0709')
    EXEC ('Create View AV0709 as ' + @sSQL + @sSQL2 + @sSQL3)
ELSE
    EXEC ('  Alter View  AV0709 as ' + @sSQL + @sSQL2 + @sSQL3)

IF @IsDate = 1
    ---- xac dinh so lieu theo ngay
    SET @strTime = ' and (VoucherDate  Between  ''' + @FromDateText + '''  and ''' + @ToDateText + '''  ) '
ELSE
    SET @strTime = ' and (TranMonth+ 100*TranYear Between ' + @FromMonthYearText + ' and  ' + @ToMonthYearText + '  ) ' 

----- Phát sinh 
SET @sSQL = '
		SELECT DISTINCT
		AV7000.ObjectID as ObjectID, 
		AV7000.ObjectName as ObjectName, 	
		AV7000.Address as Address, 
		AV7000.InventoryID,
		AV7000.InventoryName,
		AV7000.UnitID,
		AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID, 
		ISNULL(AV7000.Parameter01,0) Parameter01, ISNULL(AV7000.Parameter02,0) Parameter02, ISNULL(AV7000.Parameter03,0) Parameter03, ISNULL(AV7000.Parameter04,0) Parameter04, ISNULL(AV7000.Parameter05,0) Parameter05, 
		AV7000.InventoryTypeID, AV7000.Specification ,
		AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03,AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08,
			AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15,ISNULL(AV7000.SourceNo,'''') SourceNo , 
		AV7000.UnitName,	
		0 as BeginQuantity,
		0 as BeginConvertedQuantity,
		0 as BeginAmount,
		0 as BeginMarkQuantity,
		Sum(Case when D_C = ''D'' then isnull(AV7000.MarkQuantity,0) else 0 end) as DebitMarkQuantity,
		Sum(Case when D_C = ''C'' then isnull(AV7000.MarkQuantity,0) else 0 end) as CreditMarkQuantity,
		Sum(Case when D_C = ''D'' then isnull(AV7000.ActualQuantity,0) else 0 end) as DebitQuantity,
		Sum(Case when D_C = ''C'' then isnull(AV7000.ActualQuantity,0) else 0 end) as CreditQuantity,
		Sum(Case when D_C = ''D'' then isnull(AV7000.ConvertedQuantity,0) else 0 end) as DebitConvertedQuantity,
		Sum(Case when D_C = ''C'' then isnull(AV7000.ConvertedQuantity,0) else 0 end) as CreditConvertedQuantity,
		Sum(Case when D_C = ''D'' then isnull(AV7000.ConvertedAmount,0) else 0 end) as DebitAmount,
		Sum(Case when D_C = ''C'' then isnull(AV7000.ConvertedAmount,0) else 0 end) as CreditAmount,
		AV7000.DivisionID,
		AV7000.S01ID, AV7000.S02ID, AV7000.S03ID, AV7000.S04ID, AV7000.S05ID, AV7000.S06ID, AV7000.S07ID, AV7000.S08ID, AV7000.S09ID, AV7000.S10ID,
		AV7000.S11ID, AV7000.S12ID, AV7000.S13ID, AV7000.S14ID, AV7000.S15ID, AV7000.S16ID, AV7000.S17ID, AV7000.S18ID, AV7000.S19ID, AV7000.S20ID,
		A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
		A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
		A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
		A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20
		'	
		
	SET @sSQL1 = N'		
		From AV7002 AV7000 Full join AV0709 on 	( AV0709.InventoryID = AV7000.InventoryID) and
						(AV0709.ObjectID = AV7000.ObjectID) AND AV0709.DivisionID = AV7000.DivisionID AND
						Isnull(AV7000.S01ID,'''') = Isnull(AV0709.S01ID,'''') AND
						Isnull(AV7000.S02ID,'''') = Isnull(AV0709.S02ID,'''') AND
						Isnull(AV7000.S03ID,'''') = Isnull(AV0709.S03ID,'''') AND
						Isnull(AV7000.S04ID,'''') = Isnull(AV0709.S04ID,'''') AND
						Isnull(AV7000.S05ID,'''') = Isnull(AV0709.S05ID,'''') AND
						Isnull(AV7000.S06ID,'''') = Isnull(AV0709.S06ID,'''') AND
						Isnull(AV7000.S07ID,'''') = Isnull(AV0709.S07ID,'''') AND
						Isnull(AV7000.S08ID,'''') = Isnull(AV0709.S08ID,'''') AND
						Isnull(AV7000.S09ID,'''') = Isnull(AV0709.S09ID,'''') AND
						Isnull(AV7000.S10ID,'''') = Isnull(AV0709.S10ID,'''') AND
						Isnull(AV7000.S11ID,'''') = Isnull(AV0709.S11ID,'''') AND
						Isnull(AV7000.S12ID,'''') = Isnull(AV0709.S12ID,'''') AND
						Isnull(AV7000.S13ID,'''') = Isnull(AV0709.S13ID,'''') AND
						Isnull(AV7000.S14ID,'''') = Isnull(AV0709.S14ID,'''') AND
						Isnull(AV7000.S15ID,'''') = Isnull(AV0709.S15ID,'''') AND
						Isnull(AV7000.S16ID,'''') = Isnull(AV0709.S16ID,'''') AND
						Isnull(AV7000.S17ID,'''') = Isnull(AV0709.S17ID,'''') AND
						Isnull(AV7000.S18ID,'''') = Isnull(AV0709.S18ID,'''') AND
						Isnull(AV7000.S19ID,'''') = Isnull(AV0709.S19ID,'''') AND
						Isnull(AV7000.S20ID,'''') = Isnull(AV0709.S20ID,'''')
		LEFT JOIN AT0128 A10 ON A10.DivisionID = AV7000.DivisionID AND A10.StandardID = AV7000.S01ID AND A10.StandardTypeID = ''S01''
		LEFT JOIN AT0128 A11 ON A11.DivisionID = AV7000.DivisionID AND A11.StandardID = AV7000.S02ID AND A11.StandardTypeID = ''S02''
		LEFT JOIN AT0128 A12 ON A12.DivisionID = AV7000.DivisionID AND A12.StandardID = AV7000.S03ID AND A12.StandardTypeID = ''S03''
		LEFT JOIN AT0128 A13 ON A13.DivisionID = AV7000.DivisionID AND A13.StandardID = AV7000.S04ID AND A13.StandardTypeID = ''S04''
		LEFT JOIN AT0128 A14 ON A14.DivisionID = AV7000.DivisionID AND A14.StandardID = AV7000.S05ID AND A14.StandardTypeID = ''S05''
		LEFT JOIN AT0128 A15 ON A15.DivisionID = AV7000.DivisionID AND A15.StandardID = AV7000.S06ID AND A15.StandardTypeID = ''S06''
		LEFT JOIN AT0128 A16 ON A16.DivisionID = AV7000.DivisionID AND A16.StandardID = AV7000.S07ID AND A16.StandardTypeID = ''S07''
		LEFT JOIN AT0128 A17 ON A17.DivisionID = AV7000.DivisionID AND A17.StandardID = AV7000.S08ID AND A17.StandardTypeID = ''S08''
		LEFT JOIN AT0128 A18 ON A18.DivisionID = AV7000.DivisionID AND A18.StandardID = AV7000.S09ID AND A18.StandardTypeID = ''S09''
		LEFT JOIN AT0128 A19 ON A19.DivisionID = AV7000.DivisionID AND A19.StandardID = AV7000.S10ID AND A19.StandardTypeID = ''S10''
		LEFT JOIN AT0128 A20 ON A20.DivisionID = AV7000.DivisionID AND A20.StandardID = AV7000.S11ID AND A20.StandardTypeID = ''S11''
		LEFT JOIN AT0128 A21 ON A21.DivisionID = AV7000.DivisionID AND A21.StandardID = AV7000.S12ID AND A21.StandardTypeID = ''S12''
		LEFT JOIN AT0128 A22 ON A22.DivisionID = AV7000.DivisionID AND A22.StandardID = AV7000.S13ID AND A22.StandardTypeID = ''S13''
		LEFT JOIN AT0128 A23 ON A23.DivisionID = AV7000.DivisionID AND A23.StandardID = AV7000.S14ID AND A23.StandardTypeID = ''S14''
		LEFT JOIN AT0128 A24 ON A24.DivisionID = AV7000.DivisionID AND A24.StandardID = AV7000.S15ID AND A24.StandardTypeID = ''S15''
		LEFT JOIN AT0128 A25 ON A25.DivisionID = AV7000.DivisionID AND A25.StandardID = AV7000.S16ID AND A25.StandardTypeID = ''S16''
		LEFT JOIN AT0128 A26 ON A26.DivisionID = AV7000.DivisionID AND A26.StandardID = AV7000.S17ID AND A26.StandardTypeID = ''S17''
		LEFT JOIN AT0128 A27 ON A27.DivisionID = AV7000.DivisionID AND A27.StandardID = AV7000.S18ID AND A27.StandardTypeID = ''S18''
		LEFT JOIN AT0128 A28 ON A28.DivisionID = AV7000.DivisionID AND A28.StandardID = AV7000.S19ID AND A28.StandardTypeID = ''S19''
		LEFT JOIN AT0128 A29 ON A29.DivisionID = AV7000.DivisionID AND A29.StandardID = AV7000.S20ID AND A29.StandardTypeID = ''S20''
		'				
	SET @sSQL2 = N'		
		Where 	ISNULL(AV7000.DivisionID, AV0709.DivisionID) =''' + @DivisionID + 
			''' and
		(AV7000.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID 
			+ ''') and
		(AV7000.WareHouseID like   ''' + @WareHouseID + 
			''' ) and
		(AV7000.ObjectID between  ''' + @FromObjectID + ''' and  ''' + @ToObjectID + 
			''') and 
		AV7000.D_C in (''D'', ''C'', ''BD'') ' + @strTime + @AnaWhere 
		
	SET @sSQL3 = N'
		Group by  AV7000.ObjectID, AV7000.ObjectName, AV7000.Address,
		AV7000.InventoryID, AV7000.InventoryName, AV7000.UnitID, AV7000.UnitName, 
		AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID,
		 ISNULL(AV7000.Parameter01,0), ISNULL(AV7000.Parameter02,0), ISNULL(AV7000.Parameter03,0), ISNULL(AV7000.Parameter04,0), ISNULL(AV7000.Parameter05,0), 
		 AV7000.InventoryTypeID, AV7000.Specification,
		AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03,AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08,
		AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15,ISNULL(AV7000.SourceNo,'''') 
		,  AV7000.DivisionID,
		AV7000.S01ID, AV7000.S02ID, AV7000.S03ID, AV7000.S04ID, AV7000.S05ID, AV7000.S06ID, AV7000.S07ID, AV7000.S08ID, AV7000.S09ID, AV7000.S10ID,
		AV7000.S11ID, AV7000.S12ID, AV7000.S13ID, AV7000.S14ID, AV7000.S15ID, AV7000.S16ID, AV7000.S17ID, AV7000.S18ID, AV7000.S19ID, AV7000.S20ID,
		A10.StandardName, A11.StandardName, A12.StandardName, A13.StandardName, A14.StandardName,
		A15.StandardName, A16.StandardName, A17.StandardName, A18.StandardName, A19.StandardName,
		A20.StandardName, A21.StandardName, A22.StandardName, A23.StandardName, A24.StandardName, 
		A25.StandardName, A26.StandardName, A27.StandardName, A28.StandardName, A29.StandardName
			'
PRINT @sSQL
PRINT @sSQL1
PRINT @sSQL2
PRINT @sSQL3
IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE  Xtype = 'V' AND NAME = 'AV0707')
    EXEC (' Create view AV0707 as ' + @sSQL + @sSQL1 + @sSQL2 + @sSQL3)
ELSE
    EXEC (' Alter view AV0707 as ' + @sSQL + @sSQL1 + @sSQL2 + @sSQL3)

------------------------------ KET HOP VOI SO  PHAT SINH

SET @sSQL = '
		SELECT
		isnull(AV0707.ObjectID,AV0709.ObjectID) as ObjectID, 
		isnull(AV0707.ObjectName,AV0709.ObjectName) as ObjectName, 	
		isnull(AV0707.Address,AV0709.Address) as Address, 
		isnull(AV0707.InventoryID,AV0709.InventoryID) as InventoryID, 
		isnull(AV0707.InventoryName,AV0709.InventoryName) as InventoryName, 
		Isnull(AV0707.UnitID,AV0709.UnitID) as UnitID,
		isnull(AV0707.S1, AV0709.S1) as S1, 
		isnull(AV0707.S1, AV0709.S2) as S2, 
		isnull(AV0707.S1, AV0709.S3) as S3, 
		isnull(AV0707.I01ID, AV0709.I01ID) as I01ID, 
		isnull(AV0707.I02ID, AV0709.I02ID) as I02ID, 
		isnull(AV0707.I03ID, AV0709.I03ID) as I03ID, 
		isnull(AV0707.I04ID, AV0709.I04ID) as I04ID, 
		isnull(AV0707.I05ID, AV0709.I05ID) as I05ID, 
		 AV0707.Parameter01, AV0707.Parameter02, AV0707.Parameter03, AV0707.Parameter04, AV0707.Parameter05, 
		isnull(AV0707.InventoryTypeID, AV0709.InventoryTypeID) as InventoryTypeID, 
		isnull(AV0707.Specification , AV0709.Specification ) as Specification, 	
		AV0707.D02Notes01 , AV0707.D02Notes02 , AV0707.D02Notes03,AV0707.Notes01, AV0707.Notes02, AV0707.Notes03, AV0707.Notes04, AV0707.Notes05, AV0707.Notes06, AV0707.Notes07, AV0707.Notes08,
			AV0707.Notes09, AV0707.Notes10, AV0707.Notes11, AV0707.Notes12, AV0707.Notes13, AV0707.Notes14, AV0707.Notes15, AV0707.SourceNo,
		isnull(AV0709.UnitName,	AV0707.UnitName) as UnitName,	
		isnull(AV0709.BeginQuantity,0) as BeginQuantity,
		isnull(AV0709.BeginConvertedQuantity,0) as BeginConvertedQuantity,
		isnull(AV0709.BeginMarkQuantity,0) as BeginMarkQuantity,
		isnull(AV0709.BeginAmount,0) as BeginAmount,
		isnull(AV0707.DebitQuantity,0) as DebitQuantity, 
		isnull(AV0707.CreditQuantity,0) as CreditQuantity,
		isnull(AV0707.DebitConvertedQuantity,0) as DebitConvertedQuantity, 
		isnull(AV0707.CreditConvertedQuantity,0) as CreditConvertedQuantity,
		isnull(AV0707.DebitMarkQuantity,0) as DebitMarkQuantity, 
		isnull(AV0707.CreditMarkQuantity,0) as CreditMarkQuantity,
		isnull(AV0707.DebitAmount,0 ) as DebitAmount,
		isnull(AV0707.CreditAmount, 0) as CreditAmount,
		isnull(AV0709.BeginQuantity,0) + isnull(AV0707.DebitQuantity,0)  - isnull(AV0707.CreditQuantity,0) as EndQuantity,
		isnull(AV0709.BeginConvertedQuantity,0) + isnull(AV0707.DebitConvertedQuantity,0)  - isnull(AV0707.CreditConvertedQuantity,0) as EndConvertedQuantity,
		isnull(AV0709.BeginMarkQuantity,0) + isnull(AV0707.DebitMarkQuantity,0)  - isnull(AV0707.CreditMarkQuantity,0) as EndMarkQuantity,
		isnull(AV0709.BeginAmount,0) + isnull(AV0707.DebitAmount,0)  - isnull(AV0707.CreditAmount,0) as EndAmount, ''' + @DivisionID +  ''' AS DivisionID,
		 '
		
	SET @sSQL1 = N'
		isnull(AV0707.S01ID,AV0709.S01ID) AS S01ID, isnull(AV0707.S02ID,AV0709.S02ID) AS S02ID, 
		isnull(AV0707.S03ID,AV0709.S03ID) AS S03ID, isnull(AV0707.S04ID,AV0709.S04ID) AS S04ID, 
		isnull(AV0707.S05ID,AV0709.S05ID) AS S05ID, isnull(AV0707.S06ID,AV0709.S06ID) AS S06ID, 
		isnull(AV0707.S07ID,AV0709.S07ID) AS S07ID, isnull(AV0707.S08ID,AV0709.S08ID) AS S08ID, 
		isnull(AV0707.S09ID,AV0709.S09ID) AS S09ID, isnull(AV0707.S10ID,AV0709.S10ID) AS S10ID,
		isnull(AV0707.S11ID,AV0709.S11ID) AS S11ID, isnull(AV0707.S12ID,AV0709.S12ID) AS S12ID, 
		isnull(AV0707.S13ID,AV0709.S13ID) AS S13ID, isnull(AV0707.S14ID,AV0709.S14ID) AS S14ID, 
		isnull(AV0707.S15ID,AV0709.S15ID) AS S15ID, isnull(AV0707.S16ID,AV0709.S16ID) AS S16ID, 
		isnull(AV0707.S17ID,AV0709.S17ID) AS S17ID, isnull(AV0707.S18ID,AV0709.S18ID) AS S18ID, 
		isnull(AV0707.S19ID,AV0709.S19ID) AS S19ID, isnull(AV0707.S20ID,AV0709.S20ID) AS S20ID,
		ISNULL(AV0707.StandardName01,AV0709.StandardName01) as StandardName01, ISNULL(AV0707.StandardName02,AV0709.StandardName02) as StandardName02, 
		ISNULL(AV0707.StandardName03,AV0709.StandardName03) as StandardName03, 
		ISNULL(AV0707.StandardName04,AV0709.StandardName04) as StandardName04, ISNULL(AV0707.StandardName05,AV0709.StandardName05) as StandardName05,
		ISNULL(AV0707.StandardName06,AV0709.StandardName06) as StandardName06, ISNULL(AV0707.StandardName07,AV0709.StandardName07) as StandardName07, 
		ISNULL(AV0707.StandardName08,AV0709.StandardName08) as StandardName08, ISNULL(AV0707.StandardName09,AV0709.StandardName09) as StandardName09, 
		ISNULL(AV0707.StandardName10,AV0709.StandardName10) as StandardName10,
		ISNULL(AV0707.StandardName11,AV0709.StandardName11) as StandardName11, ISNULL(AV0707.StandardName12,AV0709.StandardName12) as StandardName12, 
		ISNULL(AV0707.StandardName13,AV0709.StandardName13) as StandardName13, ISNULL(AV0707.StandardName14,AV0709.StandardName14) as StandardName14, 
		ISNULL(AV0707.StandardName15,AV0709.StandardName15) as StandardName15, 
		ISNULL(AV0707.StandardName16,AV0709.StandardName16) as StandardName16, ISNULL(AV0707.StandardName17,AV0709.StandardName17) as StandardName17, 
		ISNULL(AV0707.StandardName18,AV0709.StandardName18) as StandardName18, ISNULL(AV0707.StandardName19,AV0709.StandardName19) as StandardName19, 
		ISNULL(AV0707.StandardName20,AV0709.StandardName20) as StandardName20
		From AV0707  Full join AV0709 on 	( AV0709.InventoryID = AV0707.InventoryID) and
						(AV0709.ObjectID = AV0707.ObjectID) and (AV0709.DivisionID = AV0707.DivisionID)
						
						'
--PRINT @sSQL
--PRINT @sSQL1
EXEC (@sSQL + @sSQL1)
--IF NOT EXISTS (SELECT TOP 1 1 FROM   SYSOBJECTS WHERE Xtype = 'V' AND NAME = 'AV0710')
--    EXEC (' Create view AV0710 as ' + @sSQL)
--ELSE
--    EXEC (' Alter view AV0710 as ' + @sSQL)
                  
---Print @sSQL
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
