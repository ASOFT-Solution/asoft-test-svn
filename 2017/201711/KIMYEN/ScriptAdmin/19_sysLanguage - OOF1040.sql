declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

--set @ScreenID=N'POSF2033'
--set @ColumnName=N'VoucherNo'
--set @IDLanguage=N'POSF2033.VoucherNo'
--If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'POSF2033' and ColumnName = N'VoucherNo' and IDLanguage = N'POSF2033.VoucherNo')Begin 
--insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
--End

set @ScreenID=N'OOF1040'
set @ColumnName=N'Color'
set @IDLanguage=N'OOF1040.Color'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1040' and ColumnName = N'Color' and IDLanguage = N'OOF1040.Color')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1040'
set @ColumnName=N'Disabled'
set @IDLanguage=N'OOF1040.Disabled'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1040' and ColumnName = N'Disabled' and IDLanguage = N'OOF1040.Disabled')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1040'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF1040.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1040' and ColumnName = N'DivisionID' and IDLanguage = N'OOF1040.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1040'
set @ColumnName=N'IsCommon'
set @IDLanguage=N'OOF1040.IsCommon'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1040' and ColumnName = N'IsCommon' and IDLanguage = N'OOF1040.IsCommon')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1040'
set @ColumnName=N'Orders'
set @IDLanguage=N'OOF1040.Orders'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1040' and ColumnName = N'Orders' and IDLanguage = N'OOF1040.Orders')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1040'
set @ColumnName=N'StatusID'
set @IDLanguage=N'OOF1040.StatusID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1040' and ColumnName = N'StatusID' and IDLanguage = N'OOF1040.StatusID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1040'
set @ColumnName=N'StatusName'
set @IDLanguage=N'OOF1040.StatusName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1040' and ColumnName = N'StatusName' and IDLanguage = N'OOF1040.StatusName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF1040'
set @ColumnName=N'StatusType'
set @IDLanguage=N'OOF1040.StatusType'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF1040' and ColumnName = N'StatusType' and IDLanguage = N'OOF1040.StatusType')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End
