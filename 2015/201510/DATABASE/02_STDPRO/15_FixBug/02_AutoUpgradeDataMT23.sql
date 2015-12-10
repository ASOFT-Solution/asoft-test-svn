declare @MT23ID as uniqueidentifier
declare @DT23ID as uniqueidentifier
declare @OldMT23ID as uniqueidentifier

declare @TienNK as decimal(20,6)
declare @TotalGNK as decimal(20,6)
declare @SoLuong as decimal(20,6)

set @TotalGNK = 0

declare cur_DT23 cursor for
select dt.DT23ID, dt.MT23ID, 
isnull(dt.Ps,0) - isnull(dt.TienCK,0) + isnull(dt.CtThueNk,0) + isnull(ttdb.TienTTDB, 0) + isnull(dt.CPCt, 0) as [TienNK], dt.SoLuong
from MT23 mst inner join DT23 dt on mst.MT23ID = dt.MT23ID
left join TTDBin ttdb on ttdb.MTID = mst.MT23ID and ttdb.MTIDDT = dt.DT23ID
where dt.TienNK is null
order by dt.MT23ID

open cur_DT23
fetch next from cur_DT23 into @DT23ID, @MT23ID, @TienNK, @SoLuong

while @@FETCH_STATUS = 0
BEGIN

-- MTID moi
if @OldMT23ID is null or @OldMT23ID <> @MT23ID
BEGIN
	-- Reset gia tri
	set @OldMT23ID = @MT23ID
	set @TotalGNK = 0	
end
set @TotalGNK = @TotalGNK + @TienNK

Update DT23 set TienNK = @TienNK
where DT23ID = @DT23ID

Update MT23 set TotalGNK = @TotalGNK
where MT23ID = @MT23ID

Update BLVT set PsNo = @TienNK, DonGia = @TienNK / @SoLuong
where MTIDDT = @DT23ID and NhomDk = 'PNK1'

-- get next record
fetch next from cur_DT23 into @DT23ID, @MT23ID, @TienNK, @SoLuong
	
END

close cur_DT23
deallocate cur_DT23

GO

--==================================== Nguyên tệ ====================================
declare @MT23ID as uniqueidentifier
declare @DT23ID as uniqueidentifier
declare @OldMT23ID as uniqueidentifier

declare @TienNKNT as decimal(20,6)
declare @TotalGNKNT as decimal(20,6)
declare @SoLuong as decimal(20,6)

set @TotalGNKNT = 0

declare cur_DT23 cursor for
select dt.DT23ID, dt.MT23ID, 
isnull(dt.PsNT,0) - isnull(dt.TienCKNT,0) + isnull(dt.CtThueNkNT,0) + isnull(ttdb.TienTTDBNT, 0) + isnull(dt.CPCtNT, 0) as [TienNKNT], dt.SoLuong
from MT23 mst inner join DT23 dt on mst.MT23ID = dt.MT23ID
left join TTDBin ttdb on ttdb.MTID = mst.MT23ID and ttdb.MTIDDT = dt.DT23ID
where dt.TienNKNT is null
order by dt.MT23ID

open cur_DT23
fetch next from cur_DT23 into @DT23ID, @MT23ID, @TienNKNT, @SoLuong

while @@FETCH_STATUS = 0
BEGIN

-- MTID moi
if @OldMT23ID is null or @OldMT23ID <> @MT23ID
BEGIN
	-- Reset gia tri
	set @OldMT23ID = @MT23ID
	set @TotalGNKNT = 0	
end
set @TotalGNKNT = @TotalGNKNT + @TienNKNT

Update DT23 set TienNKNT = @TienNKNT
where DT23ID = @DT23ID

Update MT23 set TotalGNKNT = @TotalGNKNT
where MT23ID = @MT23ID

Update BLVT set PsNoNT = @TienNKNT, DonGiaNT = @TienNKNT / @SoLuong
where MTIDDT = @DT23ID and NhomDk = 'PNK1'

-- get next record
fetch next from cur_DT23 into @DT23ID, @MT23ID, @TienNKNT, @SoLuong
	
END

close cur_DT23
deallocate cur_DT23