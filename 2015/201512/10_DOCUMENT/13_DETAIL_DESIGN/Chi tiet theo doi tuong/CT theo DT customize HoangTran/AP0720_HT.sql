IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0720_HT]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0720_HT]
GO
SET QUOTED_IDENTIFIER ON
GO

-- <Summary>
---- In báo cáo chi tiết Lọc theo mã phân tích đối tượng 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 21/01/2016 by Thị Phượng: Lọc theo mã phân tích đối tượng (Mã phân tích 5 (O05ID)) + theo dõi vỏ(IsBottle)(Customize Hoàng Trần)
-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP0720_HT]
(
    @DivisionID       AS NVARCHAR(50),
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
    @Isbottle         AS TINYINT,
	@FromO05ID        AS NVarchar(250),
	@ToO05ID		  AS NVarchar(250)
)
AS
DECLARE @sSQL           AS NVARCHAR(4000),
        @sWhere        AS NVARCHAR(4000),
        @OWhere         AS NVARCHAR (4000),
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'
SET @sWhere=''

IF @IsBottle = 1
   SET @OWhere = ''
	IF PATINDEX('[%]', @FromO05ID) > 0
		BEGIN
			SET @OWhere = @OWhere + ' And x.O05ID Like N''' + @FromO05ID + ''''
		END
	ELSE
		IF @FromO05ID IS NOT NULL AND @FromO05ID <> ''
		BEGIN
			SET @OWhere = @OWhere + ' And Isnull(x.O05ID,'''') >= N''' + REPLACE(@FromO05ID, '[]', '') + 
										''' And Isnull(x.O05ID,'''') <= N''' + REPLACE(@ToO05ID, '[]', '') + ''''
		END 
IF (@FromObjectID is not null and @FromObjectID not like '')
	Set @sWhere = @sWhere+ 'and (x.ObjectID between  N''' + @FromObjectID + ''' and  N''' + @ToObjectID+ ''')'
IF (@FromInventoryID is not null and @FromInventoryID not like '')
	Set @sWhere = @sWhere+'and (x.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID+ ''')'
IF @IsDate = 1
    ---- xac dinh so lieu theo ngay
    SET @sWhere = @sWhere+' and (x.VoucherDate  Between  ''' + @FromDateText + '''  and ''' + @ToDateText + '''  ) '
ELSE
    SET @sWhere = @sWhere+' and (x.TranMonth+ 100*x.TranYear Between ' + @FromMonthYearText + ' and  ' + @ToMonthYearText + '  ) ' 

SET @sSQL=N'
Select y.DivisionID,y.O05ID, y.ObjectAnaName5,y.InventoryID, y.InventoryName,
	isnull(y.BeginQuantity,0) as BeginQuantity,
	isnull(y.BeginConvertedQuantity,0) as BeginConvertedQuantity,
	isnull(y.BeginMarkQuantity,0) as BeginMarkQuantity,
	isnull(y.DebitQuantity,0) as DebitQuantity, 
	isnull(y.CreditQuantity,0) as CreditQuantity,
	isnull(y.DebitConvertedQuantity,0) as DebitConvertedQuantity, 
	isnull(y.CreditConvertedQuantity,0) as CreditConvertedQuantity,
	isnull(y.DebitMarkQuantity,0) as DebitMarkQuantity, 
	isnull(y.CreditMarkQuantity,0) as CreditMarkQuantity,
	isnull(y.BeginQuantity,0) + isnull(y.DebitQuantity,0) - isnull(y.CreditQuantity,0) as EndQuantity,
	isnull(y.BeginConvertedQuantity,0) + isnull(y.DebitConvertedQuantity,0)  - isnull(y.CreditConvertedQuantity,0) as EndConvertedQuantity,
	isnull(y.BeginMarkQuantity,0) + isnull(y.DebitMarkQuantity,0)  - isnull(y.CreditMarkQuantity,0) as EndMarkQuantity
	From
	(
		Select x.DivisionID,x.O05ID, x.ObjectAnaName5,x.D_C, x.InventoryID, x.InventoryName,
		0 as BeginQuantity,
		0 as BeginConvertedQuantity,
		0 as BeginMarkQuantity,
		Sum(Case when D_C = ''D'' then isnull(x.MarkQuantity,0) else 0 end) as DebitMarkQuantity,
		Sum(Case when D_C = ''C'' then isnull(x.MarkQuantity,0) else 0 end) as CreditMarkQuantity,
		Sum(Case when D_C = ''D'' then isnull(x.ActualQuantity,0) else 0 end) as DebitQuantity,
		Sum(Case when D_C = ''C'' then isnull(x.ActualQuantity,0) else 0 end) as CreditQuantity,
		Sum(Case when D_C = ''D'' then isnull(x.ConvertedQuantity,0) else 0 end) as DebitConvertedQuantity,
		Sum(Case when D_C = ''C'' then isnull(x.ConvertedQuantity,0) else 0 end) as CreditConvertedQuantity
		From AV7000_HT x
		Where x.IsBottle =1
		AND  x.DivisionID like N'''+ @DivisionID  + 
		''' and
		x.D_C in (''D'',''C'', ''BD'' )'+ @OWhere 
		+ @sWhere +'
		Group by x.DivisionID, x.D_C, x.O05ID, x.ObjectAnaName5, x.InventoryID, x.InventoryName
)y'

EXEC (@sSQL)
GO