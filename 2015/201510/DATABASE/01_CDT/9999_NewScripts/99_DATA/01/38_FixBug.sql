USE [CDT]

Declare @sysTableID int,
		@sysTableBLID int,
		@NhomDK varchar(50),
		@blConfigID int,
		@blFieldID int,
		@FieldID int,
		@FieldName nvarchar(50),
		@blFieldName nvarchar(50)

-- 1) CRM:TT2583 - Thêm tài khoản chi phí trong combo tài khoản chi phí
select @sysTableID = sysTableID from sysTable where TableName = N'DMTSCD'

Update sysField set RefCriteria = N'(TK like ''6%'' or TK like ''154%'' or TK like ''8%'') and TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)'
where sysTableID = @sysTableID
and FieldName = 'TKCP'
and RefCriteria = N'TK like ''6%'' and TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)'

-- 2) Mantis:0016740 - NhomDK HTL7 và HTL8 không đồng bộ dữ liệu khi cập nhật.
-- Update sysDataConfigDt
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'

-- HTL7
select @sysTableID = sysTableID from sysTable where TableName = 'DT33'
set @NhomDK = 'HTL7'
set @blFieldName = N'MTIDDT'
set @FieldName = N'DT33ID'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- HTL8
set @NhomDK = 'HTL8'
set @blFieldName = N'MTIDDT'
set @FieldName = N'DT33ID'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- Ẩn field nguyên tệ khi mở rộng
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TotalCKNT' and AllowNull = 1
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'ToTalTienTTDBNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'ToTalTienTTDBNT' and AllowNull = 1
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TotalCKNT' and AllowNull = 1
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TotalGNKNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'MT25'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TotalCKNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TCKNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'DT21'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TienCKNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'DT23'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TienCKNT' and AllowNull = 1
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TienNKNT' and AllowNull = 1
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'CPCtNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'DT25'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TienCKNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'DT31'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'GiaNT' and AllowNull = 1
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TienCKNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'DT33'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TienCKNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'DT22'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TienCKNT' and AllowNull = 1
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TienNKNT' and AllowNull = 1

select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TotalCKNT' and AllowNull = 1
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'TotalGNKNT' and AllowNull = 1
Update sysField set AllowNull = 0 where sysTableID = @sysTableID and FieldName = N'ToTalTienTTDBNT' and AllowNull = 1