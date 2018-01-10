declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF1020'
set @ColumnName=N'CreateDate'
set @IDLanguage=N'OOF1020.CreateDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'CreateDate' and IDLanguage = N'OOF1020.CreateDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'CreateUserID'
set @IDLanguage=N'OOF1020.CreateUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'CreateUserID' and IDLanguage = N'OOF1020.CreateUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'Description'
set @IDLanguage=N'OOF1020.Description'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'Description' and IDLanguage = N'OOF1020.Description')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF1020.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'Disabled' and IDLanguage = N'OOF1020.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF1020.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'DivisionID' and IDLanguage = N'OOF1020.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'IsCommon'
set @IDLanguage=N'OOF1020.IsCommon'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'IsCommon' and IDLanguage = N'OOF1020.IsCommon')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'LastModifyDate'
set @IDLanguage=N'OOF1020.LastModifyDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'LastModifyDate' and IDLanguage = N'OOF1020.LastModifyDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'LastModifyUserID'
set @IDLanguage=N'OOF1020.LastModifyUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'LastModifyUserID' and IDLanguage = N'OOF1020.LastModifyUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'Orders'
set @IDLanguage=N'OOF1020.Orders'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'Orders' and IDLanguage = N'OOF1020.Orders')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'ProcessID'
set @IDLanguage=N'OOF1020.ProcessID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'ProcessID' and IDLanguage = N'OOF1020.ProcessID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1020'
set @ColumnName=N'ProcessName'
set @IDLanguage=N'OOF1020.ProcessName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1020' and ColumnName = N'ProcessName' and IDLanguage = N'OOF1020.ProcessName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End