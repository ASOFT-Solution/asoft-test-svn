declare @GroupName nvarchar(MAX) declare @Description nvarchar(MAX) declare @ModuleID nvarchar(MAX) declare @ScreenID nvarchar(MAX) declare @TabIndex nvarchar(MAX) declare @GroupID nvarchar(MAX) declare @sysTable nvarchar(MAX) declare @PartialView nvarchar(MAX) 

--set @GroupName=N'POSF2032.ThongTinPhieuDeNghiXuatHoaDon'
--set @Description=N'Thông tin phiếu đề nghị xuất hóa đơn'
--set @ModuleID=N'AsoftPOS'
--set @ScreenID=N'POSF2032'
--set @TabIndex=N'1'
--set @GroupID=N'POSF2032.ThongTinPhieuDeNghiXuatHoaDon'
--set @sysTable=null
--set @PartialView=null 
--If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'POSF2032.ThongTinPhieuDeNghiXuatHoaDon')Begin 
--insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
--End
---- Group màn hình OOF1052
set @GroupName=N'OOF1052.XemChiTietThongBao'
set @Description=N'Xem chi tiết thông báo'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1052'
set @TabIndex=N'1'
set @GroupID=N'OOF1052.XemChiTietThongBao'
set @sysTable=null
set @PartialView=null 
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1052.XemChiTietThongBao')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End
----- Group đính kèm OOF1052.DinhKem
set @GroupName=N'OOF1052.DinhKem'
set @Description=N'Đính kèm'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1052'
set @TabIndex=N'2'
set @GroupID=N'OOF1052.DinhKem'
set @sysTable=N'CRMT00002'
set @PartialView=null 
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1052.DinhKem')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1052.GhiChu'
set @Description=N'Ghi chú'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1052'
set @TabIndex=N'3'
set @GroupID=N'OOF1052.GhiChu'
set @sysTable=N'CRMT90031'
set @PartialView=N'Notes'
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1052.DinhKem')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1052.LichSu'
set @Description=N'Lịch sử'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1052'
set @TabIndex=N'4'
set @GroupID=N'OOF1052.LichSu'
set @sysTable=N'CRMT00003'
set @PartialView=null 
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1052.LichSu')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End
--- Group màn hình OOF1022

set @GroupName=N'OOF1022.XemChiTietQuyTrinh'
set @Description=N'Xem chi tiết quy trình'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1022'
set @TabIndex=N'1'
set @GroupID=N'OOF1022.XemChiTietQuyTrinh'
set @sysTable=null
set @PartialView=null 
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1022.XemChiTietQuyTrinh')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1022.DinhKem'
set @Description=N'Đính kèm'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1022'
set @TabIndex=N'2'
set @GroupID=N'OOF1022.DinhKem'
set @sysTable=N'CRMT00002'
set @PartialView=null 
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1052.DinhKem')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1022.GhiChu'
set @Description=N'Ghi Chú'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1022'
set @TabIndex=N'3'
set @GroupID=N'OOF1022.GhiChu'
set @sysTable=N'CRMT90031'
set @PartialView=null 
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1022.GhiChu')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1022.LichSu'
set @Description=N'Lịch sử'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1022'
set @TabIndex=N'4'
set @GroupID=N'OOF1022.LichSu'
set @sysTable=N'CRMT00003'
set @PartialView=null 
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1022.GhiChu')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

---- Màn hình OOF1032
set @GroupName=N'OOF1032.XemChiTietBuoc'
set @Description=N'Xem chi tiết bước'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1032'
set @TabIndex=N'1'
set @GroupID=N'OOF1032.XemChiTietBuoc'
set @sysTable=null
set @PartialView=null 
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1032.XemChiTietBuoc')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1032.DinhKem'
set @Description=N'Đính Kèm'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1032'
set @TabIndex=N'3'
set @GroupID=N'OOF1032.DinhKem'
set @sysTable=N'CRMT00002'
set @PartialView=null 
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1032.DinhKem')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1032.GhiChu'
set @Description=N'Ghi chú'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1032'
set @TabIndex=N'4'
set @GroupID=N'OOF1032.GhiChu'
set @sysTable=N'CRMT90031'
set @PartialView=N'Notes'
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1032.GhiChu')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1032.LichSu'
set @Description=N'Lịch sử'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1032'
set @TabIndex=N'5'
set @GroupID=N'OOF1032.LichSu'
set @sysTable=N'CRMT00003'
set @PartialView=null
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1032.LichSu')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

---- Màn hình OOF1042
set @GroupName=N'OOF1042.XemChiTietTrangThai'
set @Description=N'Xem chi tiết trạng thái'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1042'
set @TabIndex=N'1'
set @GroupID=N'OOF1042.XemChiTietTrangThai'
set @sysTable=null
set @PartialView=null
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1042.XemChiTietTrangThai')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1042.GhiChu'
set @Description=N'Ghi chú'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1042'
set @TabIndex=N'2'
set @GroupID=N'OOF1042.GhiChu'
set @sysTable=N'CRMT90031'
set @PartialView=N'Notes'
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1042.GhiChu')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End

set @GroupName=N'OOF1042.LichSu'
set @Description=N'Lịch sử'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1042'
set @TabIndex=N'3'
set @GroupID=N'OOF1042.LichSu'
set @sysTable=N'CRMT00003'
set @PartialView=null
If not exists(select top 1 1 from [dbo].[sysGroup] where  [GroupID] = N'OOF1042.LichSu')Begin 
insert into sysGroup(GroupName,Description,ModuleID,ScreenID,TabIndex,GroupID,sysTable,PartialView)values(@GroupName,@Description,@ModuleID,@ScreenID,@TabIndex,@GroupID,@sysTable,@PartialView)
End