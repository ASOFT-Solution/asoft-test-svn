IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FindGUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[FindGUID]
GO

CREATE PROCEDURE dbo.FindGUID @searchValue uniqueidentifier, @searchTables varchar(1000), @excludeTables varchar(250), @ReceiveTableName varchar(50) OUTPUT, @ReceiveColumnName varchar(50) OUTPUT AS

/*
    Search all tables in the database for a guid
    Revision History
*/

IF OBJECT_ID('tempdb..#result') IS NOT NULL
BEGIN
	DROP TABLE #result
END

create table #result
(
	TheTable varchar(50) null,
	TheColumn varchar(50) null
)

declare @sql nvarchar(4000)
declare @where nvarchar(4000)
declare @tableName varchar(50)
declare @columnName varchar(50)
set @where =''
set @sql = 'DECLARE searchTables CURSOR FOR
    SELECT 
        c.TABLE_SCHEMA, c.TABLE_NAME, c.COLUMN_NAME
    FROM INFORMATION_SCHEMA.Columns c
        INNER JOIN INFORMATION_SCHEMA.Tables t
        ON c.TABLE_NAME = t.TABLE_NAME
        AND t.TABLE_TYPE = ''BASE TABLE''
    WHERE DATA_TYPE = ''uniqueidentifier'' '
    
if isnull(@searchTables,'') <> ''
	set @where = ' and c.TABLE_NAME IN (' + @searchTables + ') '
	
if isnull(@excludeTables,'') <> ''
	set @where = @where + ' and c.TABLE_NAME NOT IN (' + @excludeTables + ') '

if isnull(@where,'') <> ''
	set @sql = @sql + @where

exec(@sql)

DECLARE @tableSchema varchar(200)
DECLARE @szQuery varchar(8000)
SET @szQuery = ''

--DECLARE @lasttable varchar(255);
--SET @lasttable='';

OPEN searchTables

FETCH NEXT FROM searchTables INTO @tableSchema, @tableName, @columnName;
WHILE (@@FETCH_STATUS = 0)
BEGIN
	SET @szQuery = 'INSERT into #result(TheTable, TheColumn) ' +
     ' SELECT '''+@tableSchema+'.'+@tableName+''' AS TheTable, '''+@columnName+''' AS TheColumn '+
     ' FROM '+@tableName+' '+
     ' WHERE '+@columnName+' = '''+CAST(@searchValue AS varchar(50))+''''
     
   IF @szQuery <> '' 
   BEGIN
      --PRINT @szQuery
      EXEC (@szQuery)
      
      if exists (select 1 from #result)
      BEGIN
		set @ReceiveTableName = @tableName
		set @ReceiveColumnName = @columnName
		BREAK
	  END
   END
       
   FETCH NEXT FROM searchTables INTO @tableSchema, @tableName, @columnName;
END

CLOSE searchTables
DEALLOCATE searchTables

IF OBJECT_ID('tempdb..#result') IS NOT NULL
BEGIN
	DROP TABLE #result
END

