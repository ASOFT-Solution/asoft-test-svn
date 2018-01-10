declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF1042'
set @ColumnName=N'CreateDate'
set @IDLanguage=N'OOF1042.CreateDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'CreateDate' and IDLanguage = N'OOF1042.CreateDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1042'
set @ColumnName=N'CreateUserID'
set @IDLanguage=N'OOF1042.CreateUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'CreateUserID' and IDLanguage = N'OOF1042.CreateUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1042'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF1042.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'Disabled' and IDLanguage = N'OOF1042.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1042'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF1042.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'DivisionID' and IDLanguage = N'OOF1042.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1042'
set @ColumnName=N'IsCommon'
set @IDLanguage=N'OOF1042.IsCommon'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'IsCommon' and IDLanguage = N'OOF1042.IsCommon')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1042'
set @ColumnName=N'LastModifyDate'
set @IDLanguage=N'OOF1042.LastModifyDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'LastModifyDate' and IDLanguage = N'OOF1042.LastModifyDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1042'
set @ColumnName=N'LastModifyUserID'
set @IDLanguage=N'OOF1042.LastModifyUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'LastModifyUserID' and IDLanguage = N'OOF1042.LastModifyUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1042'
set @ColumnName=N'Orders'
set @IDLanguage=N'OOF1042.Orders'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'Orders' and IDLanguage = N'OOF1042.Orders')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1042'
set @ColumnName=N'StatusID'
set @IDLanguage=N'OOF1042.StatusID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'StatusID' and IDLanguage = N'OOF1042.StatusID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1042'
set @ColumnName=N'StatusName'
set @IDLanguage=N'OOF1042.StatusName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1042' and ColumnName = N'StatusName' and IDLanguage = N'OOF1042.StatusName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End




