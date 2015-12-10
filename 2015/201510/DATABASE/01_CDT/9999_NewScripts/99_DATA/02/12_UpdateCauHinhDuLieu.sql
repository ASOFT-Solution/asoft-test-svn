USE [CDT]

declare @sysTableBLID int,
		@sysTableID int,
		@sysMtTableID int,
		@sysDtTableID int,
		@NhomDK varchar(50),
		@blConfigID int,
		@blFieldID int,
		@FieldID int,
		@FieldName nvarchar(50),
		@blFieldName nvarchar(50)
		
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'

-- 1) MT11
-- PT11
select @sysTableID = sysTableID from sysTable where TableName = 'MT11'
set @NhomDK = 'PT11'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PT12
select @sysTableID = sysTableID from sysTable where TableName = 'MT11'
set @NhomDK = 'PT12'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--2) MT12
-- PC13
select @sysTableID = sysTableID from sysTable where TableName = 'MT12'
set @NhomDK = 'PC13'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC14
select @sysTableID = sysTableID from sysTable where TableName = 'MT12'
set @NhomDK = 'PC14'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC11
select @sysTableID = sysTableID from sysTable where TableName = 'MT12'
set @NhomDK = 'PC11'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC12
select @sysTableID = sysTableID from sysTable where TableName = 'MT12'
set @NhomDK = 'PC12'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--3) MT13
-- PT23
select @sysTableID = sysTableID from sysTable where TableName = 'MT13'
set @NhomDK = 'PT23'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PT24
select @sysTableID = sysTableID from sysTable where TableName = 'MT13'
set @NhomDK = 'PT24'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PT25
select @sysTableID = sysTableID from sysTable where TableName = 'MT13'
set @NhomDK = 'PT25'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PT21
select @sysTableID = sysTableID from sysTable where TableName = 'MT13'
set @NhomDK = 'PT21'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PT26
select @sysTableID = sysTableID from sysTable where TableName = 'MT13'
set @NhomDK = 'PT26'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PT27
select @sysTableID = sysTableID from sysTable where TableName = 'MT13'
set @NhomDK = 'PT27'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PT28
select @sysTableID = sysTableID from sysTable where TableName = 'MT13'
set @NhomDK = 'PT28'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PT22
select @sysTableID = sysTableID from sysTable where TableName = 'MT13'
set @NhomDK = 'PT22'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--4) MT14
-- PC23
select @sysTableID = sysTableID from sysTable where TableName = 'MT14'
set @NhomDK = 'PC23'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC24
select @sysTableID = sysTableID from sysTable where TableName = 'MT14'
set @NhomDK = 'PC24'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC25
select @sysTableID = sysTableID from sysTable where TableName = 'MT14'
set @NhomDK = 'PC25'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC27
select @sysTableID = sysTableID from sysTable where TableName = 'MT14'
set @NhomDK = 'PC27'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC28
select @sysTableID = sysTableID from sysTable where TableName = 'MT14'
set @NhomDK = 'PC28'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC21
select @sysTableID = sysTableID from sysTable where TableName = 'MT14'
set @NhomDK = 'PC21'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC22
select @sysTableID = sysTableID from sysTable where TableName = 'MT14'
set @NhomDK = 'PC22'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PC26
select @sysTableID = sysTableID from sysTable where TableName = 'MT14'
set @NhomDK = 'PC26'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--5) MT15
-- PBC1
select @sysTableID = sysTableID from sysTable where TableName = 'MT15'
set @NhomDK = 'PBC1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PBC2
select @sysTableID = sysTableID from sysTable where TableName = 'MT15'
set @NhomDK = 'PBC2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--6) MT16
-- PBN3
select @sysTableID = sysTableID from sysTable where TableName = 'MT16'
set @NhomDK = 'PBN3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PBN4
select @sysTableID = sysTableID from sysTable where TableName = 'MT16'
set @NhomDK = 'PBN4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PBN1
select @sysTableID = sysTableID from sysTable where TableName = 'MT16'
set @NhomDK = 'PBN1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PBN2
select @sysTableID = sysTableID from sysTable where TableName = 'MT16'
set @NhomDK = 'PBN2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--7) MT17
-- BC23
select @sysTableID = sysTableID from sysTable where TableName = 'MT17'
set @NhomDK = 'BC23'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BC24
select @sysTableID = sysTableID from sysTable where TableName = 'MT17'
set @NhomDK = 'BC24'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BC26
select @sysTableID = sysTableID from sysTable where TableName = 'MT17'
set @NhomDK = 'BC26'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BC27
select @sysTableID = sysTableID from sysTable where TableName = 'MT17'
set @NhomDK = 'BC27'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BC25
select @sysTableID = sysTableID from sysTable where TableName = 'MT17'
set @NhomDK = 'BC25'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BC28
select @sysTableID = sysTableID from sysTable where TableName = 'MT17'
set @NhomDK = 'BC28'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BC22
select @sysTableID = sysTableID from sysTable where TableName = 'MT17'
set @NhomDK = 'BC22'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BC21
select @sysTableID = sysTableID from sysTable where TableName = 'MT17'
set @NhomDK = 'BC21'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--8) MT18
-- BN23
select @sysTableID = sysTableID from sysTable where TableName = 'MT18'
set @NhomDK = 'BN23'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BN24
select @sysTableID = sysTableID from sysTable where TableName = 'MT18'
set @NhomDK = 'BN24'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BN25
select @sysTableID = sysTableID from sysTable where TableName = 'MT18'
set @NhomDK = 'BN25'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BN27
select @sysTableID = sysTableID from sysTable where TableName = 'MT18'
set @NhomDK = 'BN27'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BN21
select @sysTableID = sysTableID from sysTable where TableName = 'MT18'
set @NhomDK = 'BN21'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BN22
select @sysTableID = sysTableID from sysTable where TableName = 'MT18'
set @NhomDK = 'BN22'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BN26
select @sysTableID = sysTableID from sysTable where TableName = 'MT18'
set @NhomDK = 'BN26'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- BN28
select @sysTableID = sysTableID from sysTable where TableName = 'MT18'
set @NhomDK = 'BN28'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--9) MT21
-- MDV4
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @NhomDK = 'MDV4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- MDV3
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @NhomDK = 'MDV3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- MDV1
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @NhomDK = 'MDV1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- MDV2
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @NhomDK = 'MDV2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- MDV5
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @NhomDK = 'MDV5'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- MDV6
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @NhomDK = 'MDV6'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--10) MT22
-- PNM3
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @NhomDK = 'PNM3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNM4
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @NhomDK = 'PNM4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNM2
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @NhomDK = 'PNM2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNM1
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @NhomDK = 'PNM1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNM5
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @NhomDK = 'PNM5'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNM6
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @NhomDK = 'PNM6'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNM7
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @NhomDK = 'PNM7'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNM8
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @NhomDK = 'PNM8'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--11) MT23
-- PNK3
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @NhomDK = 'PNK3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNK4
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @NhomDK = 'PNK4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNK1
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @NhomDK = 'PNK1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNK2
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @NhomDK = 'PNK2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNK5
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @NhomDK = 'PNK5'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNK6
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @NhomDK = 'PNK6'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNK7
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @NhomDK = 'PNK7'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNK8
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @NhomDK = 'PNK8'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--12) MT24
-- PXT3
select @sysTableID = sysTableID from sysTable where TableName = 'MT24'
set @NhomDK = 'PXT3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PXT4
select @sysTableID = sysTableID from sysTable where TableName = 'MT24'
set @NhomDK = 'PXT4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PXT1
select @sysTableID = sysTableID from sysTable where TableName = 'MT24'
set @NhomDK = 'PXT1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PXT2
select @sysTableID = sysTableID from sysTable where TableName = 'MT24'
set @NhomDK = 'PXT2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--13) MT25
-- MCP3
select @sysTableID = sysTableID from sysTable where TableName = 'MT25'
set @NhomDK = 'MCP3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- MCP4
select @sysTableID = sysTableID from sysTable where TableName = 'MT25'
set @NhomDK = 'MCP4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- MCP2
select @sysTableID = sysTableID from sysTable where TableName = 'MT25'
set @NhomDK = 'MCP2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- MCP1
select @sysTableID = sysTableID from sysTable where TableName = 'MT25'
set @NhomDK = 'MCP1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--14) MT26
-- PTT1
select @sysTableID = sysTableID from sysTable where TableName = 'MT26'
set @NhomDK = 'PTT1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTT3
select @sysTableID = sysTableID from sysTable where TableName = 'MT26'
set @NhomDK = 'PTT3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTT5
select @sysTableID = sysTableID from sysTable where TableName = 'MT26'
set @NhomDK = 'PTT5'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTT2
select @sysTableID = sysTableID from sysTable where TableName = 'MT26'
set @NhomDK = 'PTT2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTT4
select @sysTableID = sysTableID from sysTable where TableName = 'MT26'
set @NhomDK = 'PTT4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTT6
select @sysTableID = sysTableID from sysTable where TableName = 'MT26'
set @NhomDK = 'PTT6'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTT7
select @sysTableID = sysTableID from sysTable where TableName = 'MT26'
set @NhomDK = 'PTT7'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTT8
select @sysTableID = sysTableID from sysTable where TableName = 'MT26'
set @NhomDK = 'PTT8'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--15) MT31
-- HDV3
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @NhomDK = 'HDV3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDV4
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @NhomDK = 'HDV4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDV5
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @NhomDK = 'HDV5'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDV6
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @NhomDK = 'HDV6'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDV1
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @NhomDK = 'HDV1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDV2
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @NhomDK = 'HDV2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--16) MT32
-- HDB5
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @NhomDK = 'HDB5'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDB6
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @NhomDK = 'HDB6'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDB7
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @NhomDK = 'HDB7'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDB2
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @NhomDK = 'HDB2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDB3
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @NhomDK = 'HDB3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDB4
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @NhomDK = 'HDB4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDB1
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @NhomDK = 'HDB1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HDB8
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @NhomDK = 'HDB8'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--17) MT33
-- HTL5
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @NhomDK = 'HTL5'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HTL6
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @NhomDK = 'HTL6'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HTL8
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @NhomDK = 'HTL8'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HTL1
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @NhomDK = 'HTL1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HTL2
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @NhomDK = 'HTL2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HTL3
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @NhomDK = 'HTL3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HTL4
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @NhomDK = 'HTL4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- HTL7
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @NhomDK = 'HTL7'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--18) MT34
-- PTH1
select @sysTableID = sysTableID from sysTable where TableName = 'MT34'
set @NhomDK = 'PTH1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTH2
select @sysTableID = sysTableID from sysTable where TableName = 'MT34'
set @NhomDK = 'PTH2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTH3
select @sysTableID = sysTableID from sysTable where TableName = 'MT34'
set @NhomDK = 'PTH3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTH4
select @sysTableID = sysTableID from sysTable where TableName = 'MT34'
set @NhomDK = 'PTH4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTH5
select @sysTableID = sysTableID from sysTable where TableName = 'MT34'
set @NhomDK = 'PTH5'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTH6
select @sysTableID = sysTableID from sysTable where TableName = 'MT34'
set @NhomDK = 'PTH6'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTH7
select @sysTableID = sysTableID from sysTable where TableName = 'MT34'
set @NhomDK = 'PTH7'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PTH8
select @sysTableID = sysTableID from sysTable where TableName = 'MT34'
set @NhomDK = 'PTH8'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--19) DT35
-- DCN1
select @sysTableID = sysTableID from sysTable where TableName = 'DT35'
set @NhomDK = 'DCN1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- DCN2
select @sysTableID = sysTableID from sysTable where TableName = 'DT35'
set @NhomDK = 'DCN2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- DCN3
select @sysTableID = sysTableID from sysTable where TableName = 'DT35'
set @NhomDK = 'DCN3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

