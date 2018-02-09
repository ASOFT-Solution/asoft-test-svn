declare @DivisionID nvarchar(MAX) declare @ModuleID nvarchar(MAX) declare @ScreenID nvarchar(MAX) declare @ScreenName nvarchar(MAX) declare @ScreenType nvarchar(MAX) declare @ScreenNameE nvarchar(MAX) declare @Parent nvarchar(MAX) declare @sysTable nvarchar(MAX) declare @Title nvarchar(MAX) declare @DisplayToolBar nvarchar(MAX) declare @TypeInput nvarchar(MAX) declare @DisplayToolBar2 nvarchar(MAX) declare @ReportID nvarchar(MAX) declare @DeleteStoreName nvarchar(MAX) declare @sysCategoryBusinessID nvarchar(MAX) declare @SqlFilter nvarchar(MAX) declare @StoreFilter nvarchar(MAX) declare @StoreFilterParameter nvarchar(MAX) declare @Width nvarchar(MAX) declare @sysActionID nvarchar(Max) declare @SQLPrint nvarchar(Max) declare @StorePrint nvarchar(Max) declare @StorePrintParameter nvarchar(Max) declare @TableDetailSelect nvarchar(Max)  declare @SqlFilterDetail nvarchar(Max)  declare @StoreFilterDetail nvarchar(Max) declare @StoreFilterParameterDetail nvarchar(Max) 

--set @DivisionID=N'AS'
--set @ModuleID=N'AsoftPOS'
--set @ScreenID=N'POSF2030'
--set @ScreenName=N'Danh mục phiếu đề nghị xuất hóa đơn'
--set @ScreenType=N'2'
--set @ScreenNameE=N'Danh mục phiếu đề nghị xuất hóa đơn'
--set @Parent=null 
--set @sysTable=N'POST2030'
--set @Title=N'POSF2030.Title'
--set @DisplayToolBar='1,3'  
--set @TypeInput=null
--set @DisplayToolBar2=null 
--set @ReportID=null 
--set @DeleteStoreName='POSP2031' 
--set @sysCategoryBusinessID=N'2'
--set @SqlFilter=null 
--set @StoreFilter=null 
--set @StoreFilterParameter=null 
--set @Width=null
--set @SQLPrint=null 
--set @StorePrint=null
--set @StorePrintParameter=null
--If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftPOS' and ScreenID = N'POSF2030')Begin 
--insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter)
--End
----Màn hình danh mục thông báo OOF1050
set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1050'
set @ScreenName=N'Danh mục thông báo'
set @ScreenType=N'2'
set @ScreenNameE=N'Danh mục thông báo'
set @Parent=null 
set @sysTable=N'OOT1050'
set @Title=N'OOF1050.Title'
set @DisplayToolBar='1,3,8,9'  
set @TypeInput=null
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1050')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter)
End
-------- Màn hình cập nhật thông báo OOF1051
set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1051'
set @ScreenName=N'Cập nhật thông báo'
set @ScreenType=N'3'
set @ScreenNameE=N'Cập nhật thông báo'
set @Parent=N'OOF1050'
set @sysTable=N'OOT1050'
set @Title=N'OOF1050.Title'
set @DisplayToolBar='1,3,8,9'  
set @TypeInput=N'1'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1051')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter)
End

----- Màn hình xem chi tiết thông báo OOF1052

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1052'
set @ScreenName=N'Xem chi tiết thông báo'
set @ScreenType=N'5'
set @ScreenNameE=N'Xem chi tiết thông báo'
set @Parent=N'OOF1050'
set @sysTable=N'OOT1050'
set @Title=N'OOF1052.Title'
set @DisplayToolBar='1,4'  
set @TypeInput=N'5'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID = (select top 1 sysActionID from sysAction where ActionID = 'Attach')
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1052')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter, @sysActionID)
End


---- Màn hình danh mục quy trình OOF1020

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1020'
set @ScreenName=N'Danh mục quy trình'
set @ScreenType=N'2'
set @ScreenNameE=N'Danh mục quy trình'
set @Parent= null
set @sysTable=N'OOT1020'
set @Title=N'OOF1020.Title'
set @DisplayToolBar='1,3,8,9'  
set @TypeInput=N'5'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1020')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

