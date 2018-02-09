declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF2090'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF2090.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2090' and ColumnName = N'DivisionID' and IDLanguage = N'OOF2090.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2090'
set @ColumnName=N'TaskSampleID'
set @IDLanguage=N'OOF2090.TaskSampleID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2090' and ColumnName = N'TaskSampleID' and IDLanguage = N'OOF2090.TaskSampleID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2090'
set @ColumnName=N'TaskSampleName'
set @IDLanguage=N'OOF2090.TaskSampleName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2090' and ColumnName = N'TaskSampleName' and IDLanguage = N'OOF2090.TaskSampleName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End


set @ScreenID=N'OOF2090'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF2090.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2090' and ColumnName = N'Disabled' and IDLanguage = N'OOF2090.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2090'
set @ColumnName=N'Description'
set @IDLanguage=N'OOF2090.Description'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2090' and ColumnName = N'Description' and IDLanguage = N'OOF2090.Description')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End
