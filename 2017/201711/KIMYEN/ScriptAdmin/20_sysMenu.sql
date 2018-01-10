declare @MenuText nvarchar(MAX) declare @sysScreenID nvarchar(MAX) declare @MenuOder nvarchar(MAX) declare @sysMenuParent nvarchar(MAX) declare @CustomerIndex nvarchar(MAX) declare @MenuName nvarchar(MAX) declare @ModuleID nvarchar(MAX) declare @MenuID nvarchar(MAX) declare @MenuLevel nvarchar(MAX) declare @ImageUrl nvarchar(MAX) 
--set @sysMenuParent=0
--set @MenuText=N'A00.ASOFT-HRM'
--set @sysScreenID=null 
--set @MenuOder=N'1'
--set @CustomerIndex=N'-1'
--set @MenuName=N'ItemOO'
--set @ModuleID=N'AsoftHRM'
--set @MenuID=N'A00.ASOFT-OO'
--set @MenuLevel=N'0'
--set @ImageUrl=null 
--If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'A00.ASOFT-OO')Begin 
--insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel,ImageUrl)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel,@ImageUrl)
--End

set @sysMenuParent=null
set @MenuText=N'ASOFT_OO'
set @sysScreenID=null
set @MenuOder=N'2'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT_OO'
set @ModuleID=N'ASOFT_OO'
set @MenuID=N'ASOFTOO'
set @MenuLevel=N'0'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT_OO')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End

set @sysMenuParent=29
set @MenuText=N'DanhMuc'
set @sysScreenID=null 
set @MenuOder=N'1'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT_OO_DanhMuc'
set @ModuleID=N'ASOFTOO'
set @MenuID=N'ASOFT_OO_DanhMuc'
set @MenuLevel=N'1'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT_OO_DanhMuc')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End

set @sysMenuParent=29
set @MenuText=N'QuanLy'
set @sysScreenID=null 
set @MenuOder=N'2'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT_OO_QuanLy'
set @ModuleID=N'ASOFTOO'
set @MenuID=N'ASOFT_OO_QuanLy'
set @MenuLevel=N'1'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT_OO_QuanLy')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End

set @sysMenuParent=29
set @MenuText=N'BaoCao'
set @sysScreenID=null 
set @MenuOder=N'3'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT_OO_BaoCao'
set @ModuleID=N'ASOFTOO'
set @MenuID=N'ASOFT_OO_BaoCao'
set @MenuLevel=N'1'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT_OO_BaoCao')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End

set @sysMenuParent=29
set @MenuText=N'ThietLap'
set @sysScreenID=null 
set @MenuOder=N'4'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT_OO_ThietLap'
set @ModuleID=N'ASOFTOO'
set @MenuID=N'ASOFT_OO_ThietLap'
set @MenuLevel=N'1'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT_OO_ThietLap')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End

set @sysMenuParent=31
set @MenuText=N'DanhMucThongBao'
set @sysScreenID=N'OOF1050'
set @MenuOder=N'1'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT_OO_QuanLy_DanhMucThongBao'
set @ModuleID=N'ASOFTOO'
set @MenuID=N'ASOFT_OO_QuanLy_DanhMucThongBao'
set @MenuLevel=N'2'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT_OO_QuanLy_DanhMucThongBao')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End

set @sysMenuParent=30
set @MenuText=N'DanhMucQuyTrinh'
set @sysScreenID=N'OOF1020'
set @MenuOder=N'1'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT_OO_DanhMuc_DanhMucQuyTrinh'
set @ModuleID=N'ASOFTOO'
set @MenuID=N'ASOFT_OO_DanhMuc_DanhMucQuyTrinh'
set @MenuLevel=N'2'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT_OO_DanhMuc_DanhMucQuyTrinh')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End

set @sysMenuParent=30
set @MenuText=N'DanhMucBuoc'
set @sysScreenID=N'OOF1030'
set @MenuOder=N'2'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT_OO_DanhMuc_DanhMucBuoc'
set @ModuleID=N'ASOFTOO'
set @MenuID=N'ASOFT_OO_DanhMuc_DanhMucBuoc'
set @MenuLevel=N'2'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT_OO_DanhMuc_DanhMucBuoc')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End

set @sysMenuParent=30
set @MenuText=N'DanhMucTrangThai'
set @sysScreenID=N'OOF1040'
set @MenuOder=N'3'
set @CustomerIndex=N'-1'
set @MenuName=N'ASOFT_OO_DanhMuc_DanhMucTrangThai'
set @ModuleID=N'ASOFTOO'
set @MenuID=N'ASOFT_OO_DanhMuc_DanhMucTrangThai'
set @MenuLevel=N'2'
--set @ImageUrl=null 
If not exists(select top 1 1 from [dbo].[sysMenu] where  [MenuID] = N'ASOFT_OO_DanhMuc_DanhMucTrangThai')Begin 
insert into sysMenu(MenuText,sysScreenID,MenuOder,sysMenuParent,CustomerIndex,MenuName,ModuleID,MenuID,MenuLevel)values(@MenuText,@sysScreenID,@MenuOder,@sysMenuParent,@CustomerIndex,@MenuName,@ModuleID,@MenuID,@MenuLevel)
End