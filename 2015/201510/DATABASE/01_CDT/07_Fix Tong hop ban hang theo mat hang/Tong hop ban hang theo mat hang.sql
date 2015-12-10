use [CDT]

update sysReport 
set Query = N'select x.ngayct, x.sohoadon, x.makh, x.tenkh, x.mavt, x.tenvt, x.soluong, x.gia, x.ps, x.ck, sltl as [Số lượng trả lại], gttl as [Giá trị trả lại], x.ps - x.ck as [Doanh số], vo.thue, x.giavon, x.tienvon, x.ps - x.ck - x.tienvon as [Lãi gộp], x.mabp, b.tenbp, x.loaivt, case when x.loaivt=1 then N''Hàng hóa'' when x.loaivt=2 then N''Nguyên liệu'' when x.loaivt=3 then N''Công cụ dụng cụ'' when x.loaivt=4 then N''thành phẩm'' when x.loaivt=5 then N''TSCĐ'' when x.loaivt=6 then N''Dịch vụ'' else '''' end N''Tên loại vật tư'' from ( select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, giavon, tienvon, mabp, 0 ''sltl'', 0 ''gttl'', v.loaivt from mt32, dt32, dmvt v where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt union all select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, giavon, -tienvon, mabp, soluong ''sltl'', ps ''gttl'', v.loaivt from mt33, dt33, dmvt v where mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt ) x, vatout vo, dmbophan b where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps order by x.ngayct, x.sohoadon, x.mavt'
where ReportName = N'Báo cáo lãi gộp hàng hóa'

if not exists (select top 1 1 from Dictionary where Content = N'Giảm giá/ Chiết khấu')
                 insert Dictionary (Content, Content2) values (N'Giảm giá/ Chiết khấu', N'Discount')

if not exists (select top 1 1 from Dictionary where Content = N'Số lượng trả lại')
                 insert Dictionary (Content, Content2) values (N'Số lượng trả lại', N'Return quantity')

if not exists (select top 1 1 from Dictionary where Content = N'Giá trị trả lại')
                 insert Dictionary (Content, Content2) values (N'Giá trị trả lại', N'Return amount')

if not exists (select top 1 1 from Dictionary where Content = N'Tỉ lệ lãi gộp (%)')
                 insert Dictionary (Content, Content2) values (N'Tỉ lệ lãi gộp (%)', N'Interest rate margin (%)')

if not exists (select top 1 1 from Dictionary where Content = N'Mã loại vật tư')
                 insert Dictionary (Content, Content2) values (N'Mã loại vật tư', N'Materials code')

if not exists (select top 1 1 from Dictionary where Content = N'Tên loại vật tư')
                 insert Dictionary (Content, Content2) values (N'Tên loại vật tư', N'Materials name')