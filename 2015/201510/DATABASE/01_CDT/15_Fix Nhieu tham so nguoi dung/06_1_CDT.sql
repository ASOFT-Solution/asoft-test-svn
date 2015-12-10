use [CDT]

if exists (Select id from SysObjects Where id = Object_ID('sysConfigTmp') And xType = 'U')
	drop table sysConfigTmp

declare @sql nvarchar(4000)

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysConfig'  and col.name = 'IsFormatString')
BEGIN
-- Backup data

set @sql = N'select [_Key]
      ,[_Value]
      ,[IsUser]
      ,[sysSiteID]
      ,[StartConfig]
      ,[DienGiai]
      ,[DienGiai2]
      ,[DbName] 
into sysConfigTmp from sysConfig'

END
else
BEGIN

-- Backup data
set @sql = N'select [_Key]
      ,[_Value]
      ,[IsUser]
      ,[sysSiteID]
      ,[StartConfig]
      ,[DienGiai]
      ,[DienGiai2]
      ,IsFormatString
      ,[DbName] 
into sysConfigTmp from sysConfig'

END

exec(@sql)

delete from sysConfig

