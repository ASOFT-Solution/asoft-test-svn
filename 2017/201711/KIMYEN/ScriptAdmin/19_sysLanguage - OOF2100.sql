declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF2100'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF2100.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'DivisionID' and IDLanguage = N'OOF2100.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'DepartmentID'
set @IDLanguage=N'OOF2100.DepartmentID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'DepartmentID' and IDLanguage = N'OOF2100.DepartmentID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'LeaderID'
set @IDLanguage=N'OOF2100.LeaderID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'LeaderID' and IDLanguage = N'OOF2100.LeaderID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'ProjectID'
set @IDLanguage=N'OOF2100.ProjectID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'ProjectID' and IDLanguage = N'OOF2100.ProjectID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'ProjectName'
set @IDLanguage=N'OOF2100.ProjectName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'ProjectName' and IDLanguage = N'OOF2100.ProjectName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'DepartmentID'
set @IDLanguage=N'OOF2100.DepartmentID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'DepartmentID' and IDLanguage = N'OOF2100.DepartmentID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'ContractID'
set @IDLanguage=N'OOF2100.ContractID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'ContractID' and IDLanguage = N'OOF2100.ContractID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'StatusID'
set @IDLanguage=N'OOF2100.StatusID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'StatusID' and IDLanguage = N'OOF2100.StatusID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'AssignedToUserID'
set @IDLanguage=N'OOF2100.AssignedToUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'AssignedToUserID' and IDLanguage = N'OOF2100.AssignedToUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'StartDate'
set @IDLanguage=N'OOF2100.StartDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'StartDate' and IDLanguage = N'OOF2100.StartDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2100'
set @ColumnName=N'EndDate'
set @IDLanguage=N'OOF2100.EndDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2100' and ColumnName = N'EndDate' and IDLanguage = N'OOF2100.EndDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End