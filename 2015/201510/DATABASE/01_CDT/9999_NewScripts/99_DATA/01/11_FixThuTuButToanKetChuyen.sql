use [CDT]

-- Thứ tự sổ nhật ký chung
Update sysReport set Query = N'declare @tungay datetime
declare @denngay datetime 

set @tungay = @@Ngayct1
set @denngay = DATEADD(hh,23,@@Ngayct2)

CREATE TABLE #BLTK_TEMP(
	[MaCT] [nvarchar](512),
	[NGS] [smalldatetime],
	[SoCT] [nvarchar](512),
	[NgayCT] [smalldatetime],
	[DienGiai] [nvarchar](512),
	[TK] [varchar](16),
	[TKDu] [varchar](16),
	[MaNT] [varchar](16),
	[TyGia] [decimal](28, 6),
	[PsNoNT] [decimal](28, 6),
	[PsCoNT] [decimal](28, 6),
	[PsNo] [decimal](28, 6),
	[PsCo] [decimal](28, 6),
	[GhiChu] [nvarchar](512))

DECLARE @NgayCT    smalldatetime, @cur       CURSOR

SET @cur = CURSOR
FOR SELECT DISTINCT NgayCT FROM   bltk
WHERE  @@ps					AND NgayCt BETWEEN @tungay AND @denngay 
OPEN @cur
FETCH NEXT FROM @cur INTO @NgayCT
WHILE @@FETCH_STATUS = 0
  BEGIN
      ----  insert chứng từ
      INSERT INTO #BLTK_TEMP
                  (mact,  NGS, SoCt, NgayCT,DienGiai,
                   Tk,Tkdu,MaNt,tygia, PsNoNt, PsCoNt,PsNo,
                   Psco,[GhiChu])
      SELECT mact,dbo.Layngayghiso(NgayCT),SoCt, NgayCT,DienGiai,
             Tk,Tkdu,MaNt,tygia,PsNoNt,
             PsCoNt,PsNo,Psco,'''' AS [Ghi chú]
      FROM   bltk
      WHERE  mact not in (select MACT from dmKetchuyen) and NgayCT = @NgayCT
      order by NgayCT,MTID, MTIDDT, NhomDK
      -- Insert kết chuyển
      INSERT INTO #BLTK_TEMP
                  (mact,[NGS], SoCt, NgayCT, DienGiai,
                   Tk,Tkdu,MaNt,tygia,PsNoNt,
                   PsCoNt,PsNo, Psco,[GhiChu])
      SELECT mact,dbo.Layngayghiso(NgayCT), SoCt, NgayCT, DienGiai,
             Tk, Tkdu,MaNt, tygia, PsNoNt, 
             PsCoNt, PsNo,  Psco, '''' AS [Ghi chú]
      FROM   bltk
      WHERE  mact in (select MACT from dmKetchuyen) and NgayCT = @NgayCT
      order by NgayCT,MTID, MTIDDT, NhomDK
      FETCH NEXT FROM @cur INTO @NgayCT
  END
CLOSE @cur 
--Select data
Select mact, NGS as [Ngày ghi sổ], 
SoCt, NgayCT, DienGiai, 
Tk, Tkdu, MaNt,tygia, PsNoNt, PsCoNt,PsNo, Psco, '''' as [Ghi chú]
from #BLTK_TEMP
Drop table #BLTK_TEMP'
where ReportName = N'Sổ nhật ký chung'
