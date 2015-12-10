--1) OBVT
-- Tự động cập nhật MaDVT
declare @MaVT varchar(16),
		@OBVTID uniqueidentifier

declare obvt cursor for select MaVT, OBVTID from OBVT where MaDVT is null

open obvt
fetch next from obvt into @MaVT, @OBVTID

while @@Fetch_Status = 0
BEGIN
	
	Update OBVT set MaDVT = (select MaDVT from DMVT vt where vt.MaVT = MaVT and vt.MaVT = @MaVT)
	where MaDVT is null and OBVTID = @OBVTID
	
	fetch next from obvt into @MaVT, @OBVTID
END

close obvt 
deallocate obvt

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBVT'  and col.name = 'MaDVT')
BEGIN
	ALTER TABLE [dbo].[OBVT] ALTER COLUMN [MaDVT] [varchar](16) NOT NULL 
END

-- 2) OBNTXT
-- Tự động cập nhật MaDVT
declare @OBNTXTID uniqueidentifier

declare OBNTXT cursor for select MaVT, OBNTXTID from OBNTXT where MaDVT is null

open OBNTXT
fetch next from OBNTXT into @MaVT, @OBNTXTID

while @@Fetch_Status = 0
BEGIN
	
	Update OBNTXT set MaDVT = (select MaDVT from DMVT vt where vt.MaVT = MaVT and vt.MaVT = @MaVT)
	where MaDVT is null and OBNTXTID = @OBNTXTID
	
	fetch next from OBNTXT into @MaVT, @OBNTXTID
END

close OBNTXT 
deallocate OBNTXT

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBNTXT'  and col.name = 'MaDVT')
BEGIN
	ALTER TABLE [dbo].[OBNTXT] ALTER COLUMN [MaDVT] [varchar](16) NOT NULL 
END

-- TODO: có nhiều phiếu lưu vào BLVT chưa kiểm soát hết
-- 3) BLVT
-- Tự động cập nhật MaDVT
declare @sysTableBLID int,
		@BLMaDVT int,
		@BLVTID int,
		@MTIDDT uniqueidentifier,
		@MTID uniqueidentifier,
		@TableNameUseMaDVT varchar(50),
		@searchTables varchar(250),
		@TableName varchar(50),
		@ColumnName varchar(50),
		@ColMaVTName varchar(50),
		@ColMaDVTName varchar(50),
		@sql nvarchar(4000)
set @searchTables = ''
set @ColMaVTName = ''
set @ColMaDVTName = ''
-- Lấy danh sách các table sử dụng field MaDVT trong BLVT
select @sysTableBLID = sysTableID from CDT.dbo.sysTable where TableName = 'BLVT'
select @BLMaDVT = sysFieldID from CDT.dbo.sysField where sysTableID = @sysTableBLID and FieldName = 'MaDVT'

declare cur_TableUseMaDVT cursor for select TableName from CDT.dbo.sysTable where sysTableID IN (
select sysTableID from CDT.dbo.sysField where sysFieldID IN(select mtFieldID from CDT.dbo.sysDataConfigDt where blConfigID IN (
select blConfigID from CDT.dbo.sysDataConfig where sysTableID = @sysTableBLID) and blFieldID = @BLMaDVT and mtFieldID is not null)
Union 
select sysTableID from CDT.dbo.sysField where sysFieldID IN(select dtFieldID from CDT.dbo.sysDataConfigDt where blConfigID IN (
select blConfigID from CDT.dbo.sysDataConfig where sysTableID = @sysTableBLID) and blFieldID = @BLMaDVT and dtFieldID is not null)
Union
select sysTableID from CDT.dbo.sysField where sysFieldID IN(select dt2FieldID from CDT.dbo.sysDataConfigDt where blConfigID IN (
select blConfigID from CDT.dbo.sysDataConfig where sysTableID = @sysTableBLID) and blFieldID = @BLMaDVT and dt2FieldID is not null)
)
open cur_TableUseMaDVT
fetch next from cur_TableUseMaDVT into @TableNameUseMaDVT

while @@Fetch_Status = 0
BEGIN
	if (@searchTables <> '')
		set @searchTables = @searchTables + ','
	set @searchTables = @searchTables + '''' + @TableNameUseMaDVT + ''''
	fetch next from cur_TableUseMaDVT into @TableNameUseMaDVT
END

close cur_TableUseMaDVT 
deallocate cur_TableUseMaDVT

-- Cập nhật MaDVT trong table BLVT bằng cách map qua các table dữ liệu tương ứng
declare BLVT cursor for select BLVTID, MTIDDT, MTID from BLVT where MaDVT is null

open BLVT
fetch next from BLVT into @BLVTID, @MTIDDT, @MTID

while @@Fetch_Status = 0
BEGIN
	set @TableName = ''
	set @ColumnName = ''
	exec FindGUID @MTIDDT, @searchTables ,'''BLVT'',''BLTK''', @TableName output, @ColumnName output

	if isnull(@TableName,'') = '' or isnull(@ColumnName,'') = ''
		exec FindGUID @MTID, @searchTables ,'''BLVT'',''BLTK''', @TableName output, @ColumnName output

	if isnull(@TableName,'') = '' or isnull(@ColumnName,'') = ''
	BEGIN
		fetch next from BLVT into @BLVTID, @MTIDDT, @MTID
		continue
	END
		
	if exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name = @TableName  and col.name = 'MaVT')
	BEGIN
		set @ColMaVTName = 'MaVT'
	END
	else if exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name = @TableName  and col.name = 'MaVT1')
	BEGIN
		set @ColMaVTName = 'MaVT1'
	END
	else if exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name = @TableName  and col.name = 'MaVT2')
	BEGIN
		set @ColMaVTName = 'MaVT2'
	END
	
	if exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name = @TableName  and col.name = 'MaDVT')
	BEGIN
		set @ColMaDVTName = 'MaDVT'
	END
	else if exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name = @TableName  and col.name = 'MaDVT1')
	BEGIN
		set @ColMaDVTName = 'MaDVT1'
	END
	else if exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name = @TableName  and col.name = 'MaDVT2')
	BEGIN
		set @ColMaDVTName = 'MaDVT2'
	END
	
	if (@ColMaVTName <> '')
	BEGIN
		if isnull(cast(@MTIDDT as varchar(50)), '') <> ''
			set @sql = 'Update BLVT set MaDVT = (select ' + @ColMaDVTName + ' from ' + @TableName + ' vt where vt.' + @ColMaVTName + ' = MaVT and vt.' + @ColumnName + '= ''' + cast(@MTIDDT as varchar(50)) + ''')
				where MaDVT is null and BLVTID = ''' + cast(@BLVTID as varchar(50)) + ''''	
		else if isnull(cast(@MTID as varchar(50)), '') <> ''
			set @sql = 'Update BLVT set MaDVT = (select ' + @ColMaDVTName + ' from ' + @TableName + ' vt where vt.' + @ColMaVTName + ' = MaVT and vt.' + @ColumnName + '= ''' + cast(@MTID as varchar(50)) + ''')
				where MaDVT is null and BLVTID = ''' + cast(@BLVTID as varchar(50)) + ''''	
		
		exec(@sql)
	END
	
	fetch next from BLVT into @BLVTID, @MTIDDT, @MTID
END

close BLVT 
deallocate BLVT

/*if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLVT'  and col.name = 'MaDVT')
BEGIN
	ALTER TABLE [dbo].[BLVT] ALTER COLUMN [MaDVT] [varchar](16) NOT NULL 
END*/