USE [CDT]

DECLARE @sysReportID INT
DECLARE @sysFieldID INT

-- 1) Update TKDu thành điều kiện đặc biệt
SELECT @sysReportID = sysReportID FROM [sysReport] WHERE ReportName = N'Tổng hợp số dư công nợ cuối kỳ'

select @sysFieldID = sysFieldID from sysField
where sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')
and FieldName = 'TKDu'
and sysFieldID IN (select sysFieldID from sysReportFilter
				where sysReportID = @sysReportID)

Update sysReportFilter set specialCond = 1
where sysReportID = @sysReportID 
and sysFieldID = @sysFieldID
and specialCond <> 1

-- 2) Update câu query
Update sysReport
set Query = N'declare @tk nvarchar(16)
declare @tkdu nvarchar(16)
declare @ngayCt datetime
declare @dk nvarchar(256)
declare @sql nvarchar (4000)
set @tk=@@TK
set @tkdu=@@TKDu
set @ngayCt=@@NgayCt
set @sql=''create view wsodu as select makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by makh''
exec (@sql)
set @sql=''create view wsotk as select makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<=cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime)'' + '' and left(isnull(TKDu,''''''''),len('''''' + @tkdu + ''''''))=''''''+ @tkdu + '''''' group by makh ''
exec (@sql)
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wducuoi as select makh,
dunont=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
duno=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,
ducont=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
duco=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end
from wG1 group by makh''
exec (@sql)

select wducuoi.*, dmkh.tenkh from wducuoi,dmkh where wducuoi.makh *= dmkh.makh 
drop view wsodu
drop view wsotk
drop view wG1
drop view wducuoi'
where sysReportID = @sysReportID