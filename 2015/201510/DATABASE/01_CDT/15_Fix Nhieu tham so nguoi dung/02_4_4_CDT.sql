/*Fill data to DbName column of sysPrintedInvoiceDt table*/
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
	-- Database chua co thong tin hoa don tu in sysPrintedInvoiceDt
	if not exists (select * from sysPrintedInvoiceDt where sysSiteID = @sysSiteID and DbName = @DbName)
	BEGIN
		if exists (select * from sysPrintedInvoiceDt where sysSiteID = @sysSiteID and isnull(DbName,'') = '')
			-- Cap nhat nhung sysPrintedInvoiceDt co san
			Update sysPrintedInvoiceDt set DbName = @DbName where sysSiteID = @sysSiteID
		else
			BEGIN
				if @SiteCode = N'PRO' -- Site PRO
					INSERT INTO [CDT].[dbo].[sysPrintedInvoiceDt]
							   ([sysSiteID]
							   ,[sysReportID]
							   ,[ReportName]
							   ,[ReportName2]
							   ,[Pages]
							   ,[Page1]
							   ,[Background1]
							   ,[Page2]
							   ,[Background2]
							   ,[Page3]
							   ,[Background3]
							   ,[Page4]
							   ,[Background4]
							   ,[Page5]
							   ,[Background5]
							   ,[Page6]
							   ,[Background6]
							   ,[Page7]
							   ,[Background7]
							   ,[Page8]
							   ,[Background8]
							   ,[Page9]
							   ,[Background9]
							   ,[Disabled]
							   ,[DbName])
					select		[sysSiteID]
							   ,[sysReportID]
							   ,[ReportName]
							   ,[ReportName2]
							   ,[Pages]
							   ,[Page1]
							   ,[Background1]
							   ,[Page2]
							   ,[Background2]
							   ,[Page3]
							   ,[Background3]
							   ,[Page4]
							   ,[Background4]
							   ,[Page5]
							   ,[Background5]
							   ,[Page6]
							   ,[Background6]
							   ,[Page7]
							   ,[Background7]
							   ,[Page8]
							   ,[Background8]
							   ,[Page9]
							   ,[Background9]
							   ,[Disabled]
							   ,@DbName from sysPrintedInvoiceDt where sysSiteID = @sysSiteID and DbName = @MainDbNamePRO
				else if @SiteCode = N'STD' -- Site STD
					INSERT INTO [CDT].[dbo].[sysPrintedInvoiceDt]
							   ([sysSiteID]
							   ,[sysReportID]
							   ,[ReportName]
							   ,[ReportName2]
							   ,[Pages]
							   ,[Page1]
							   ,[Background1]
							   ,[Page2]
							   ,[Background2]
							   ,[Page3]
							   ,[Background3]
							   ,[Page4]
							   ,[Background4]
							   ,[Page5]
							   ,[Background5]
							   ,[Page6]
							   ,[Background6]
							   ,[Page7]
							   ,[Background7]
							   ,[Page8]
							   ,[Background8]
							   ,[Page9]
							   ,[Background9]
							   ,[Disabled]
							   ,[DbName])
					select		[sysSiteID]
							   ,[sysReportID]
							   ,[ReportName]
							   ,[ReportName2]
							   ,[Pages]
							   ,[Page1]
							   ,[Background1]
							   ,[Page2]
							   ,[Background2]
							   ,[Page3]
							   ,[Background3]
							   ,[Page4]
							   ,[Background4]
							   ,[Page5]
							   ,[Background5]
							   ,[Page6]
							   ,[Background6]
							   ,[Page7]
							   ,[Background7]
							   ,[Page8]
							   ,[Background8]
							   ,[Page9]
							   ,[Background9]
							   ,[Disabled]
							   ,@DbName from sysPrintedInvoiceDt where sysSiteID = @sysSiteID and DbName = @MainDbNameSTD
			END
	END
  end
  else
	BEGIN
		if exists (select * from sysPrintedInvoiceDt where sysSiteID = @sysSiteID and isnull(DbName,'') = '')
			Update sysPrintedInvoiceDt set DbName = 'CDT' where sysSiteID = @sysSiteID
	END
	
	-- get next record
	fetch next from cur_AllDb into @DbName, @sysSiteID, @SiteCode
  end
  
close cur_AllDb
deallocate cur_AllDb
