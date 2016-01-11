/****** Object:  StoredProcedure [dbo].[AP3337]    Script Date: 07/29/2010 11:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[AP3337] @Find nvarchar(4000), @Date as datetime

AS

Declare @sql nvarchar(4000)
Declare @sql1 nvarchar(4000)

If @Find = ''
	Begin
		Set @sql = '
			SELECT 
				A01.Kho_MaSo, 
				T02.WareHouseName,
				A01.PNX_NgayNhanHang,
				A02.HH_MaSo,
				T01.InventoryName,
				Sum(A02.CTNX_SoLuong) As [Quantity]
			FROM 	
				ASAHotel..FB_PhieuNhapXuat A01 INNER JOIN 
				ASAHotel..FB_ChiTietPhieuNhapXuat A02 ON A01.PNX_MaSo = A02.PNX_MaSo LEFT OUTER JOIN 
				AT1302 T01 ON A02.HH_MaSo = T01.InventoryID LEFT OUTER JOIN 
				AT1303 T02 ON A01.Kho_MaSo = T02.WareHouseID
			WHERE A01.PNX_LoaiDonHang = ''0'' And ltrim(A01.PNX_NgayNhanHang) + ''_'' + ltrim(A01.Kho_MaSo) + ''_'' + ltrim(A02.HH_MaSo)  Not In (Select Ma From AT3332) 
				AND T01.InventoryID In (Select InventoryID From AT1302 Where InventoryTypeID = ''H'')  And Cast(Substring(A01.PNX_NgayNhanHang,5,2) + ''/'' + Right(A01.PNX_NgayNhanHang,2) + ''/'' + Left(A01.PNX_NgayNhanHang,4) As Datetime) = ''' + ltrim(@Date) + ''' 
			GROUP BY A01.Kho_MaSo, T02.WareHouseName, A01.PNX_NgayNhanHang, A02.HH_MaSo, T01.InventoryName
			ORDER BY A01.Kho_MaSo, A02.HH_MaSo' 

			EXEC (@sql)

		Set @sql1 = '
			SELECT TOP 100 PERCENT 
				A01.Kho_MaSo, 
				T02.WareHouseName,
				A01.PNX_NgayNhanHang,
				A02.HH_MaSo,
				T01.InventoryName,
				Sum(A02.CTNX_SoLuong) As [Quantity]
			FROM 	
				ASAHotel..FB_PhieuNhapXuat A01 INNER JOIN 
				ASAHotel..FB_ChiTietPhieuNhapXuat A02 ON A01.PNX_MaSo = A02.PNX_MaSo LEFT OUTER JOIN 
				AT1302 T01 ON A02.HH_MaSo = T01.InventoryID LEFT OUTER JOIN 
				AT1303 T02 ON A01.Kho_MaSo = T02.WareHouseID
			WHERE A01.PNX_LoaiDonHang = ''0'' And ltrim(A01.PNX_NgayNhanHang) + ''_'' + ltrim(A01.Kho_MaSo) + ''_'' + ltrim(A02.HH_MaSo) Not In (Select Ma From AT3332) 
				AND T01.InventoryID In (Select InventoryID From AT1302 Where InventoryTypeID = ''H'')  And Cast(Substring(A01.PNX_NgayNhanHang,5,2) + ''/'' + Right(A01.PNX_NgayNhanHang,2) + ''/'' + Left(A01.PNX_NgayNhanHang,4) As Datetime) = ''' + ltrim(@Date) + ''' 
			GROUP BY A01.Kho_MaSo, T02.WareHouseName, A01.PNX_NgayNhanHang, A02.HH_MaSo, T01.InventoryName
			ORDER BY A01.Kho_MaSo, A02.HH_MaSo' 

			If exists (Select Top 1 1 From sysobjects Where Id = Object_ID('AV3337') And xType = 'V')
			Begin
				Drop View AV3337
			End
				EXEC('Create View AV3337 --Create by AP3336
					As  ' + @sql1)	
	End
Else
	Begin
		Set @sql = '
			SELECT 
				A01.Kho_MaSo As [Maõ kho], 
				T02.WareHouseName As [Teân Kho],
				A01.PNX_NgayNhanHang As [Ngaøy xuaát],
				A02.HH_MaSo As [Maõ haøng],
				T01.InventoryName As [Teân haøng],
				Sum(A02.CTNX_SoLuong) As [Soá löôïng]
			FROM 	
				ASAHotel..FB_PhieuNhapXuat A01 INNER JOIN 
				ASAHotel..FB_ChiTietPhieuNhapXuat A02 ON A01.PNX_MaSo = A02.PNX_MaSo LEFT OUTER JOIN 
				AT1302 T01 ON A02.HH_MaSo = T01.InventoryID LEFT OUTER JOIN 
				AT1303 T02 ON A01.Kho_MaSo = T02.WareHouseID
			WHERE A01.PNX_LoaiDonHang = ''0''  And ltrim(A01.PNX_NgayNhanHang) + ''_'' + ltrim(A01.Kho_MaSo) + ''_'' + ltrim(A02.HH_MaSo) Not In (Select Ma From AT3332) 
				AND T01.InventoryID In (Select InventoryID From AT1302 Where InventoryTypeID = ''H'')  And ' + @Find + ' AND Cast(Substring(A01.PNX_NgayNhanHang,5,2) + ''/'' + Right(A01.PNX_NgayNhanHang,2) + ''/'' + Left(A01.PNX_NgayNhanHang,4) As Datetime) = ''' + ltrim(@Date) + ''' 
			GROUP BY A01.Kho_MaSo, T02.WareHouseName, A01.PNX_NgayNhanHang, A02.HH_MaSo, T01.InventoryName
			ORDER BY A01.Kho_MaSo, A02.HH_MaSo' 

			EXEC (@sql)

		Set @sql1 = '
			SELECT TOP 100 PERCENT
				A01.Kho_MaSo, 
				T02.WareHouseName,
				A01.PNX_NgayNhanHang,
				A02.HH_MaSo,
				T01.InventoryName,
				Sum(A02.CTNX_SoLuong) As [Quantity]
			FROM 	
				ASAHotel..FB_PhieuNhapXuat A01 INNER JOIN 
				ASAHotel..FB_ChiTietPhieuNhapXuat A02 ON A01.PNX_MaSo = A02.PNX_MaSo LEFT OUTER JOIN 
				AT1302 T01 ON A02.HH_MaSo = T01.InventoryID LEFT OUTER JOIN 
				AT1303 T02 ON A01.Kho_MaSo = T02.WareHouseID
			WHERE A01.PNX_LoaiDonHang = ''0''  And ltrim(A01.PNX_NgayNhanHang) + ''_'' + ltrim(A01.Kho_MaSo) + ''_'' + ltrim(A02.HH_MaSo) Not In (Select Ma From AT3332) 
				AND T01.InventoryID In (Select InventoryID From AT1302 Where InventoryTypeID = ''H'')  And ' + @Find + ' AND Cast(Substring(A01.PNX_NgayNhanHang,5,2) + ''/'' + Right(A01.PNX_NgayNhanHang,2) + ''/'' + Left(A01.PNX_NgayNhanHang,4) As Datetime) = ''' + ltrim(@Date) + ''' 
			GROUP BY A01.Kho_MaSo, T02.WareHouseName, A01.PNX_NgayNhanHang, A02.HH_MaSo, T01.InventoryName
			ORDER BY A01.Kho_MaSo, A02.HH_MaSo' 

			If exists (Select Top 1 1 From sysobjects Where Id = Object_ID('AV3337') And xType = 'V')
			Begin
				Drop View AV3337
			End
				EXEC('Create View AV3337 --Create by AP3336
					As  ' + @sql1)	
	End