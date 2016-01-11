IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP6015]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP6015]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- In bao cao so sanh gia mua.
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/12/2009 by Nguyen Thuy Tuyen
---- 
---- Edited by: [GS] [Thanh Nguyen] [04/08/2010]
---- Edited by: [AS][Thuy Tuyen][21/09/2010] [Cai thien toc do]
---- Modified on 30/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified on 16/05/2013 by Le Thi Thu Hien : 0020698 
-- <Example>
---- 

CREATE   PROCEDURE  [dbo].[OP6015]     
					@DivisionID nvarchar(50),
					@IsDate tinyint,
					@FromMonth int,				
					@ToMonth int,
					@FromYear int,
					@ToYear int,
					@FromDate datetime,
					@ToDate datetime,				
					@FromInventoryID nvarchar(50),
					@ToInventoryID nvarchar(50),
					@FromObjectID nvarchar(50),
					@ToObjectID nvarchar(50)

AS
DECLARE @sSQL nvarchar(max),
		@sTime nvarchar(3000),
		@sTime2 nvarchar(3000), 
		@FromMonthYearText NVARCHAR(20), 
		@ToMonthYearText NVARCHAR(20), 
		@FromDateText NVARCHAR(20), 
		@ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(10), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(10), @ToDate, 101) + ' 23:59:59'
 
If @IsDate =0 
BEGIN
	Set @sTime ='TranMonth + 100*TranYear between '+@FromMonthYearText+'  and  '+@ToMonthYearText+'  '
	Set @sTime2 ='TranMonth + 100*TranYear < '+@FromMonthYearText+'    '
END

If @IsDate =1
BEGIN
	Set @sTime =' CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101)  Between '''+ @FromDateText +''' and '''+@ToDateText+'''  '
	Set @sTime2 = 'CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101),101) < '''+ @FromDateText +''' '	
END



--- Lay ngay gan bao cao nhat
Set @sSQL ='
SELECT  top 100 percent  max(TransactionID ) as MaxTransactionID, OV2400.DivisionID   
FROM	OV2400 
INNER JOIN 	(	SELECT	max(Voucherdate)  as MaxDate, DivisionID  
				FROM	OV2400 
				WHERE	InventoryID  Between N'''+@FromInventoryID+'''  and   N'''+@ToInventoryID+'''	and ObjectID Between N'''+@FromObjectID+ ''' and N'''+@ToObjectID+'''and '+ @sTime+'
				GROUP BY ObjectID,InventoryID, DivisionID 
	) T on OV2400.VoucherDate = T.MaxDate and OV2400.DivisionID = T.DivisionID
WHERE	InventoryID  Between N'''+@FromInventoryID+'''  and  N'''+@ToInventoryID+'''
		and ObjectID Between N'''+@FromObjectID+ ''' and N'''+@ToObjectID+''' 
		and '+ @sTime+' 
GROUP BY ObjectID,InventoryID, OV2400.DivisionID
ORDER BY  max(TransactionID ) '
 
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='OV6020')
	EXEC ('CREATE VIEW OV6020 AS '+@sSQL) -- tao boi Store OP6015
ELSE
	EXEC( 'ALTER VIEW OV6020 AS '+@sSQL) --- Tao boi Stor OP6015


Set @sSQL ='
SELECT	OV2400.*,OV6020.MaxTransactionID  
FROM	OV2400 
INNER JOIN  OV6020 on OV6020.MaxTransactionID = OV2400.TransactionID And OV6020.DivisionID = OV2400.DivisionID  '
 
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='OV6018')
	EXEC ('CREATE VIEW OV6018 as  -- tao boi Store OP6015
			'+@sSQL)
ELSE
	EXEC( 'ALTER VIEW OV6018 as  --- Tao boi Stor OP6015
			'+@sSQL)

--print @sSQL
--- Lay  thong tin truoc ngay bao cao

Set @sSQL = '
SELECT TOP 100 percent   max(PurchasePrice)  as PurchasePrice , 
		max (TransactionID) as TransactionID ,InventoryID,ObjectID, DivisionID 
FROM	OV2400
WHERE	'+ @sTime2+'
GROUP BY ObjectID,InventoryID, DivisionID
ORDER BY TransactionID '

--PRINT @sSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='OV6019')
	EXEC ('CREATE VIEW OV6019 as  -- tao boi Store OP6015
			'+@sSQL)
ELSE
	EXEC( 'ALTER VIEW OV6019 as  --- Tao boi Stor OP6015
				'+@sSQL)

Set @sSQL ='
SELECT	OV2400.* 
FROM	OV2400 
INNER JOIN OV6019 on OV6019.TransactionID = OV2400.TransactionID
'

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='OV6017')
	EXEC ('CREATE VIEW OV6017 AS  -- tao boi Store OP6015
			'+@sSQL)
ELSE
	EXEC( 'ALTER VIEW OV6017 AS  --- Tao boi Stor OP6015
			'+@sSQL)


---lay 
Set @sSQL ='
SELECT DISTINCT InventoryID,InventoryName, UnitID, UnitName, ObjectID,ObjectName , DivisionID 
FROM	OV2400 
WHERE    InventoryID  Between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+'''
		AND ObjectID Between N'''+@FromObjectID+ ''' and N'''+@ToObjectID+''' 
		AND '+ @sTime + '
		AND DivisionID = N''' + @DivisionID + ''''
----print @sSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='OV6016')
	EXEC ('CREATE VIEW OV6016 AS  -- tao boi Store OP6015
	'+@sSQL)
ELSE
	EXEC( 'ALTER VIEW OV6016 AS  --- Tao boi Stor OP6015
	'+@sSQL)

--- Tra ra bao cao
Set  @sSQL ='
SELECT OV6016.*,OV6018.PurchasePrice as NewPurchasePrice, 
		OV6018.OrderQuantity as NewQuantity,OV6018.notes as note, 
		OV6017.PurchasePrice as OldPurchasePrice  
FROM	OV6016 
LEFT JOIN OV6018 on OV6018.InventoryID = OV6016.InventoryID and OV6018.ObjectID = OV6016.ObjectID And OV6018.DivisionID = OV6016.DivisionID
LEFT JOIN OV6017 on OV6018.InventoryID = OV6017.InventoryID and OV6017.ObjectID = OV6018.ObjectID And OV6017.DivisionID = OV6018.DivisionID
WHERE (ISNULL(OV6018.PurchasePrice ,0) > 0 or isnull(OV6017.PurchasePrice ,0) > 0)
'
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='OV6015')
	EXEC ('CREATE VIEW OV6015 AS  -- tao boi Store OP6015
	'+@sSQL)
ELSE
	EXEC( 'ALTER VIEW OV6015 AS  --- Tao boi Stor OP6015
	'+@sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

