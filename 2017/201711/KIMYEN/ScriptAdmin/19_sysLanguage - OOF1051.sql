declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

--set @ScreenID=N'POSF2033'
--set @ColumnName=N'VoucherNo'
--set @IDLanguage=N'POSF2033.VoucherNo'
--If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'POSF2033' and ColumnName = N'VoucherNo' and IDLanguage = N'POSF2033.VoucherNo')Begin 
--insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
--End

set @ScreenID=N'OOF1051'
set @ColumnName=N'Content'
set @IDLanguage=N'OOF1051.Content'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'Content' and IDLanguage = N'OOF1051.Content')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'CreateDate'
set @IDLanguage=N'OOF1051.CreateDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'CreateDate' and IDLanguage = N'OOF1051.CreateDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'CreateUserID'
set @IDLanguage=N'OOF1051.CreateUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'CreateUserID' and IDLanguage = N'OOF1051.CreateUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'DepartmentID'
set @IDLanguage=N'OOF1051.DepartmentID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'DepartmentID' and IDLanguage = N'OOF1051.DepartmentID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF1051.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'Disabled' and IDLanguage = N'OOF1051.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF1051.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'DivisionID' and IDLanguage = N'OOF1051.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'EffectDate'
set @IDLanguage=N'OOF1051.EffectDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'EffectDate' and IDLanguage = N'OOF1051.EffectDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'ExpiryDate'
set @IDLanguage=N'OOF1051.ExpiryDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'CreateDate' and IDLanguage = N'OOF1051.CreateDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'InformDivisionID'
set @IDLanguage=N'OOF1051.InformDivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'InformDivisionID' and IDLanguage = N'OOF1051.InformDivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'InformID'
set @IDLanguage=N'OOF1051.InformID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'InformID' and IDLanguage = N'OOF1051.InformID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'InformName'
set @IDLanguage=N'OOF1051.InformName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'InformName' and IDLanguage = N'OOF1051.InformName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'InformType'
set @IDLanguage=N'OOF1051.InformType'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'InformType' and IDLanguage = N'OOF1051.InformType')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'InformType1'
set @IDLanguage=N'OOF1051.InformType1'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'InformType1' and IDLanguage = N'OOF1051.InformType1')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'InformType2'
set @IDLanguage=N'OOF1051.InformType2'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'InformType2' and IDLanguage = N'OOF1051.InformType2')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'LastModifyDate'
set @IDLanguage=N'OOF1051.LastModifyDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'LastModifyDate' and IDLanguage = N'OOF1051.LastModifyDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1051'
set @ColumnName=N'LastModifyUserID'
set @IDLanguage=N'OOF1051.LastModifyUserID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1051' and ColumnName = N'LastModifyUserID' and IDLanguage = N'OOF1051.LastModifyUserID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End