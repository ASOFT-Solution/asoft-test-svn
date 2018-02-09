declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF2102'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF2102.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'DivisionID' and IDLanguage = N'OOF2102.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'ProjectID'
set @IDLanguage=N'OOF2102.ProjectID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'ProjectID' and IDLanguage = N'OOF2102.ProjectID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'ProjectName'
set @IDLanguage=N'OOF2102.ProjectName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'ProjectName' and IDLanguage = N'OOF2102.ProjectName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'ContractNo'
set @IDLanguage=N'OOF2102.ContractNo'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'ContractNo' and IDLanguage = N'OOF2102.ContractNo')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'StartDate'
set @IDLanguage=N'OOF2102.StartDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'StartDate' and IDLanguage = N'OOF2102.StartDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'EndDate'
set @IDLanguage=N'OOF2102.EndDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'EndDate' and IDLanguage = N'OOF2102.EndDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'LeaderID'
set @IDLanguage=N'OOF2102.LeaderID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'LeaderID' and IDLanguage = N'OOF2102.LeaderID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'AssignedToUserID'
set @IDLanguage=N'OOF2102.AssignedToUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'AssignedToUserID' and IDLanguage = N'OOF2102.AssignedToUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'DepartmentID'
set @IDLanguage=N'OOF2102.DepartmentID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'DepartmentID' and IDLanguage = N'OOF2102.DepartmentID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'ProjectType'
set @IDLanguage=N'OOF2102.ProjectType'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'ProjectType' and IDLanguage = N'OOF2102.ProjectType')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'CheckingDate'
set @IDLanguage=N'OOF2102.CheckingDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'CheckingDate' and IDLanguage = N'OOF2102.CheckingDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'TaskSampleID'
set @IDLanguage=N'OOF2102.TaskSampleID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'TaskSampleID' and IDLanguage = N'OOF2102.TaskSampleID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'CreateDate'
set @IDLanguage=N'OOF2102.CreateDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'CreateDate' and IDLanguage = N'OOF2102.CreateDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'CreateUserID'
set @IDLanguage=N'OOF2102.CreateUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'CreateUserID' and IDLanguage = N'OOF2102.CreateUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'LastModifyDate'
set @IDLanguage=N'OOF2102.LastModifyDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'LastModifyDate' and IDLanguage = N'OOF2102.LastModifyDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2102'
set @ColumnName=N'LastModifyUserID'
set @IDLanguage=N'OOF2102.LastModifyUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2102' and ColumnName = N'LastModifyUserID' and IDLanguage = N'OOF2102.LastModifyUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End


