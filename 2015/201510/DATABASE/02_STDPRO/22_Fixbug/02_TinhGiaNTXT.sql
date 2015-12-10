IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TinhGiaNTXT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TinhGiaNTXT]
GO

/****** Object:  StoredProcedure [dbo].[TinhGiaNTXT]    Script Date: 02/14/2012 16:24:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TinhGiaNTXT]
@mtiddt uniqueidentifier,
@denngay datetime,
@makho varchar(16),
@mavt varchar(16),
@SlXuat decimal(16,6),
@DonGiaXuat float output
AS

--1.Xác định số lượng tồn
declare @SlTon decimal(16,6)
if (@mtiddt is null)
begin
	select @SlTon = sum(SoLuong - SoLuong_x) 
	from wBLVT 
	where NgayCT <= @DenNgay
	group by MaKho, MaVT
	having MaKho = @MaKho and MaVT = @MaVT
	--2.Tìm tất cả chứng từ nhập
	declare curNhap cursor for
	select DonGia, SoLuong
	from wBLVT
	where SoLuong > 0 and NgayCT <= @DenNgay and MaVT = @MaVT and MaKho = @MaKho
	order by NgayCT desc
end
else
begin
	select @SlTon = sum(SoLuong - SoLuong_x) 
	from wBLVT 
	where NgayCT <= @DenNgay and (MTIDDT is null or MTIDDT <> @mtiddt)
	group by MaKho, MaVT
	having MaKho = @MaKho and MaVT = @MaVT
	--2.Tìm tất cả chứng từ nhập
	declare curNhap cursor for
	select DonGia, SoLuong
	from wBLVT
	where SoLuong > 0 and NgayCT <= @DenNgay and MaVT = @MaVT and MaKho = @MaKho
	and (MTIDDT is null or MTIDDT <> @mtiddt)
	order by NgayCT desc
end
--3.Duyệt tất cả chứng từ nhập để đưa vào bảng tạm những chứng từ xa nhất
create table #t(
DonGia decimal(16,6),
SoLuong decimal(16,6))
declare @DonGia decimal(16,6), @SoLuong decimal(16,6)
open curNhap
fetch next from curNhap into @DonGia,@SoLuong
while (@@fetch_status = 0)
begin
	if (@SlTon <= 0)
		break
	if @SlTon > @SoLuong
		insert into #t(DonGia,SoLuong) values(@DonGia,@SoLuong)
	else
		insert into #t(DonGia,SoLuong) values(@DonGia,@SlTon)
	set @SlTon = @SlTon - @SoLuong
	fetch next from curNhap into @DonGia,@SoLuong
end
close curNhap
deallocate curNhap
--4.Duyệt chứng từ xa nhất để xuất theo FIFO
create table #t1(
DonGia decimal(16,6),
SoLuong decimal(16,6),
ThanhTien decimal(16,6))
declare curNhap1 scroll cursor for select * from #t
open curNhap1
fetch last from curNhap1 into @DonGia,@SoLuong
while (@@fetch_status = 0)
begin
	if (@SlXuat <= 0)
		break
	if @SlXuat > @SoLuong
		insert into #t1(DonGia,SoLuong) values(@DonGia,@SoLuong)
	else
		insert into #t1(DonGia,SoLuong) values(@DonGia,@SlXuat)
	set @SlXuat = @SlXuat - @SoLuong
	fetch prior from curNhap1 into @DonGia,@SoLuong
end
close curNhap1
deallocate curNhap1
--5.Lấy giá xuất
update #t1 set ThanhTien = SoLuong*DonGia
select @DonGiaXuat = case when Sum(SoLuong)>0 then sum(ThanhTien)/sum(SoLuong) else 0 end
from #t1
