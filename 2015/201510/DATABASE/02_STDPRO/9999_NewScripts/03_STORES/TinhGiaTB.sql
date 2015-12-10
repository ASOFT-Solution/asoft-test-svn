IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TinhGiaTB]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TinhGiaTB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[TinhGiaTB]
@tungay datetime,
@denngay datetime,
@dk nvarchar(255)
AS
if (@dk is null or @dk = '')
	set @dk = '1 = 1'
declare @sql varchar(4000)
set @sql = 'delete banggiaTb where ngayct=cast(''' + convert(nvarchar,@denngay) + ''' as datetime) and ' + @dk
exec (@sql)
set @sql = 'insert into banggiaTb (makho,mavt,madvt,soluong, soluongQD,psno,dongia,DongiaQD,ngayct) 
select makho,mavt,madvt, Sum(soluong) as Soluong,sum(soluongQD), Sum(Psno) as PsNo,
		DonGia = case when Sum(Soluong) >0 then Sum(psno)/sum(soluong) else 0 end,
		DongiaQD = case when Sum(SoluongQD) >0 then Sum(psno)/sum(soluongQD) else 0 end,
		cast(''' + convert(nvarchar,@denngay) + ''' as datetime) as ngayct
from (
	(select makho, mavt,madvt, soluong,soluongQD, psno from blvt 
	where ngayct between cast(''' + convert(nvarchar,@tungay) + ''' as datetime) and cast(''' + convert(nvarchar,@denngay) + ''' as datetime))
	union all
	(	
		select makho, mavt,madvt, (Sum(Soluong) - Sum(Soluong_x)) as Soluong,(sum(soluongQD)-sum(soluong_xQD)) as soluongQD, (Sum(Psno)-Sum(Psco))as PSno
		from
		(

		select makho,mavt,madvt,soluong,soluongQD, 0.0 as soluong_x,0.0 as soluong_xQD, dudau as psno,0.0 as psco
		from obvt where ' + @dk + '
		union all
		select  makho, mavt,madvt, soluong,soluongQD, soluong_x,soluong_xQD, psno,psco
		from blvt
		where ' + @dk + ' and ngayct < cast(''' + convert(nvarchar,@tungay) + ''' as datetime)
		)x
		where cast(''' + convert(nvarchar,@tungay) + ''' as datetime) < cast(''' + convert(nvarchar,@denngay) + ''' as datetime)
		group by makho, mavt,madvt
	))y
where mavt in (select mavt from dmvt where tonkho=3) and ' + @dk + '
group by makho, mavt ,madvt'
exec (@sql)
set @sql = 'select makho,mavt ,madvt,Soluong,soluongQD, PsNo,DonGia, DongiaQD from banggiaTb 
where ngayct=cast(''' + convert(nvarchar,@denngay) + ''' as datetime) and ' + @dk + ' order by makho,mavt,madvt'
exec (@sql)
RETURN