-- DCN4
select @sysTableID = sysTableID from sysTable where TableName = 'DT35'
set @NhomDK = 'DCN4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @FieldID, NULL)

--20) MT36
-- KTT1
select @sysTableID = sysTableID from sysTable where TableName = 'MT36'
set @NhomDK = 'KTT1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- KTT2
select @sysTableID = sysTableID from sysTable where TableName = 'MT36'
set @NhomDK = 'KTT2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--21) MT41
-- NSX1
select @sysTableID = sysTableID from sysTable where TableName = 'MT41'
set @NhomDK = 'NSX1'
set @blFieldName = N'Saleman'
set @FieldName = N'MaKH'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- NSX2
select @sysTableID = sysTableID from sysTable where TableName = 'MT41'
set @NhomDK = 'NSX2'
set @blFieldName = N'Saleman'
set @FieldName = N'MaKH'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--22) MT42
-- PNH2
select @sysTableID = sysTableID from sysTable where TableName = 'MT42'
set @NhomDK = 'PNH2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNH1
select @sysTableID = sysTableID from sysTable where TableName = 'MT42'
set @NhomDK = 'PNH1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--23) MT43
-- PXK1
select @sysTableID = sysTableID from sysTable where TableName = 'MT43'
set @NhomDK = 'PXK1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PXK2
select @sysTableID = sysTableID from sysTable where TableName = 'MT43'
set @NhomDK = 'PXK2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--24) MT44
-- PDC3
select @sysTableID = sysTableID from sysTable where TableName = 'MT44'
set @NhomDK = 'PDC3'
set @blFieldName = N'Saleman'
set @FieldName = N'MaKH'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PDC4
select @sysTableID = sysTableID from sysTable where TableName = 'MT44'
set @NhomDK = 'PDC4'
set @blFieldName = N'Saleman'
set @FieldName = N'MaKH'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--25) MT45
-- PXC1
select @sysTableID = sysTableID from sysTable where TableName = 'MT45'
set @NhomDK = 'PXC1'
set @blFieldName = N'Saleman'
set @FieldName = N'MaKH'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PXC2
select @sysTableID = sysTableID from sysTable where TableName = 'MT45'
set @NhomDK = 'PXC2'
set @blFieldName = N'Saleman'
set @FieldName = N'MaKH'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--26) MT51
-- PKT5
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @NhomDK = 'PKT5'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PKT6
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @NhomDK = 'PKT6'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PKT7
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @NhomDK = 'PKT7'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PKT8
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @NhomDK = 'PKT8'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PKT1
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @NhomDK = 'PKT1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PKT2
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @NhomDK = 'PKT2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PKT3
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @NhomDK = 'PKT3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PKT4
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @NhomDK = 'PKT4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

