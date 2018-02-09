declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

--set @ScreenID=N'POSF2033'
--set @ColumnName=N'VoucherNo'
--set @IDLanguage=N'POSF2033.VoucherNo'
--If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'POSF2033' and ColumnName = N'VoucherNo' and IDLanguage = N'POSF2033.VoucherNo')Begin 
--insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
--End

set @ScreenID=N'OOF1031'
set @ColumnName=N'Description'
set @IDLanguage=N'OOF1031.Description'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'Description' and IDLanguage = N'OOF1031.Description')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF1031.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'Disabled' and IDLanguage = N'OOF1031.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'Orders'
set @IDLanguage=N'OOF1031.Orders'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'Orders' and IDLanguage = N'OOF1031.Orders')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'ProcessID'
set @IDLanguage=N'OOF1031.ProcessID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'ProcessID' and IDLanguage = N'OOF1031.ProcessID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'StepID'
set @IDLanguage=N'OOF1031.StepID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'StepID' and IDLanguage = N'OOF1031.StepID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'StepName'
set @IDLanguage=N'OOF1031.StepName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'StepName' and IDLanguage = N'OOF1031.StepName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'WorkID'
set @IDLanguage=N'OOF1031.WorkID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'WorkID' and IDLanguage = N'OOF1031.WorkID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'WorkName'
set @IDLanguage=N'OOF1031.WorkName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'WorkName' and IDLanguage = N'OOF1031.WorkName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'DescriptionW'
set @IDLanguage=N'OOF1031.DescriptionW'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'DescriptionW' and IDLanguage = N'OOF1031.DescriptionW')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'ExecutionTime'
set @IDLanguage=N'OOF1031.ExecutionTime'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'ExecutionTime' and IDLanguage = N'OOF1031.ExecutionTime')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1031'
set @ColumnName=N'Notes'
set @IDLanguage=N'OOF1031.Notes'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1031' and ColumnName = N'Notes' and IDLanguage = N'OOF1031.Notes')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

