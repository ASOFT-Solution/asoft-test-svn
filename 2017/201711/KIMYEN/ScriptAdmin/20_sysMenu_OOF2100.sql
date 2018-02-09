declare @MenuText nvarchar(MAX) declare @sysScreenID nvarchar(MAX) declare @MenuOder nvarchar(MAX) declare @sysMenuParent nvarchar(MAX) declare @CustomerIndex nvarchar(MAX) declare @MenuName nvarchar(MAX) declare @ModuleID nvarchar(MAX) declare @MenuID nvarchar(MAX) declare @MenuLevel nvarchar(MAX) declare @ImageUrl nvarchar(MAX) 

set @sysMenuParent=(select top 1 sysMenuID from [dbo].[sysMenu] where [MenuID] = N'ASOFT_OO_QuanLy')
set @MenuText=N'QuanLyCongViec'
set @sysScreenID=N'OOF2100'
set @MenuOder=N'2'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT-OO_QuanLy_QuanLyCongViec'
set @ModuleID=N'ASOFTOO'
set @MenuID=N'ASOFT-OO_QuanLy_QuanLyCongViec'
set @MenuLevel=N'2'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT-OO_QuanLy_QuanLyCongViec')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End

