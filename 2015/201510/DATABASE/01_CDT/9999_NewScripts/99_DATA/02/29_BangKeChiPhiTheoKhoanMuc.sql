Use CDT

-- [CRM: TT9230]: Bổ sung điều kiện hiển thị các chứng từ có chi phí
-- ''BC2'',''DCN'',''HDB'',''HDV'',''HTL'',''KTT'',''NSX'',''PBC'',''PDC'',''PNB'',''PT'',''PT2'',''PTH'',''PXC'',''PXK''
Update sysReport set Query = N'declare @TK1 varchar(16)
declare @TK2 varchar(16)
declare @TKDU1 varchar(16)
declare @TKDU2 varchar(16)

declare @sql nvarchar(4000)

set @TK1 = @@TK1
set @TK2 = @@TK2
set @TKDU1 = @@TKDU1
set @TKDU2 = @@TKDU2

set @sql = N''
IF OBJECT_ID(''''tempdb..#t'''') IS NOT NULL
BEGIN
	DROP TABLE #t
END

IF OBJECT_ID(''''tempdb..#t2'''') IS NOT NULL
BEGIN
	DROP TABLE #t2
END

select distinct b.mact ,b.SOCT , b.NGAYCT ,b.diengiai, b.MAKH ,b.tenkh ,
b.MAPHI,ph.tenphi , b.mant, b.tygia ,
b.MABP,bp.tenbp ,  b.TK as [Tài khoản nợ], b.TKDU as [Tài khoản có], b.PSNO as [Thành tiền], psnont as [Thành tiền NT] , MTID, MTIDDT
into #t
from bltk  b left join dmphi ph on b.maphi=ph.maphi left join dmbophan bp on b.mabp=bp.mabp 
where mact in (''''PC'''', ''''PBN'''',  ''''MDV'''', ''''PNK'''', ''''PXT'''', ''''MCP'''', ''''PTT'''', ''''PNH'''', ''''PKT'''', ''''PNM'''',''''BC2'''',''''DCN'''',''''HDB'''',''''HDV'''',''''HTL'''',''''KTT'''',''''NSX'''',''''PBC'''',''''PDC'''',''''PNB'''',''''PT'''',''''PT2'''',''''PTH'''',''''PXC'''',''''PXK'''')AND PSNO<>0
and MTIDDT is not null

select distinct b.mact ,b.SOCT , b.NGAYCT ,b.diengiai, b.MAKH ,b.tenkh ,
t.MAPHI,ph.tenphi , b.mant, b.tygia ,
t.MABP,bp.tenbp ,  b.TK as [Tài khoản nợ], b.TKDU as [Tài khoản có] , vat.Thue as [Thành tiền], vat.ThueNT as [Thành tiền NT], b.MTID, t.MTIDDT
into #t2
from (bltk  b inner join #t t on b.MTID = t.MTID) left join vatin vat on t.MTIDDT = vat.MTIDDT left join dmphi ph on t.maphi=ph.maphi left join dmbophan bp on t.mabp=bp.mabp
where b.mact in (''''PC'''', ''''PBN'''',  ''''MDV'''', ''''PNK'''', ''''PXT'''', ''''MCP'''', ''''PTT'''', ''''PNH'''', ''''PKT'''', ''''PNM'''',''''BC2'''',''''DCN'''',''''HDB'''',''''HDV'''',''''HTL'''',''''KTT'''',''''NSX'''',''''PBC'''',''''PDC'''',''''PNB'''',''''PT'''',''''PT2'''',''''PTH'''',''''PXC'''',''''PXK'''')AND b.PSNO<>0
and b.MTIDDT is null

select * from (
select mact , SOCT , NGAYCT , diengiai, MAKH ,tenkh ,
MAPHI, tenphi , mant, tygia ,
MABP, tenbp ,  [Tài khoản nợ], [Tài khoản có], [Thành tiền], [Thành tiền NT] 
from #t

union all 

select mact ,SOCT , NGAYCT ,diengiai, MAKH ,tenkh ,
MAPHI, tenphi , mant, tygia ,
MABP, tenbp ,  [Tài khoản nợ], [Tài khoản có], [Thành tiền], [Thành tiền NT] 
from #t2

union all
select distinct b.mact ,b.SOCT , b.NGAYCT ,b.diengiai, b.MAKH ,b.tenkh ,
b.MAPHI,ph.tenphi , b.mant , b.tygia ,
b.MABP,bp.tenbp ,  b.TK as [Tài khoản nợ], b.TKDU as [Tài khoản có], b.PSNO as [Thành tiền], psnont as [Thành tiền NT] 
from bltk  b left join dmphi ph on b.maphi=ph.maphi left join dmbophan bp on b.mabp=bp.mabp where mact = ''''PC2'''' AND PSNO<>0 and b.tkdu like ''''11%''''
union all
select distinct b.mact ,b.SOCT , b.NGAYCT ,b.diengiai, b.MAKH ,b.tenkh ,
b.MAPHI,ph.tenphi , b.mant , b.tygia ,
b.MABP,bp.tenbp ,  b.TK as [Tài khoản nợ], b.TKDU as [Tài khoản có], b.PSNO as [Thành tiền], psnont as [Thành tiền NT] 
from bltk  b left join dmphi ph on b.maphi=ph.maphi left join dmbophan bp on b.mabp=bp.mabp where mact = ''''BN2'''' AND PSNO<>0 and b.tkdu like ''''11%''''
) x
where x.ngayCt between cast('' + ''''@@ngayct1'''' + '' as datetime) and cast('' + ''''@@ngayct2'''' + '' as datetime) and '' + @@ps

if @TK1 <> '''' and @TK2 = ''''
	set @sql = @sql + N'' and left(x.[Tài khoản nợ], '' + convert(varchar(16), len(@TK1)) + '') >= '''''' + @TK1 + ''''''''
else if @TK2 <> '''' and @TK1 = ''''
	set @sql = @sql + N'' and left(x.[Tài khoản nợ], '' + convert(varchar(16), len(@TK2)) + '') <= '''''' + @TK2 + ''''''''
else if @TK1 <> '''' and @TK2 <> ''''
	set @sql = @sql + N'' and left(x.[Tài khoản nợ], '' + convert(varchar(16), len(@TK1)) + '') >= '''''' + @TK1 + ''''''''
					+ N'' and left(x.[Tài khoản nợ], '' + convert(varchar(16), len(@TK2)) + '') <= '''''' + @TK2 + ''''''''

if @TKDU1 <> '''' and @TKDU2 = ''''
	set @sql = @sql + N'' and left(x.[Tài khoản có], '' + convert(varchar(16), len(@TKDU1)) + '') >= '''''' + @TKDU1 + ''''''''
else if @TKDU2 <> '''' and @TKDU1 = ''''
	set @sql = @sql + N'' and left(x.[Tài khoản có], '' + convert(varchar(16), len(@TKDU2)) + '') <= '''''' + @TKDU2 + ''''''''
else if @TKDU1 <> '''' and @TKDU2 <> ''''
	set @sql = @sql + N'' and left(x.[Tài khoản có], '' + convert(varchar(16), len(@TKDU1)) + '') >= '''''' + @TKDU1 + ''''''''
					+ N'' and left(x.[Tài khoản có], '' + convert(varchar(16), len(@TKDU2)) + '') <= '''''' + @TKDU2 + ''''''''
	
set @sql = @sql + '' order by SoCT, ngayCT 
drop table #t
drop table #t2''

exec(@sql)'
where ReportName = N'Bảng kê chi phí theo khoản mục'