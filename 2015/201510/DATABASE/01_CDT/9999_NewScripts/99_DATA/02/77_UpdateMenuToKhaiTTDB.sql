Use CDT
declare @sysMenuParent int
select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Thuế khác'
UPDATE sysMenu Set MenuPluginID = 5812, PluginName = 'ToKhaiTTDB.ToKhaiTTDB' where MenuName = N'Tạo tờ khai thuế TTĐB' and sysMenuParent = @sysMenuParent