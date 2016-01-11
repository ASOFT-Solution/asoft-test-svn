IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7720]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP7720]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Bao cao Luy ke hang ton kho
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Nguyen Van Nhan Create Date 24/04/2005
----Edited by Nguyen Quoc Huy, Date 19/03/2007
----Edited by: [GS] [Minh Lâm] [29/07/2010]
----Modified on 17/07/2014 by Thanh Sơn: lấy dữ liệu trực tiếp từ store, không sinh view AV7720
-- <Example>
/*
    EXEC WP0100,0, 1
*/

CREATE PROCEDURE AP7720
(
    @DivisionID NVARCHAR(50),
    @FromMonth INT,
    @FromYear INT,
    @ToMonth INT,
    @ToYear INT,
    @FromWareHouseID NVARCHAR(50) ,
    @ToWareHouseID NVARCHAR(50) ,
    @RowTypeID NVARCHAR(50), ---- CI1, CI2, CI3, IN, I01,...I05.
    @IsQuantity TINYINT,
    @IsBegin TINYINT,
    @IsDebit TINYINT,
    @IsCredit TINYINT,
    @IsEnd TINYINT,
    @MonthYear01 INT,
    @MonthYear02 INT,
    @MonthYear03 INT,
    @MonthYear04 INT,
    @MonthYear05 INT,
    @MonthYear06 INT,
    @MonthYear07 INT,
    @MonthYear08 INT,
    @MonthYear09 INT,
    @MonthYear10 INT,
    @MonthYear11 INT,
    @MonthYear12 INT,
    @MonthYear13 INT,
    @MonthYear14 INT,
    @MonthYear15 INT,
    @MonthYear16 INT,
    @MonthYear17 INT,
    @MonthYear18 INT,
    @MonthYear19 INT,
    @MonthYear20 INT,
    @strWhereClause NVARCHAR(250)
)
AS
DECLARE 
	@ColumnName NVARCHAR(250),
	@sSQL NVARCHAR(4000),
	@sSQL1 NVARCHAR(4000),
	@sSQL2 NVARCHAR(4000),
	@sSQL3 NVARCHAR(4000),
	@sSQL4 NVARCHAR(4000),
	@BeginField NVARCHAR(200) ,
	@DebitField NVARCHAR(200) ,
	@CreditField NVARCHAR(200) ,
	@EndField NVARCHAR(200) ,
	@SQL NVARCHAR(4000) ,
	@strSQL NVARCHAR(4000) ,
	@TypeName NVARCHAR(250) ,
	@sql_Filter NVARCHAR(4000), 
	@FromMonthYearText NVARCHAR(20), 
	@ToMonthYearText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)

IF @IsQuantity = 0 --- Gia tri
   BEGIN
         SET @BeginField = 'BeginAmount'
         SET @DebitField = 'DebitAmount - ISNULL(InDebitAmount,0) '
         SET @CreditField = 'CreditAmount - ISNULL(InCreditAmount,0) '
         SET @EndField = ' EndAmount'
   END
ELSE
   BEGIN
         SET @BeginField = 'BeginQuantity'
         SET @DebitField = ' DebitQuantity - ISNULL(InDebitQuantity,0) '
         SET @CreditField = 'CreditQuantity - ISNULL(InCreditQuantity,0)'
         SET @EndField = ' EndQuantity'
   END
   
DELETE AT6666
INSERT INTO AT6666 (DivisionID, SelectionType, SelectionID, SelectionName )
SELECT @DivisionID, SelectionType, SelectionID, SelectionName FROM AV6666
WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
EXEC AP7710 @RowTypeID , @ColumnName OUTPUT

SET @sSQL = ''
SET @sSQL1 = ''
SET @sSQL2 = ''
SET @sSQL3 = ''
SET @sSQL4 = ''

IF @RowTypeID = 'IN' SET @sql_Filter = ' V7.I01ID, V7.I02ID, V7.I03ID, V7.I04ID, V7.I05ID , CI1ID, CI2ID, CI3ID '
---- So du ban Dau

IF @IsBegin <> 0  --- Lay so du dau:
BEGIN
	SET @sSQL = @sSQL + '
SELECT DISTINCT V7.DivisionID,' + @ColumnName + ' as Column00ID, SelectionName as Column00Name, 0 as TypeID , ''WFML000134'' as TypeName   '
	IF @RowTypeID = 'IN' SET @sSQL = @sSQL + ', ' + @sql_Filter 
	EXEC AP7719 @BeginField , @ColumnName , @SQL OUTPUT , @MonthYear01 , @MonthYear02 , @MonthYear03 , @MonthYear04 , @MonthYear05 , @MonthYear06 , @MonthYear07 , @MonthYear08 , @MonthYear09 , @MonthYear10 , @MonthYear11 , @MonthYear12 , @MonthYear13 , @MonthYear14 , @MonthYear15 , @MonthYear16 , @MonthYear17 , @MonthYear18 , @MonthYear19 , @MonthYear20
	SET @sSQL = @sSQL + @SQL + '
