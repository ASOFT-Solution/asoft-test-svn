Use CDT


declare @sysTableID as int
declare @sysFieldID as int
declare @sysTableMTID as int
declare @sysTableDTID as int
declare @sysDataConfigID as int
declare @sysTableBLVTID as int

-- Cấu hình dòng dữ liệu
SELECT @sysTableBLVTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'BLVT'
SELECT @sysTableMTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MT46'
SELECT @sysTableDTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'DT46'

-- Cấu hình chi tiết dòng dữ liệu
declare @blConfigID INT,
@blFieldID INT,
@mtFieldID INT,
@dtFieldID INT


------PTR3

SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR3'

select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLVTID and mtTableID = @sysTableID and NhomDK = 'PTR5'

---Delete
----detelte SoLuong_xQD
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID 
and FieldName = 'SoLuong_xQD'

delete sysDataConfigDt where blFieldId = @sysFieldId and blConfigID = @blConfigID

----delete MTIDDoiTru
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID 
and FieldName = 'MTIDDoiTru'

delete sysDataConfigDt where blFieldId = @sysFieldId and blConfigID = @blConfigID

--Insert other fiel
SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLVTID AND [FieldName] = N'SoLuongQD'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Soluong2QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

------PTR4
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR4'

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLVTID AND [FieldName] = N'MTIDDoiTru'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MTIDDoiTru'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLVTID AND [FieldName] = N'SoLuong_xQD'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Soluong1QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)



