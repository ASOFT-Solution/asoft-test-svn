Use CDT
declare @sysMenuParent int
select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Thuế khác'
declare @sysTableID int
select @sysTableID = sysTableID from sysTable where TableName = 'DTTDBOut'
UPDATE sysMenu Set sysTableID = @sysTableID, MenuPluginID = NULL, PluginName = NULL where MenuName = N'Tạo bảng kê TTĐB đầu ra' and sysMenuParent = @sysMenuParent

