declare @tableName nvarchar(128),
		@fieldName nvarchar(128),
		@sql nvarchar(4000)
		
declare cur cursor for

SELECT 
    tbl.name, c.name
FROM 
    dbo.syscolumns c
	inner join sysobjects tbl on tbl.id = c.id
    INNER JOIN dbo.systypes st ON st.xusertype = c.xusertype
    INNER JOIN dbo.systypes bt ON bt.xusertype = c.xtype
WHERE 
    OBJECTPROPERTY(c.id,'ISTABLE') = 1
    and tbl.xType = 'U'
    and (bt.name = 'datetime' or bt.name = 'smalldatetime')
    and tbl.category <> 2
ORDER BY
    OBJECT_NAME(c.id), 
    c.colid

open cur
fetch next from cur into @tableName, @fieldName
    
while @@FETCH_STATUS = 0
BEGIN
	set @sql = 'Update ' + @tableName + ' set ' + @fieldName + ' = cast(CONVERT(VARCHAR(10),' + @fieldName + ',120) as datetime)
	where (DATEPART(hour,' + @fieldName + ') <> 0 or DATEPART(minute,' + @fieldName + ') <> 0 or DATEPART(second,' + @fieldName + ') <> 0)'
	exec(@sql)
fetch next from cur into @tableName, @fieldName
END

close cur
deallocate cur
