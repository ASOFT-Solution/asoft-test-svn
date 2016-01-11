IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0710]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0710]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Lọc theo mã phân tích nghiệp vụ
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on by 
---- Modified on 06/11/2006 by Nguyễn Quốc Huy
---- Modified on 22/01/2008 by Đặng Lê Bảo Quỳnh
---- Modified on 22/01/2008 by Thanh Nguyen
---- Modified on 22/11/2011 by Nguyễn Bình Minh: Sửa lỗi không lấy được số liệu số dư đầu kỳ nếu không có số phát sinh
---- Modified on 22/08/2013 by Khanh Van: Lay them thong tin Notes, so luong mark cho 2T
---- Modified on 15/07/2014 by Thanh Sơn: Chuyển lấy dữ liệu trực tiếp từ store, không sinh ra view AV0710
---- Modified on 05/10/2015 by Thanh Thịnh: Group by lại các trường dữ liệu
---- Modified on 11/11/2015 by Bảo Anh: Không lấy số dư cho view phát sinh AV0707
---- Modified on 16/11/2015 by Bảo Anh: Sửa lỗi 1 mặt hàng cùng đối tượng nhưng lên nhiều dòng (bỏ group by theo các trường Notes)
-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP0710]
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
    @FromAna01ID      NVARCHAR(50) = NULL,
    @ToAna01ID        NVARCHAR(50) = NULL,
    @FromAna02ID      NVARCHAR(50) = NULL,
    @ToAna02ID        NVARCHAR(50) = NULL,
    @FromAna03ID      NVARCHAR(50) = NULL,
    @ToAna03ID        NVARCHAR(50) = NULL,
    @FromAna04ID      NVARCHAR(50) = NULL,
    @ToAna04ID        NVARCHAR(50) = NULL,
    @FromAna05ID      NVARCHAR(50) = NULL,
    @ToAna05ID        NVARCHAR(50) = NULL,
    @FromAna06ID      NVARCHAR(50) = NULL,
    @ToAna06ID        NVARCHAR(50) = NULL,
    @FromAna07ID      NVARCHAR(50) = NULL,
    @ToAna07ID        NVARCHAR(50) = NULL,
    @FromAna08ID      NVARCHAR(50) = NULL,
    @ToAna08ID        NVARCHAR(50) = NULL,
    @FromAna09ID      NVARCHAR(50) = NULL,
    @ToAna09ID        NVARCHAR(50) = NULL,
    @FromAna10ID      NVARCHAR(50) = NULL,
    @ToAna10ID        NVARCHAR(50) = NULL
)
AS
DECLARE @sSQL           AS NVARCHAR(4000),
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
max(AV7000.Notes01) as Notes01, max(AV7000.Notes02) as Notes02, max(AV7000.Notes03) as Notes03, max(AV7000.Notes04) as Notes04, max(AV7000.Notes05) as Notes05,
max(AV7000.Notes06) as Notes06, max(AV7000.Notes07) as Notes07, max(AV7000.Notes08) as Notes08,	max(AV7000.Notes09) as Notes09, max(AV7000.Notes10) as Notes10,
max(AV7000.Notes11) as Notes11, max(AV7000.Notes12) as Notes12, max(AV7000.Notes13) as Notes13, max(AV7000.Notes14) as Notes14, max(AV7000.Notes15) as Notes15,
ISNULL(AV7000.SourceNo,'''') [SourceNo]
From AV7000 
Where 	AV7000.DivisionID like N''' + @DivisionID + 
    ''' and
D_C in (''D'',''C'', ''BD'' ) and
(AV7000.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID
    + ''') and
(AV7000.WareHouseID like   N''' + @WareHouseID + 
    ''' ) and
(AV7000.ObjectID between  N''' + @FromObjectID + ''' and  N''' + @ToObjectID
    + ''')  ' + @AnaWhere + ' '

SET @Ssql = @Ssql + @strTime + ' '

