declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF1021'
set @ColumnName=N'Description'
set @IDLanguage=N'OOF1021.Description'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1021' and ColumnName = N'Description' and IDLanguage = N'OOF1021.Description')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1021'
set @ColumnName=N'IsCommon'
set @IDLanguage=N'OOF1021.IsCommon'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1021' and ColumnName = N'IsCommon' and IDLanguage = N'OOF1021.IsCommon')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1021'
set @ColumnName=N'Orders'
set @IDLanguage=N'OOF1021.Orders'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1021' and ColumnName = N'Orders' and IDLanguage = N'OOF1021.Orders')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1021'
set @ColumnName=N'ProcessID'
set @IDLanguage=N'OOF1021.ProcessID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1021' and ColumnName = N'ProcessID' and IDLanguage = N'OOF1021.ProcessID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1021'
set @ColumnName=N'ProcessName'
set @IDLanguage=N'OOF1021.ProcessName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1021' and ColumnName = N'ProcessName' and IDLanguage = N'OOF1021.ProcessName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