------- Màn hình cập nhật quy trình OOF1021
set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1021'
set @ScreenName=N'Cập nhật quy trình'
set @ScreenType=N'3'
set @ScreenNameE=N'Cập nhật quy trình'
set @Parent= N'OOF1020'
set @sysTable=N'OOT1020'
set @Title=N'OOF1021.Title'
set @DisplayToolBar=null 
set @TypeInput=N'1'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=N'800'
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1021')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

----- Màn hình xem chi tiết quy trình OOF1022

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1022'
set @ScreenName=N'Xem chi tiết quy trình'
set @ScreenType=N'5'
set @ScreenNameE=N'Xem chi tiết quy trình'
set @Parent= N'OOF1020'
set @sysTable=N'OOT1020'
set @Title=N'OOF1022.Title'
set @DisplayToolBar=N'1,4'
set @TypeInput=N'5'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=N'800'
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =(select top 1 sysActionID from sysAction where ActionID = 'Attach')
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1022')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

----- Màn hình danh mục bước OOF1030

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1030'
set @ScreenName=N'Danh mục bước'
set @ScreenType=N'2'
set @ScreenNameE=N'Danh mục bước'
set @Parent=null
set @sysTable=N'OOT1030'
set @Title=N'OOF1030.Title'
set @DisplayToolBar=N'1,3,8,9'
set @TypeInput=null
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1030')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

------ Màn hình cập nhật bước OOF1031
set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1031'
set @ScreenName=N'Cập nhật bước'
set @ScreenType=N'3'
set @ScreenNameE=N'Cập nhật bước'
set @Parent=N'OOF1030'
set @sysTable=N'OOT1030'
set @Title=N'OOF1031.Title'
set @DisplayToolBar=null
set @TypeInput=N'2'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=N'800'
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1031')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

---- Màn hình xem chi tiết bước OOF1032

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1032'
set @ScreenName=N'Xem chi tiết bước'
set @ScreenType=N'5'
set @ScreenNameE=N'Xem chi tiết bước'
set @Parent=N'OOF1032'
set @sysTable=N'OOT1030'
set @Title=N'OOF1032.Title'
set @DisplayToolBar=N'1,4'
set @TypeInput=N'5'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =(select top 1 sysActionID from sysAction where ActionID = 'Attach')
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1032')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End
------ Màn hình danh mục trạng thái OOF1040
set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1040'
set @ScreenName=N'Danh mục trạng thái'
set @ScreenType=N'2'
set @ScreenNameE=N'Danh mục trạng thái'
set @Parent=null
set @sysTable=N'OOT1040'
set @Title=N'OOF1040.Title'
set @DisplayToolBar=N'1,3,8,9'
set @TypeInput=null
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1040')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

----- Màn hình cập nhật trạng thái OOF1041

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1041'
set @ScreenName=N'Cập nhật trạng thái'
set @ScreenType=N'3'
set @ScreenNameE=N'Cập nhật trạng thái'
set @Parent=N'OOF1040'
set @sysTable=N'OOT1040'
set @Title=N'OOF1041.Title'
set @DisplayToolBar=null
set @TypeInput=N'1'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=N'700'
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1041')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

----- Màn hình xem chi tiết trạng thái OOF1040
set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF1042'
set @ScreenName=N'Xem chi tiết trạng thái'
set @ScreenType=N'5'
set @ScreenNameE=N'Xem chi tiết trạng thái'
set @Parent=N'OOF1040'
set @sysTable=N'OOT1040'
set @Title=N'OOF1042.Title'
set @DisplayToolBar=N'1,4'
set @TypeInput=N'5'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=N'700'
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF1042')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

---- Màn hình danh sách mẫu dự án
set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF2090'
set @ScreenName=N'Danh sách mẫu dự án/nhóm công việc'
set @ScreenType=N'2'
set @ScreenNameE=N'Danh sách mẫu dự án/nhóm công việc'
set @Parent=null
set @sysTable=N'OOT2090'
set @Title=N'OOF2090.Title'
set @DisplayToolBar=N'1,3,8,9'
set @TypeInput=null
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=N'OOP2091'
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF2090')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

