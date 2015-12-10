use [CDT]

Update sysReport set Query = N'declare @pstk float
declare @sltk float
set @sltk=(select sum(soluong)-sum(soluong_X) from blvt where NGAYCT < @@ngayct1 AND  MAVT = @@mavt  AND @@ps)
 set @sltk=case when @sltk is  null then 0 else @sltk end
set @pstk=(select sum(psno)-sum(psco) from blvt where NGAYCT < @@ngayct1 AND  MAVT = @@mavt  AND @@ps)
 set @pstk=case when @pstk is  null then 0 else @pstk end
declare @psdk float, @psdk1 float
declare @sldk float, @sldk1 float

set @sldk=(select sum(soluong) from obvt where   MAVT = @@mavt  AND @@ps) 
set @sldk1=(select sum(soluong) from obntxt where   MAVT = @@mavt  AND @@ps)
 set @sldk=case when @sldk is  null then 0 else @sldk end + case when @sldk1 is  null then 0 else @sldk1 end
set @psdk=(select sum(dudau) from obvt where  MAVT = @@mavt  AND @@ps)
set @psdk1=(select sum(dudau) from obntxt where  MAVT = @@mavt  AND @@ps)
 set @psdk=case when @psdk is  null then 0 else @psdk end + case when @psdk1 is  null then 0 else @psdk1 end
select y.tenvt, x.* from (

SELECT NULL NGAYCT,null as MACT, NULL AS MTID, NULL SOCT, NULL TENKH, case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end as DIENGIAI, NULL DONGIA, @@mavt mavt,
	 @sltk + @sldk soluong, @pstk+@psdk [Giá trị nhập], NULL SOLUONG_X, NULL [Giá trị xuất]
UNION all
SELECT NGAYCT,MACT,MTID, SOCT, DMKH.TENKH , DIENGIAI, DONGIA,   @@mavt mavt,
	SOLUONGN = CASE WHEN SOLUONG > 0 THEN SOLUONG ELSE NULL END, GIATRIN = CASE WHEN PSNO > 0 THEN PSNO ELSE NULL END,
	SOLUONGX = CASE WHEN SOLUONG_X > 0 THEN SOLUONG_X ELSE NULL END, GIATRIX = CASE WHEN PSCO > 0 THEN PSCO ELSE NULL END
FROM BLVT, DMKH
WHERE BLVT.MAKH *= DMKH.MAKH AND NGAYCT BETWEEN @@ngayct1 AND @@ngayct2 AND   MAVT = @@mavt AND @@ps) x, dmvt y 
where x.mavt=y.mavt
Order by x.NGAYCT
'
where ReportName = N'Sổ chi tiết vật tư'