-- OBNTXT
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBNTXT'  and col.name = 'TKkho')
BEGIN
	ALTER TABLE OBNTXT ADD  TKkho [varchar](16) NULL 
END

-- OBVT
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBVT'  and col.name = 'TKkho')
BEGIN
	ALTER TABLE OBVT ADD  TKkho [varchar](16) NULL 
END

-- OBTK
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBTK'  and col.name = 'TrangThaiVT')
BEGIN
	ALTER TABLE OBTK ADD  TrangThaiVT bit not null CONSTRAINT [df_obtk_TrangThaiVT] DEFAULT (0)
END

GO

-- Cập nhật số liệu table OBVT
declare @MaVT varchar(16)

declare cur_ob cursor for 
select MaVT from OBVT

open cur_ob

fetch next from cur_ob into @MaVT

WHILE @@FETCH_STATUS = 0
BEGIN

Update OBVT set TKkho = (select TKKho from DMVT vt where vt.MaVT = MaVT and vt.MaVT = @MaVT)
where TKkho is null and MaVT = @MaVT

fetch next from cur_ob into @MaVT
END

close cur_ob
deallocate cur_ob


-- Cập nhật số liệu table OBNTXT
declare cur_ob cursor for 
select MaVT from OBNTXT

open cur_ob

fetch next from cur_ob into @MaVT

WHILE @@FETCH_STATUS = 0
BEGIN

Update OBNTXT set TKkho = (select TKKho from DMVT vt where vt.MaVT = MaVT and vt.MaVT = @MaVT)
where TKkho is null and MaVT = @MaVT

fetch next from cur_ob into @MaVT
END

close cur_ob
deallocate cur_ob

-- Cập nhật số liệu table OBTK
declare @TK varchar(16)
declare @TrangThaiVT bit
declare @obvt decimal(28,6)
declare @obvtNT decimal(28,6)
declare @obntxt decimal(28,6)
declare @obntxtNT decimal(28,6)
declare @totalDuDau decimal(28,6)
declare @totalDuDauNT decimal(28,6)

declare cur_ob cursor for 
select TK from OBTK where TK like N'15%'

open cur_ob

fetch next from cur_ob into @TK

WHILE @@FETCH_STATUS = 0
BEGIN

set @TrangThaiVT = 0

if exists (select top 1 1 from OBNTXT where TKkho = @TK)
	set @TrangThaiVT = 1

if exists (select top 1 1 from OBVT where TKkho = @TK)
	set @TrangThaiVT = 1	

if @TrangThaiVT = 1
BEGIN
	select @obvt = sum(DuDau), @obvtNT = sum(DuDauNT) from OBVT where TKkho = @TK group by TkKho
	select @obntxt = sum(DuDau), @obntxtNT = sum(DuDauNT) from OBNTXT where TKkho = @TK group by TkKho

	set @totalDuDau = isnull(@obvt,0) + isnull(@obntxt,0)
	set @totalDuDauNT = isnull(@obvtNT,0) + isnull(@obntxtNT,0)

	if (select count(*) from OBTK where TK = @TK and TrangThaiVT = 0) >= 2
	BEGIN
		delete from OBTK where TK = @TK
		
		insert into OBTK(TK, DuNo, DuCo, DuNoNT, DuCoNT, MaNT, MaBP, MaVV, MaPhi, TrangThaiVT)
		values (@TK, @totalDuDau, 0, @totalDuDauNT, 0 , 'VND', NULL, NULL, NULL, 1)
	END
	else if (select count(*) from OBTK where TK = @TK and TrangThaiVT = 0) = 1
	BEGIN
		Update OBTK set DuNo = @totalDuDau, DuCo = 0, DuNoNT = @totalDuDauNT, DuCoNT = 0, TrangThaiVT = 1
		where TK = @TK
	END
END
fetch next from cur_ob into @TK
END

close cur_ob
deallocate cur_ob