---- Màn hình xem chi tiết mẫu dự án nhóm công việc

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF2092'
set @ScreenName=N'Xem chi tiết mẫu dự án/nhóm công việc'
set @ScreenType=N'5'
set @ScreenNameE=N'Xem chi tiết mẫu dự án/nhóm công việc'
set @Parent=N'OOF2090'
set @sysTable=N'OOT2090'
set @Title=N'OOF2092.Title'
set @DisplayToolBar=N'1,4'
set @TypeInput=N'5'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =(select top 1 sysActionID from sysAction where ActionID = 'Attach')
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF2092')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End
----- Màn hình cập nhật mẫu dự án/nhóm công việc

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF2091'
set @ScreenName=N'Cập nhật mẫu dự án/nhóm công việc'
set @ScreenType=N'3'
set @ScreenNameE=N'Cập nhật mẫu dự án/nhóm công việc'
set @Parent=N'OOF2090'
set @sysTable=N'OOT2090'
set @Title=N'OOF2091.Title'
set @DisplayToolBar=null
set @TypeInput=N'2'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=N'600'
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF2091')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

Update sysScreen set DeleteStoreName = 'OOP2091' where ScreenID = 'OOF2090'
Update sysScreen set DeleteStoreName = 'OOP2091' where ScreenID = 'OOF2092'
Update sysScreen set DeleteStoreName = 'OOP1031' where ScreenID = 'OOF1030'
Update sysScreen set DeleteStoreName = 'OOP1031' where ScreenID = 'OOF1032'
Update sysScreen set DeleteStoreName = 'OOP1041' where ScreenID = 'OOF1040'
Update sysScreen set DeleteStoreName = 'OOP1041' where ScreenID = 'OOF1042'
Update sysScreen set DeleteStoreName = 'OOP1051' where ScreenID = 'OOF1050'
Update sysScreen set DeleteStoreName = 'OOP1051' where ScreenID = 'OOF1052'
Update sysScreen set DeleteStoreName = 'OOP1021' where ScreenID = 'OOF1020'
Update sysScreen set DeleteStoreName = 'OOP1021' where ScreenID = 'OOF1022'

------- Màn hình danh sách dự án/nhóm công việc OOF2100----------------
----------------------------------------------------------------------
set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF2100'
set @ScreenName=N'Danh sách dự án/nhóm công việc'
set @ScreenType=N'2'
set @ScreenNameE=N'Danh sách dự án/nhóm công việc'
set @Parent=null
set @sysTable=N'OOT2100'
set @Title=N'OOF2100.Title'
set @DisplayToolBar=N'1,3'
set @TypeInput=null
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=N'OOP2101'
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null
set @StoreFilter=null
set @StoreFilterParameter=null 
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF2100')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

--------------------------------Màn hình cập nhật dự án nhóm công việc OOF2101----------------
-------------------------------------------------------------------------------------------

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF2101'
set @ScreenName=N'Cập nhật dự án/nhóm công việc'
set @ScreenType=N'3'
set @ScreenNameE=N'Cập nhật dự án/nhóm công việc'
set @Parent=N'OOF2100'
set @sysTable=N'OOT2100'
set @Title=N'OOF2101.Title'
set @DisplayToolBar=null
set @TypeInput=N'1'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=N'800'
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF2101')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

----------------Màn hình chọn hợp đồng---------------

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF2104'
set @ScreenName=N'Chọn hợp đồng'
set @ScreenType=N'4'
set @ScreenNameE=N'Chọn hợp đồng'
set @Parent=null
set @sysTable=N'AT1020'
set @Title=N'OOF2104.Title'
set @DisplayToolBar=null
set @TypeInput=N'1'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=N'OOP2104' 
set @StoreFilterParameter=N'@DivisionID=@@DivisionID,@PageNumber=@requestPage,@PageSize=@requestPageSize,@TxtSearch=@TxtSearch,@UserID=@@UserID' 
set @Width=N'900'
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF2104')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End
------------------------ Màn hình chọn nhân viên
set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'CMNF9003'
set @ScreenName=N'Chọn nhân viên'
set @ScreenType=N'4'
set @ScreenNameE=N'Chọn nhân viên'
set @Parent=null
set @sysTable=N'AT1103'
set @Title=N'CMNF9003.Title'
set @DisplayToolBar=null
set @TypeInput=N'1'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=N'SELECT AT1103.DivisionID, AT1103.EmployeeID, AT1103.FullName as EmployeeName
   , AT1103.DepartmentID, AT1102.DepartmentName, AT1103.Address
   , AT1103.Tel, AT1103.Email, AT1103.IsCommon, AT1103.Disabled
