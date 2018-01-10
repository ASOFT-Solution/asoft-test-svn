declare @TableName nvarchar(MAX) declare @Description nvarchar(MAX) declare @PK nvarchar(MAX) declare @ModuleID nvarchar(MAX) declare @ParentTable nvarchar(MAX) declare @RefLink nvarchar(MAX) declare @RefUrl nvarchar(MAX) declare @RelTable nvarchar(MAX) declare @RelColumn nvarchar(MAX) declare @TableDelete nvarchar(MAX) declare @TypeREL nvarchar(MAX) declare @RealRelColumn nvarchar(MAX) declare @StartRowImport nvarchar(MAX) declare @RefScreenMainID nvarchar(MAX) 

--set @TableName=N'POST2030'
--set @Description=N'Phiếu đề nghị xuất hóa đơn'
--set @PK=N'APK'
--set @ModuleID=N'AsoftPOS'
--set @ParentTable=null 
--set @RefLink=N'VoucherNo'
--set @RefUrl=N'/PopupLayout/Index/POS/POSF2031?PK=#=APKMaster#&Table=POST2030&key=APK&DivisionID=#:DivisionID#&NOUPDATE=1'
--set @RelTable=null 
--set @RelColumn=null 
--set @TableDelete=null 
--set @TypeREL='51'
--set @RealRelColumn=null
--set @StartRowImport=null 
--set @RefScreenMainID=N'POSF2031'
--If not exists(select top 1 1 from [dbo].[sysTable] where  [TableName] = N'POST2030')Begin 
--insert into sysTable(TableName,Description,PK,ModuleID,ParentTable,RefLink,RefUrl,RelTable,RelColumn,TableDelete,TypeREL,RealRelColumn,StartRowImport,RefScreenMainID)values(@TableName,@Description,@PK,@ModuleID,@ParentTable,@RefLink,@RefUrl,@RelTable,@RelColumn,@TableDelete,@TypeREL,@RealRelColumn,@StartRowImport,@RefScreenMainID)
--End

set @TableName=N'OOT1050'
set @Description=N'Danh mục thông báo'
set @PK=N'APK'
set @ModuleID=N'AsoftOO'
set @ParentTable=null 
set @RefLink=N'InformName'
set @RefUrl=null
set @RelTable=null 
set @RelColumn=null 
set @TableDelete=null 
set @TypeREL='55'
set @RealRelColumn=null
set @StartRowImport=null 
set @RefScreenMainID=N'OOF1051'
If not exists(select top 1 1 from [dbo].[sysTable] where  [TableName] = N'OOT1050')Begin 
insert into sysTable(TableName,Description,PK,ModuleID,ParentTable,RefLink,RefUrl,RelTable,RelColumn,TableDelete,TypeREL,RealRelColumn,StartRowImport,RefScreenMainID)values(@TableName,@Description,@PK,@ModuleID,@ParentTable,@RefLink,@RefUrl,@RelTable,@RelColumn,@TableDelete,@TypeREL,@RealRelColumn,@StartRowImport,@RefScreenMainID)
End

set @TableName=N'OOT1020'
set @Description=N'Danh mục quy trình'
set @PK=N'APK'
set @ModuleID=N'AsoftOO'
set @ParentTable=null 
set @RefLink=N'ProcessID'
set @RefUrl=null
set @RelTable=null 
set @RelColumn=null 
set @TableDelete=null 
set @TypeREL='55'
set @RealRelColumn=null
set @StartRowImport=null 
set @RefScreenMainID=N'OOF1021'
If not exists(select top 1 1 from [dbo].[sysTable] where  [TableName] = N'OOT1020')Begin 
insert into sysTable(TableName,Description,PK,ModuleID,ParentTable,RefLink,RefUrl,RelTable,RelColumn,TableDelete,TypeREL,RealRelColumn,StartRowImport,RefScreenMainID)values(@TableName,@Description,@PK,@ModuleID,@ParentTable,@RefLink,@RefUrl,@RelTable,@RelColumn,@TableDelete,@TypeREL,@RealRelColumn,@StartRowImport,@RefScreenMainID)
End

set @TableName=N'OOT1030'
set @Description=N'Danh mục bước'
set @PK=N'APK'
set @ModuleID=N'AsoftOO'
set @ParentTable=null 
set @RefLink=N'StepID'
set @RefUrl=null
set @RelTable=null 
set @RelColumn=null 
set @TableDelete=null 
set @TypeREL='55'
set @RealRelColumn=null
set @StartRowImport=null 
set @RefScreenMainID=N'OOF1031'
If not exists(select top 1 1 from [dbo].[sysTable] where  [TableName] = N'OOT1030')Begin 
insert into sysTable(TableName,Description,PK,ModuleID,ParentTable,RefLink,RefUrl,RelTable,RelColumn,TableDelete,TypeREL,RealRelColumn,StartRowImport,RefScreenMainID)values(@TableName,@Description,@PK,@ModuleID,@ParentTable,@RefLink,@RefUrl,@RelTable,@RelColumn,@TableDelete,@TypeREL,@RealRelColumn,@StartRowImport,@RefScreenMainID)
End

set @TableName=N'OOT1040'
set @Description=N'Danh mục trạng thái'
set @PK=N'APK'
set @ModuleID=N'AsoftOO'
set @ParentTable=null 
set @RefLink=N'StatusID'
set @RefUrl=null
set @RelTable=null 
set @RelColumn=null 
set @TableDelete=null 
set @TypeREL='55'
set @RealRelColumn=null
set @StartRowImport=null 
set @RefScreenMainID=N'OOF1041'
If not exists(select top 1 1 from [dbo].[sysTable] where  [TableName] = N'OOT1040')Begin 
insert into sysTable(TableName,Description,PK,ModuleID,ParentTable,RefLink,RefUrl,RelTable,RelColumn,TableDelete,TypeREL,RealRelColumn,StartRowImport,RefScreenMainID)values(@TableName,@Description,@PK,@ModuleID,@ParentTable,@RefLink,@RefUrl,@RelTable,@RelColumn,@TableDelete,@TypeREL,@RealRelColumn,@StartRowImport,@RefScreenMainID)
End