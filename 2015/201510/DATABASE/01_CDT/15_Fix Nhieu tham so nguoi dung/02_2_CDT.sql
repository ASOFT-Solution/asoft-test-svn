/*Fill data to DbName column of sysHistory table*/
use [CDT]

declare @DbName varchar(50)
declare @SiteCode nvarchar(128)
declare @MainDbNamePRO varchar(50)
declare @MainDbNameSTD varchar(50)
declare @sysSiteID int

-- Lay ten DB PRO
select top 1 @MainDbNamePRO = DbName 
from sysDatabase inner join sysSite on sysDatabase.sysSiteID = sysSite.sysSiteID  where sysSite.SiteCode = 'PRO'
Order by DbName

-- Lay ten DB STD
select top 1 @MainDbNameSTD = DbName 
from sysDatabase inner join sysSite on sysDatabase.sysSiteID = sysSite.sysSiteID  where sysSite.SiteCode = 'STD'
Order by DbName

declare cur_AllDb cursor for
select DbName, sysDatabase.sysSiteID, SiteCode from sysDatabase left join sysSite on sysDatabase.sysSiteID = sysSite.sysSiteID Order by DbName

open cur_AllDb
fetch next from cur_AllDb into @DbName, @sysSiteID, @SiteCode

while @@fetch_status = 0
  begin
  		
  if @sysSiteID <> 1 
  Begin
	-- Database chua co history
	if not exists (select * from sysHistory where sysSiteID = @sysSiteID and DbName = @DbName)
	BEGIN
		if exists (select * from sysHistory where sysSiteID = @sysSiteID and isnull(DbName,'') = '')
			-- Cap nhat nhung History co san
			Update sysHistory set DbName = @DbName where sysSiteID = @sysSiteID
		else
			BEGIN
				if @SiteCode = N'PRO' -- Site PRO
					INSERT INTO [CDT].[dbo].[sysHistory]([hDateTime],[sysUserID],[sysSiteID],[sysMenuID],[Action],[PkValue],[OldContent],[DbName])
					select [hDateTime],[sysUserID],[sysSiteID],[sysMenuID],[Action],[PkValue],[OldContent],@DbName from sysHistory
					where sysSiteID = @sysSiteID and DbName = @MainDbNamePRO
				else if @SiteCode = N'STD' -- Site STD
					INSERT INTO [CDT].[dbo].[sysHistory]([hDateTime],[sysUserID],[sysSiteID],[sysMenuID],[Action],[PkValue],[OldContent],[DbName])
					select [hDateTime],[sysUserID],[sysSiteID],[sysMenuID],[Action],[PkValue],[OldContent],@DbName from sysHistory
					where sysSiteID = @sysSiteID and DbName = @MainDbNameSTD 
			END
	END
  end
  else
	BEGIN
		if exists (select * from sysHistory where sysSiteID = @sysSiteID and isnull(DbName,'') = '')
			Update sysHistory set DbName = 'CDT' where sysSiteID = @sysSiteID
	END
	
	-- get next record
	fetch next from cur_AllDb into @DbName, @sysSiteID, @SiteCode
  end
  
close cur_AllDb
deallocate cur_AllDb
