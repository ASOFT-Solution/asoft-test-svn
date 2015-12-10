-- [ACC_TÍN THỊNH PHÁT] Lỗi báo cáo chênh lệch giá vốn và giá bán: Lấy thiếu dữ liệu do trường hợp Divide zero
USE [CDT]

Update sysReport
set Query = N'select x.mavt, 
	(select case when @@lang = 1 then k.tenvt2 else k.tenvt end from dmvt k where k.mavt = x.mavt) as tenvt, SUM(x.soluong) as [Số lượng tiêu thụ], 
	case when SUM(x.soluong) = 0 then 0 else SUM(x.tienvon) / SUM(x.soluong) end as [Đơn giá (Giá vốn)], 
	SUM(x.tienvon) as [Giá vốn], 
	case when SUM(x.soluong) = 0 then 0 else SUM(x.ps - x.ck) / SUM(x.soluong) end as [Đơn giá (Giá bán)], 
	SUM(x.ps - x.ck) as [Giá bán], 
	SUM(x.ps - x.ck - x.tienvon) as [Chênh lệch],  
	x.loaiVT
	from (select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, giavon, tienvon, mabp, loaiVT
		from mt32, dt32, dmvt v
		where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
		union all
		select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, giavon, -tienvon, mabp, loaiVT
		from mt33, dt33, dmvt v
		where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt) x, 
		vatout vo, dmbophan b
	where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
	Group by x.mavt, x.tenvt, x.loaiVT
	order by x.mavt'
where ReportName = N'Báo cáo chi tiết chênh lệch giá vốn và giá bán'