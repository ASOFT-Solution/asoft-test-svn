declare @ConstraintName  nvarchar(250)
declare @ColumnName  nvarchar(250)
declare @SumColumnName  nvarchar(250)
declare @TableName  nvarchar(250)
declare @DivisionCol  nvarchar(250)
declare @sSQLTable  nvarchar(250)
declare @sSQLConstraint nvarchar(250)

set @sSQLTable = ''
set @sSQLConstraint = ''

-- Get tat ca cac table co cot DivisionID
declare cur_TableDivision cursor for
SELECT distinct col.TABLE_NAME
FROM INFORMATION_SCHEMA.Columns col inner join INFORMATION_SCHEMA.TABLES tabls
	on col.TABLE_NAME = tabls.TABLE_NAME and tabls.TABLE_TYPE = 'BASE TABLE'
WHERE	(col.COLUMN_NAME = 'DivisionID' or 
		col.COLUMN_NAME = 'DefDivisionID')
		AND col.TABLE_NAME not LIKE '%_tracking'

open cur_TableDivision
fetch next from cur_TableDivision into @TableName

while @@fetch_status = 0
  begin
	-- Xoa bang tam
	IF (select COUNT(*) from sysobjects sysobj where sysobj.xtype = 'U' and sysobj.name = 'Constrain_Temp') > 0
	begin
	drop table Constrain_Temp
	end
	
	-- Lay cac field trong khoa chinh cua bang cho vao bang tam
	SELECT distinct Tab.CONSTRAINT_NAME, Col.COLUMN_NAME into Constrain_Temp
	from 
		INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab inner join 
		INFORMATION_SCHEMA.TABLES tabls on tabls.TABLE_NAME = Tab.Table_Name
		inner join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col on Col.Table_Name = Tab.Table_Name
	WHERE 
		tabls.TABLE_TYPE = 'BASE TABLE' and
		Tab.Constraint_Type = 'PRIMARY KEY' and 
		tabls.Table_Name <> 'dtproperties' and 
		tabls.TABLE_NAME = @TableName

	-- Khoa chinh cua bang chua co DivisionID
	if not exists (select 1 from Constrain_Temp where COLUMN_NAME = 'DivisionID' or COLUMN_NAME = 'DefDivisionID')
	begin
		set @SumColumnName = ''
		set @ConstraintName = ''
		set @ColumnName = ''
		declare cur_TableCons cursor for
		select CONSTRAINT_NAME, COLUMN_NAME from Constrain_Temp
		
		open cur_TableCons
		fetch next from cur_TableCons into @ConstraintName, @ColumnName
		
		while @@fetch_status = 0
		begin
		
		if isnull(@SumColumnName, '') = ''
		begin
			set @SumColumnName = @ColumnName
		end
		else
		begin
			set @SumColumnName = @SumColumnName + ',' + @ColumnName
		end
		
		fetch next from cur_TableCons into @ConstraintName, @ColumnName
		
		end
		--print @TableName + ' ' + @ConstraintName + ' ' + @SumColumnName
				
		set @DivisionCol = ''
		-- Bang co cot DivisionID
		if exists (SELECT 1
			FROM INFORMATION_SCHEMA.Columns col inner join INFORMATION_SCHEMA.TABLES tabls
			on col.TABLE_NAME = tabls.TABLE_NAME and tabls.TABLE_TYPE = 'BASE TABLE'
			WHERE	col.COLUMN_NAME = 'DivisionID'
			and col.TABLE_NAME = @TableName)
		begin
			set @DivisionCol = 'DivisionID'
		end
		else
		begin
			set @DivisionCol = 'DefDivisionID'
		end
		
		-- Cot DivisionID khong cho Null
		 if exists (SELECT 1
			FROM INFORMATION_SCHEMA.Columns col inner join INFORMATION_SCHEMA.TABLES tabls
			on col.TABLE_NAME = tabls.TABLE_NAME and tabls.TABLE_TYPE = 'BASE TABLE'
			WHERE	col.COLUMN_NAME = @DivisionCol
			and col.IS_NULLABLE = 'NO'
			and col.TABLE_NAME = @TableName)
		begin
			if isnull(@ConstraintName,'') <> ''
			begin
			-- Them DivisionID lam khoa chinh
			set @sSQLTable = 'ALTER TABLE ' + @TableName
			set @sSQLConstraint = ' DROP CONSTRAINT ' + @ConstraintName
			exec (@sSQLTable + @sSQLConstraint)
		
			set @sSQLConstraint = ' ADD CONSTRAINT ' + @ConstraintName + ' PRIMARY KEY (' + @SumColumnName + ',' + @DivisionCol + ')'
			exec (@sSQLTable + @sSQLConstraint)	
			end
		end
		
		close cur_TableCons
		deallocate cur_TableCons
	end 

	-- get next record
    fetch next from cur_TableDivision into @TableName
  end

-- Xoa bang tam
IF (select COUNT(*) from sysobjects sysobj where sysobj.xtype = 'U' and sysobj.name = 'Constrain_Temp') > 0
	begin
	drop table Constrain_Temp
	end
	
close cur_TableDivision
deallocate cur_TableDivision
