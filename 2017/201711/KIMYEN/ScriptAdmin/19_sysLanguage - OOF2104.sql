declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF2104'
set @ColumnName=N'ContractID'
set @IDLanguage=N'OOF2104.ContractID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2104' and ColumnName = N'ContractID' and IDLanguage = N'OOF2104.ContractID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2104'
set @ColumnName=N'ContractNo'
set @IDLanguage=N'OOF2104.ContractNo'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2104' and ColumnName = N'ContractNo' and IDLanguage = N'OOF2104.ContractNo')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2104'
set @ColumnName=N'ContractName'
set @IDLanguage=N'OOF2104.ContractName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2104' and ColumnName = N'ContractName' and IDLanguage = N'OOF2104.ContractName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End


set @ScreenID=N'OOF2104'
set @ColumnName=N'ObjectID'
set @IDLanguage=N'OOF2104.ObjectID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2104' and ColumnName = N'ObjectID' and IDLanguage = N'OOF2104.ObjectID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End


set @ScreenID=N'OOF2104'
set @ColumnName=N'SignDate'
set @IDLanguage=N'OOF2104.SignDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2104' and ColumnName = N'SignDate' and IDLanguage = N'OOF2104.SignDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End


set @ScreenID=N'OOF2104'
set @ColumnName=N'BeginDate'
set @IDLanguage=N'OOF2104.BeginDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2104' and ColumnName = N'BeginDate' and IDLanguage = N'OOF2104.BeginDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End


set @ScreenID=N'OOF2104'
set @ColumnName=N'EndDate'
set @IDLanguage=N'OOF2104.EndDate'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2104' and ColumnName = N'EndDate' and IDLanguage = N'OOF2104.EndDate')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End


set @ScreenID=N'OOF2104'
set @ColumnName=N'Amount'
set @IDLanguage=N'OOF2104.Amount'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2104' and ColumnName = N'Amount' and IDLanguage = N'OOF2104.Amount')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End