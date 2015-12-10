USE CDT
Declare @sysTableID int

-- MT42
select @sysTableID = sysTableID from sysTable where TableName = N'MT42'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKH'

-- MT41
select @sysTableID = sysTableID from sysTable where TableName = N'MT41'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKH'

-- MT43
select @sysTableID = sysTableID from sysTable where TableName = N'MT43'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKH'

-- MT44
select @sysTableID = sysTableID from sysTable where TableName = N'MT44'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKH'

-- MT45
select @sysTableID = sysTableID from sysTable where TableName = N'MT45'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKH'

-- DT22
select @sysTableID = sysTableID from sysTable where TableName = N'DT22'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKho'

-- DT23
select @sysTableID = sysTableID from sysTable where TableName = N'DT23'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKho'

-- DT24
select @sysTableID = sysTableID from sysTable where TableName = N'DT24'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKho'

-- DT32
select @sysTableID = sysTableID from sysTable where TableName = N'DT32'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKho'

-- DT41
select @sysTableID = sysTableID from sysTable where TableName = N'DT41'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKho'

-- DT42
select @sysTableID = sysTableID from sysTable where TableName = N'DT42'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKho'

-- DT43
select @sysTableID = sysTableID from sysTable where TableName = N'DT43'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKho'

-- DT45
select @sysTableID = sysTableID from sysTable where TableName = N'DT45'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKho'

-- DT45
select @sysTableID = sysTableID from sysTable where TableName = N'DT45'

Update sysField set EditMask = NULL
where sysTableID = @sysTableID and EditMask = N'&' and FieldName = 'MaKho'