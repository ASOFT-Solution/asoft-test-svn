USE [CDT]

-- Bỏ column MaNhomTTDB do không còn dùng nữa, nếu giữ column này sẽ bị lỗi không load được giá trị trong tab thuế TTDB

declare @sysTableID as int,
		@sysFieldID as int

-- MT21
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
delete from sysField where FieldName = 'MaNhomTTDB' and sysTableID = @sysTableID and Visible = 0

-- MT22	
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
delete from sysField where FieldName = 'MaNhomTTDB' and sysTableID = @sysTableID and Visible = 0
	
-- MT23
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
delete from sysField where FieldName = 'MaNhomTTDB' and sysTableID = @sysTableID and Visible = 0