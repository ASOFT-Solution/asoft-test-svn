-- Fix lỗi Divide zero
-- Fix giới hạn ngày KH và ngày kết thúc khấu hao
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFaData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFaData]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetFaData] @ngayCt  datetime
as
	--set @ngayCt='07/01/2008'
declare @sql nvarchar (4000)
set @sql='create view TongtienPB as 
(SELECT mats, min(tkKH) as tkKH, sum(khthang1) + sum(khthang2) + sum(khthang3) + sum(khthang4) as khthang FROM	(
	select mats,tkkh,KHthang1,khthang2,khthang3,khthang4  from dmtscd
		where mats in (select mats from dmtscd  where cast('''+ convert(nvarchar,@ngayct) + ''' as datetime) between ngayKH and DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, dateadd(mm,sothang,ngayKH)) + 1, 0)))
		and  mats not in (select mats from fathoikh where ngayct<=cast('''+ convert(nvarchar,@ngayct) + ''' as datetime) union select mats from fagiamts where ngayct<=cast('''+ convert(nvarchar,@ngayct) + ''' as datetime))
	union all
	select n.mats,t.tkKH, n.nguyengia1/n.sothang as khthang1, n.nguyengia2/n.sothang as khthang2, n.nguyengia3/n.sothang as khthang3, n.nguyengia4/n.sothang as khthang4 from fanguyengia n, dmtscd t
		where n.mats = t.mats and n.sothang >0
		and cast('''+ convert(nvarchar,@ngayct) + ''' as datetime) between n.ngaykh and DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, dateadd(mm,n.sothang,n.ngaykh)) + 1, 0))
		and n.mats not in (select mats from fathoikh where ngayct<=cast('''+ convert(nvarchar,@ngayct) + ''' as datetime) union select mats from fagiamts where ngayct<=cast('''+ convert(nvarchar,@ngayct) + ''' as datetime))
	) x group by mats) '
--print @sql
exec (@sql)
set @sql='create view tienPB as 
select a.*,b.KHthang,tkKH,c.tongheso from FatieuthucPB a inner join TongtienPB b on a.mats = b.mats
	inner join (select mats,sum(heso) as tongheso from FatieuthucPB group by mats) 
	c on a.mats=c.mats'
exec (@sql)
select a.mats ,b.tents ,a.tkKH ,a.TKCP 
	,a.heso*a.KHthang/NULLIF(a.tongheso, 0) as tienpb,a.mabp,a.maphi
	,a.mavv, a.macongtrinh , a.heso , a.KHThang  
	 from tienPB a inner join dmtscd b on a.mats=b.mats --where tongheso>0
drop view tienPB
drop view TongtienPB