FROM AT1103 Left join AT1102 on AT1103.DivisionID = AT1102.DivisionID
   And AT1103.DepartmentID = AT1102.DepartmentID and AT1102.Disabled = 0
WHERE AT1103.Disabled = 0 and AT1103.DivisionID = ''@@DivisionID'' and  (AT1103.EmployeeID LIKE ''@TxtSearch''
 OR AT1103.FullName LIKE ''@TxtSearch''
 OR AT1103.Address LIKE ''@TxtSearch''
 OR AT1103.DepartmentID LIKE ''@TxtSearch''
 OR AT1102.DepartmentName LIKE ''@TxtSearch''
 OR AT1103.Tel LIKE ''@TxtSearch''
 OR AT1103.Email LIKE ''@TxtSearch'')
Order by AT1103.EmployeeID, AT1103.FullName'
set @StoreFilter=null 
set @StoreFilterParameter=null 
set @Width=N'900'
set @SQLPrint=null
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'CMNF9003')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

------------------ Màn hình chọn phòng ban OOF2103------
--------------------------------------------------------

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF2103'
set @ScreenName=N'Chọn phòng ban'
set @ScreenType=N'4'
set @ScreenNameE=N'Chọn phòng ban'
set @Parent=null
set @sysTable=N'OOT2100'
set @Title=N'OOF2103.Title'
set @DisplayToolBar=null
set @TypeInput=N'1'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=N'OOP2103' 
set @StoreFilterParameter=N'@DivisionID=@@DivisionID,@PageNumber=@requestPage,@PageSize=@requestPageSize,@UserID=@@UserID' 
set @Width=N'800'
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =null
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF2103')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End

----- Màn hình xem chi tiết dự án OOF2102

set @DivisionID=N'APK'
set @ModuleID=N'AsoftOO'
set @ScreenID=N'OOF2102'
set @ScreenName=N'Xem chi tiết dự án/nhóm công việc'
set @ScreenType=N'5'
set @ScreenNameE=N'Xem chi tiết dự án/nhóm công việc'
set @Parent=N'OOF2100'
set @sysTable=N'OOT2100'
set @Title=N'OOF2102.Title'
set @DisplayToolBar=N'1,4'
set @TypeInput=N'5'
set @DisplayToolBar2=null 
set @ReportID=null 
set @DeleteStoreName=null
set @sysCategoryBusinessID=N'1'
set @SqlFilter=null 
set @StoreFilter=null
set @StoreFilterParameter=null
set @Width=null
set @SQLPrint=null 
set @StorePrint=null
set @StorePrintParameter=null
set @sysActionID =N'3'
If not exists(select top 1 1 from [dbo].[sysScreen] where  ModuleID = N'AsoftOO' and ScreenID = N'OOF2102')Begin 
insert into sysScreen(DivisionID,ModuleID,ScreenID,ScreenName,ScreenType,ScreenNameE,Parent,sysTable,Title,DisplayToolBar,TypeInput,DisplayToolBar2,ReportID,DeleteStoreName,sysCategoryBusinessID,SqlFilter,StoreFilter,StoreFilterParameter,Width,SQLPrint,StorePrint,StorePrintParameter,sysActionID)values(@DivisionID,@ModuleID,@ScreenID,@ScreenName,@ScreenType,@ScreenNameE,@Parent,@sysTable,@Title,@DisplayToolBar,@TypeInput,@DisplayToolBar2,@ReportID,@DeleteStoreName,@sysCategoryBusinessID,@SqlFilter,@StoreFilter,@StoreFilterParameter,@Width,@SQLPrint,@StorePrint,@StorePrintParameter,@sysActionID)
End