FROM AV7777 V7 
	INNER JOIN AT6666 V6 on V7.DivisionID = V6.DivisionID AND V6.SelectionID = V7.' + @ColumnName + ' AND V6.SelectionType = ''' + @RowTypeID + '''  
WHERE V7.DivisionID LIKE ''' + @DivisionID + ''' 
	AND WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + '''
	AND TranMonth + 100*TranYear >= ' + @FromMonthYearText + '
	AND TranMonth + 100*TranYear <= ' + @ToMonthYearText + ' '
	IF ISNULL(@strWhereClause, '') <> '' SET @sSQL = @sSQL + ' and (' + @strWhereClause + ')'
	SET @sSQL = @sSQL + '
GROUP BY V7.DivisionID,' + @ColumnName + ' ,V6.SelectionName '
    IF @RowTypeID = 'IN' SET @sSQL = @sSQL + ', ' + @sql_Filter
    SET @sSQL1 = @sSQL
END

SET @sSQL = ''
--------------------------- Nhap kho -------------------------------
IF @IsDebit <> 0  --- Lay so nhap kho
	BEGIN
		IF @sSQL1 <> '' SET @sSQL = @sSQL + '
UNION ALL SELECT DISTINCT V7.DivisionID,' + @ColumnName + ' AS Column00ID, SelectionName  AS Column00Name, 1 AS Orders, ''WFML000135'' AS TypeName'
        ELSE SET @sSQL = @sSQL + '
SELECT DISTINCT V7.DivisionID,' + @ColumnName + ' AS Column00ID, SelectionName AS Column00Name , 1 AS TypeID , ''WFML000135'' AS TypeName'
        IF @RowTypeID = 'IN' SET @sSQL = @sSQL + ', ' + @sql_Filter
		EXEC AP7719 @DebitField , @ColumnName , @SQL OUTPUT , @MonthYear01 , @MonthYear02 , @MonthYear03 , @MonthYear04 , @MonthYear05 , @MonthYear06 , @MonthYear07 , @MonthYear08 , @MonthYear09 , @MonthYear10 , @MonthYear11 , @MonthYear12 , @MonthYear13 , @MonthYear14 , @MonthYear15 , @MonthYear16 , @MonthYear17 , @MonthYear18 , @MonthYear19 , @MonthYear20
		SET @sSQL = @sSQL + @SQL + '
FROM AV7777 V7 INNER JOIN AT6666 V6 ON V7.DivisionID = V6.DivisionID AND V6.SelectionID = V7.' + @ColumnName + ' AND V6.SelectionType = ''' + @RowTypeID + '''  
WHERE V7.DivisionID LIKE ''' + @DivisionID + '''
	AND WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + '''
	AND TranMonth + 100*TranYear >= ' + @FromMonthYearText + '
	AND TranMonth + 100*TranYear <= ' + @ToMonthYearText + ' '
			IF ISNULL(@strWhereClause , '') <> '' SET @sSQL = @sSQL + ' AND (' + @strWhereClause + ')'
		SET @sSQL = @sSQL + '
GROUP BY V7.DivisionID,' + @ColumnName + ' ,V6.SelectionName '
		IF @RowTypeID = 'IN' SET @sSQL = @sSQL + ', ' + @sql_Filter
		SET @sSQL2 = @sSQL	
	END

SET @sSQL = ''

IF @IsCredit <> 0  --- Xuat kho
   BEGIN
         IF @sSQL1 + @sSQL2 <> '' SET @sSQL = @sSQL + ' 
UNION ALL SELECT DISTINCT V7.DivisionID,' + @ColumnName + ' AS Column00ID, SelectionName AS Column00Name , 2 AS TypeID , ''WFML000136'' AS TypeName '
         ELSE SET @sSQL = @sSQL + '
SELECT DISTINCT V7.DivisionID,' + @ColumnName + ' AS Column00ID, SelectionName  AS Column00Name, 1 AS TypeID , ''WFML000136'' AS TypeName   '
         IF @RowTypeID = 'IN' SET @sSQL = @sSQL + ', ' + @sql_Filter
		 EXEC AP7719 @CreditField , @ColumnName , @SQL OUTPUT , @MonthYear01 , @MonthYear02 , @MonthYear03 , @MonthYear04 , @MonthYear05 , @MonthYear06 , @MonthYear07 , @MonthYear08 , @MonthYear09 , @MonthYear10 , @MonthYear11 , @MonthYear12 , @MonthYear13 , @MonthYear14 , @MonthYear15 , @MonthYear16 , @MonthYear17 , @MonthYear18 , @MonthYear19 , @MonthYear20
		 SET @sSQL = @sSQL + @SQL + '