IF @WareHouseID <> '%'
    SET @sSQl = @sSQL + ' Group by  AV7000.DivisionID,  ' + @WareHouseID2 + 
        '  ,' + @WareHouseName + 
        ',  AV7000.ObjectID,    AV7000.InventoryID,	 AV7000.InventoryName,	  AV7000.UnitID,
 AV7000.S1, 	 AV7000.S2, 	 AV7000.S3, 	 AV7000.I01ID, 	 AV7000.I02ID, 	 AV7000.I03ID, 	 AV7000.I04ID, 	 AV7000.I05ID, 
  ISNULL(AV7000.Parameter01,0) , ISNULL(AV7000.Parameter02,0) , ISNULL(AV7000.Parameter03,0) , ISNULL(AV7000.Parameter04,0) , ISNULL(AV7000.Parameter05,0) , 
 AV7000.UnitName ,AV7000.ObjectName, AV7000.Address , AV7000.InventoryTypeID, AV7000.Specification, AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03, ISNULL(AV7000.SourceNo,'''')
'
ELSE
    SET @sSQl = @sSQL + 
        ' Group by  AV7000.DivisionID, AV7000.ObjectID,     AV7000.InventoryID,	 AV7000.InventoryName,	  AV7000.UnitID,
 AV7000.S1, 	 AV7000.S2, 	 AV7000.S3, 	 AV7000.I01ID, 	 AV7000.I02ID, 	 AV7000.I03ID, 	 AV7000.I04ID, 	 AV7000.I05ID, 
ISNULL(AV7000.Parameter01,0), ISNULL(AV7000.Parameter02,0), ISNULL(AV7000.Parameter03,0), ISNULL(AV7000.Parameter04,0), ISNULL(AV7000.Parameter05,0), 
 AV7000.UnitName , AV7000.ObjectName, AV7000.Address , AV7000.InventoryTypeID, AV7000.Specification, AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03,ISNULL(AV7000.SourceNo,'''') 
	'

IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE  Xtype = 'V' AND NAME = 'AV0709')
    EXEC ('Create View AV0709 as ' + @sSQL)
ELSE
    EXEC ('  Alter View  AV0709 as ' + @sSQL)

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
AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03,
max(AV7000.Notes01) as Notes01, max(AV7000.Notes02) as Notes02, max(AV7000.Notes03) as Notes03, max(AV7000.Notes04) as Notes04, max(AV7000.Notes05) as Notes05,
max(AV7000.Notes06) as Notes06, max(AV7000.Notes07) as Notes07, max(AV7000.Notes08) as Notes08,	max(AV7000.Notes09) as Notes09, max(AV7000.Notes10) as Notes10,
max(AV7000.Notes11) as Notes11, max(AV7000.Notes12) as Notes12, max(AV7000.Notes13) as Notes13, max(AV7000.Notes14) as Notes14, max(AV7000.Notes15) as Notes15,
ISNULL(AV7000.SourceNo,'''') SourceNo , AV7000.UnitName,	
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
AV7000.DivisionID
From AV7000 Full join AV0709 on 	( AV0709.InventoryID = AV7000.InventoryID) and
				(AV0709.ObjectID = AV7000.ObjectID) AND AV0709.DivisionID = AV7000.DivisionID 		
Where 	ISNULL(AV7000.DivisionID, AV0709.DivisionID) =''' + @DivisionID + 
    ''' and
(AV7000.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID 
    + ''') and
(AV7000.WareHouseID like   ''' + @WareHouseID + 
    ''' ) and
(AV7000.ObjectID between  ''' + @FromObjectID + ''' and  ''' + @ToObjectID + 
    ''') and 
AV7000.D_C in (''D'', ''C'') ' + @strTime + @AnaWhere + ' ' + 
    ' 
Group by  AV7000.ObjectID, AV7000.ObjectName, AV7000.Address,
AV7000.InventoryID, AV7000.InventoryName, AV7000.UnitID, AV7000.UnitName, 
AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID,
 ISNULL(AV7000.Parameter01,0), ISNULL(AV7000.Parameter02,0), ISNULL(AV7000.Parameter03,0), ISNULL(AV7000.Parameter04,0), ISNULL(AV7000.Parameter05,0), 
 AV7000.InventoryTypeID, AV7000.Specification,
AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03,
---AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08,
---	AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15,
ISNULL(AV7000.SourceNo,''''), AV7000.DivisionID
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE  Xtype = 'V' AND NAME = 'AV0707')
    EXEC (' Create view AV0707 as ' + @sSQL)
ELSE
    EXEC (' Alter view AV0707 as ' + @sSQL)

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
isnull(AV0709.BeginAmount,0) + isnull(AV0707.DebitAmount,0)  - isnull(AV0707.CreditAmount,0) as EndAmount, ''' + @DivisionID +  ''' AS DivisionID	
--EndAmount
From AV0707  Full join AV0709 on 	( AV0709.InventoryID = AV0707.InventoryID) and
				(AV0709.ObjectID = AV0707.ObjectID) and (AV0709.DivisionID = AV0707.DivisionID)		'

EXEC (@sSQL)
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
