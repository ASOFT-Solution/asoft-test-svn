declare @ScreenID nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @IDLanguage nvarchar(MAX) 

set @ScreenID=N'OOF2103'
set @ColumnName=N'DivisionID'
set @IDLanguage=N'OOF2102.DivisionID'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2103' and ColumnName = N'DivisionID' and IDLanguage = N'OOF2103.DivisionID')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End

set @ScreenID=N'OOF2103'
set @ColumnName=N'DepartmentName'
set @IDLanguage=N'OOF2102.DepartmentName'
If not exists(select top 1 1 from [dbo].[sysLanguage] where  [ScreenID] = N'OOF2103' and ColumnName = N'DepartmentName' and IDLanguage = N'OOF2103.DepartmentName')Begin 
insert into sysLanguage(ScreenID,ColumnName,IDLanguage)values(@ScreenID,@ColumnName,@IDLanguage)
End