--27) MT52
-- PNB1
select @sysTableID = sysTableID from sysTable where TableName = 'MT52'
set @NhomDK = 'PNB1'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNB2
select @sysTableID = sysTableID from sysTable where TableName = 'MT52'
set @NhomDK = 'PNB2'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNB3
select @sysTableID = sysTableID from sysTable where TableName = 'MT52'
set @NhomDK = 'PNB3'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

-- PNB4
select @sysTableID = sysTableID from sysTable where TableName = 'MT52'
set @NhomDK = 'PNB4'
set @blFieldName = N'Saleman'
set @FieldName = N'Saleman'
SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName
SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = @FieldName
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @FieldID, NULL, NULL)

---- Update các cấu hình sai
---- 1) MT11
---- PT11
--select @sysMtTableID = sysTableID from sysTable where TableName = 'MT11'
--select @sysDtTableID = sysTableID from sysTable where TableName = 'DT11'
--set @NhomDK = 'PT11'

---- MaKHCt
--set @blFieldName = N'MaKH'
--set @FieldName = N'MaKHCt'
--SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysDtTableID AND [FieldName] = @FieldName
--SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysMtTableID and NhomDK = @NhomDK
--SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName

--Update sysDataConfigDt set mtFieldID = null, dtFieldID = @FieldID
--where blConfigID = @blConfigID and blFieldID = @blFieldID

