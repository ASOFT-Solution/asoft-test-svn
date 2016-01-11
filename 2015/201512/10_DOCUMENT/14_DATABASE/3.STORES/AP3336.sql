/****** Object:  StoredProcedure [dbo].[AP3336]    Script Date: 07/29/2010 11:48:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/


ALTER PROCEDURE [dbo].[AP3336] @Find nvarchar(4000), @Date as datetime, @Room as nvarchar(50), @Filter as nvarchar(4000) = ''

AS

Declare @sql nvarchar(4000)
Declare @sql1 nvarchar(4000)
Set @Room = Case When @Room = '' Then '%' Else @Room End
Set @Filter = Case When @Filter = '' Then '' Else ' And A01.Ma In(' +  @Filter +')'  End

 
If @Find = ''
	Begin
		Set @sql = '
		SELECT 
			(Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End) AS [Soá phoøng],
			A03.Ten AS [Teân khaùch], 
			A01.Ngay AS [Ngaøy],
			A01.MaHoaDonTay AS [Maõ Bill],   
		        	A01.MaDichVu AS [Maõ dòch vuï],
			T01.InventoryName AS [Teân dòch vuï], 
			A01.MoTaDichVu AS [Moâ taû dòch vuï],
		        	A01.SoTien*A01.QuyDoi  AS [Soá tieàn],
			A01.MaThanhToan AS [Maõ thanh toaùn],
			A05.CongTyDuLich AS [Maõ coâng ty], 
			(Select CongTy From AsaHotel..CongTy Where Ma = A05.CongTyDuLich) AS [Teân coâng ty],
		        	A01.MaBoPhan AS [Maõ boä phaän],
			A03.NgayDen AS [Ngaøy check in],
			A03.NgayTraPhong AS [Ngaøy check out],
			A01.Ma As [Maõ heä thoáng]
		FROM   ASAHotel..HoaDonDichVu A01 LEFT OUTER JOIN
		        	ASAHotel..DichVu A02 ON A01.MaDichVu = A02.Ma LEFT OUTER JOIN
			ASAHotel..Khach A03 On A01.MaPhongThue2 = A03.MaPhongThue And A01.MaKhach2 = A03.MaKhach LEFT OUTER JOIN
			ASAHotel..PhongThue A04 On A01.MaPhongThue2 = A04.Ma LEFT OUTER JOIN
			ASAHotel..Dangky A05 On A01.MaDangKy2 = A05.Ma LEFT OUTER JOIN
		        	AT1302 T01 ON A01.MaDichVu = T01.InventoryID
		WHERE A01.MaThanhToan Is Not Null And A01.Sua = 0 And A01.Ma Not In (Select Ma From AT3333) 
			And isnull(A03.NgayTraPhong,'''') = ' + Case When @Date <> '01/01/1900' Then '''' + ltrim(@Date) + '''' Else 'isnull(A03.NgayTraPhong,'''')' End + ' 
			And (Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End) <> ''000'' And (Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End)  Like ''' + @Room  +  '''' + @Filter  + ' ORDER BY A04.Phong, A01.MaKhach1, A01.MaDichVu, A01.Ngay ' 

		EXEC (@sql)

		Set @sql1 = '
		SELECT TOP 100 PERCENT
			(Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End) AS Phong,
			A03.Ten, 
			A01.Ngay,
			A01.MaHoaDonTay,   
		        	A01.MaDichVu,
			T01.InventoryName, 
			A01.MoTaDichVu,
			A01.SoTien*A01.QuyDoi AS [BillAmount],

			Case When A01.MaDichVu In (''FB'',''LA'',''MA'',''MB'',''RM'') 
				Then 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) * 100 / (100 + A01.ThueDacBiet) * 100 / 105 
				Else 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) * 100 / (100 + A01.ThueDacBiet) 
				End AS [NetAmount],

			Case When A01.MaDichVu In (''FB'',''LA'',''MA'',''MB'',''RM'') 
				Then 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) * 100 / 105
				Else 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) 
				End AS [OriginalAmount],

		        	Case When A01.MaDichVu In (''FB'',''LA'',''MA'',''MB'',''RM'') 
				Then 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) * 5 / 105 
				Else 
					0
				End AS [ServiceCharge],

			A01.MaThanhToan,
			A05.CongTyDuLich, 
			(Select CongTy From AsaHotel..CongTy Where Ma = A05.CongTyDuLich) AS [Teân coâng ty],
		        	A01.MaBoPhan,
			A03.NgayDen,
			A03.NgayTraPhong,
			A01.Ma
		FROM   ASAHotel..HoaDonDichVu A01 LEFT OUTER JOIN
		        	ASAHotel..DichVu A02 ON A01.MaDichVu = A02.Ma LEFT OUTER JOIN
			ASAHotel..Khach A03 On A01.MaPhongThue2 = A03.MaPhongThue And A01.MaKhach2 = A03.MaKhach LEFT OUTER JOIN
			ASAHotel..PhongThue A04 On A01.MaPhongThue2 = A04.Ma LEFT OUTER JOIN
			ASAHotel..Dangky A05 On A01.MaDangKy2 = A05.Ma LEFT OUTER JOIN
		        	AT1302 T01 ON A01.MaDichVu = T01.InventoryID
		WHERE A01.MaThanhToan Is Not Null And A01.Sua = 0 And A01.Ma Not In (Select Ma From AT3333) 
			And isnull(A03.NgayTraPhong,'''') = ' + Case When @Date <> '01/01/1900' Then '''' + ltrim(@Date) + '''' Else 'isnull(A03.NgayTraPhong,'''')' End + ' 
			And (Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End) <> ''000'' And (Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End)  Like ''' + @Room  +  '''' + @Filter  + ' ORDER BY A04.Phong, A01.MaKhach1, A01.MaDichVu, A01.Ngay ' 
		
		If exists (Select Top 1 1 From sysobjects Where Id = Object_ID('AV3336') And xType = 'V')
		Begin
			Drop View AV3336
		End
		EXEC('Create View AV3336 --Create by AP3336
				As  ' + @sql1)	
		

	End
Else
	Begin
		Set @sql = '
		SELECT
			(Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End) AS [Soá phoøng], 
			A03.Ten AS [Teân khaùch], 			A01.Ngay AS [Ngaøy],
			A01.MaHoaDonTay AS [Maõ Bill],   
		        	A01.MaDichVu AS [Maõ dòch vuï],
			T01.InventoryName AS [Teân dòch vuï], 
			A01.MoTaDichVu AS [Moâ taû dòch vuï],
		        	A01.SoTien*A01.QuyDoi  AS [Soá tieàn],
			A01.MaThanhToan AS [Maõ thanh toaùn],
			A05.CongTyDuLich AS [Maõ coâng ty], 
			(Select CongTy From AsaHotel..CongTy Where Ma = A05.CongTyDuLich) AS [Teân coâng ty],
		        	A01.MaBoPhan AS [Maõ boä phaän],
			A03.NgayDen AS [Ngaøy check in],
			A03.NgayTraPhong AS [Ngaøy check out],
			A01.Ma As [Maõ heä thoáng]  
		FROM   ASAHotel..HoaDonDichVu A01 LEFT OUTER JOIN
		        	ASAHotel..DichVu A02 ON A01.MaDichVu = A02.Ma LEFT OUTER JOIN
			ASAHotel..Khach A03 On A01.MaPhongThue2 = A03.MaPhongThue And A01.MaKhach2 = A03.MaKhach LEFT OUTER JOIN
			ASAHotel..PhongThue A04 On A01.MaPhongThue2 = A04.Ma LEFT OUTER JOIN
			ASAHotel..Dangky A05 On A01.MaDangKy2 = A05.Ma LEFT OUTER JOIN
		        	AT1302 T01 ON A01.MaDichVu = T01.InventoryID
		WHERE A01.MaThanhToan Is Not Null AND A01.Sua = 0  And A01.Ma Not In (Select Ma From AT3333) 
			AND ' + @Find + ' And isnull(A03.NgayTraPhong,'''') = ' + Case When @Date <> '01/01/1900' Then '''' + ltrim(@Date) + '''' Else 'isnull(A03.NgayTraPhong,'''')' End + ' 
			And (Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End) <> ''000'' And (Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End)  Like ''' + @Room  + '''' +  @Filter  + ' ORDER BY A04.Phong, A01.MaKhach1,A01.MaDichVu, A01.Ngay'

		EXEC (@sql)

		Set @sql1 = '
		SELECT TOP 100 PERCENT
			(Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End) AS Phong,
			A03.Ten, 
			A01.Ngay,
			A01.MaHoaDonTay,   
		        	A01.MaDichVu,
			T01.InventoryName, 
			A01.MoTaDichVu,
		        	A01.SoTien*A01.QuyDoi AS [BillAmount],

			Case When A01.MaDichVu In (''FB'',''LA'',''MA'',''MB'',''RM'') 
				Then 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) * 100 / (100 + A01.ThueDacBiet) * 100 / 105 
				Else 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) * 100 / (100 + A01.ThueDacBiet) 
				End AS [NetAmount],

			Case When A01.MaDichVu In (''FB'',''LA'',''MA'',''MB'',''RM'') 
				Then 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) * 100 / 105
				Else 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) 
				End AS [OriginalAmount],

		        	Case When A01.MaDichVu In (''FB'',''LA'',''MA'',''MB'',''RM'') 
				Then 
					A01.SoTien*A01.QuyDoi  * 100 / (100 + A01.Thue) * 5 / 105 
				Else 
					0
				End AS [ServiceCharge],
			A01.MaThanhToan,
			A05.CongTyDuLich, 
			(Select CongTy From AsaHotel..CongTy Where Ma = A05.CongTyDuLich) AS [Teân coâng ty],
		        	A01.MaBoPhan,
			A03.NgayDen,
			A03.NgayTraPhong,
			A01.Ma
		FROM   ASAHotel..HoaDonDichVu A01 LEFT OUTER JOIN
		        	ASAHotel..DichVu A02 ON A01.MaDichVu = A02.Ma LEFT OUTER JOIN
			ASAHotel..Khach A03 On A01.MaPhongThue2 = A03.MaPhongThue And A01.MaKhach2 = A03.MaKhach LEFT OUTER JOIN
			ASAHotel..PhongThue A04 On A01.MaPhongThue2 = A04.Ma LEFT OUTER JOIN
			ASAHotel..Dangky A05 On A01.MaDangKy2 = A05.Ma LEFT OUTER JOIN
		        	AT1302 T01 ON A01.MaDichVu = T01.InventoryID
		WHERE A01.MaThanhToan Is Not Null AND A01.Sua = 0  And A01.Ma Not In (Select Ma From AT3333) 
			AND ' + @Find + ' And isnull(A03.NgayTraPhong,'''') = ' + Case When @Date <> '01/01/1900' Then '''' + ltrim(@Date) + '''' Else 'isnull(A03.NgayTraPhong,'''')' End + ' 
			And (Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End) <> ''000'' And (Case When A04.Phong Is Null Then cast(A01.MaDangKy2 as nvarchar(100)) Else A04.Phong End)  Like ''' + @Room  + '''' +  @Filter  + ' ORDER BY A04.Phong, A01.MaKhach1,A01.MaDichVu, A01.Ngay'	
		If exists (Select Top 1 1 From sysobjects Where Id = Object_ID('AV3336') And xType = 'V')
		Begin
			Drop View AV3336
		End

		EXEC('Create View AV3336 --Create by AP3336
				As  ' + @sql1)	
		

	End