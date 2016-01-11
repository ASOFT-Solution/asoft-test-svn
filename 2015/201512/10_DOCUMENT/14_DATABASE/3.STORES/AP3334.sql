/****** Object:  StoredProcedure [dbo].[AP3334]    Script Date: 07/29/2010 11:38:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/

--Ke thua hoa don dich vu
ALTER PROCEDURE [dbo].[AP3334] @Where nvarchar(4000), @Method tinyint = 0, @VoucherID nvarchar(50) = '' -- 0, do du lieu ke thua, 1 cap nhat tinh trang da ke thua, 2 Xoa

AS
If @Method = 0
	Select  Null As ObjectID, Null As VATObjectID, 'USD' As CurrencyID, 
		T01.InventoryID, Case when T01.InventoryID = 'RM' Then T01.InventoryName + ' ' + A01.Phong + ' (' + ltrim(day(A01.NgayDen)) + '/' + ltrim(month(A01.NgayDen)) + '/' + ltrim(year(A01.NgayDen)) + ' - ' + ltrim(day(A01.NgayTraPhong)) + '/' + ltrim(month(A01.NgayTraPhong)) + '/' + ltrim(year(A01.NgayTraPhong)) + ')' 
		Else T01.InventoryName + Case when (MaHoaDonTay is null Or MaHoaDonTay = '') Then '' Else ' (' + A01.MaHoaDonTay + ')' End End As InventoryName,
		Case when T01.InventoryID = 'RM' Then T01.InventoryName + ' ' + A01.Phong + ' (' + ltrim(day(A01.NgayDen)) + '/' + ltrim(month(A01.NgayDen)) + '/' + ltrim(year(A01.NgayDen)) + ' - ' + ltrim(day(A01.NgayTraPhong)) + '/' + ltrim(month(A01.NgayTraPhong)) + '/' + ltrim(year(A01.NgayTraPhong)) + ').' 
		Else T01.InventoryName + Case when (MaHoaDonTay is null Or MaHoaDonTay = '') Then '.' Else ' (' + A01.MaHoaDonTay + ').' End End As InventoryName1,
		T01.UnitID, T01.IsStocked, T01.MethodID, T01.IsSource, T01.IsLocation, T01.IsLimitDate,
	A01.Quantity, A01.UnitPrice, T01.SalesAccountID, A01.OriginalAmount, 0 As ConvertedAmount, 0 As ExchangeRate
	From 
	(Select Phong,Null as MaHoaDonTay,NgayDen,NgayTraPhong,MaDichVu As InventoryID, Count(MaDichVu) As Quantity, Sum(OriginalAmount)/Count(MaDichVu) As UnitPrice, Sum(OriginalAmount) As OriginalAmount
	From AV3336
	Where MadichVu = 'RM'
	GROUP BY Phong,NgayDen,NgayTraPhong,MaDichVu,OriginalAmount
	UNION ALL
	Select Phong,MaHoaDonTay,NgayDen,NgayTraPhong,MaDichVu As InventoryID, 1 As Quantity, OriginalAmount As UnitPrice, OriginalAmount As OriginalAmount
	From AV3336
	Where MadichVu <> 'RM'
	UNION ALL
	Select Null As Phong,Null As MaHoaDonTay,Null As NgayDen,Null As NgayTraPhong, 'ZZ' As InventoryID, 1 As Quantity, Sum(ServiceCharge) As UnitPrice, Sum(ServiceCharge) As OriginalAmount
	From AV3336
	) AS A01 LEFT OUTER JOIN AT1302 T01
	ON A01.InventoryID = T01.InventoryID
	ORDER BY A01.InventoryID
	
Else
	If @Method = 1
		Begin
			Insert Into AT3333 Select @VoucherID, Ma From AV3336 Where Ma Not In (Select Ma From AT3333)
		End
	Else
		Begin
			Delete From AT3333 Where VoucherID = @VoucherID
		End