declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

--set @ScreenID=N'POSF2033'
--set @ColumnName=N'VoucherNo'
--set @IDLanguage=N'POSF2033.VoucherNo'
--If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'POSF2033' and ColumnName = N'VoucherNo' and IDLanguage = N'POSF2033.VoucherNo')Begin 
--insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
--End

set @ScreenID=N'OOF1052'
set @ColumnName=N'CreateDate'
set @IDLanguage=N'OOF1052.CreateDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'CreateDate' and IDLanguage = N'OOF1052.CreateDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'CreateUserID'
set @IDLanguage=N'OOF1052.CreateUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'CreateUserID' and IDLanguage = N'OOF1052.CreateUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'DepartmentID'
set @IDLanguage=N'OOF1052.DepartmentID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'DepartmentID' and IDLanguage = N'OOF1052.DepartmentID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'Description'
set @IDLanguage=N'OOF1052.Description'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'Description' and IDLanguage = N'OOF1052.Description')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF1052.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'Disabled' and IDLanguage = N'OOF1052.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'EffectDate'
set @IDLanguage=N'OOF1052.EffectDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'EffectDate' and IDLanguage = N'OOF1052.EffectDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'ExpiryDate'
set @IDLanguage=N'OOF1052.ExpiryDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'ExpiryDate' and IDLanguage = N'OOF1052.ExpiryDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'InformDivisionID'
set @IDLanguage=N'OOF1052.InformDivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'InformDivisionID' and IDLanguage = N'OOF1052.InformDivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'InformName'
set @IDLanguage=N'OOF1052.InformName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'InformName' and IDLanguage = N'OOF1052.InformName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'InformType'
set @IDLanguage=N'OOF1052.InformType'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'InformType' and IDLanguage = N'OOF1052.InformType')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'LastModifyDate'
set @IDLanguage=N'OOF1052.LastModifyDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'LastModifyDate' and IDLanguage = N'OOF1052.LastModifyDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1052'
set @ColumnName=N'LastModifyUserID'
set @IDLanguage=N'OOF1052.LastModifyUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1052' and ColumnName = N'LastModifyUserID' and IDLanguage = N'OOF1052.LastModifyUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

