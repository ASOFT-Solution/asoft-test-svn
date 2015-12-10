/*Fill data to DbName column of sysPrintedInvoice table*/
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
	-- Database chua co thong tin hoa don tu in sysPrintedInvoice
	if not exists (select * from sysPrintedInvoice where sysSiteID = @sysSiteID and DbName = @DbName)
	BEGIN
		if exists (select * from sysPrintedInvoice where sysSiteID = @sysSiteID and isnull(DbName,'') = '')
			-- Cap nhat nhung sysPrintedInvoice co san
			Update sysPrintedInvoice set DbName = @DbName where sysSiteID = @sysSiteID
		else
			BEGIN
				if @SiteCode = N'PRO' -- Site PRO
					INSERT INTO [CDT].[dbo].[sysPrintedInvoice]([sysSiteID],[AllowRePrint],[Logo],[CopyCaption],[DbName])
					select [sysSiteID],[AllowRePrint],[Logo],[CopyCaption],@DbName from sysPrintedInvoice
					where sysSiteID = @sysSiteID and DbName = @MainDbNamePRO
				else if @SiteCode = N'STD' -- Site STD
					INSERT INTO [CDT].[dbo].[sysPrintedInvoice]([sysSiteID],[AllowRePrint],[Logo],[CopyCaption],[DbName])
					select [sysSiteID],[AllowRePrint],[Logo],[CopyCaption],@DbName from sysPrintedInvoice
					where sysSiteID = @sysSiteID and DbName = @MainDbNameSTD 
			END
	END
  end
  else
	BEGIN
		if exists (select * from sysPrintedInvoice where sysSiteID = @sysSiteID and isnull(DbName,'') = '')
			Update sysPrintedInvoice set DbName = 'CDT' where sysSiteID = @sysSiteID
	END
	
	-- get next record
	fetch next from cur_AllDb into @DbName, @sysSiteID, @SiteCode
  end
  
close cur_AllDb
deallocate cur_AllDb
