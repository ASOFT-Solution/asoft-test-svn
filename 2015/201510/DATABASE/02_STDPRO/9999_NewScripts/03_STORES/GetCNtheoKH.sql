IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCNtheoKH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCNtheoKH]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE    procedure [dbo].[GetCNtheoKH]
@ngayCt datetime,
@mant varchar(16),
@gioihan decimal(28,6),
@dk nvarchar(2)
as
declare @sql nvarchar (4000)

set @sql='create view wsodu as select tk, Saleman, makh,sum(duno)as duno, sum(duco) as duco ,sum(dunont)as dunont, sum(ducont) as ducont, mabp, mavv, maphi 
from obkh where left(tk,1)='''+ @dk +''' and MaNT = ''' + @mant + ''' group by tk, Saleman, makh, mabp, mavv, maphi'
exec (@sql)
set @sql='create view wsops as select tk, Saleman, makh,sum(psno)as duno, sum(psco) as duco,sum(psnont)as dunont, sum(pscont) as ducont, mabp, mavv, maphi 
from bltk where tk in (select tk from dmtk where tkcongno = 1 and left(tk,1) = ''' + @dk + ''') and ngayct<cast(''' + 
convert(nvarchar,dateadd(d,1,@ngayct)) + ''' as datetime) and mant = ''' + @mant + ''' group by tk, Saleman, makh, mabp, mavv, maphi '
print @sql
exec (@sql)
set @sql='create view wG as select * from wsodu union all select * from wsops'
exec (@sql)
set @sql='create view wducuoi as select tk, Saleman, makh,duno=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,
duco=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,dunont=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
ducont=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end, mabp, mavv, maphi from wG group by tk, Saleman, makh, mabp, mavv, maphi'
exec (@sql)

set @sql = 'select * from wducuoi 
where duno + duco + dunont + ducont > 0 and '
if @mant='VND'  
	set @sql = @sql + 'duno + duco < ' + convert(nvarchar,@gioihan)
else 
	set @sql = @sql + 'dunont + ducont < ' + convert(nvarchar,@gioihan)
exec (@sql)
 
drop view wsodu
drop view wsops
drop view wG
drop view wducuoi