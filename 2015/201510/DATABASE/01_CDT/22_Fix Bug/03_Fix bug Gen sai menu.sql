USE [CDT]

delete from sysMenu 
where sysSiteID is null
and MenuName IN (N'Khấu trừ, điều chỉnh, hoàn thuế', 
				N'Bảng phân bổ thuế được khấu trừ tháng',
				N'Bảng phân bổ thuế được khấu trừ năm',
				N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra',
				N'Thuế khác')
