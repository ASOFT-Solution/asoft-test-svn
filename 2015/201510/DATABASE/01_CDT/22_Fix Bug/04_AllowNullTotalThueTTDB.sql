USE [CDT]
declare @sysTableID as int

-- MT23
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'

Update sysField set AllowNull = 1
where sysTableID = @sysTableID and fieldName = 'ToTalTienTTDB'
and AllowNull = 0

Update sysField set AllowNull = 1
where sysTableID = @sysTableID and fieldName = 'ToTalTienTTDBNT'
and AllowNull = 0

-- MT22
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'

Update sysField set AllowNull = 1
where sysTableID = @sysTableID and fieldName = 'ToTalTienTTDB'
and AllowNull = 0

Update sysField set AllowNull = 1
where sysTableID = @sysTableID and fieldName = 'ToTalTienTTDBNT'
and AllowNull = 0

-- MT21
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'

Update sysField set AllowNull = 1
where sysTableID = @sysTableID and fieldName = 'ToTalTienTTDB'
and AllowNull = 0

Update sysField set AllowNull = 1
where sysTableID = @sysTableID and fieldName = 'ToTalTienTTDBNT'
and AllowNull = 0