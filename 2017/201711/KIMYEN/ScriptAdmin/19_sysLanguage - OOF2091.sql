declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF2091'
set @ColumnName=N'TaskSampleID'
set @IDLanguage=N'OOF2091.TaskSampleID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2091' and ColumnName = N'TaskSampleID' and IDLanguage = N'OOF2091.TaskSampleID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2091'
set @ColumnName=N'TaskSampleName'
set @IDLanguage=N'OOF2091.TaskSampleName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2091' and ColumnName = N'TaskSampleName' and IDLanguage = N'OOF2091.TaskSampleName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2091'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF2091.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2091' and ColumnName = N'Disabled' and IDLanguage = N'OOF2091.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2091'
set @ColumnName=N'Description'
set @IDLanguage=N'OOF2091.Description'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2091' and ColumnName = N'Description' and IDLanguage = N'OOF2091.Description')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2091'
set @ColumnName=N'StepName'
set @IDLanguage=N'OOF2091.StepName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2091' and ColumnName = N'StepName' and IDLanguage = N'OOF2091.StepName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End