---- TenKHCt
--set @blFieldName = N'TenKH'
--set @FieldName = N'TenKHCt'
--SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysDtTableID AND [FieldName] = @FieldName
--SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName

--Update sysDataConfigDt set mtFieldID = null, dtFieldID = @FieldID
--where blConfigID = @blConfigID and blFieldID = @blFieldID

---- 2) MT12
---- PC11
--select @sysMtTableID = sysTableID from sysTable where TableName = 'MT12'
--select @sysDtTableID = sysTableID from sysTable where TableName = 'DT12'
--set @NhomDK = 'PC11'

---- MaKH
--set @blFieldName = N'MaKH'
--set @FieldName = N'MaKH'
--SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysMtTableID AND [FieldName] = @FieldName
--SELECT @blConfigID = blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysMtTableID and NhomDK = @NhomDK
--SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName

--Update sysDataConfigDt set dtFieldID = null, mtFieldID = @FieldID
--where blConfigID = @blConfigID and blFieldID = @blFieldID

---- TenKH
--set @blFieldName = N'TenKH'
--set @FieldName = N'TenKH'
--SELECT @FieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysMtTableID AND [FieldName] = @FieldName
--SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = @blFieldName

--Update sysDataConfigDt set dtFieldID = null, mtFieldID = @FieldID
--where blConfigID = @blConfigID and blFieldID = @blFieldID