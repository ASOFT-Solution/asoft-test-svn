declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

--set @ScreenID=N'POSF2033'
--set @ColumnName=N'VoucherNo'
--set @IDLanguage=N'POSF2033.VoucherNo'
--If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'POSF2033' and ColumnName = N'VoucherNo' and IDLanguage = N'POSF2033.VoucherNo')Begin 
--insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
--End

set @ScreenID=N'OOF1022'
set @ColumnName=N'CreateDate'
set @IDLanguage=N'OOF1022.CreateDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'CreateDate' and IDLanguage = N'OOF1022.CreateDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1022'
set @ColumnName=N'CreateUserID'
set @IDLanguage=N'OOF1022.CreateUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'CreateUserID' and IDLanguage = N'OOF1022.CreateUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1022'
set @ColumnName=N'Description'
set @IDLanguage=N'OOF1022.Description'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'Description' and IDLanguage = N'OOF1022.Description')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1022'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF1022.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'Disabled' and IDLanguage = N'OOF1022.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1022'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF1022.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'DivisionID' and IDLanguage = N'OOF1022.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End


set @ScreenID=N'OOF1022'
set @ColumnName=N'IsCommon'
set @IDLanguage=N'OOF1022.IsCommon'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'IsCommon' and IDLanguage = N'OOF1022.IsCommon')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1022'
set @ColumnName=N'LastModifyDate'
set @IDLanguage=N'OOF1022.LastModifyDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'LastModifyDate' and IDLanguage = N'OOF1022.LastModifyDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1022'
set @ColumnName=N'LastModifyUserID'
set @IDLanguage=N'OOF1022.LastModifyUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'LastModifyUserID' and IDLanguage = N'OOF1022.LastModifyUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1022'
set @ColumnName=N'Orders'
set @IDLanguage=N'OOF1022.Orders'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'Orders' and IDLanguage = N'OOF1022.Orders')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1022'
set @ColumnName=N'ProcessID'
set @IDLanguage=N'OOF1022.ProcessID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'ProcessID' and IDLanguage = N'OOF1022.ProcessID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1022'
set @ColumnName=N'ProcessName'
set @IDLanguage=N'OOF1022.ProcessName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1022' and ColumnName = N'ProcessName' and IDLanguage = N'OOF1022.ProcessName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End