use [CDT]

if exists (Select id from SysObjects Where id = Object_ID('sysConfigTmp') And xType = 'U')
BEGIN

declare @sql nvarchar(4000)

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysConfig'  and col.name = 'IsFormatString')
BEGIN
set @sql = N'insert into sysConfig([_Key]
					  ,[_Value]
					  ,[IsUser]
					  ,[sysSiteID]
					  ,[StartConfig]
					  ,[DienGiai]
					  ,[DienGiai2]
					  ,[DbName])

select [_Key]
      ,[_Value]
      ,[IsUser]
      ,[sysSiteID]
      ,[StartConfig]
      ,[DienGiai]
      ,[DienGiai2]
      ,[DbName] from sysConfigTmp'
END
ELSE
BEGIN
set @sql = N'insert into sysConfig([_Key]
					  ,[_Value]
					  ,[IsUser]
					  ,[sysSiteID]
					  ,[StartConfig]
					  ,[DienGiai]
					  ,[DienGiai2]
					  ,IsFormatString
					  ,[DbName])

select [_Key]
      ,[_Value]
      ,[IsUser]
      ,[sysSiteID]
      ,[StartConfig]
      ,[DienGiai]
      ,[DienGiai2]
      ,IsFormatString
      ,[DbName] from sysConfigTmp'
END

exec(@sql)

drop table sysConfigTmp

END