declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF2092'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF2092.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'DivisionID' and IDLanguage = N'OOF2092.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'TaskSampleID'
set @IDLanguage=N'OOF2092.TaskSampleID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'TaskSampleID' and IDLanguage = N'OOF2092.TaskSampleID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'TaskSampleName'
set @IDLanguage=N'OOF2092.TaskSampleName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'TaskSampleName' and IDLanguage = N'OOF2092.TaskSampleName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF2092.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'Disabled' and IDLanguage = N'OOF2092.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'Description'
set @IDLanguage=N'OOF2092.Description'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'Description' and IDLanguage = N'OOF2092.Description')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'ProcessID'
set @IDLanguage=N'OOF2092.ProcessID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'ProcessID' and IDLanguage = N'OOF2092.ProcessID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'ProcessName'
set @IDLanguage=N'OOF2092.ProcessName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'ProcessName' and IDLanguage = N'OOF2092.ProcessName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'StepID'
set @IDLanguage=N'OOF2092.StepID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'StepID' and IDLanguage = N'OOF2092.StepID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'StepName'
set @IDLanguage=N'OOF2092.StepName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'StepName' and IDLanguage = N'OOF2092.StepName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'CreateUserID'
set @IDLanguage=N'OOF2092.CreateUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'CreateUserID' and IDLanguage = N'OOF2092.CreateUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'CreateDate'
set @IDLanguage=N'OOF2092.CreateDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'CreateDate' and IDLanguage = N'OOF2092.CreateDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'LastModifyDate'
set @IDLanguage=N'OOF2092.LastModifyDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'LastModifyDate' and IDLanguage = N'OOF2092.LastModifyDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2092'
set @ColumnName=N'LastModifyUserID'
set @IDLanguage=N'OOF2092.LastModifyUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2092' and ColumnName = N'LastModifyUserID' and IDLanguage = N'OOF2092.LastModifyUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End