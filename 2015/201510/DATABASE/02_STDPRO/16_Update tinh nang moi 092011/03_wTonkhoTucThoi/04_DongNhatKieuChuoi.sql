declare @tableName nvarchar(128),
		@fieldName nvarchar(128),
		@nullable bit,
		@sql nvarchar(1024)
		
declare cur cursor for

SELECT 
    tbl.name, c.name, c.isnullable
FROM 
    dbo.syscolumns c
	inner join sysobjects tbl on tbl.id = c.id
    INNER JOIN dbo.systypes st ON st.xusertype = c.xusertype
    INNER JOIN dbo.systypes bt ON bt.xusertype = c.xtype
WHERE 
    OBJECTPROPERTY(c.id,'ISTABLE') = 1
    and tbl.xType = 'U'
    and bt.name = 'nvarchar'
    and tbl.category <> 2
    and c.prec < 512
ORDER BY
    OBJECT_NAME(c.id), 
    c.colid

open cur
fetch next from cur into @tableName, @fieldName, @nullable
    
while @@FETCH_STATUS = 0
BEGIN
	if @nullable = 0
		set @sql = N'ALTER TABLE ' + @tableName + N' ALTER COLUMN ' + @fieldName + N' [nvarchar] (512) NOT NULL'
	else
		set @sql = N'ALTER TABLE ' + @tableName + N' ALTER COLUMN ' + @fieldName + N' [nvarchar] (512) NULL'
	
	exec(@sql)
fetch next from cur into @tableName, @fieldName, @nullable
END

close cur
deallocate cur
