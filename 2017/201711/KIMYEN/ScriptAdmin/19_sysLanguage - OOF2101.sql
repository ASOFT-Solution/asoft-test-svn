declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF2101'
set @ColumnName=N'ProjectID'
set @IDLanguage=N'OOF2101.ProjectID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'ProjectID' and IDLanguage = N'OOF2101.ProjectID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'ProjectName'
set @IDLanguage=N'OOF2101.ProjectName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'ProjectName' and IDLanguage = N'OOF2101.ProjectName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'TaskSampleID'
set @IDLanguage=N'OOF2101.TaskSampleID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'TaskSampleID' and IDLanguage = N'OOF2101.TaskSampleID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'ContractName'
set @IDLanguage=N'OOF2101.ContractName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'ContractName' and IDLanguage = N'OOF2101.ContractName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'StartDate'
set @IDLanguage=N'OOF2101.StartDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'StartDate' and IDLanguage = N'OOF2101.StartDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'EndDate'
set @IDLanguage=N'OOF2101.EndDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'EndDate' and IDLanguage = N'OOF2101.EndDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'CheckingDate'
set @IDLanguage=N'OOF2101.CheckingDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'CheckingDate' and IDLanguage = N'OOF2101.CheckingDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'DepartmentName'
set @IDLanguage=N'OOF2101.DepartmentName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'DepartmentName' and IDLanguage = N'OOF2100.DepartmentName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'AssignedToUserName'
set @IDLanguage=N'OOF2101.AssignedToUserName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'AssignedToUserName' and IDLanguage = N'OOF2101.AssignedToUserName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'LeaderName'
set @IDLanguage=N'OOF2101.LeaderName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'LeaderName' and IDLanguage = N'OOF2101.LeaderName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2101'
set @ColumnName=N'StatusID'
set @IDLanguage=N'OOF2101.StatusID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2101' and ColumnName = N'StatusID' and IDLanguage = N'OOF2101.StatusID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End