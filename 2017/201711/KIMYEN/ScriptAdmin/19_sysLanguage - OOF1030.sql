﻿declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

--set @ScreenID=N'POSF2033'
--set @ColumnName=N'VoucherNo'
--set @IDLanguage=N'POSF2033.VoucherNo'
--If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'POSF2033' and ColumnName = N'VoucherNo' and IDLanguage = N'POSF2033.VoucherNo')Begin 
--insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
--End

set @ScreenID=N'OOF1030'
set @ColumnName=N'Description'
set @IDLanguage=N'OOF1030.Description'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1030' and ColumnName = N'Description' and IDLanguage = N'OOF1030.Description')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1030'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF1030.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1030' and ColumnName = N'Disabled' and IDLanguage = N'OOF1030.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1030'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF1030.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1030' and ColumnName = N'DivisionID' and IDLanguage = N'OOF1030.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1030'
set @ColumnName=N'Orders'
set @IDLanguage=N'OOF1030.Orders'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1030' and ColumnName = N'Orders' and IDLanguage = N'OOF1030.Orders')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1030'
set @ColumnName=N'ProcessID'
set @IDLanguage=N'OOF1030.ProcessID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1030' and ColumnName = N'ProcessID' and IDLanguage = N'OOF1030.ProcessID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1030'
set @ColumnName=N'RelatedToTypeID'
set @IDLanguage=N'OOF1030.RelatedToTypeID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1030' and ColumnName = N'RelatedToTypeID' and IDLanguage = N'OOF1030.RelatedToTypeID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1030'
set @ColumnName=N'StepID'
set @IDLanguage=N'OOF1030.StepID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1030' and ColumnName = N'StepID' and IDLanguage = N'OOF1030.StepID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1030'
set @ColumnName=N'StepName'
set @IDLanguage=N'OOF1030.StepName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1030' and ColumnName = N'StepName' and IDLanguage = N'OOF1030.StepName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