FROM AV7777 V7 INNER JOIN AT6666 V6 ON V7.DivisionID = V6.DivisionID AND V6.SelectionID = V7.' + @ColumnName + ' 
AND V6.SelectionType = ''' + @RowTypeID + '''  
WHERE V7.DivisionID LIKE ''' + @DivisionID + '''
	AND WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + '''
	AND TranMonth + 100 * TranYear >= ' + @FromMonthYearText + '
	AND TranMonth + 100 * TranYear  <= ' + @ToMonthYearText + ' '
         IF ISNULL(@strWhereClause , '') <> '' SET @sSQL = @sSQL + ' AND (' + @strWhereClause + ')'
         SET @sSQL = @sSQL + '
GROUP BY V7.DivisionID,' + @ColumnName + ', V6.SelectionName '
         IF @RowTypeID = 'IN' SET @sSQL = @sSQL + ', ' + @sql_Filter
--print @sSQL
         SET @sSQL3 = @sSQL
   END
   
SET @sSQL = ''

IF @IsEnd <> 0  --- Ton cuoi
   BEGIN
         IF @sSQL1 + @sSQL2 + @sSQL3 <> '' SET @sSQL = @sSQL + '
UNION ALL SELECT DISTINCT V7.DivisionID,' + @ColumnName + ' AS Column00ID, SelectionName  AS Column00Name , 3 AS TypeID, ''WFML000137'' AS TypeName   '
         ELSE SET @sSQL = @sSQL + '
SELECT V7.DivisionID, ' + @ColumnName + ' AS Column00ID, SelectionName AS Column00Name , 3 AS TypeID, ''WFML000137'' AS TypeName '
         IF @RowTypeID = 'IN' SET @sSQL = @sSQL + ',  ' + @sql_Filter    
         EXEC AP7719 @EndField , @ColumnName , @SQL OUTPUT , @MonthYear01 , @MonthYear02 , @MonthYear03 , @MonthYear04 , @MonthYear05 , @MonthYear06 , @MonthYear07 , @MonthYear08 , @MonthYear09 , @MonthYear10 , @MonthYear11 , @MonthYear12 , @MonthYear13 , @MonthYear14 , @MonthYear15 , @MonthYear16 , @MonthYear17 , @MonthYear18 , @MonthYear19 , @MonthYear20
         SET @sSQL = @sSQL + @SQL + '
FROM AV7777 V7 
	INNER JOIN AT6666 V6 ON V7.DivisionID = V6.DivisionID AND V6.SelectionID = V7.' + @ColumnName + ' AND V6.SelectionType =''' + @RowTypeID + '''  
WHERE V7.DivisionID LIKE ''' + @DivisionID + '''
	AND WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + '''
	AND TranMonth + 100*TranYear >= ' + @FromMonthYearText + ' 
	AND TranMonth + 100*TranYear  <= ' + @ToMonthYearText + ' '
         IF ISNULL(@strWhereClause , '') <> '' SET @sSQL = @sSQL + ' AND (' + @strWhereClause + ')'
		 SET @sSQL = @sSQL + '
GROUP BY V7.DivisionID,' + @ColumnName + ' ,V6.SelectionName '
         IF @RowTypeID = 'IN' SET @sSQL = @sSQL + ', ' + @sql_Filter
         SET @sSQL4 = @sSQL
   END

--Print @sSQL1+' '+@sSQL2+' '+@sSQL3+' '+@sSQL4
---Print @sSQL3+' '+@sSQL4
--print @RowTypeID
--if @RowTypeID ='IN'

SET @strSQL = @sSQL1 + ' ' + @sSQL2 + ' ' + @sSQL3 + ' ' + @sSQL4
PRINT @strSQL

EXEC (@sSQL1+' '+@sSQL2+' '+@sSQL3+' '+@sSQL4)

--IF NOT EXISTS ( SELECT 1 FROM sysobjects WHERE Name = 'AV7720' AND Xtype = 'V' )
--   BEGIN
--         Exec ( '  Create View AV7720 as '+ )
--   END
--ELSE
--   BEGIN
--         Exec ( '  Alter View AV7720  As '+@sSQL1+' '+@sSQL2+' '+@sSQL3+' '+@sSQL4 )
--   END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
