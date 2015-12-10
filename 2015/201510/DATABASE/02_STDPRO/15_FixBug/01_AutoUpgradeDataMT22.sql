declare @MT22ID as uniqueidentifier
declare @DT22ID as uniqueidentifier
declare @OldMT22ID as uniqueidentifier

declare @TienNK as decimal(20,6)
declare @TotalGNK as decimal(20,6)
declare @SoLuong as decimal(20,6)

set @TotalGNK = 0

declare cur_DT22 cursor for
select dt.DT22ID, dt.MT22ID, 
isnull(dt.Ps,0) - isnull(dt.TienCK,0) + isnull(ttdb.TienTTDB, 0) + isnull(dt.CPCt, 0) as [TienNK], dt.SoLuong
from MT22 mst inner join DT22 dt on mst.MT22ID = dt.MT22ID
left join TTDBin ttdb on ttdb.MTID = mst.MT22ID and ttdb.MTIDDT = dt.DT22ID
where dt.TienNK is null
order by dt.MT22ID

open cur_DT22
fetch next from cur_DT22 into @DT22ID, @MT22ID, @TienNK, @SoLuong

while @@FETCH_STATUS = 0
BEGIN

-- MTID moi
if @OldMT22ID is null or @OldMT22ID <> @MT22ID
BEGIN
	-- Reset gia tri
	set @OldMT22ID = @MT22ID
	set @TotalGNK = 0	
end
set @TotalGNK = @TotalGNK + @TienNK

Update DT22 set TienNK = @TienNK
where DT22ID = @DT22ID

Update MT22 set TotalGNK = @TotalGNK
where MT22ID = @MT22ID

Update BLVT set PsNo = @TienNK, DonGia = @TienNK / @SoLuong
where MTIDDT = @DT22ID and NhomDk = 'PNM1'

-- get next record
fetch next from cur_DT22 into @DT22ID, @MT22ID, @TienNK, @SoLuong
	
END

close cur_DT22
deallocate cur_DT22

GO

--==================================== Nguyên tệ ====================================
declare @MT22ID as uniqueidentifier
declare @DT22ID as uniqueidentifier
declare @OldMT22ID as uniqueidentifier

declare @TienNKNT as decimal(20,6)
declare @TotalGNKNT as decimal(20,6)
declare @SoLuong as decimal(20,6)

set @TotalGNKNT = 0

declare cur_DT22 cursor for
select dt.DT22ID, dt.MT22ID, 
isnull(dt.PsNT,0) - isnull(dt.TienCKNT,0) + isnull(ttdb.TienTTDBNT, 0) + isnull(dt.CPCtNT, 0) as [TienNKNT], dt.SoLuong
from MT22 mst inner join DT22 dt on mst.MT22ID = dt.MT22ID
left join TTDBin ttdb on ttdb.MTID = mst.MT22ID and ttdb.MTIDDT = dt.DT22ID
where dt.TienNKNT is null
order by dt.MT22ID

open cur_DT22
fetch next from cur_DT22 into @DT22ID, @MT22ID, @TienNKNT, @SoLuong

while @@FETCH_STATUS = 0
BEGIN

-- MTID moi
if @OldMT22ID is null or @OldMT22ID <> @MT22ID
BEGIN
	-- Reset gia tri
	set @OldMT22ID = @MT22ID
	set @TotalGNKNT = 0	
end
set @TotalGNKNT = @TotalGNKNT + @TienNKNT

Update DT22 set TienNKNT = @TienNKNT
where DT22ID = @DT22ID

Update MT22 set TotalGNKNT = @TotalGNKNT
where MT22ID = @MT22ID

Update BLVT set PsNoNT = @TienNKNT, DonGiaNT = @TienNKNT / @SoLuong
where MTIDDT = @DT22ID and NhomDk = 'PNM1'

-- get next record
fetch next from cur_DT22 into @DT22ID, @MT22ID, @TienNKNT, @SoLuong
	
END

close cur_DT22
deallocate cur_DT22