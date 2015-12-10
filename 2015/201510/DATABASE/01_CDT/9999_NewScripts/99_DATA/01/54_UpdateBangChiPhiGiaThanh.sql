Use CDT


Update sysReport set Query = N'declare @ngayct1 datetime
declare @ngayct2 datetime
set @ngayct1=@@ngayct1
set @ngayct2=dateadd(hh,23,@@ngayct2)
DECLARE @SOQD NVARCHAR(50)
DECLARE @DBname NVARCHAR(10)

set @DBname = @@DBName
SELECT @SOQD = _Value  FROM [CDT].[dbo].[sysConfig] WHERE _key=''SOQD'' and DBname = @DBname
--print @SOQD
DECLARE @tbResult TABLE
            (
              JobCode varchar(16),				-- Mã công trình
              JobName nvarchar(512),			-- Tên công trình
              TienDDDk decimal(28, 6),			-- Chi phí dở dang đầu kỳ
              Material decimal(28, 6),			-- Chi phí vật liệu trực tiếp
              Labor decimal(28, 6),				-- Chi phí nhân công trực tiếp
              Machine decimal(28, 6),			-- Chi phí máy thi công
              CPThauPhu decimal(28, 6),			-- Chi phí Thuê thầu phụ
              CommonCost decimal(28, 6),		-- Chi phí Sản xuất chung
              SumCost decimal(28, 6),			-- Tổng chi phí
              JobCost decimal(28, 6),			-- Giá thành công trình
              TienDDCk decimal(28, 6)			-- Chi phí dở dang cuối kỳ
            )
IF @SOQD = N''15/2006/QĐ-BTC'' -- Nếu là quyết định 15
BEGIN
	INSERT  INTO @tbResult (JobCode ,JobName,TienDDDk,Material,Labor,Machine,CPThauPhu,CommonCost,SumCost,JobCost,TienDDCk)		
			select z.macongtrinh,b.TenCongtrinh, sum(tiendd) , sum(vl) , sum(nc) , sum(mtc), sum(ttp) ,sum(cpc) , sum(vl+nc+mtc+ttp+cpc) , sum(vl+nc+mtc+ttp+cpc+tiendd) ,sum(vl+nc+mtc+ttp+cpc+tiendd) 
			From
				(
					select macongtrinh, sum(tien) as tiendd,0.0 as vl,0.0 as nc, 0.0 as mtc, 0.0 as ttp, 0.0 as cpc 
					From
						(
							select macongtrinh ,sum(tien) as tien from cocongtrinhdd group by macongtrinh
							union all
							select macongtrinh ,sum(psno)as tien from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622'' or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh is not null and ngayct<@ngayct1 group by macongtrinh
						)x 
					group by macongtrinh
					union all
					select macongtrinh,sum(tiendd) as tiendd, sum(vl) as vl, sum(nc) as nc, sum(mtc) as mtc, sum(ttp) as ttp, sum(cpc) as cpc 
					From 
						( 
							select macongtrinh, 0.0 as tiendd,sum(psno) as vl,0.0 as nc, 0.0 as mtc, 0.0 as ttp, 0.0 as cpc from bltk where left(tk,3) =''621''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
							union all
							select macongtrinh, 0.0 as tiendd,0.0 as vl,sum(psno) as nc, 0.0 as mtc, 0.0 as ttp, 0.0 as cpc from bltk where left(tk,3) =''622''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
							union all
							select macongtrinh, 0.0 as tiendd,0.0 as vl,0.0 as nc,sum(psno)  as mtc, 0.0 as ttp, 0.0 as cpc from bltk where left(tk,3) =''623''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
							union all
							select macongtrinh, 0.0 as tiendd,0.0 as vl,0.0 as nc,0.0  as mtc, sum(psno) as ttp, 0.0 as cpc from bltk where left(tk,4) =''6278''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
							union all
							select macongtrinh, 0.0 as tiendd,0.0 as vl,0.0 as nc,0.0  as mtc, 0.0 as ttp,sum(psno)  as cpc from bltk where left(tk,3) =''627'' and left(tk,4) <>''6278''   and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
						)y 
					group by macongtrinh
				)z inner join dmcongtrinh b on z.macongtrinh=b.macongtrinh 
			where @@ps
			group by z.macongtrinh,b.tencongtrinh
END
 
Else IF @SOQD = N''48/2006/QĐ-BTC'' -- Nếu là quyết định 48
BEGIN
	INSERT  INTO @tbResult (JobCode ,JobName,TienDDDk,Material,Labor,Machine,CPThauPhu,CommonCost,SumCost,JobCost,TienDDCk)		
			select z.macongtrinh,b.TenCongtrinh, sum(tiendd) , sum(vl)  , sum(nc) , sum(mtc) , sum(ttp) ,sum(cpc) , sum(vl+nc+mtc+ttp+cpc) , sum(vl+nc+mtc+ttp+cpc+tiendd) ,sum(vl+nc+mtc+ttp+cpc+tiendd) 
			From
				(
					select macongtrinh, sum(tien) as tiendd,0.0 as vl,0.0 as nc, 0.0 as mtc, 0.0 as ttp, 0.0 as cpc 
					From
						(
							select macongtrinh ,sum(tien) as tien from cocongtrinhdd group by macongtrinh
							union all
							select macongtrinh ,sum(psno)as tien from bltk where ( left(tk,5) =''15411'' or left(tk,5) =''15412'' or left(tk,5) =''15413'' or left(tk,5) =''15417'' ) and macongtrinh is not null and ngayct<@ngayct1 group by macongtrinh
						)x 
					group by macongtrinh
					union all
					select macongtrinh,sum(tiendd) as tiendd, sum(vl) as vl, sum(nc) as nc, sum(mtc) as mtc, sum(ttp) as ttp, sum(cpc) as cpc 
					From 
						( 
							select macongtrinh, 0.0 as tiendd,sum(psno) as vl,0.0 as nc, 0.0 as mtc, 0.0 as ttp, 0.0 as cpc from bltk where left(tk,5) =''15411''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
							union all
							select macongtrinh, 0.0 as tiendd,0.0 as vl,sum(psno) as nc, 0.0 as mtc, 0.0 as ttp, 0.0 as cpc from bltk where left(tk,5) =''15412''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
							union all
							select macongtrinh, 0.0 as tiendd,0.0 as vl,0.0 as nc,sum(psno)  as mtc, 0.0 as ttp, 0.0 as cpc from bltk where left(tk,5) =''15413''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
							union all
							select macongtrinh, 0.0 as tiendd,0.0 as vl,0.0 as nc,0.0  as mtc, 0.0 as ttp,sum(psno)  as cpc from bltk where left(tk,5) =''15417'' and  ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
						)y 
					group by macongtrinh
				)z inner join dmcongtrinh b on z.macongtrinh=b.macongtrinh 
			where @@ps
			group by z.macongtrinh,b.tencongtrinh
END
-- Lấy kết quả in báo cáo
Select	JobCode as macongtrinh, JobName as TenCongtrinh,
		TienDDDk as [Dở dang đầu kỳ], Material as [Chi phí nguyên vật liệu],
		Labor as [Chi phí nhân công trực tiếp], Machine as [Chi phí máy thi công],
		CPThauPhu as [Chi phí Thuê thầu phụ], CommonCost as [Chi phí sản xuất chung],
		SumCost as [Tổng chi phí], JobCost as [Giá thành công trình],
		TienDDCk as [Dở dang cuối kỳ] 
from @tbResult'
where ReportName = N'Bảng Chi phí và Giá thành Công trình'