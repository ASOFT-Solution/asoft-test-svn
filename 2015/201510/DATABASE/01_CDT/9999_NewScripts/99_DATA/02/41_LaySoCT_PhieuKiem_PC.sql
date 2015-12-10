USE [CDT]

-- [CRM: TT9723]: Lấy số CT hiển thị lên báo cáo trường hợp kiêm phiếu chi
Update sysReport
set Query = N'declare @tungay datetime
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
	[GhiChu] [nvarchar](512),
	MTID uniqueidentifier,
	[stt] int,
	MaKH varchar(16),
	TenKH nvarchar(512))

create table #tbl_SoCT
 (
	[SOCT] [nvarchar](512)  NULL ,	
	MTID uniqueidentifier
) ON [PRIMARY]

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
                   Psco,[GhiChu], MTID, stt, MaKH, TenKH)
      SELECT mact,dbo.Layngayghiso(NgayCT),SoCt, NgayCT,DienGiai,
             Tk,Tkdu,MaNt,tygia,PsNoNt,
             PsCoNt,PsNo,Psco,'''' AS [Ghi chú], MTID, 1, MaKH, TenKH
      FROM   bltk
      WHERE  mact not in (select MACT from dmKetchuyen) and mact not in (select distinct MACT from MT52) and NgayCT = @NgayCT and @@ps
      --order by NgayCT,MTID, MTIDDT, NhomDK
      order by NgayCT,MTID, NhomDK
      -- Insert kết chuyển
      INSERT INTO #BLTK_TEMP
                  (mact,[NGS], SoCt, NgayCT, DienGiai,
                   Tk,Tkdu,MaNt,tygia,PsNoNt,
                   PsCoNt,PsNo, Psco,[GhiChu], MTID, stt, MaKH, TenKH)
      SELECT mact,dbo.Layngayghiso(NgayCT), SoCt, NgayCT, DienGiai,
             Tk, Tkdu,MaNt, tygia, PsNoNt, 
             PsCoNt, PsNo,  Psco, '''' AS [Ghi chú], MTID, 2, MaKH, TenKH
      FROM   bltk
      WHERE  mact in (select MACT from dmKetchuyen) and NgayCT = @NgayCT and @@ps
      --order by NgayCT,MTID, MTIDDT, NhomDK
      order by NgayCT,MTID, NhomDK
      FETCH NEXT FROM @cur INTO @NgayCT
  END
CLOSE @cur 

Insert into #tbl_SoCT
select distinct SOCT as SoCT, MT22ID as MTID from MT22
union all
select distinct SOCT, MT23ID from MT23
union all
select distinct SOCT, MT33ID from MT33
union all
select distinct SOCT, MT21ID from MT21
union all
select distinct SOCT, MT25ID from MT25

--Select data
Select MACT, NGS as [Ngày ghi sổ], 
case when exists (select top 1 SoCt from #tbl_SoCT where #tbl_SoCT.MTID = #BLTK_TEMP.MTID) then (select top 1 SoCt from #tbl_SoCT where #tbl_SoCT.MTID = #BLTK_TEMP.MTID) else
#BLTK_TEMP.SoCt end as SoCt, 
NgayCT, DienGiai, 
Tk, Tkdu, MaNt,tygia, case when tygia = 1 then 0 else PsNoNt end as PsNoNt, case when tygia = 1 then 0 else PsCoNt end as PsCoNt,PsNo, Psco, '''' as [Ghi chú], MTID, MaKH, TenKH
from #BLTK_TEMP
order by stt, NgayCT, SoCt
Drop table #BLTK_TEMP
Drop table #tbl_SoCT'
where ReportName = N'Sổ nhật ký chung'