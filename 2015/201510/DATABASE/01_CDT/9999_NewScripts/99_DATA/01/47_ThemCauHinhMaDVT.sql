Use CDT
declare @sysTableBLID int,
		@sysTableID int,
		@NhomDK varchar(50),
		@blConfigID int,
		@blFieldID int,
		@FieldID int,
		@FieldName nvarchar(50),
		@blFieldName nvarchar(50)

select @sysTableBLID = sysTableID from sysTable where TableName = 'BLVT'

-- PNM1
select @sysTableID = sysTableID from sysTable where TableName = 'DT22'
set @NhomDK = 'PNM1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- PXT1
select @sysTableID = sysTableID from sysTable where TableName = 'DT24'
set @NhomDK = 'PXT1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- HDB1
select @sysTableID = sysTableID from sysTable where TableName = 'DT32'
set @NhomDK = 'HDB1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- HTL1
select @sysTableID = sysTableID from sysTable where TableName = 'DT33'
set @NhomDK = 'HTL1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- PNH1
select @sysTableID = sysTableID from sysTable where TableName = 'DT42'
set @NhomDK = 'PNH1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- PXK1
select @sysTableID = sysTableID from sysTable where TableName = 'DT43'
set @NhomDK = 'PXK1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- PDC1
select @sysTableID = sysTableID from sysTable where TableName = 'DT44'
set @NhomDK = 'PDC1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- PDC2
select @sysTableID = sysTableID from sysTable where TableName = 'DT44'
set @NhomDK = 'PDC2'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- PXC
select @sysTableID = sysTableID from sysTable where TableName = 'DT45'
set @NhomDK = 'PXC'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- PNK1
select @sysTableID = sysTableID from sysTable where TableName = 'DT23'
set @NhomDK = 'PNK1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- NSX1
select @sysTableID = sysTableID from sysTable where TableName = 'DT41'
set @NhomDK = 'NSX1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- PTR4
select @sysTableID = sysTableID from sysTable where TableName = 'MT46'
set @NhomDK = 'PTR4'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT1'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTR1
select @sysTableID = sysTableID from sysTable where TableName = 'MT46'
set @NhomDK = 'PTR1'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT1'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTR2
select @sysTableID = sysTableID from sysTable where TableName = 'DT46'
set @NhomDK = 'PTR2'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT2'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- PTR3
select @sysTableID = sysTableID from sysTable where TableName = 'DT46'
set @NhomDK = 'PTR3'
set @blFieldName = N'MaDVT'
set @FieldName = N'MaDVT2'
select @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)